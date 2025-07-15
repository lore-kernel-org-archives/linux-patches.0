Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E452E7BB1;
	Tue, 15 Jul 2025 13:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586300; cv=none; b=DuHDfIf6HEkX0zbphSv62qj85KnZhxlLunaasFcuE8JR5fKh2orzlowTYrQGBf/tyUnL6iEftPZ31iFSiXrOxHMnZhKGetKVffM31Z9KoBURmzDEziNr9nyFFWGnJt2RIKbRs42hFd9VJFmnoNvfZzgT51Z4rQ3nrYZNoiC3Prs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586300; c=relaxed/simple;
	bh=xpgTpNwemqiAf6vu7BQ13hin96lVEyf/zpmXd/gFAVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7wH16Fg9tA1kSKdTOItwBU9myIsFYRdpffPg3Z+nm9u60ehjZuJg5+VOlol9qvOvExeIgfEReDKtP8WrlsziZSu6j5Mb50BkqOSdxrGIurYOkAjRWJ9i2PlO9B+uO/4q22hD3TGrNdKC40TE8h24N3SXfPseKXarmoMzJpyOVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mxd4B2at; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mxd4B2at"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64253C4CEF1;
	Tue, 15 Jul 2025 13:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586300;
	bh=xpgTpNwemqiAf6vu7BQ13hin96lVEyf/zpmXd/gFAVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mxd4B2atV5yZl0Qjr76MpHzKfi+n3BCPmMVMoipt/rE/VuDBIIrJH1/BanyueKUso
	 wi5Mz/oxUobgGOFry4XmnGSL7I116adrVhKD460YU8Kg+KPrb2JzGwfTh2GqsXvFoW
	 wjbqRbubpbxQhJsUbUvF36UWEZKXTzTdK0yg7Wms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 014/148] ovl: Check for NULL d_inode() in ovl_dentry_upper()
Date: Tue, 15 Jul 2025 15:12:16 +0200
Message-ID: <20250715130800.877210510@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4d75e1cdf0b9c..af813e7773795 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -191,7 +191,9 @@ enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path)
 
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



