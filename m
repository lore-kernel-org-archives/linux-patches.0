Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8D269942;
	Wed, 21 Feb 2024 13:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523552; cv=none; b=g57I6mkkqHY+nbvWe1AUYstK7ZeRQoh5jp1s21vsOBBZ7zRzQXlIqdnJ4mdDbj8ieO+cCdSrjERtQuaUbbqGSVTL8TFI75TwJrkhST2A2sttnugHUSrAjtJOydXhDY0/7CphwB8+wSOFoEO3FNPeq2qXxS03Kn8Icn88U9dUiYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523552; c=relaxed/simple;
	bh=61OMF2WuSgcJj4AbP40L3a5wXvGa4gtnKJ+2enx1Sgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=butDuW6Rza0VnzSzNQqiKG98NhSPeIAlrrsC5X59TQnOMG7nmCHht3lR3RcD85H6KKC3zKx9hWWhfg22hS312rlwAehVPShD7qtzuE1a/z9AFdKZC7mgu+iF7fQ/RXjlAfjYcQNTkH0ljnCB5buw9ue3Q03nCG9JLeeM5Gl+Jts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMPO04ip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMPO04ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8C5C433F1;
	Wed, 21 Feb 2024 13:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523552;
	bh=61OMF2WuSgcJj4AbP40L3a5wXvGa4gtnKJ+2enx1Sgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMPO04ipEHZb0GXXIsA3X7P8Uawc3XXKlHMQzL6nrWdxiouvv0CXlbmZg+jpasaFj
	 tMKV+yRBxuhAR5MzcEWOMdn/faSvKr4OrRC0WivUWqsayIDtZ7liYfd4966Qv00bOT
	 KEINjuI1wtTKODvlGZCCxsQOSOrirudVWATE8fzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	"Doebel, Bjoern" <doebel@amazon.de>
Subject: [PATCH 5.15 470/476] fs/ntfs3: Add null pointer checks
Date: Wed, 21 Feb 2024 14:08:41 +0100
Message-ID: <20240221130025.388945973@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit fc4992458e0aa2d2e82a25c922e6ac36c2d91083 upstream.

Added null pointer checks in function ntfs_security_init.
Also added le32_to_cpu in functions ntfs_security_init and indx_read.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: "Doebel, Bjoern" <doebel@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/fsntfs.c |   16 ++++++++++------
 fs/ntfs3/index.c  |    3 ++-
 2 files changed, 12 insertions(+), 7 deletions(-)

--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1872,10 +1872,12 @@ int ntfs_security_init(struct ntfs_sb_in
 		goto out;
 	}
 
-	root_sdh = resident_data_ex(attr, sizeof(struct INDEX_ROOT));
-	if (root_sdh->type != ATTR_ZERO ||
+	if(!(root_sdh = resident_data_ex(attr, sizeof(struct INDEX_ROOT))) ||
+	    root_sdh->type != ATTR_ZERO ||
 	    root_sdh->rule != NTFS_COLLATION_TYPE_SECURITY_HASH ||
-	    offsetof(struct INDEX_ROOT, ihdr) + root_sdh->ihdr.used > attr->res.data_size) {
+	    offsetof(struct INDEX_ROOT, ihdr) +
+			le32_to_cpu(root_sdh->ihdr.used) >
+			le32_to_cpu(attr->res.data_size)) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -1891,10 +1893,12 @@ int ntfs_security_init(struct ntfs_sb_in
 		goto out;
 	}
 
-	root_sii = resident_data_ex(attr, sizeof(struct INDEX_ROOT));
-	if (root_sii->type != ATTR_ZERO ||
+	if(!(root_sii = resident_data_ex(attr, sizeof(struct INDEX_ROOT))) ||
+	    root_sii->type != ATTR_ZERO ||
 	    root_sii->rule != NTFS_COLLATION_TYPE_UINT ||
-	    offsetof(struct INDEX_ROOT, ihdr) + root_sii->ihdr.used > attr->res.data_size) {
+	    offsetof(struct INDEX_ROOT, ihdr) +
+			le32_to_cpu(root_sii->ihdr.used) >
+			le32_to_cpu(attr->res.data_size)) {
 		err = -EINVAL;
 		goto out;
 	}
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1106,7 +1106,8 @@ ok:
 	}
 
 	/* check for index header length */
-	if (offsetof(struct INDEX_BUFFER, ihdr) + ib->ihdr.used > bytes) {
+	if (offsetof(struct INDEX_BUFFER, ihdr) + le32_to_cpu(ib->ihdr.used) >
+	    bytes) {
 		err = -EINVAL;
 		goto out;
 	}


