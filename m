Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B9F3BBFA1;
	Mon, 17 Aug 2026 13:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974159; cv=none; b=Ep/ALezaSe/9KGIj/72c6cdcNJfz+oWTZTS4dO5ieFaNt7vSJBG8K1BjgsV0UHCeFTZfros8XxPd0el8tJ5OSkQhbXqQaIP2h7cNq7r1UZHh5EvMSZyUfJrLBmL3EPA4UVHy1iZtOpvMzpzJcuVWuhk+4BCBuOdMPyoL2336VwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974159; c=relaxed/simple;
	bh=sNsL4KhY1ixd91+CORqKxM80xobpizJAt2W7cQqNRJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUn9vtZ9uZ5yY3TU1bWVveyoRpsRPULQUQvYLFIttunk6F6WW0Op9O/THL078CUJZC9yigz0wP0BIP8l318oU8l8tJJMqq+SHZ3X/deLDo0QcnuufPYG6LQaN0FJXT+H3IFEVqhRN1rWZBzr2XPJ+3DWzLfAH9/3GWIo+2LkzNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fnMQ4oZy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fnMQ4oZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651691F000E9;
	Mon, 17 Aug 2026 13:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974157;
	bh=GcimCa3EhSZhuboewzY/mul6OJwJfq6YDs4zqexigVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fnMQ4oZy7aniET1Z6At2+3oFIfe6ySAGuubewfuzgtg1Y7OuHgx1SjF0G3RL9VoyE
	 g85t5bSjMVK819bqszjyZkGEHG/oJ+Vc/pVo+KujieVEPOCJ2Ua5ucB1ebV+CJMIM+
	 69Z/cHVxy/GZqme7GNtzh0baARJ25K5j/Q9hccfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 082/271] vhost-scsi: reject feature changes after endpoint
Date: Mon, 17 Aug 2026 15:30:07 +0200
Message-ID: <20260817132540.118678405@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Jia <physicalmtea@gmail.com>

[ Upstream commit 42bc45df5905e2b7dccb72adaf7730f66cfbe03f ]

vhost_scsi_setup_vq_cmds() runs from VHOST_SCSI_SET_ENDPOINT and allocates
each command's protection scatterlist array (prot_sgl) according to the
acknowledged VIRTIO_SCSI_F_T10_PI bit.  The command pools are not rebuilt
when VHOST_SET_FEATURES changes that bit later.

Although virtio feature bits must not change after feature negotiation,
vhost_scsi_set_features() currently accepts such a request after the
endpoint is active and updates acked_features.  Enabling T10-PI after
endpoint setup therefore leaves prot_sgl NULL while the I/O path follows
the new feature bit.

For a 129-page protection payload, vhost_scsi_mapal() passes the missing
first chunk to sg_alloc_table_chained():

  sg_alloc_table_chained(table, 129, first_chunk=NULL,
                         nents_first_chunk=inline_sg_cnt)

sg_pool_index() then hits:

  BUG_ON(nents > SG_CHUNK_SIZE);   /* 129 > 128 */

The kernel reported the following call trace and register state:

  Call Trace:
   <TASK>
   ? __sg_alloc_table+0x1d8/0x250
   ? __pfx_vhost_run_work_list+0x10/0x10 [vhost]
   sg_alloc_table_chained+0x59/0xf0
   ? __pfx_sg_pool_alloc+0x10/0x10
   ? vhost_scsi_calc_sgls.constprop.0+0x43/0x60 [vhost_scsi]
   vhost_scsi_handle_vq+0xf02/0x1700 [vhost_scsi]
   ? __pfx_vhost_scsi_handle_vq+0x10/0x10 [vhost_scsi]
   vhost_scsi_handle_kick+0x37/0x50 [vhost_scsi]
   vhost_run_work_list+0x8e/0xd0 [vhost]
   vhost_task_fn+0xe1/0x210
   ret_from_fork+0x348/0x540
   </TASK>

  RIP: 0010:0x4
  CR2 = 0x4
  RSP: 0018:ffffc90000dbf940 EFLAGS: 00010202
  RAX: ffffffff82396810 RBX: ffff88811dc28b80 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: 0000000000000820 RDI: 0000000000000081

VHOST_F_LOG_ALL is a vhost-specific runtime feature and remains the only
exception.

Reject changes to any feature other than VHOST_F_LOG_ALL while the
endpoint is active.  This preserves the existing runtime log toggle while
preventing feature-dependent command resources and data-path state from
becoming inconsistent.  Userspace must clear the endpoint before changing
any other negotiated feature and set the endpoint up again afterward.

Fixes: bf2d650391be ("vhost-scsi: Allocate T10 PI structs only when enabled")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260726144314.1652934-1-physicalmtea@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index c79197edb1637..904bd842cdd84 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2227,6 +2227,7 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 {
 	struct vhost_virtqueue *vq;
 	bool is_log, was_log;
+	u64 old_features;
 	int i;
 
 	if (features & ~VHOST_SCSI_FEATURES)
@@ -2242,6 +2243,14 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 	if (!vs->dev.nvqs)
 		goto out;
 
+	old_features = vs->vqs[0].vq.acked_features;
+	if (vs->vs_tpg &&
+	    ((features ^ old_features) &
+	     ~(1ULL << VHOST_F_LOG_ALL))) {
+		mutex_unlock(&vs->dev.mutex);
+		return -EBUSY;
+	}
+
 	is_log = features & (1 << VHOST_F_LOG_ALL);
 	/*
 	 * All VQs should have same feature.
-- 
2.53.0



