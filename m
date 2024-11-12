Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76CF1A76C7;
	Tue, 12 Nov 2024 10:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407416; cv=none; b=I0xJuUX4M5DR4D+PthQqgAkzEdTmmgNkXZB5OW4Cxvt7yGsBsb78ZxHxWf+RJO7A+B8SDw5jiXBB5WfNI3gyGOYEzmrjI1pCdr2+E0mooeiP8zmtE221MDGU2zgRYmvorsnANr1D/uNLf+8X+jjbvaTm8Kkt5a2wRmXH0sewwj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407416; c=relaxed/simple;
	bh=jFc8vgcUpI3YwcxR1sNmMzPcPm9A0ioCjdNu25nAQj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbpexvBXLPCO13kb3eSgh1US790GEFCUBwsG29UCiqxDHrIjSUt3hxFx2y3+Jpiz6shEhNtwuiC2AiODlC3yQvznRjKYBaHG/IpLxk2NH3t0azee/cSbxN3EvWRvNvc8hkU8yK9uUSIBnfastrSbBldUTJhzkFTrR6ki6vhNFKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFa+JP4i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFa+JP4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F59C4CECD;
	Tue, 12 Nov 2024 10:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407416;
	bh=jFc8vgcUpI3YwcxR1sNmMzPcPm9A0ioCjdNu25nAQj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFa+JP4ib0/bSGw1JNKZLwhoqLTo9XOHT9DzRAdEZnMJYAr2kCimR0VB5ty0Aqg3m
	 UpzMXgzvTQhjvUsxhWqYu4mwfRPoKPMiXgbtUvfSSvlrGy0/l1e8WSNkOvorQ8jZHk
	 UtjGZRtHLg07cqLwSTHs4kl/4ohWPFtuKILFz9vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Anna Schumaker <anna.schumaker@oracle.com>
Subject: [PATCH 6.1 69/98] nfs: Fix KMSAN warning in decode_getfattr_attrs()
Date: Tue, 12 Nov 2024 11:21:24 +0100
Message-ID: <20241112101846.885709292@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1566,6 +1566,7 @@ void nfs_fattr_init(struct nfs_fattr *fa
 	fattr->gencount = nfs_inc_attr_generation_counter();
 	fattr->owner_name = NULL;
 	fattr->group_name = NULL;
+	fattr->mdsthreshold = NULL;
 }
 EXPORT_SYMBOL_GPL(nfs_fattr_init);
 


