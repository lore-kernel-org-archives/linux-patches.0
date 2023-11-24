Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C842EAEA;
	Fri, 24 Nov 2023 19:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ws2z/jmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEC7C433C8;
	Fri, 24 Nov 2023 19:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853333;
	bh=kjuY0HURZLHzzcsgCnUU6ZE5SKiVVQhh3LER52wV9ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ws2z/jmP0OsjKFZyyGanyl8mwwp/Y67Sb8AO72nZ8fR8tSJDGrxdnWp8SQWLkM7If
	 jetHQM2jTN8wA8J8a5v1oDys4uV5Y85Ra2IjqsCNA6FCnTwpbc3/Uv/w15q5Q+tTSK
	 Dy53Nv/wWhPxDQYNMyPR2DWkP5ZdCyj5DI0IrmKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/297] xfs: dont leak memory when attr fork loading fails
Date: Fri, 24 Nov 2023 17:53:08 +0000
Message-ID: <20231124172005.374026163@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172000.087816911@linuxfoundation.org>
References: <20231124172000.087816911@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit c78c2d0903183a41beb90c56a923e30f90fa91b9 ]

I observed the following evidence of a memory leak while running xfs/399
from the xfs fsck test suite (edited for brevity):

XFS (sde): Metadata corruption detected at xfs_attr_shortform_verify_struct.part.0+0x7b/0xb0 [xfs], inode 0x1172 attr fork
XFS: Assertion failed: ip->i_af.if_u1.if_data == NULL, file: fs/xfs/libxfs/xfs_inode_fork.c, line: 315
------------[ cut here ]------------
WARNING: CPU: 2 PID: 91635 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
CPU: 2 PID: 91635 Comm: xfs_scrub Tainted: G        W         5.19.0-rc7-xfsx #rc7 6e6475eb29fd9dda3181f81b7ca7ff961d277a40
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
RIP: 0010:assfail+0x46/0x4a [xfs]
Call Trace:
 <TASK>
 xfs_ifork_zap_attr+0x7c/0xb0
 xfs_iformat_attr_fork+0x86/0x110
 xfs_inode_from_disk+0x41d/0x480
 xfs_iget+0x389/0xd70
 xfs_bulkstat_one_int+0x5b/0x540
 xfs_bulkstat_iwalk+0x1e/0x30
 xfs_iwalk_ag_recs+0xd1/0x160
 xfs_iwalk_run_callbacks+0xb9/0x180
 xfs_iwalk_ag+0x1d8/0x2e0
 xfs_iwalk+0x141/0x220
 xfs_bulkstat+0x105/0x180
 xfs_ioc_bulkstat.constprop.0.isra.0+0xc5/0x130
 xfs_file_ioctl+0xa5f/0xef0
 __x64_sys_ioctl+0x82/0xa0
 do_syscall_64+0x2b/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

This newly-added assertion checks that there aren't any incore data
structures hanging off the incore fork when we're trying to reset its
contents.  From the call trace, it is evident that iget was trying to
construct an incore inode from the ondisk inode, but the attr fork
verifier failed and we were trying to undo all the memory allocations
that we had done earlier.

The three assertions in xfs_ifork_zap_attr check that the caller has
already called xfs_idestroy_fork, which clearly has not been done here.
As the zap function then zeroes the pointers, we've effectively leaked
the memory.

The shortest change would have been to insert an extra call to
xfs_idestroy_fork, but it makes more sense to bundle the _idestroy_fork
call into _zap_attr, since all other callsites call _idestroy_fork
immediately prior to calling _zap_attr.  IOWs, it eliminates one way to
fail.

Note: This change only applies cleanly to 2ed5b09b3e8f, since we just
reworked the attr fork lifetime.  However, I think this memory leak has
existed since 0f45a1b20cd8, since the chain xfs_iformat_attr_fork ->
xfs_iformat_local -> xfs_init_local_fork will allocate
ifp->if_u1.if_data, but if xfs_ifork_verify_local_attr fails,
xfs_iformat_attr_fork will free i_afp without freeing any of the stuff
hanging off i_afp.  The solution for older kernels I think is to add the
missing call to xfs_idestroy_fork just prior to calling kmem_cache_free.

Found by fuzzing a.sfattr.hdr.totsize = lastbit in xfs/399.

[ backport note: did not include refactoring of xfs_idestroy_fork into
xfs_ifork_zap_attr, simply added the missing call as suggested in the
commit for backports ]

Fixes: 2ed5b09b3e8f ("xfs: make inode attribute forks a permanent part of struct xfs_inode")
Probably-Fixes: 0f45a1b20cd8 ("xfs: improve local fork verification")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 20095233d7bc0..c1f965af8432d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -330,6 +330,7 @@ xfs_iformat_attr_fork(
 	}
 
 	if (error) {
+		xfs_idestroy_fork(ip->i_afp);
 		kmem_cache_free(xfs_ifork_zone, ip->i_afp);
 		ip->i_afp = NULL;
 	}
-- 
2.42.0



