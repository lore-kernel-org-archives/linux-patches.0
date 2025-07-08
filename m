Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0888E202F70;
	Tue,  8 Jul 2025 16:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993813; cv=none; b=RhXACc6jTC1hu+rlEBlLGifQosPuIksyNqDAc2PV/9Jbs5qdYPhfmMUtnTmfXeHDqt6W2yDJSUjWNEE6Ui2UQZLHWRFN4QYTGSLD8T2hasToiEp4y6RlRiW8dfJ54bN0mG0Nm/DpNbGGyUj9VKQAH7JnHSKO8Wkuux6kFowvYwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993813; c=relaxed/simple;
	bh=cO6tBYjm1G1sYCOt+VNGLrSAnKc9NyGsuU7xMcuS+hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSdUYbjJ1gtLfLDZ8psZP63TzpIMip7QBlFO+QRjfYSZpP4ABk7GqpTKphKEH11Nrp9bGEjMZjxz0mx4M3IPDFgm6CUBMIPJMAd2DiQJDAYYnpx+khySaKBoukqI+F0IRUkQI1r63TQa394QK8dN8Zj8PQ06yoYMLkcTwLEVaf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6vM7W89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6vM7W89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B234C4CEED;
	Tue,  8 Jul 2025 16:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993812;
	bh=cO6tBYjm1G1sYCOt+VNGLrSAnKc9NyGsuU7xMcuS+hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6vM7W890z8+Ud/3L3FqnNEyfrGvgoWPu8k/YHiSkUjrAkYGBG7g/iX/S4NljrWhC
	 HtxEp7HiV8Uds/2ZM+7oS731VTwhn+z9xXJrx3yICA/76+rTM5nWWKr0A1ucOsRuhr
	 ie4Acxy5FfFQHnBfKSdZgwTmWOfnN9s2fia0Dj8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/160] ovl: Check for NULL d_inode() in ovl_dentry_upper()
Date: Tue,  8 Jul 2025 18:21:03 +0200
Message-ID: <20250708162232.240323151@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 8a39f1c870e9d6fbac5638f3a42a6a6363829c49 ]

In ovl_path_type() and ovl_is_metacopy_dentry() GCC notices that it is
possible for OVL_E() to return NULL (which implies that d_inode(dentry)
may be NULL). This would result in out of bounds reads via container_of(),
seen with GCC 15's -Warray-bounds -fdiagnostics-details. For example:

In file included from arch/x86/include/generated/asm/rwonce.h:1,
                 from include/linux/compiler.h:339,
                 from include/linux/export.h:5,
                 from include/linux/linkage.h:7,
                 from include/linux/fs.h:5,
                 from fs/overlayfs/util.c:7:
In function 'ovl_upperdentry_dereference',
    inlined from 'ovl_dentry_upper' at ../fs/overlayfs/util.c:305:9,
    inlined from 'ovl_path_type' at ../fs/overlayfs/util.c:216:6:
include/asm-generic/rwonce.h:44:26: error: array subscript 0 is outside array bounds of 'struct inode[7486503276667837]' [-Werror=array-bounds=]
   44 | #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
      |                         ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/asm-generic/rwonce.h:50:9: note: in expansion of macro '__READ_ONCE'
   50 |         __READ_ONCE(x);                                                 \
      |         ^~~~~~~~~~~
fs/overlayfs/ovl_entry.h:195:16: note: in expansion of macro 'READ_ONCE'
  195 |         return READ_ONCE(oi->__upperdentry);
      |                ^~~~~~~~~
  'ovl_path_type': event 1
  185 |         return inode ? OVL_I(inode)->oe : NULL;
  'ovl_path_type': event 2

Avoid this by allowing ovl_dentry_upper() to return NULL if d_inode() is
NULL, as that means the problematic dereferencing can never be reached.
Note that this fixes the over-eager compiler warning in an effort to
being able to enable -Warray-bounds globally. There is no known
behavioral bug here.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/util.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 8a9980ab2ad8f..74abba466f19b 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -215,7 +215,9 @@ enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path)
 
 struct dentry *ovl_dentry_upper(struct dentry *dentry)
 {
-	return ovl_upperdentry_dereference(OVL_I(d_inode(dentry)));
+	struct inode *inode = d_inode(dentry);
+
+	return inode ? ovl_upperdentry_dereference(OVL_I(inode)) : NULL;
 }
 
 struct dentry *ovl_dentry_lower(struct dentry *dentry)
-- 
2.39.5



