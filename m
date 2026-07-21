Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8159819049B;
	Tue, 21 Jul 2026 17:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654576; cv=none; b=KrL6DMi7BZugCdHxFB5d/1+IZuCo2Lnv4rRjR2vmPwjB8UFLevHGu8lRsptp4r+sNAH4+fZ24HoJQObv+4r2DNDx4FPRq3P5b/O89G7DYHNUV1+QG+VpBQzxfkiEjUVwvkxqrU7aMxHsj2xvji4nmbUXxfRkx+rXznLsP0j1RN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654576; c=relaxed/simple;
	bh=lcOPt/CclMXWApAnYYZrxCpDatGIJfQ9YNCF6ntYIeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIoVTHX5dnBbPaSHhpKv1E7Y1sJ7Es38Cyex0GsykvIM8nne/ryPHplPtOJXVuMqq4f1ZgWKoYNZlQ2qmM0u/D3F+vk2s6S9JWMFRYm5b4bKbUMV0kiP1qzQTkSy50xdwmsOvEMPsfjLWURFwgMxOYaehL+Yo3PsZnhDBfsEFr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b73DA3UN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b73DA3UN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80541F000E9;
	Tue, 21 Jul 2026 17:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654575;
	bh=BT9IK2Cqfa+SG8Wrv2G3F5BdoEAdYp609e2f5Xlj90k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b73DA3UNXmbwG9anLsYGuEw4voPCrYgjB+Iu59aXXkvCl16ySm7m6GVfMCWGYa2ZV
	 bta9Hogi+Iw+rRwI1QQrzKVpgDJCUIbRxIzAOMK5d2xrMPnbFBwAUS0foM8pBsqakk
	 OBcTk+3qEENcb8KtzvBIcCqIi84qLXq16qA5cPt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1714/2077] ntfs: sanitize MFT references returned from ntfs_lookup_inode_by_name()
Date: Tue, 21 Jul 2026 17:23:07 +0200
Message-ID: <20260721152633.183416076@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit d97a36bae86a9a4021562ded2987f904e6bcb1d7 upstream.

ntfs_lookup_inode_by_name() returns MFT references read from directory
index entries on disk. These values are untrusted, but the function can
currently return an error-marked MFT reference to its callers without
validating it.

Callers later decode lookup failures with MREF_ERR(). A crafted NTFS image
can set the MREF error bit while leaving the low bits as an arbitrary
value, causing callers to consume a bogus pseudo-errno instead of treating
the lookup result as corrupted on-disk metadata.

Fix this at the source by normalizing every error-marked MFT reference
returned from ntfs_lookup_inode_by_name() to ERR_MREF(-EIO). Apply this to
all four directory lookup return paths so every caller gets a validated
result without needing additional checks or an API change.

This keeps the sanitization in the common lookup helper, which is cleaner
than duplicating validation in each caller.

Fixes: 1e9ea7e04472 ("Revert "fs: Remove NTFS classic"")
Cc: stable@vger.kernel.org
Reported-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/dir.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs/dir.c b/fs/ntfs/dir.c
index 4b6bd5f30c65..6fa9ae3377cb 100644
--- a/fs/ntfs/dir.c
+++ b/fs/ntfs/dir.c
@@ -23,6 +23,13 @@
 __le16 I30[5] = { cpu_to_le16('$'), cpu_to_le16('I'),
 		cpu_to_le16('3'),	cpu_to_le16('0'), 0 };
 
+static inline u64 ntfs_check_mref(u64 mref)
+{
+	if (IS_ERR_MREF(mref))
+		return ERR_MREF(-EIO);
+	return mref;
+}
+
 /*
  * ntfs_lookup_inode_by_name - find an inode in a directory given its name
  * @dir_ni:	ntfs inode of the directory in which to search for the name
@@ -178,7 +185,7 @@ u64 ntfs_lookup_inode_by_name(struct ntfs_inode *dir_ni, const __le16 *uname,
 			mref = le64_to_cpu(ie->data.dir.indexed_file);
 			ntfs_attr_put_search_ctx(ctx);
 			unmap_mft_record(dir_ni);
-			return mref;
+			return ntfs_check_mref(mref);
 		}
 		/*
 		 * For a case insensitive mount, we also perform a case
@@ -273,7 +280,7 @@ u64 ntfs_lookup_inode_by_name(struct ntfs_inode *dir_ni, const __le16 *uname,
 		if (name) {
 			ntfs_attr_put_search_ctx(ctx);
 			unmap_mft_record(dir_ni);
-			return name->mref;
+			return ntfs_check_mref(name->mref);
 		}
 		ntfs_debug("Entry not found.");
 		err = -ENOENT;
@@ -413,7 +420,7 @@ u64 ntfs_lookup_inode_by_name(struct ntfs_inode *dir_ni, const __le16 *uname,
 			mref = le64_to_cpu(ie->data.dir.indexed_file);
 			kfree(kaddr);
 			iput(ia_vi);
-			return mref;
+			return ntfs_check_mref(mref);
 		}
 		/*
 		 * For a case insensitive mount, we also perform a case
@@ -538,7 +545,7 @@ u64 ntfs_lookup_inode_by_name(struct ntfs_inode *dir_ni, const __le16 *uname,
 	if (name) {
 		kfree(kaddr);
 		iput(ia_vi);
-		return name->mref;
+		return ntfs_check_mref(name->mref);
 	}
 	ntfs_debug("Entry not found.");
 	err = -ENOENT;
-- 
2.55.0



