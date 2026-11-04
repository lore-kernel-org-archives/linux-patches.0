Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828856;
	b=RrhVOMghTgf4wAo4/zZWkp+LjLCjVjfzgSEMTOZmFQd8fYBWBA+wGDxx63PylR2xxhFL
	 70Dm90SwS2q6dy3fiUboBprqpeVEWrsQyuebajbouVgrLCcQQ2VmcBkK7+M2jELzu7AMf
	 FizraQTdDoPmn7PRYz09aT0a9psesVXfnFLvWa2ugJ8s2aBnAMaBVVTRujD7x2olTmbTe
	 4P5AY7rQeTVRh/IrcFjR28sW3458BnxjZ8GxpkSabINpxlFh1sv2fj140EbEN3nlvksl0
	 koZ7ruXBUN/3vvH6rwO4K+j/PNloy6h+xnDKUIuvGEFDor9oQQM0Y7ZpCLCYs6Skcqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E3MMYcrwdBs6ltyGd2k56YV5JhMMysV7HJy2uiz2DE0=;
	b=kNj33+6LqyUQjHR5ec+hPZU34ctpmGKTT7BQV63ME6YmIIcOhzrVoIdTMXa4a6QZ8vMp
	 EK5HMpJ8qYCncaQnjmKLXoEa75DE8HLZQG7oMFWvaod0HD+TLLZT5kSoiXMtddLMgQzD9
	 Q2poJysvGgSJsDktuXvMpR1kueip2DOj/QRScQtIDWV+xDHDZGhuReXkFGAKqvNL8IJKB
	 OZW92bzJuk00mw/p0uHSkqxHs/QKhO0FFtCEgnFtvI8W3HWVtQ41R3Gze/AhMrvhpWJUy
	 UbiFielFoeP/WaRdI/5xQO+eQXnSj0++rq88nHUk2+sKVbx4WD67wjEvda03zfwQ0RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gprlDBQ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B996070F18;
	Wed,  4 Nov 2026 21:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gprlDBQ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96BD1F00919;
	Wed,  4 Nov 2026 21:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828855;
	bh=E3MMYcrwdBs6ltyGd2k56YV5JhMMysV7HJy2uiz2DE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gprlDBQ6l6I6sq0aPvgoB9T/1aWfJ1opE61jrm9IRBzn9NAHBupYcy7XHAUovyERt
	 Gcjwcg9PkVWTPRnLUrn+yDI8IR1z5FT/dfxBfsrNZ1AF7Cqe4vORH4ODaxXdON6Gjr
	 f8stpII7ma91fJvbfOWbNnkoM2Vhl4CT1tEqqpek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 283/547] ovl: set OVL_WHITEOUTS before publishing the upper dir
Date: Wed,  4 Nov 2026 16:07:47 -0500
Message-ID: <20261104211046.239133466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
 fs/overlayfs/copy_up.c |    2 +-
 fs/overlayfs/readdir.c |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -834,9 +834,9 @@ static int ovl_copy_up_workdir(struct ov
 
 	if (!c->metacopy)
 		ovl_set_upperdata(inode);
-	ovl_inode_update(inode, temp);
 	if (S_ISDIR(inode->i_mode))
 		ovl_set_flag(OVL_WHITEOUTS, inode);
+	ovl_inode_update(inode, temp);
 out:
 	ovl_end_write(c->dentry);
 
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1072,7 +1072,8 @@ static int ovl_dir_open(struct inode *in
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
-	od->is_real = ovl_dir_is_real(inode);
+	od->is_real = !OVL_TYPE_MERGE(type) &&
+		      !ovl_test_flag(OVL_WHITEOUTS, inode);
 	od->is_upper = OVL_TYPE_UPPER(type);
 	file->private_data = od;
 


