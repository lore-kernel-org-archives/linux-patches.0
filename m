Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061833;
	b=PYNMxe9ZbtVRCIkyUvwMCddMHWeOiU/59BSJ/SUgtF36/3MmZPL7tTem/S183qGI713K
	 vJm/3CFpGdj/+15zvRUa4cI8FvWQJvZQq4i+yybiIjNnsoEcuyVO60vQEFzyyp0ymQkfp
	 0zPqbx7plAvJNCH4y5lRi8edfyNjHkD4MGoLcErDBUqmqyBfFsU1R5zKzmqgvC5ao0Xe+
	 xBgOBK2FA3FPWSNtZAQEWi56GHi98u4rb74tYJIbTgx/sHG5aooVzLNI3w72EVlkGoq6d
	 WxnwFxth774bLrodMRemamLQ/zXVljSeJBjXsvMWFvguiOrOMzK8M6TtDEanRUiIipg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hAIcLPucytEBnt4MuU46Dw84Vn2tkVxE6BjTk8QpJac=;
	b=QuPSo7oO+lh8Lwa5ApYikAtVe0VCYjjY+90z2Zj+UKVguzHijN+H46X/D4KB2+3KuPek
	 XXLKptI8UrqVkw6nwm1QPA4RriXfhfa/CPYNzjh7kR9+aMADOuxVZ6fF6F4Q30BWYrl0E
	 YT/D96mo7hfkEeai8cDGV3DwFbWKZjkopRELAUIl9TnrJ0lDO1Ed8EAE5tNMX8438GCu9
	 yq+yadFUdumMs70was6lBpvm8o+sOjaCfM4D37Vk+pOP7vbJXFX+GJWZ0XoOIZxMJ9Eoi
	 g50exVkoiyTdeFrtgT/iy99NgLbls2vREvpk/ky2RjOAw9Xplt4ChFA33NsXSW1Ygtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BH49znO7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1943F606A326;
	Sat,  7 Nov 2026 14:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BH49znO7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4291F0089F;
	Sat,  7 Nov 2026 14:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061833;
	bh=hAIcLPucytEBnt4MuU46Dw84Vn2tkVxE6BjTk8QpJac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BH49znO7PQfMghwZZ4RoFgJ2mWdr/B+73GvwjlOJuR1tRyCXC8O5GGXFCGOVRLrah
	 Y0GNgbXeMckzE+JyVcb+CzuSKMcJQOsyH+g/VMggT8jbAD7Ee6fFBqGkVQ12B9Ky2Q
	 XOdHp7OXOWoGGqzzhhFs43lGVyfh7+ijsGhuGguU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.12 0827/1536] ovl: set OVL_WHITEOUTS before publishing the upper dir
Date: Sat,  7 Nov 2026 08:47:23 -0500
Message-ID: <20261107135020.770141918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

commit cbec8610ec5aaf35df50094ff639febc23f20773 upstream.

Listing a directory while it is copied up causes a use-after-free of
the readdir cache.

A merge directory must never be iterated as a real upper directory:
that mode frees the cache in OVL_I(inode)->cache without looking at
its refcount, while files opened in merged mode still use it.
ovl_copy_up_workdir() publishes the upper dentry before it sets
OVL_WHITEOUTS, and ovl_dir_open() samples both without a lock, so an
open between the two stores finds the upper directory and takes it
for a real one.

With a delay between the two stores, an unprivileged process that
listed a directory during its copy-up saw only "." and "..", and its
next getdents freed the readdir cache of another descriptor.

Fix this by setting OVL_WHITEOUTS before ovl_inode_update(), so that
ovl_dir_reset() agrees with ovl_dir_open(), and by testing
OVL_TYPE_MERGE() of the path type in ovl_dir_open(), so that an open
that observes the upper dentry never iterates a merge dir as a real
dir, regardless of the order in which it observes the flag.

Fixes: b79e05aaa166 ("ovl: no direct iteration for dir with origin xattr")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: test OVL_TYPE_MERGE() instead of smp_rmb() in ovl_dir_open()]
Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxh-1J2OBjnDVbrrrjy1puSOW0kABvghN85ih6dtKUBTyA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
[ backport: context: the store is followed by the unlock: label ]

 fs/overlayfs/copy_up.c |    2 +-
 fs/overlayfs/readdir.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -845,9 +845,9 @@ static int ovl_copy_up_workdir(struct ov
 
 	if (!c->metacopy)
 		ovl_set_upperdata(inode);
-	ovl_inode_update(inode, temp);
 	if (S_ISDIR(inode->i_mode))
 		ovl_set_flag(OVL_WHITEOUTS, inode);
+	ovl_inode_update(inode, temp);
 unlock:
 	unlock_rename(c->workdir, c->destdir);
 out:
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -961,7 +961,8 @@ static int ovl_dir_open(struct inode *in
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
-	od->is_real = ovl_dir_is_real(inode);
+	od->is_real = !OVL_TYPE_MERGE(type) &&
+		      !ovl_test_flag(OVL_WHITEOUTS, inode);
 	od->is_upper = OVL_TYPE_UPPER(type);
 	file->private_data = od;
 


