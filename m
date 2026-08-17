Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657493B8BDA;
	Mon, 17 Aug 2026 13:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974962; cv=none; b=McuVyKdTnUNzq9CwO5a33OspE/GaFxJAt9OMFwXn4z4HftOTVhvWb90F8reZvSjKG/tkitV/cowWzdG5KW+tIHBui9psIatvbEesKT8O5PvI40JbfIkDfAIS3QFftv6jVF/PY9hAmfnmQCMz/PtWfZlM2xFNNIxueAbQ3Ke1o+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974962; c=relaxed/simple;
	bh=SAK7L5tPtXgn+y9ccx1YBsW4lrlGBbSG9bjdx6laeqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyMubidNkttmlwvACA7EkjlKcodIRr3ZhgKSlYl9KgY6h0xz7xBe4fSRiFyXv+MUwI7ryTanZzbyad4Y6vls/wD2+zqm3h2a+ig7KEy9n9KYlv1H+raAiVElyRZgPtkEDbW8BC7dBjAIAiYFTym2XfXkWQUISX4FP/8tayye49E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7mdctVJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7mdctVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA49F1F00A3D;
	Mon, 17 Aug 2026 13:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974958;
	bh=DEco5GD/l46AmEQV4FjnG+og7WOm7CzwNm/trdXtzAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k7mdctVJDu+nxCSAEX9xiWecrkGXU/OZ86IbaSd6+rSSUsvGheNoBr/f3AkmJpgmV
	 s9qWjR+qsCDHrr+r6iMVzrleRk2kyqTZmbIiSHr+9tbl1KANNvhSpWgZFcjTIt72jV
	 oaORsQSidKUFtL6wJEyDuyfCOfxW9eRhN1erF5fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Jia <physicalmtea@gmail.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 074/250] vhost-scsi: reject feature changes after endpoint
Date: Mon, 17 Aug 2026 15:30:35 +0200
Message-ID: <20260817132539.467595082@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 65a57de0080ef..29716ce714554 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -2231,6 +2231,7 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 {
 	struct vhost_virtqueue *vq;
 	bool is_log, was_log;
+	u64 old_features;
 	int i;
 
 	if (features & ~VHOST_SCSI_FEATURES)
@@ -2246,6 +2247,14 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
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



