Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5582F216E30;
	Tue,  8 Apr 2025 11:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112270; cv=none; b=ijz1+Q2D79qlVsllw9zfo+SpRmMlLsPXNNZsCJ/oz52yc87rvytA9ry88u9Db5Bx5RJp00g/n9JlNlT44Tr/yEaAnPNiyGPd486R+/oJ7NWD+PHQDoR6EZJF8G5A5rKVbDxQRgclJ1C5L9pIv2jiT++TUwEdpxkZdkFAtk2Lqro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112270; c=relaxed/simple;
	bh=J+m6rKTsijpccpwWx2QYhD37bZONszItXd4UnxRwWls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qF5D/sqEebXzSNqeyOSypqJi8evDtGoNM1nt0S/MqC5NPNJYQdJxmjbEyGABhd5FhC06EmPk9pysMoa0hNNFCpyGKLpgKTFXEkb8gqNAyDjN4ijr5KC6amIwAK9m8HzsQv9KYyBgsMlfx6MKhzlVUxbYr3s0kCdCy8icdttOii0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJ1NTci6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJ1NTci6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635A4C4CEE5;
	Tue,  8 Apr 2025 11:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112269;
	bh=J+m6rKTsijpccpwWx2QYhD37bZONszItXd4UnxRwWls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJ1NTci6oZgXliQ5VTdmfXxVwLfBcEyWAeYYcgLwCbqUl8900mAEi0eUfEKph5vkN
	 S2lw8MgT0nfxs+9kaVbqL0V2mD8fOsYoasMZj+mWIrN66FpTb/cjYZmXcpqedVIdqu
	 lzHhHzL/jtpXqSOxtK/n87s63EKcMORrx8czTkaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.14 728/731] nfsd: fix management of listener transports
Date: Tue,  8 Apr 2025 12:50:25 +0200
Message-ID: <20250408104931.207535423@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

commit d093c90892607be505e801469d6674459e69ab89 upstream.

Currently, when no active threads are running, a root user using nfsdctl
command can try to remove a particular listener from the list of previously
added ones, then start the server by increasing the number of threads,
it leads to the following problem:

[  158.835354] refcount_t: addition on 0; use-after-free.
[  158.835603] WARNING: CPU: 2 PID: 9145 at lib/refcount.c:25 refcount_warn_saturate+0x160/0x1a0
[  158.836017] Modules linked in: rpcrdma rdma_cm iw_cm ib_cm ib_core nfsd auth_rpcgss nfs_acl lockd grace overlay isofs uinput snd_seq_dummy snd_hrtimer nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 rfkill ip_set nf_tables qrtr sunrpc vfat fat uvcvideo videobuf2_vmalloc videobuf2_memops uvc videobuf2_v4l2 videodev videobuf2_common snd_hda_codec_generic mc e1000e snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hda_core snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore sg loop dm_multipath dm_mod nfnetlink vsock_loopback vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport vmw_vmci vsock xfs libcrc32c crct10dif_ce ghash_ce vmwgfx sha2_ce sha256_arm64 sr_mod sha1_ce cdrom nvme drm_client_lib drm_ttm_helper ttm nvme_core drm_kms_helper nvme_auth drm fuse
[  158.840093] CPU: 2 UID: 0 PID: 9145 Comm: nfsd Kdump: loaded Tainted: G    B   W          6.13.0-rc6+ #7
[  158.840624] Tainted: [B]=BAD_PAGE, [W]=WARN
[  158.840802] Hardware name: VMware, Inc. VMware20,1/VBSA, BIOS VMW201.00V.24006586.BA64.2406042154 06/04/2024
[  158.841220] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[  158.841563] pc : refcount_warn_saturate+0x160/0x1a0
[  158.841780] lr : refcount_warn_saturate+0x160/0x1a0
[  158.842000] sp : ffff800089be7d80
[  158.842147] x29: ffff800089be7d80 x28: ffff00008e68c148 x27: ffff00008e68c148
[  158.842492] x26: ffff0002e3b5c000 x25: ffff600011cd1829 x24: ffff00008653c010
[  158.842832] x23: ffff00008653c000 x22: 1fffe00011cd1829 x21: ffff00008653c028
[  158.843175] x20: 0000000000000002 x19: ffff00008653c010 x18: 0000000000000000
[  158.843505] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[  158.843836] x14: 0000000000000000 x13: 0000000000000001 x12: ffff600050a26493
[  158.844143] x11: 1fffe00050a26492 x10: ffff600050a26492 x9 : dfff800000000000
[  158.844475] x8 : 00009fffaf5d9b6e x7 : ffff000285132493 x6 : 0000000000000001
[  158.844823] x5 : ffff000285132490 x4 : ffff600050a26493 x3 : ffff8000805e72bc
[  158.845174] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000098588000
[  158.845528] Call trace:
[  158.845658]  refcount_warn_saturate+0x160/0x1a0 (P)
[  158.845894]  svc_recv+0x58c/0x680 [sunrpc]
[  158.846183]  nfsd+0x1fc/0x348 [nfsd]
[  158.846390]  kthread+0x274/0x2f8
[  158.846546]  ret_from_fork+0x10/0x20
[  158.846714] ---[ end trace 0000000000000000 ]---

