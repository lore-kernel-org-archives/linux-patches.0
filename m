Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB76A313552;
	Wed,  3 Dec 2025 16:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778195; cv=none; b=F9N4R6Bj2PDuloHkh48xZJa7TOVSkkpxfGeUVxyOkhM/ve2754a1LGyuOtAQMb2xdxMZ1jxmhvVJLDrHDchNiQrrwNlsoRURZvaVeeL+smSR2fI0yCFHw8OU9hnWU6mnH3ykpcp2V1B++INLrEnvGa+rikni5nNbHf/GJ0sB7ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778195; c=relaxed/simple;
	bh=A6gPhNbzO+GFRMQFCfp6IvcrunNytIcHsOkWNS53huE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odJZ9nKQSH549/EMa16jZb2qPpEYcbEyFBUS1wJIYr7uaTRrujiAQoHgPJ1Bj+3hpEMC/VOXwd6ToCFe+sqi/9A7OsUCedi88wRM2cK2wayMWOvNfNrBNL6iqIJRWrl/oqQo0bGSaCxULMN3fqDOToNGowYBnj0Fdagzw07aXUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PT3Y6tSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PT3Y6tSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C4CC4CEF5;
	Wed,  3 Dec 2025 16:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778195;
	bh=A6gPhNbzO+GFRMQFCfp6IvcrunNytIcHsOkWNS53huE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PT3Y6tSJCA0F0iLmAi/4Lt3SdJBWEs92vXTfkQfDda+OuhAo31Fc7i/Ew5HPC3I4c
	 ShJ2YK7Y0wBGT6reTJTbG7WnARW1o93mJ+E39xy/f0hSYl/BPBHx84c6oKFaHndUJe
	 YVkFwI3r4A8d7sMcx7f2Y1gDClCo29qoQNB6l9J0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	rtm@csail.mit.edu,
	Olga Kornievskaia <okorniev@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 271/392] NFSD: free copynotify stateid in nfs4_free_ol_stateid()
Date: Wed,  3 Dec 2025 16:27:01 +0100
Message-ID: <20251203152424.136270918@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Olga Kornievskaia <okorniev@redhat.com>

commit 4aa17144d5abc3c756883e3a010246f0dba8b468 upstream.

Typically copynotify stateid is freed either when parent's stateid
is being close/freed or in nfsd4_laundromat if the stateid hasn't
been used in a lease period.

However, in case when the server got an OPEN (which created
a parent stateid), followed by a COPY_NOTIFY using that stateid,
followed by a client reboot. New client instance while doing
CREATE_SESSION would force expire previous state of this client.
It leads to the open state being freed thru release_openowner->
nfs4_free_ol_stateid() and it finds that it still has copynotify
stateid associated with it. We currently print a warning and is
triggerred

WARNING: CPU: 1 PID: 8858 at fs/nfsd/nfs4state.c:1550 nfs4_free_ol_stateid+0xb0/0x100 [nfsd]

This patch, instead, frees the associated copynotify stateid here.

If the parent stateid is freed (without freeing the copynotify
stateids associated with it), it leads to the list corruption
when laundromat ends up freeing the copynotify state later.

