Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323E338AC72;
	Sat, 12 Sep 2026 19:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242596; cv=none; b=Hk5f4W3jw7QyShB5VYbhMsmrkOkmFzynW2rOHcqemP7Pjl8BcX3MG+AzU0Chyg/Za4+FDUDZt5Q9+wfEsUPEelQ1i3sU1ELBx1eDTSLcISBoMiDTTeGmKcba/CTgj79glLEGddVsU7Gv2Nz5CvbFoIZTXnO60C+g2CIldDzbHhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242596; c=relaxed/simple;
	bh=loAPSZRU65d3GiS3kmdmBp3Niz6yZz4BTnSGaOnnsUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnXwNUh+USBYTIHmgRDRQypNb1NwdSvv8KR0pFqr+dbK54hAOh3bfl0yRVAgCf2QNyK+I046cqvdwCAh4+cFc+oxoD5Z54rLUiH24b4+EIxvb9upF23BtG7BuPVaND30kGsJO86ztcuspR70KFiCCGvfBOZ6Dzwaj665+Rfwy0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMFBPdv6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMFBPdv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3561F000FF;
	Sat, 12 Sep 2026 19:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242595;
	bh=EvhADCmfVf2in9nE5+OJ1YZukUIABNS8X1kC7OikSc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMFBPdv6SdBE5h5lD9NxFTneguLmOjWDHwehAANAQ9A5WXhXN25X24WM0eBd2Xo82
	 HnBhpAfLuEw+vQfBBJYN774f/pIb9yqnAQz1DXE7vnFNKrbmT7UOMKcHYsD7T7qZ5c
	 VXt3Wf4MUhUXaO59R/9en+KJuOWEcTSrBCq+1guc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 458/798] UDF symlink pathComponent header OOB read
Date: Sat, 12 Sep 2026 09:01:26 +0200
Message-ID: <20260912065527.643907836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lee <david.lee@trailofbits.com>

[ Upstream commit d23eb7380d1594cda31a5dc8487dd2a5c8def8c7 ]

udf_symlink_filler() can enter udf_pc_to_char() with a partial pathComponent header.

Validate that enough input remains for a complete pathComponent header
before accessing it. Reject malformed symlink data that would otherwise
make udf_pc_to_char() perform an out-of-bounds read.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
Link: https://patch.msgid.link/20260717104722.41446-1-david.lee@trailofbits.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/symlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index c973db239604f..87f69cd556892 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -40,6 +40,8 @@ static int udf_pc_to_char(struct super_block *sb, unsigned char *from,
 	/* Reserve one byte for terminating \0 */
 	tolen--;
 	while (elen < fromlen) {
+		if (fromlen - elen < sizeof(struct pathComponent))
+			return -EIO;
 		pc = (struct pathComponent *)(from + elen);
 		elen += sizeof(struct pathComponent);
 		switch (pc->componentType) {
-- 
2.53.0



