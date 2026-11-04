Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829040;
	b=b9Q1YnIGTdMV/qJe73wwCVME9+GDHo3E7GQ+DsjIzZTlvq5/Xt0R4EypJV+UDCW6KBB5
	 CWRihx8NWUKKsiepuTIkKa9cgLy1ZdkfQTKCvg/Okrs66PhesKghBHVtFKChDsyTfxB9L
	 oHZ25yetAFTABJK2Z8k4G5eScWRjSnndw3CnKm6WLUgTyBPxRAt8zFfL0mXt3dA7naLN4
	 VjUSwL2DKkZLMTDj0oMGQajdb8wCo2+TFpbBqY6sAv5XOPiiRIRORnZKrt/a876LRMxjE
	 nLBis15U/wRldT6Qo52W9Y3a4CjY22c3l2bqDkE0qHFhh9rWJ6Qo1yxBqhklK1ui09A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RdoxLCMA5BEVmyRqifKkBX3Ec1/bC0RO0V1DKupL1eM=;
	b=trn5HJxdcNDRzyufNBHHYyJUrk1oeHtNKuol31WxrxT6yJm0gk9VdFZ6hoHNoiyl9elA
	 c4QIrggbZMITt1Dgeo3Db9jH8yt7HGHJWInho6Evs5h26su5uPqP0N6JT+NVkom5Pnd/A
	 f/w6q4fSI46qj6HK/vuLEzV8kcX/1Z1V0ssFEPTfrF7IjV5GQOWo+Vgk0+yiJiwpmythV
	 YmXIDBAa4d3EIEfEbIF6YdmviIlAkPvpQwidyQPG0f/S2rpoWJQttC9odc49IdecMWPnz
	 fdwld6jqvlH2/DRLOKmshGTKcDnxkbqLK/WPPLWvHh1RxTmELrvkO0+QrAvAS+0977A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TM7wO1GB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024896070764;
	Wed,  4 Nov 2026 21:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TM7wO1GB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956AF1F00A16;
	Wed,  4 Nov 2026 21:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829039;
	bh=RdoxLCMA5BEVmyRqifKkBX3Ec1/bC0RO0V1DKupL1eM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TM7wO1GBj3ZLv66FU5leLOwr47UqNI3zlu4qz27R0EN9YETgrDfgauwgF2/Uku850
	 3ivB0gwnTod+MIQojf6AvBIC7RV6M250VWMJTw7JCfQT9FqjLKcDnAzJC/C8/i6IdW
	 fxetIcc6Xq9vKTGzniF+VTZ7h4Pa1CrqnaLj1jdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Zuber <jamz@amazon.com>,
	NeilBrown <neil@brown.name>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 7.3 406/547] NFS: Fix stale negative cache on failed nfs_mkdir()
Date: Wed,  4 Nov 2026 16:09:50 -0500
Message-ID: <20261104211049.850684924@linuxfoundation.org>
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
@@ -2490,6 +2490,8 @@ struct dentry *nfs_mkdir(struct mnt_idma
 	trace_nfs_mkdir_enter(dir, dentry);
 	ret = NFS_PROTO(dir)->mkdir(dir, dentry, &attr);
 	trace_nfs_mkdir_exit(dir, dentry, PTR_ERR_OR_ZERO(ret));
+	if (IS_ERR(ret))
+		d_drop(dentry);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nfs_mkdir);


