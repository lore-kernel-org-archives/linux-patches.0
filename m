Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F5516423;
	Tue, 27 Feb 2024 14:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042616; cv=none; b=hzZTPCbkoSBvBCjCFisPY2NUZgieMv8h1BNUDRberyRcZNIK/vQMhDMd5F7RhLP3s6x0ArJIqI2VGgO+Rs5kE3kZ/Be7QGHC5X6lxZ4QmTD8ytJTYh7/NGN1Z6BJtMOlKEWjE5ATdcXFAbKEXKLrdWsM+dPGY2e0wBVZlkFJmZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042616; c=relaxed/simple;
	bh=umdjfE1QTT+s+TEQVp401nPnNFcxb6LbgiajslFMZaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TW7umqeeVDC15kUvF2asftaTojpM7HyC997I+P2OB5E+ejRsNys8K6Wp5VC2m40dDPt3V0gOtnjLT+oH/0N9thIxRGKrKwkWi3jOVozud4v50bgqeuUlI5hd+zpyLF3mXW31XttSaqCkdH2ZxJV7I4AyKu2yw0JIaB/dQtUbfVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CD3/3k4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CD3/3k4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E749C433C7;
	Tue, 27 Feb 2024 14:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042616;
	bh=umdjfE1QTT+s+TEQVp401nPnNFcxb6LbgiajslFMZaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CD3/3k4+swEJ15yid888XTDxfiFUSaTYTNGyfYE46TWmIzTw/Z3HSe8BzuX8706n0
	 t296ucZDqoU5GigpyO4wkH1JfsZolrGMES6ApUjV9MAWQSDVjuquC/3VFjPVSMCd5d
	 fgRhc8xlIrTxCATxgoRQ8+zf1HaVHUihvGeBku5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/245] fs/ntfs3: Add NULL ptr dereference checking at the end of attr_allocate_frame()
Date: Tue, 27 Feb 2024 14:24:05 +0100
Message-ID: <20240227131616.976798213@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

[ Upstream commit aaab47f204aaf47838241d57bf8662c8840de60a ]

It is preferable to exit through the out: label because
internal debugging functions are located there.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/attrib.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 1d5ac2164d94f..64a6d255c4686 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1583,8 +1583,10 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
 			le_b = NULL;
 			attr_b = ni_find_attr(ni, NULL, &le_b, ATTR_DATA, NULL,
 					      0, NULL, &mi_b);
-			if (!attr_b)
-				return -ENOENT;
+			if (!attr_b) {
+				err = -ENOENT;
+				goto out;
+			}
 
 			attr = attr_b;
 			le = le_b;
@@ -1665,13 +1667,15 @@ int attr_allocate_frame(struct ntfs_inode *ni, CLST frame, size_t compr_size,
 ok:
 	run_truncate_around(run, vcn);
 out:
-	if (new_valid > data_size)
-		new_valid = data_size;
+	if (attr_b) {
+		if (new_valid > data_size)
+			new_valid = data_size;
 
-	valid_size = le64_to_cpu(attr_b->nres.valid_size);
-	if (new_valid != valid_size) {
-		attr_b->nres.valid_size = cpu_to_le64(valid_size);
-		mi_b->dirty = true;
+		valid_size = le64_to_cpu(attr_b->nres.valid_size);
+		if (new_valid != valid_size) {
+			attr_b->nres.valid_size = cpu_to_le64(valid_size);
+			mi_b->dirty = true;
+		}
 	}
 
 	return err;
-- 
2.43.0



