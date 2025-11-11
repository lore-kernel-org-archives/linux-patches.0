Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59082F5474;
	Tue, 11 Nov 2025 01:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825094; cv=none; b=TOfmoVmNwT6mYEbBV38HhHB2cQVC+0+2JoQUyqJeZkHQeD9SI4/64CB7CKz+TkiQ5RptB2Q/z4OiCp6aKmsZMnzT85AzHRiQeE04/DSb5T3KsHRqL66aoAzsygohf0Re+TeAs4pzSbRTGyQOy5W4WeaNaj9NO+kBDZ6duEJguqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825094; c=relaxed/simple;
	bh=JesUjYpTLLwdUNH/+O4Zv7WnvRapxXMyHDgOBGtiJAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B6LWNHZkUvqgb6795HB+p6E2jbyM1pyJmBK2HYKrEzxoyGCd04wEi+9WRFI8tMy0T1APdO4SA7cpZOCnal2RhS19HM4L2jEulr+1tblfQr3DvAWeumWYAdCVSTSOBz8XR3hw7zgffs5oTTqRTJ1eb9RrDgz7twV9srYkX6hTNj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7ClLMpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7ClLMpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443B3C19424;
	Tue, 11 Nov 2025 01:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825094;
	bh=JesUjYpTLLwdUNH/+O4Zv7WnvRapxXMyHDgOBGtiJAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7ClLMpfN8GR3ACisgZnifaidoVFtxZycPPkRAcwFUqw2j0gi9jf6EBU86+2dkMTn
	 qFvH4B0LWE5Srf98MtBWYr5rKkSY/HFKTUZC2Z6k9apOP+aE/BWKBk5KgXuNJIOqDb
	 8BXRrgvl/td1SDahtIoMUsVTbuTlEO+uQ8orVQKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Neil Brown <neil@brown.name>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 621/849] ovl: make sure that ovl_create_real() returns a hashed dentry
Date: Tue, 11 Nov 2025 09:43:11 +0900
Message-ID: <20251111004551.444546160@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit ad1423922781e6552f18d055a5742b1cff018cdc ]

e8bd877fb76bb9f3 ("ovl: fix possible double unlink") added a sanity
check of !d_unhashed(child) to try to verify that child dentry was not
unlinked while parent dir was unlocked.

This "was not unlink" check has a false positive result in the case of
casefolded parent dir, because in that case, ovl_create_temp() returns
an unhashed dentry after ovl_create_real() gets an unhashed dentry from
ovl_lookup_upper() and makes it positive.

To avoid returning unhashed dentry from ovl_create_temp(), let
ovl_create_real() lookup again after making the newdentry positive,
so it always returns a hashed positive dentry (or an error).

This fixes the error in ovl_parent_lock() in ovl_check_rename_whiteout()
after ovl_create_temp() and allows mount of overlayfs with casefolding
enabled layers.

Reported-by: André Almeida <andrealmeid@igalia.com>
Closes: https://lore.kernel.org/r/18704e8c-c734-43f3-bc7c-b8be345e1bf5@igalia.com/
Suggested-by: Neil Brown <neil@brown.name>
Reviewed-by: Neil Brown <neil@brown.name>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/dir.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index dbd63a74df4b1..039e829aa7dee 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -205,12 +205,32 @@ struct dentry *ovl_create_real(struct ovl_fs *ofs, struct dentry *parent,
 			err = -EPERM;
 		}
 	}
-	if (!err && WARN_ON(!newdentry->d_inode)) {
+	if (err)
+		goto out;
+
+	if (WARN_ON(!newdentry->d_inode)) {
 		/*
 		 * Not quite sure if non-instantiated dentry is legal or not.
 		 * VFS doesn't seem to care so check and warn here.
 		 */
 		err = -EIO;
+	} else if (d_unhashed(newdentry)) {
+		struct dentry *d;
+		/*
+		 * Some filesystems (i.e. casefolded) may return an unhashed
+		 * negative dentry from the ovl_lookup_upper() call before
+		 * ovl_create_real().
+		 * In that case, lookup again after making the newdentry
+		 * positive, so ovl_create_upper() always returns a hashed
+		 * positive dentry.
+		 */
+		d = ovl_lookup_upper(ofs, newdentry->d_name.name, parent,
+				     newdentry->d_name.len);
+		dput(newdentry);
+		if (IS_ERR_OR_NULL(d))
+			err = d ? PTR_ERR(d) : -ENOENT;
+		else
+			return d;
 	}
 out:
 	if (err) {
-- 
2.51.0



