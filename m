Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95E918785C;
	Fri, 15 Nov 2024 06:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653027; cv=none; b=bVzfuTqznkSyLzrm19OKywxkSHSog6tqZxxIktZpQlMS5SYeKYbSWmDmRlA8x5IjjWXPd4Q5ZES8FgAhCQzDPTin1oFoCLjLn8I7yF6Q+0YJj6w/C9mykLP/ptZkgCGntePFkbcdmF+QaTCazclU5quDh5M/Svq9N6iGog/FB7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653027; c=relaxed/simple;
	bh=aE2yc7O4MQgHJkjdyjrGmE1PC6YiekhHx9H8piupe+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAoMcow7CiBPaB0eGw0ErvqMQc4xSRRuMyQafBxCnmePpW4TcXdE0sFfzJ+bux7Gn3jFH47Q2cBom3D6SA0L+wVD5jRNnOrtMfsYbC68CVX0hArQKmbw8+ZHvTgoZdDyLuLKfd46CzSi4YlgDf+qGUY8JI5qql292ZwaAZ43km0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TcR9t8aZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TcR9t8aZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D225C4CECF;
	Fri, 15 Nov 2024 06:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653027;
	bh=aE2yc7O4MQgHJkjdyjrGmE1PC6YiekhHx9H8piupe+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TcR9t8aZ0iquXg2MINBNM44sLYqg5V7LwGnf4+Ynkb4TI0IjsabfAQ1bB0ug6bz0s
	 ZhuV/zRyuVzGXDLcSKucVN9iN0BUsxMNp6WtHqIKQxFgklhycpOuHx2WTf/8bWDThO
	 jOhBKpQWURQ0WeH4SNrm2DqHCq0ZIvct7npAWpgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 5.4 32/66] nfs: Fix KMSAN warning in decode_getfattr_attrs()
Date: Fri, 15 Nov 2024 07:37:41 +0100
Message-ID: <20241115063724.001569823@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Roberto Sassu <roberto.sassu@huawei.com>

commit dc270d7159699ad6d11decadfce9633f0f71c1db upstream.

Fix the following KMSAN warning:

CPU: 1 UID: 0 PID: 7651 Comm: cp Tainted: G    B
Tainted: [B]=BAD_PAGE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)
=====================================================
=====================================================
BUG: KMSAN: uninit-value in decode_getfattr_attrs+0x2d6d/0x2f90
 decode_getfattr_attrs+0x2d6d/0x2f90
 decode_getfattr_generic+0x806/0xb00
 nfs4_xdr_dec_getattr+0x1de/0x240
 rpcauth_unwrap_resp_decode+0xab/0x100
 rpcauth_unwrap_resp+0x95/0xc0
 call_decode+0x4ff/0xb50
 __rpc_execute+0x57b/0x19d0
 rpc_execute+0x368/0x5e0
 rpc_run_task+0xcfe/0xee0
 nfs4_proc_getattr+0x5b5/0x990
 __nfs_revalidate_inode+0x477/0xd00
 nfs_access_get_cached+0x1021/0x1cc0
 nfs_do_access+0x9f/0xae0
 nfs_permission+0x1e4/0x8c0
 inode_permission+0x356/0x6c0
 link_path_walk+0x958/0x1330
 path_lookupat+0xce/0x6b0
 filename_lookup+0x23e/0x770
 vfs_statx+0xe7/0x970
 vfs_fstatat+0x1f2/0x2c0
 __se_sys_newfstatat+0x67/0x880
 __x64_sys_newfstatat+0xbd/0x120
 x64_sys_call+0x1826/0x3cf0
 do_syscall_64+0xd0/0x1b0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The KMSAN warning is triggered in decode_getfattr_attrs(), when calling
decode_attr_mdsthreshold(). It appears that fattr->mdsthreshold is not
initialized.

Fix the issue by initializing fattr->mdsthreshold to NULL in
nfs_fattr_init().

Cc: stable@vger.kernel.org # v3.5.x
Fixes: 88034c3d88c2 ("NFSv4.1 mdsthreshold attribute xdr")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1494,6 +1494,7 @@ void nfs_fattr_init(struct nfs_fattr *fa
 	fattr->gencount = nfs_inc_attr_generation_counter();
 	fattr->owner_name = NULL;
 	fattr->group_name = NULL;
+	fattr->mdsthreshold = NULL;
 }
 EXPORT_SYMBOL_GPL(nfs_fattr_init);
 


