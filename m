Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831738;
	b=V0aBSjIyGoxw3h2pHxEUfgcB2i936RvVGhhmO2vjD9/zmoI1s3ckSovxgTadPvoI3Msf
	 +su2Hm05Xni+8ULfPxqHjO0qh9WEh6zeDBAlzAvvYyteyTaHJm2QTF8TRPTCpxTvFLO45
	 RGOyE2uE0cBI27emxitqWERyuvEHAgAwV/Kz5DhGCI4QYkzbLZzpEDMm8JwoOOFjuaiKv
	 bRKrDfhVhNvnaFQRVC+9U30koPQG3nnFioCgbwKyFCeL9OLFEkiJOfRK1K9PRNQkZtxxp
	 h8MC3cWptTStuClapZ4iwStPex+RvAdEvs0pjO3s2By4/aS+J3ao2hVmAKuL2ul2yoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831738;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hGpYJNZm1haREsS2n6aSYkoccvODzsqNwvODuLtmbCE=;
	b=PHZeDft7YDjbytg5ZsALGSwRlcm0wP/tmEzw2tc+/N6lsORHwZ0VEwpHkGXuJ1JjLCJi
	 rRYw4mAfH5C+zpKc/mmuDZkhtdqQhpmSDgC4rBtMNM5ofEq3dtG1X/Jc4AC9B/UyCyirC
	 aRIVbXaDZotbqGhhWTaPAvtsIoGHCaG1fi9WaRmDTnDoCj7Kc+OsGkNppHjgyuGHcx100
	 7UK7KV7ad4ZQWvL0VSbTuLPemxv+6T6936BcnOUVm9BmgGotYu5hu468qhv2//euDnVas
	 T0Q390lWTfhNqKcsVXL360/PuhzD6sSQ38L2kjwhIc3qqjcbwqEVq6YOO79wb7bd9Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZus6kyg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEE9606A32F;
	Wed,  4 Nov 2026 22:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sZus6kyg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2761F000C1;
	Wed,  4 Nov 2026 22:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831737;
	bh=hGpYJNZm1haREsS2n6aSYkoccvODzsqNwvODuLtmbCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sZus6kygcZ3Qsr10ESfsM0qfqySFkd5k7mN48+Ytagk5Zcy05YqmlzhEIfxAdqJ/P
	 +7hDoOmrmrQzAAOS5qTSKCurbkTqFpPVIhihMjTaMGaN381BczLWxbvOQ8KQUVAeCN
	 tcep5ny1qy0pnT7XxX1/B+qTW/sRUYjqt1x+a9W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Zuber <jamz@amazon.com>,
	NeilBrown <neil@brown.name>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.18 0882/1005] NFS: Fix stale negative cache on failed nfs_mkdir()
Date: Wed,  4 Nov 2026 16:10:15 -0500
Message-ID: <20261104211107.945341206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jimmy Zuber <jamz@amazon.com>

commit 211cda4fdf33011cee39f8970c4625b207142d6b upstream.

Since commit 8376583b84a1 ("nfs: change mkdir inode_operation to return
alternate dentry if needed"), nfs_mkdir() no longer drops the dentry on
RPC failure.  A negative cache value can then result in spurious ENOENT
results for further operations within that directory, such as open or
stat.

We observed this breaking some applications where an EEXIST on mkdir
caused the application to assume the directory to exist, only to fail
operations within that directory due to the retained negative cache
entry.  The other create paths, nfs_create() and nfs_mknod(), still drop
the dentry on failure.  This patch restores the previous behavior.

Fixes: 8376583b84a1 ("nfs: change mkdir inode_operation to return alternate dentry if needed")
Cc: stable@vger.kernel.org # v6.15+
Signed-off-by: Jimmy Zuber <jamz@amazon.com>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -2442,6 +2442,8 @@ struct dentry *nfs_mkdir(struct mnt_idma
 	trace_nfs_mkdir_enter(dir, dentry);
 	ret = NFS_PROTO(dir)->mkdir(dir, dentry, &attr);
 	trace_nfs_mkdir_exit(dir, dentry, PTR_ERR_OR_ZERO(ret));
+	if (IS_ERR(ret))
+		d_drop(dentry);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nfs_mkdir);


