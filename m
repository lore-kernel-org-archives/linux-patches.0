Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798DD27A477;
	Sat, 30 May 2026 17:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163063; cv=none; b=FLloXxoMOgZEir0hksMVUx4VN9gTnWpE69pFu5SDViQRfpHgWRqYDFRz3duqlORQZjVGiOu8tAmoVYktkR7RhZrzFTrN4q7dthS6yfgUZj1RMAOwxQIq6JaSz8/RvFZO3ykv8f9zwaJLfzqTznzTy7dfxrB+m2a6Uf7iicfpV5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163063; c=relaxed/simple;
	bh=RAUgQy0akPH+YgQtXI1FHiLsCDHvu0EgGOAQVYFbQNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtTeqN7HqMh+rQ+ZcnUO0vX7YuRc6a0kffcTHKYlRwe5n/lPlN9+s5sHnVqNP+djtBhG8e1ySWXFMHdD5vSN40agZ+WZhfiOgPDxt8DPXdSgI5+isgLksYd7A0YYdypspLuDeZUN9sBWxiE4TptPWt7/YsW7JfYM0iiMYdbOyTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uwQg8/EF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uwQg8/EF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB351F00893;
	Sat, 30 May 2026 17:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163062;
	bh=pnJ8AQExv4rnuA5SunVrfERB2WIBbwpQm5JOUdq+4oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uwQg8/EFxScfU3DPqZoXDkhqy1N8gbn5YqzA55uFCAfpEp+U+XTfF3hV6tTMPd0zg
	 x3skYr0U/JoHPmlnfCR/lcPyusehG565Zza8ef/TcGl/0y4xDsbxriOWoHlUDWOzkn
	 k5ccvn5zpkkKeg9bKTOrhgWhZ/0BOLlKDCKVyJbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Kees Cook" <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Tony Luck <tony.luck@intel.com>,
	linux-hardening@vger.kernel.org,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 5.15 144/776] pstore: inode: Only d_invalidate() is needed
Date: Sat, 30 May 2026 17:57:38 +0200
Message-ID: <20260530160244.141751549@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit a43e0fc5e9134a46515de2f2f8d4100b74e50de3 ]

Unloading a modular pstore backend with records in pstorefs would
trigger the dput() double-drop warning:

  WARNING: CPU: 0 PID: 2569 at fs/dcache.c:762 dput.part.0+0x3f3/0x410

Using the combo of d_drop()/dput() (as mentioned in
Documentation/filesystems/vfs.rst) isn't the right approach here, and
leads to the reference counting problem seen above. Use d_invalidate()
and update the code to not bother checking for error codes that can
never happen.

Suggested-by: Alexander Viro <viro@zeniv.linux.org.uk>
Fixes: 609e28bb139e ("pstore: Remove filesystem records when backend is unregistered")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-hardening@vger.kernel.org
[ Minor context change fixed. ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pstore/inode.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -312,7 +312,6 @@ int pstore_put_backend_records(struct ps
 {
 	struct pstore_private *pos, *tmp;
 	struct dentry *root;
-	int rc = 0;
 
 	root = psinfo_lock_root();
 	if (!root)
@@ -322,11 +321,8 @@ int pstore_put_backend_records(struct ps
 	list_for_each_entry_safe(pos, tmp, &records_list, list) {
 		if (pos->record->psi == psi) {
 			list_del_init(&pos->list);
-			rc = simple_unlink(d_inode(root), pos->dentry);
-			if (WARN_ON(rc))
-				break;
-			d_drop(pos->dentry);
-			dput(pos->dentry);
+			d_invalidate(pos->dentry);
+			simple_unlink(d_inode(root), pos->dentry);
 			pos->dentry = NULL;
 		}
 	}
@@ -334,7 +330,7 @@ int pstore_put_backend_records(struct ps
 
 	inode_unlock(d_inode(root));
 
-	return rc;
+	return 0;
 }
 
 /*


