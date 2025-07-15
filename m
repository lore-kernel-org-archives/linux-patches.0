Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6042984A35;
	Tue, 15 Jul 2025 13:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587392; cv=none; b=UpO0CVIVGaDkiugiBFflBxdbbB0bJoH3dJjbsXfcK9vsKezP1qqb4vaObmtF7a5X402um+YA2q/aEVCe1cJHVS5gx+t/1kbsAzeXx0EguhWXL9UqyKqJ/toXIQrK/DfTWAL+g0uqHJ5ujXn6IBwqOyIRd+ElYLNTdX7jtngexmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587392; c=relaxed/simple;
	bh=qzx6s2UFaPGCYqI7L1Mi9EdpudBuAA0FnQNC7Ggq8tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6kdKeAxCqEJiX8bL57BS51WgLwFeK10yKDO9wtEU2+vHbsuOnoA3i2XzPxMka7VYQcyCEskWzQvrLULUlDaaeH1lJYHh3I2cBzdQXaey+AyreNAM6N+Qf6IAyHmB0y0lEL8d67gxXHsMBQVUCO69cggWWWYDxKSNqGXmFWR/ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSi4KRGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSi4KRGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9BDC4CEF1;
	Tue, 15 Jul 2025 13:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587392;
	bh=qzx6s2UFaPGCYqI7L1Mi9EdpudBuAA0FnQNC7Ggq8tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSi4KRGOBfXsycVGNMloPysPAC400WdTFBiD5hLMPyOMzLrX2vmQwEoSuv3DJ51Cn
	 lA9MpXszrUJESpC8ekNdLA43L4OjiVqOHAlAXVrq+B+2j/KnNHu3VHthq/950BvbYV
	 09gly4QdS5kl8AFaN4ZwR7wNu7DJReFFfivNoXTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Jason Wang <jasowang@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Xinyu Zheng <zhengxinyu6@huawei.com>
Subject: [PATCH 6.1 84/88] vhost-scsi: protect vq->log_used with vq->mutex
Date: Tue, 15 Jul 2025 15:15:00 +0200
Message-ID: <20250715130757.942070943@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dongli Zhang <dongli.zhang@oracle.com>

commit f591cf9fce724e5075cc67488c43c6e39e8cbe27 upstream.

The vhost-scsi completion path may access vq->log_base when vq->log_used is
already set to false.

    vhost-thread                       QEMU-thread

vhost_scsi_complete_cmd_work()
-> vhost_add_used()
   -> vhost_add_used_n()
      if (unlikely(vq->log_used))
                                      QEMU disables vq->log_used
                                      via VHOST_SET_VRING_ADDR.
                                      mutex_lock(&vq->mutex);
                                      vq->log_used = false now!
                                      mutex_unlock(&vq->mutex);

				      QEMU gfree(vq->log_base)
        log_used()
        -> log_write(vq->log_base)

Assuming the VMM is QEMU. The vq->log_base is from QEMU userpace and can be
reclaimed via gfree(). As a result, this causes invalid memory writes to
QEMU userspace.

The control queue path has the same issue.

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Message-Id: <20250403063028.16045-2-dongli.zhang@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
[ resoloved conflicts in drivers/vhost/scsi.c
  bacause vhost_scsi_complete_cmd_work() has been refactored. ]
Signed-off-by: Xinyu Zheng <zhengxinyu6@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/scsi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -568,8 +568,10 @@ static void vhost_scsi_complete_cmd_work
 		ret = copy_to_iter(&v_rsp, sizeof(v_rsp), &iov_iter);
 		if (likely(ret == sizeof(v_rsp))) {
 			struct vhost_scsi_virtqueue *q;
-			vhost_add_used(cmd->tvc_vq, cmd->tvc_vq_desc, 0);
 			q = container_of(cmd->tvc_vq, struct vhost_scsi_virtqueue, vq);
+			mutex_lock(&q->vq.mutex);
+			vhost_add_used(cmd->tvc_vq, cmd->tvc_vq_desc, 0);
+			mutex_unlock(&q->vq.mutex);
 			vq = q - vs->vqs;
 			__set_bit(vq, vs->compl_bitmap);
 		} else
@@ -1173,8 +1175,11 @@ static void vhost_scsi_tmf_resp_work(str
 	else
 		resp_code = VIRTIO_SCSI_S_FUNCTION_REJECTED;
 
+	mutex_lock(&tmf->svq->vq.mutex);
 	vhost_scsi_send_tmf_resp(tmf->vhost, &tmf->svq->vq, tmf->in_iovs,
 				 tmf->vq_desc, &tmf->resp_iov, resp_code);
+	mutex_unlock(&tmf->svq->vq.mutex);
+
 	vhost_scsi_release_tmf_res(tmf);
 }
 


