Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6448D19AA56;
	Thu, 25 Jul 2024 14:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918363; cv=none; b=G/Y4B6311Yd6iZgE8JxApnGtbLMSnnZGjZaitlyxXG3xK/0yjRs+0HwUeCLoYN0LnJ+imLPSMHjZY8bPUmrfHGEhHh1K8coIhEG5oNsd1ETGX04ev49zJVVKUOqMgYMbRjxouCtzw19/Unma79JPmYDkLNbufBjUR86VFEIzU0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918363; c=relaxed/simple;
	bh=whiduLO/l5leQZqN15QhG9SoEJssfBve0SXSQ68q00g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bk77FoHbOICORs6umojLux9Eb9rxJIedccTAf1T+zb/JwIeBaQZ2O4RlA2Ne0uAgpe8xDxFBGJZRrxcuUlrgLjn4sl1eyAojIdjKAnPPKeX+seMqstKbk6zbvgu87lwazr9DZySLdXIZL4tQ4+Fh8Ug/MaozlGnYyQhmm4FiwoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8WuNV+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8WuNV+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A775CC116B1;
	Thu, 25 Jul 2024 14:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918363;
	bh=whiduLO/l5leQZqN15QhG9SoEJssfBve0SXSQ68q00g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8WuNV+pOPMaLBp3FsCuPYVGLpUiHRGmlcC/081iu9zSmfLVwOFGg00QNGS0fRqxt
	 A6/v2K96BUPMByryFlMpOQUsRXhE8rRTN49OGqEH77kIDu/gdvl0SFQnKoEn3CFAPi
	 Br60TGZNBHN8oXWVdgJUt0zkYFQrHR/ctiQg6inE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	lei lu <llfamsec@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Subject: [PATCH 6.10 05/29] fs/ntfs3: Add a check for attr_names and oatbl
Date: Thu, 25 Jul 2024 16:36:21 +0200
Message-ID: <20240725142732.021453835@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
References: <20240725142731.814288796@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 702d4930eb06dcfda85a2fa67e8a1a27bfa2a845 upstream.

Added out-of-bound checking for *ane (ATTR_NAME_ENTRY).

Reported-by: lei lu <llfamsec@gmail.com>
Fixes: 865e7a7700d93 ("fs/ntfs3: Reduce stack usage")
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fslog.c |   38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3722,6 +3722,8 @@ int log_replay(struct ntfs_inode *ni, bo
 
 	u64 rec_lsn, checkpt_lsn = 0, rlsn = 0;
 	struct ATTR_NAME_ENTRY *attr_names = NULL;
+	u32 attr_names_bytes = 0;
+	u32 oatbl_bytes = 0;
 	struct RESTART_TABLE *dptbl = NULL;
 	struct RESTART_TABLE *trtbl = NULL;
 	const struct RESTART_TABLE *rt;
@@ -3736,6 +3738,7 @@ int log_replay(struct ntfs_inode *ni, bo
 	struct NTFS_RESTART *rst = NULL;
 	struct lcb *lcb = NULL;
 	struct OPEN_ATTR_ENRTY *oe;
+	struct ATTR_NAME_ENTRY *ane;
 	struct TRANSACTION_ENTRY *tr;
 	struct DIR_PAGE_ENTRY *dp;
 	u32 i, bytes_per_attr_entry;
@@ -4314,17 +4317,40 @@ check_attr_table:
 	lcb = NULL;
 
 check_attribute_names2:
-	if (rst->attr_names_len && oatbl) {
-		struct ATTR_NAME_ENTRY *ane = attr_names;
-		while (ane->off) {
+	if (attr_names && oatbl) {
+		off = 0;
+		for (;;) {
+			/* Check we can use attribute name entry 'ane'. */
+			static_assert(sizeof(*ane) == 4);
+			if (off + sizeof(*ane) > attr_names_bytes) {
+				/* just ignore the rest. */
+				break;
+			}
+
+			ane = Add2Ptr(attr_names, off);
+			t16 = le16_to_cpu(ane->off);
+			if (!t16) {
+				/* this is the only valid exit. */
+				break;
+			}
+
+			/* Check we can use open attribute entry 'oe'. */
+			if (t16 + sizeof(*oe) > oatbl_bytes) {
+				/* just ignore the rest. */
+				break;
+			}
+
 			/* TODO: Clear table on exit! */
-			oe = Add2Ptr(oatbl, le16_to_cpu(ane->off));
+			oe = Add2Ptr(oatbl, t16);
 			t16 = le16_to_cpu(ane->name_bytes);
+			off += t16 + sizeof(*ane);
+			if (off > attr_names_bytes) {
+				/* just ignore the rest. */
+				break;
+			}
 			oe->name_len = t16 / sizeof(short);
 			oe->ptr = ane->name;
 			oe->is_attr_name = 2;
-			ane = Add2Ptr(ane,
-				      sizeof(struct ATTR_NAME_ENTRY) + t16);
 		}
 	}
 


