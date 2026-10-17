Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E3C3A382F;
	Sat, 17 Oct 2026 15:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252541; cv=none; b=j48DwxtN9TwOMkBc5o0HyflR29ulqsxEvSv8ApUooxVedB1Av86i3hoX0/mJbxwhP79O/e4ozmYqBMnb+ZsZ4T2UmdGe7ni3FUnM+593YqRxp2OmMc87Rr7m4KzVIOMQIq4XEdc5X1p1f/HyaLc8Ewelm5UZ5yt66yUDFbvetxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252541; c=relaxed/simple;
	bh=rcYZJ8qG87+jmdw3A69+B4aDicZnn1thvX2suJkfXV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayviZk+DsZcIQiYNFz7X21luZ8xH52UkXGwNP9U7UAsD14ka3h77eNJrnlIm6mxuYz1HEUg/IIPFIlhufyMdaut+iRpU2YNXdxre2qvvtw5FiIB/Obm6Q3j2J7/jYJBllyK6o1zOPM4ge07diIa4xIQ0dNC67SFP+OzcvZ9nC4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLYKCRLJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLYKCRLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11111F000C6;
	Sat, 17 Oct 2026 15:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252538;
	bh=p1d0so2y7CcAa5j6md5DcMQ7eBHS2YWDHE+xXhvXKWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLYKCRLJqkd8hj0h+kV7+r7U2T1ez0MTRAP0UYM75TFfBOrjx1VraRNYy606gyQH+
	 pcr9Wmtmr25TjNrZ9jgwVQ+CBoOHFS6ITVcSLe2rRp5bwi1Snxp2ppKFfzr7o6Ml6Y
	 YwTLFOAY7gAxqJmiHN71H1AVjp/3gfoaglHYftxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 14/52] dm-integrity: fix NULL pointer dereference when the R flag is used
Date: Sat, 17 Oct 2026 17:54:15 +0200
Message-ID: <20261017155105.321449617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 7d4d4f3b668d708d94f62ecdd33ac330a6fd8a84 ]

If the dm-integrity device has the SB_FLAG_DIRTY_BITMAP flag set and the
user activates the device in the 'R' mode, a crash in dm_integrity_resume
happens because the function attempts to read the journal containing the
bitmap.

This patch makes dm-integrity skip any writes to the device in
dm_integrity_resume if the device is activated in the 'R' mode.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
Cc: stable@vger.kernel.org
Stable-dep-of: fc79aeb86a2c ("dm-integrity: validate the superblock on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 415e763041bd2..5ad2b85cef049 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3873,6 +3873,10 @@ static void dm_integrity_resume(struct dm_target *ti)
 	r = sync_rw_sb(ic, REQ_OP_READ);
 	if (r)
 		dm_integrity_io_error(ic, "reading superblock", r);
+
+	if (ic->mode == 'R')
+		goto skip_writes;
+
 	if ((ic->sb->flags & flags) != flags) {
 		ic->sb->flags |= flags;
 		r = sync_rw_sb(ic, REQ_OP_WRITE | REQ_FUA);
@@ -3982,6 +3986,7 @@ static void dm_integrity_resume(struct dm_target *ti)
 		}
 	}
 
+skip_writes:
 	ic->reboot_notifier.notifier_call = dm_integrity_reboot;
 	ic->reboot_notifier.next = NULL;
 	ic->reboot_notifier.priority = INT_MAX - 1;	/* be notified after md and before hardware drivers */
-- 
2.53.0



