Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705814;
	b=cTWj3owyYvLmkxnW/3W6JZBFFvNU5nPNx7MfGBTA1Sz+GIOXmvDN8nsIh9kbMrF/gytg
	 V4t1Znx4+PaAKCzOborofRKdwxa5oDLc1GRMmHS8Wuiy510/GgTZhiWFTHNSss0XY3E83
	 UhlGY/7XFBu7m+1f5nXgoq1SqNi4+iNNy9ujDU8zlWm/wOUx3dSC9mhn68nTX1Cmri2ez
	 opOcxEKt5LIfU48t5tgsJtB8FBic4zZJY7van6yKeZZwLUl8Y4t9xZuaB3O3E7O+cxSAq
	 lfxRaH16GfICoCXfHGaHm73zFwKPbOhQYtJRL/sr3bWWQcmKUjQkEY9q8LpBg0FJvcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k2Zs0SQhj9VnabZpU4r4MmIOLd/m2LtmNBvC69C7dgg=;
	b=zoZ15xUyQkDUR838yvmycjYY810zf5Yu+dj/jDTg6iXYylAn4yVSTcopy/JXkg9NNUIe
	 NsMoYorcoPN5+5kUfM5HRo4xv/9Yf3tkQCy2xEid1BOE1Vs4Bm4JZysr5PTI+HM3LOQ+A
	 0ST1aYggKfzD83SQXbf/PDH5t7Epm8uMabrV6kHXLUbl/SD3m+d1oM2Vyd5UIuy6adg2G
	 VWVEKeWM8uqga55NvowfK0/dZcqlnhUiad5Rvgbw+574CfC8cuwZ+sfhO1xfpob5RhlM8
	 vXPrtlVNJhg0FKy6B8NqPkjXg/HUaxSQ//c2b83/HppRtM2qpJS8MDhu5P8Z4RROwoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YEHxoaxT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EA0606A333;
	Thu, 26 Nov 2026 15:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YEHxoaxT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AA81F000EB;
	Thu, 26 Nov 2026 15:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705814;
	bh=k2Zs0SQhj9VnabZpU4r4MmIOLd/m2LtmNBvC69C7dgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YEHxoaxTlSc5etG3QOXoYkXK8G01MM4ZZYmilVb01n14zSMIui0XQAcIBs9bdEv53
	 M/5LCE6IAMX7t32NewyphTlpJdQqG6FMSwNWQSryo9Y3mZWyZ50OFXgZ2sy1gRyF4c
	 DrWewdGDH2GRiSlyfSVTtjHqWfzG2TsKcCkOj+TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Christian Brauner <brauner@kernel.org>,
	Petr Vaganov <petrvaganoff@gmail.com>
Subject: [PATCH 5.15 317/319] fs/stat.c: avoid harmless garbage value problem in vfs_statx_path()
Date: Thu, 26 Nov 2026 15:41:25 +0100
Message-ID: <20261126144013.916018001@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

commit 0fac3ed473dd2955053be6671cdd747807f5e488 upstream.

Clang static checker(scan-build) warning:
fs/stat.c:287:21: warning: The left expression of the compound assignment is
an uninitialized value. The computed value will also be garbage.
  287 |                 stat->result_mask |= STATX_MNT_ID_UNIQUE;
      |                 ~~~~~~~~~~~~~~~~~ ^
fs/stat.c:290:21: warning: The left expression of the compound assignment is
an uninitialized value. The computed value will also be garbage.
  290 |                 stat->result_mask |= STATX_MNT_ID;

When vfs_getattr() failed because of security_inode_getattr(), 'stat' is
uninitialized. In this case, there is a harmless garbage problem in
vfs_statx_path(). It's better to return error directly when
vfs_getattr() failed, avoiding garbage value and more clearly.

Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20250119025946.1168957-1-suhui@nfschina.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ Petr: There is no vfs_statx_path() in this tree. The fix is applied
  directly in vfs_statx() by jumping to path_put() via a new out_path
  label, preserving the reference drop and the ESTALE retry. ]
Fixes: fa2fcf4f1df1 ("statx: add mount ID")
Signed-off-by: Petr Vaganov <petrvaganoff@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/stat.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/stat.c
+++ b/fs/stat.c
@@ -227,11 +227,14 @@ retry:
 		goto out;
 
 	error = vfs_getattr(&path, stat, request_mask, flags);
+	if (error)
+		goto out_path;
 	stat->mnt_id = real_mount(path.mnt)->mnt_id;
 	stat->result_mask |= STATX_MNT_ID;
 	if (path.mnt->mnt_root == path.dentry)
 		stat->attributes |= STATX_ATTR_MOUNT_ROOT;
 	stat->attributes_mask |= STATX_ATTR_MOUNT_ROOT;
+out_path:
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;


