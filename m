Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8153A3148C2;
	Thu, 16 Jul 2026 14:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210874; cv=none; b=eX0XjNF2gP4rd+7f8sdtj2pmoVMfJk+fahrt3LBj6bPB8+wx6YNOBLMsczKOJEX2dochCIsCFYM1n0koJ/Vps5hwfOGMr09yJz5TkUm+f8S+aQDHHUjF0TMQTlMiMz03CS3XgtkicE2daE10SSbcvHhtUTUvNN03XmmCsrCa9Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210874; c=relaxed/simple;
	bh=xXDm9dDQa1OXP1f+j1JIfnzjcIdhHMotlHYRMmOWt+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+CNfeWd02MeDJ18NJhCI1rUTeVWRue8ICogNdkXqMLAqMNuM06BRSWK8k7T9lDldxdvYOtRVEoqa7kZBDS243MbvQkcT7bxkki62+DxH6GvRZBFLOhCxuvuVMsrFXw68MW90eVRj9mIN2BfpVmU953ZIUbB6EvFaiecVW8Rs1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+R0mdQ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+R0mdQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DB81F000E9;
	Thu, 16 Jul 2026 14:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210873;
	bh=aLjFKUBNcDl31ZXhLoxDTIHV3Me6xpkyJV5MPd7tbv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+R0mdQ+VSM+nbJaXlyVttXKz2q0/Juiv7AYHzTPwN0eD/vlu42d417GYcsY6RBnx
	 K77WowKZN1AFSwkC8JcnWkKoZXYi8vDNCrt5jSUTeX5AiG3L96WDvumz+JbU5OKZ+h
	 8a0NRc/111EGXaQ1WoUjYZ698Vf3m+Bmuh5jLRkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 212/480] fs/ntfs3: zero-fill folios beyond i_valid in ntfs_read_folio()
Date: Thu, 16 Jul 2026 15:29:19 +0200
Message-ID: <20260716133049.319201781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 356fa248168be90109b66f32a61b8eaedc98424a ]

Handle ntfs_read_folio() early when the folio offset is beyond i_valid
by zero-filling the folio and marking it uptodate. This avoids needless
I/O and locking, improves read performance.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: d7ea8495fd30 ("fs/ntfs3: fix missing run load for vcn0 in attr_data_get_block_locked()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/inode.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 0cf2898334f33b..1b7bb924fc0025 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -723,6 +723,19 @@ static int ntfs_read_folio(struct file *file, struct folio *folio)
 	struct address_space *mapping = folio->mapping;
 	struct inode *inode = mapping->host;
 	struct ntfs_inode *ni = ntfs_i(inode);
+	loff_t vbo = folio_pos(folio);
+
+	if (unlikely(is_bad_ni(ni))) {
+		folio_unlock(folio);
+		return -EIO;
+	}
+
+	if (ni->i_valid <= vbo) {
+		folio_zero_range(folio, 0, folio_size(folio));
+		folio_mark_uptodate(folio);
+		folio_unlock(folio);
+		return 0;
+	}
 
 	if (is_resident(ni)) {
 		ni_lock(ni);
-- 
2.53.0



