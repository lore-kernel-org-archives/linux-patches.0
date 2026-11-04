Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828862;
	b=gpjiw1jRbSLjY6wFy7iCjN92vBM9+3WF8Na5QHgrWBc+OAnaGqobHuLhX5s3DVQSAdr3
	 5nNIWhsLOLnNo9MUr9BlmNRsvbukYrEk5PwLptFYUBB134sWsJJR+FydbQcpuGMTfiyOB
	 sB4fbp2mDyzk1rEN98SQxIgg7SgiaA6ouQly4M1wxf3SV/h8it4l+LAbEBSp9lpO2+H+C
	 IiviBe+02qPnQsYeWjGQK6uoAE7/Az2NNjVU2373+6IdElCHxhmHdQo1zn4Yrm0GBaQBc
	 ZvZyOGtjB4f15zLz7jLa9OQWuvQm/itYmXN2ABf1zgsW4XyNrQbYQ3o7iVTl1G820TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MNG0RRN51pxFErQaNq/ySeMp4Ldx8YaHIeCwiV7ofcQ=;
	b=2NGUGvnGId6D2zLnNUeIicim3EVf90iEpmyTMweWCbgx3q9atAiWqBC20D+LGwBXAjHP
	 n7e395fZgggMl+M+eNScoLI80KRmPduwyEIlPuOw3ClU73Ru2YuJ4KBS4eszmkwteTEN6
	 9B4y8zIw3LM3dqrvn4VPdG6ovbwQVsAyi7jVWc+9PAQuNiyZl3kn1pgANcakGfykpd5yG
	 Nnto7/CAhaP7M4cejUsByeyyXNFbZysZAvZ6Tf+axEZXPz/9tEIkulDgWwnpt9tpC+Fo0
	 aQLgDP4osZwHDPTCgLBLbXLlC/ONbfzHXSK2BLwUrdhv8yTD9As9i8C7O+VHTmwy2QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AH8Z8Y1l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA846070F23;
	Wed,  4 Nov 2026 21:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AH8Z8Y1l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862891F00A15;
	Wed,  4 Nov 2026 21:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828861;
	bh=MNG0RRN51pxFErQaNq/ySeMp4Ldx8YaHIeCwiV7ofcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AH8Z8Y1l9G9HMzjnK7mYjA2PMKm6rUicSovN9KEX6ToazzmIq/zhnFkRvugiof9gt
	 bp0GCv7aInVh2KtGaVRLIlg8w6opAqx9ac01EX0E21AAj+V4s9DWXGdCAyfOgjOLS/
	 DlH5d4FUsXwO4ky4/375ub0dCinWWIsEda+wtKnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 7.3 287/547] ovl: check that the parents of volatile/dirty are dirs
Date: Wed,  4 Nov 2026 16:07:51 -0500
Message-ID: <20261104211046.356207137@linuxfoundation.org>
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

commit e34d2ef818e4c7676d8d8e1bf43e6a1ed39efb2a upstream.

An unprivileged user crashes the kernel by mounting overlayfs with the
volatile option.

A dentry that serves as the parent of a lookup must be a directory.
ovl_create_volatile_dirty() walks work/incompat/volatile/dirty by name,
and ovl_lookup_or_create() returns an existing entry whatever its type.
A file or a symlink that another task creates during the mount becomes
the parent of the next lookup, which calls a NULL ->lookup.

An unprivileged user mounted overlayfs with "volatile" in a user
namespace while a second process created a symlink named work/incompat,
and the mount task oopsed on a NULL ->lookup call.

Fix this by returning -ENOTDIR from ovl_lookup_or_create() when the
caller asked for a directory and the existing entry is a non-dir.

Fixes: c86243b090bc ("ovl: provide a mount option "volatile"")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/super.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -621,16 +621,21 @@ cleanup_temp:
 
 static struct dentry *ovl_lookup_or_create(struct ovl_fs *ofs,
 					   struct dentry *parent,
-					   const char *name, umode_t mode)
+					   const char *name, bool is_dir)
 {
 	struct dentry *child;
 
 	child = ovl_start_creating_upper(ofs, parent, &QSTR(name));
 	if (!IS_ERR(child)) {
-		if (!child->d_inode)
+		if (!child->d_inode) {
 			child = ovl_create_real(ofs, parent, child,
 						&QSTR(name),
-						OVL_CATTR(mode));
+						OVL_CATTR(is_dir ? S_IFDIR :
+								   S_IFREG));
+		} else if (is_dir && !d_can_lookup(child)) {
+			end_creating(child);
+			child = ERR_PTR(-ENOTDIR);
+		}
 		end_creating_keep(child);
 	}
 	dput(parent);
@@ -652,7 +657,7 @@ static int ovl_create_volatile_dirty(str
 	const char *const *name = volatile_path;
 
 	for (ctr = ARRAY_SIZE(volatile_path); ctr; ctr--, name++) {
-		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1 ? S_IFDIR : S_IFREG);
+		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1);
 		if (IS_ERR(d))
 			return PTR_ERR(d);
 	}