nfsd_nl_listener_set_doit() would manipulate the list of transports of
server's sv_permsocks and close the specified listener but the other
list of transports (server's sp_xprts list) would not be changed leading
to the problem above.

Instead, determined if the nfsdctl is trying to remove a listener, in
which case, delete all the existing listener transports and re-create
all-but-the-removed ones.

Fixes: 16a471177496 ("NFSD: add listener-{set,get} netlink command")
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   44 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1917,6 +1917,7 @@ int nfsd_nl_listener_set_doit(struct sk_
 	struct svc_serv *serv;
 	LIST_HEAD(permsocks);
 	struct nfsd_net *nn;
+	bool delete = false;
 	int err, rem;
 
 	mutex_lock(&nfsd_mutex);
@@ -1977,34 +1978,28 @@ int nfsd_nl_listener_set_doit(struct sk_
 		}
 	}
 
-	/* For now, no removing old sockets while server is running */
-	if (serv->sv_nrthreads && !list_empty(&permsocks)) {
+	/*
+	 * If there are listener transports remaining on the permsocks list,
+	 * it means we were asked to remove a listener.
+	 */
+	if (!list_empty(&permsocks)) {
 		list_splice_init(&permsocks, &serv->sv_permsocks);
-		spin_unlock_bh(&serv->sv_lock);
-		err = -EBUSY;
-		goto out_unlock_mtx;
+		delete = true;
 	}
+	spin_unlock_bh(&serv->sv_lock);
 
-	/* Close the remaining sockets on the permsocks list */
-	while (!list_empty(&permsocks)) {
-		xprt = list_first_entry(&permsocks, struct svc_xprt, xpt_list);
-		list_move(&xprt->xpt_list, &serv->sv_permsocks);
-
-		/*
-		 * Newly-created sockets are born with the BUSY bit set. Clear
-		 * it if there are no threads, since nothing can pick it up
-		 * in that case.
-		 */
-		if (!serv->sv_nrthreads)
-			clear_bit(XPT_BUSY, &xprt->xpt_flags);
-
-		set_bit(XPT_CLOSE, &xprt->xpt_flags);
-		spin_unlock_bh(&serv->sv_lock);
-		svc_xprt_close(xprt);
-		spin_lock_bh(&serv->sv_lock);
+	/* Do not remove listeners while there are active threads. */
+	if (serv->sv_nrthreads) {
+		err = -EBUSY;
+		goto out_unlock_mtx;
 	}
 
-	spin_unlock_bh(&serv->sv_lock);
+	/*
+	 * Since we can't delete an arbitrary llist entry, destroy the
+	 * remaining listeners and recreate the list.
+	 */
+	if (delete)
+		svc_xprt_destroy_all(serv, net);
 
 	/* walk list of addrs again, open any that still don't exist */
 	nlmsg_for_each_attr(attr, info->nlhdr, GENL_HDRLEN, rem) {
@@ -2031,6 +2026,9 @@ int nfsd_nl_listener_set_doit(struct sk_
 
 		xprt = svc_find_listener(serv, xcl_name, net, sa);
 		if (xprt) {
+			if (delete)
+				WARN_ONCE(1, "Transport type=%s already exists\n",
+					  xcl_name);
 			svc_xprt_put(xprt);
 			continue;
 		}