[ 1626.839430] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
[ 1626.842828] Modules linked in: nfnetlink_queue nfnetlink_log bluetooth cfg80211 rpcrdma rdma_cm iw_cm ib_cm ib_core nfsd nfs_acl lockd grace nfs_localio ext4 crc16 mbcache jbd2 overlay uinput snd_seq_dummy snd_hrtimer qrtr rfkill vfat fat uvcvideo snd_hda_codec_generic videobuf2_vmalloc videobuf2_memops snd_hda_intel uvc snd_intel_dspcfg videobuf2_v4l2 videobuf2_common snd_hda_codec snd_hda_core videodev snd_hwdep snd_seq mc snd_seq_device snd_pcm snd_timer snd soundcore sg loop auth_rpcgss vsock_loopback vmw_vsock_virtio_transport_common vmw_vsock_vmci_transport vmw_vmci vsock xfs 8021q garp stp llc mrp nvme ghash_ce e1000e nvme_core sr_mod nvme_keyring nvme_auth cdrom vmwgfx drm_ttm_helper ttm sunrpc dm_mirror dm_region_hash dm_log iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi fuse dm_multipath dm_mod nfnetlink
[ 1626.855594] CPU: 2 UID: 0 PID: 199 Comm: kworker/u24:33 Kdump: loaded Tainted: G    B   W           6.17.0-rc7+ #22 PREEMPT(voluntary)
[ 1626.857075] Tainted: [B]=BAD_PAGE, [W]=WARN
[ 1626.857573] Hardware name: VMware, Inc. VMware20,1/VBSA, BIOS VMW201.00V.24006586.BA64.2406042154 06/04/2024
[ 1626.858724] Workqueue: nfsd4 laundromat_main [nfsd]
[ 1626.859304] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[ 1626.860010] pc : __list_del_entry_valid_or_report+0x148/0x200
[ 1626.860601] lr : __list_del_entry_valid_or_report+0x148/0x200
[ 1626.861182] sp : ffff8000881d7a40
[ 1626.861521] x29: ffff8000881d7a40 x28: 0000000000000018 x27: ffff0000c2a98200
[ 1626.862260] x26: 0000000000000600 x25: 0000000000000000 x24: ffff8000881d7b20
[ 1626.862986] x23: ffff0000c2a981e8 x22: 1fffe00012410e7d x21: ffff0000920873e8
[ 1626.863701] x20: ffff0000920873e8 x19: ffff000086f22998 x18: 0000000000000000
[ 1626.864421] x17: 20747562202c3839 x16: 3932326636383030 x15: 3030666666662065
[ 1626.865092] x14: 6220646c756f6873 x13: 0000000000000001 x12: ffff60004fd9e4a3
[ 1626.865713] x11: 1fffe0004fd9e4a2 x10: ffff60004fd9e4a2 x9 : dfff800000000000
[ 1626.866320] x8 : 00009fffb0261b5e x7 : ffff00027ecf2513 x6 : 0000000000000001
[ 1626.866938] x5 : ffff00027ecf2510 x4 : ffff60004fd9e4a3 x3 : 0000000000000000
[ 1626.867553] x2 : 0000000000000000 x1 : ffff000096069640 x0 : 000000000000006d
[ 1626.868167] Call trace:
[ 1626.868382]  __list_del_entry_valid_or_report+0x148/0x200 (P)
[ 1626.868876]  _free_cpntf_state_locked+0xd0/0x268 [nfsd]
[ 1626.869368]  nfs4_laundromat+0x6f8/0x1058 [nfsd]
[ 1626.869813]  laundromat_main+0x24/0x60 [nfsd]
[ 1626.870231]  process_one_work+0x584/0x1050
[ 1626.870595]  worker_thread+0x4c4/0xc60
[ 1626.870893]  kthread+0x2f8/0x398
[ 1626.871146]  ret_from_fork+0x10/0x20
[ 1626.871422] Code: aa1303e1 aa1403e3 910e8000 97bc55d7 (d4210000)
[ 1626.871892] SMP: stopping secondary CPUs

Reported-by: rtm@csail.mit.edu
Closes: https://lore.kernel.org/linux-nfs/d8f064c1-a26f-4eed-b4f0-1f7f608f415f@oracle.com/T/#t
Fixes: 624322f1adc5 ("NFSD add COPY_NOTIFY operation")
Cc: stable@vger.kernel.org
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1499,7 +1499,8 @@ static void nfs4_free_ol_stateid(struct
 	release_all_access(stp);
 	if (stp->st_stateowner)
 		nfs4_put_stateowner(stp->st_stateowner);
-	WARN_ON(!list_empty(&stid->sc_cp_list));
+	if (!list_empty(&stid->sc_cp_list))
+		nfs4_free_cpntf_statelist(stid->sc_client->net, stid);
 	kmem_cache_free(stateid_slab, stid);
 }
 


