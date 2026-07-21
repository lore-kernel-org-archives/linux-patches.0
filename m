Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D01F44AB9E;
	Tue, 21 Jul 2026 21:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670068; cv=none; b=WcAeSNsvrDa/yRPLk6GIoIDHIhfj7sMXsXv13FeBlPBfvfbs4S2/9vJ9y7Nd7ZU24WgW8M3dwXUe46dUxRQ06pRrtOgQvhaoCkLaGEv4jFqJ7MfUX6cV7ucmNejko3H4gcq3ViE67Bk7s8WPbSNcv5E8T6gkqFy7COQkA9S1iyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670068; c=relaxed/simple;
	bh=35iWDvtyvs914o8+J3NJX9WoQP11A9flkCDy4XtYtGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNc5yZHCQLOdVM3LRBcnVaQGgnc+LKROTTk4kqLMZxlVeZ5k3yPUDJC2T10MKUnLVREmKRz30MOEywaWuEKXbKWQXfIKXekZy6PAR+A5Pq5hD16ceyhcrdEj4xLesMugAXMKXgdp2ibFPAVRq6T5gBg9P3wLEWmYo80vTgSBdzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAsWcMue; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAsWcMue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A121F000E9;
	Tue, 21 Jul 2026 21:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670066;
	bh=AoW3OGvdP4eQK63zfjmIs+BQzAx0Pa2DQeYi0AZmt7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rAsWcMue7vtm6frgVkRfWJ25nfMMxruGLDO4bj2icFTRjvpPkESciFM5hMPYy10ts
	 lLYHfpGkplC5S/A0+U/SESNG/SA9QmSbUzVyn7z5CZ0wXedDq+fmsBARCpMm1WeDYu
	 WXq9TA0oer1KXCSZRe/uN/lnodZuiHDW4FsAlb5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavitra Jha <jhapavitra98@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.1 0790/1067] fs/ntfs3: validate lcns_follow in log_replay conversion
Date: Tue, 21 Jul 2026 17:23:11 +0200
Message-ID: <20260721152442.236491650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 6a4c53a2e26a865565bd6a460961e8d6fcb32329 upstream.

log_replay() converts DIR_PAGE_ENTRY_32 records into DIR_PAGE_ENTRY
records when replaying version 0 restart tables.

During this conversion, the memmove() length is derived directly from
the on-disk lcns_follow field:

	memmove(&dp->vcn, &dp0->vcn_low,
		2 * sizeof(u64) +
				le32_to_cpu(dp->lcns_follow) * sizeof(u64));

check_rstbl() validates restart table structure, but does not constrain
per-entry lcns_follow values relative to the entry size. A malformed
filesystem image can provide an oversized lcns_follow value, causing
the conversion memmove() to access memory beyond the bounds of the
allocated restart table buffer.

The same field is later used to bound iteration over page_lcns[],
so validating lcns_follow during conversion also prevents downstream
out-of-bounds access from the same malformed metadata.

Compute the maximum valid lcns_follow from the already-validated
restart table entry size and reject entries that exceed this bound.
Reuse the existing t16/t32 scratch variables already declared in
log_replay() to avoid introducing new declarations.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Signed-off-by: Pavitra Jha <jhapavitra98@gmail.com>
[almaz.alexandrovich@paragon-software.com: fixed the conflicts]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -4265,13 +4265,26 @@ check_dirty_page_table:
 	if (rst->major_ver)
 		goto end_conv_1;
 
+	t16 = le16_to_cpu(dptbl->size);
+	if (t16 < sizeof(struct DIR_PAGE_ENTRY)) {
+		log->set_dirty = true;
+		goto out;
+	}
+
+	t32 = (t16 - sizeof(struct DIR_PAGE_ENTRY)) / sizeof(u64);
+
 	dp = NULL;
 	while ((dp = enum_rstbl(dptbl, dp))) {
 		struct DIR_PAGE_ENTRY_32 *dp0 = (struct DIR_PAGE_ENTRY_32 *)dp;
-		// NOTE: Danger. Check for of boundary.
+		u32 lcns = le32_to_cpu(dp->lcns_follow);
+
+		if (lcns > t32) {
+			log->set_dirty = true;
+			goto out;
+		}
+
 		memmove(&dp->vcn, &dp0->vcn_low,
-			2 * sizeof(u64) +
-				le32_to_cpu(dp->lcns_follow) * sizeof(u64));
+			2 * sizeof(u64) + lcns * sizeof(u64));
 	}
 
 end_conv_1:


