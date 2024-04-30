Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667C9129E81;
	Tue, 30 Apr 2024 10:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473702; cv=none; b=sqbhC6zubz0rqGhSGCycs/3AJ840ne0LfXYCUsO13IHFi/k1gZ65YccE25hSxItFrSNR35OMp/FlRQ/ZyzPaO5XTh3Z1aeIYwVtuqUWzqv9WeKS0oYzMoJY47Q81Dgxs8wLH4LUsio4mayMPV0mV5pFkOiVarY+8iwMXprOjGIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473702; c=relaxed/simple;
	bh=UYr6g1KvOjMJuBGnnL3YVTxuxdVRBYXIs0ALbakW5iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwSIpB0buMx3E26oYdebhUMx1/uwfNw0n1EDmtG9/vVMsc2FmngMjBx0ws2P6iezU5xl/MOhoA/3Gajewv0l4OsPN0vh+ng8b31JPGJrKN2XjCSNo8SUrQ14MneZRGu+cp4VCLmztF6+wZiaQTnlPZg2jzhsQ9bcwycUMyFNc9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bImZO0cK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bImZO0cK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A429C2BBFC;
	Tue, 30 Apr 2024 10:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473701;
	bh=UYr6g1KvOjMJuBGnnL3YVTxuxdVRBYXIs0ALbakW5iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bImZO0cKNPQkrsm/sunwsTnH9x2rVVY19AxxRDFTkowLRj04isEnhdWMAS60yknjh
	 5zqWr5aISlvcNtkSFpopIvVWHg+P4l+w4bO0WjoFkjwA1MBHwle3GNwApxyVPMsWil
	 v1izoikfCKITKbLCNt54vITyExNYe807qaPw1km8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihuang Yu <yihyu@redhat.com>,
	Will Deacon <will@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	stable@kernel.org
Subject: [PATCH 4.19 10/77] vhost: Add smp_rmb() in vhost_vq_avail_empty()
Date: Tue, 30 Apr 2024 12:38:49 +0200
Message-ID: <20240430103041.425493448@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <gshan@redhat.com>

commit 22e1992cf7b034db5325660e98c41ca5afa5f519 upstream.

A smp_rmb() has been missed in vhost_vq_avail_empty(), spotted by
Will. Otherwise, it's not ensured the available ring entries pushed
by guest can be observed by vhost in time, leading to stale available
ring entries fetched by vhost in vhost_get_vq_desc(), as reported by
Yihuang Yu on NVidia's grace-hopper (ARM64) platform.

  /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64      \
  -accel kvm -machine virt,gic-version=host -cpu host          \
  -smp maxcpus=1,cpus=1,sockets=1,clusters=1,cores=1,threads=1 \
  -m 4096M,slots=16,maxmem=64G                                 \
  -object memory-backend-ram,id=mem0,size=4096M                \
   :                                                           \
  -netdev tap,id=vnet0,vhost=true                              \
  -device virtio-net-pci,bus=pcie.8,netdev=vnet0,mac=52:54:00:f1:26:b0
   :
  guest# netperf -H 10.26.1.81 -l 60 -C -c -t UDP_STREAM
  virtio_net virtio0: output.0:id 100 is not a head!

Add the missed smp_rmb() in vhost_vq_avail_empty(). When tx_can_batch()
returns true, it means there's still pending tx buffers. Since it might
read indices, so it still can bypass the smp_rmb() in vhost_get_vq_desc().
Note that it should be safe until vq->avail_idx is changed by commit
275bf960ac697 ("vhost: better detection of available buffers").

Fixes: 275bf960ac69 ("vhost: better detection of available buffers")
Cc: <stable@kernel.org> # v4.11+
Reported-by: Yihuang Yu <yihyu@redhat.com>
Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20240328002149.1141302-2-gshan@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vhost.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2426,9 +2426,19 @@ bool vhost_vq_avail_empty(struct vhost_d
 	r = vhost_get_avail(vq, avail_idx, &vq->avail->idx);
 	if (unlikely(r))
 		return false;
+
 	vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
+	if (vq->avail_idx != vq->last_avail_idx) {
+		/* Since we have updated avail_idx, the following
+		 * call to vhost_get_vq_desc() will read available
+		 * ring entries. Make sure that read happens after
+		 * the avail_idx read.
+		 */
+		smp_rmb();
+		return false;
+	}
 
-	return vq->avail_idx == vq->last_avail_idx;
+	return true;
 }
 EXPORT_SYMBOL_GPL(vhost_vq_avail_empty);
 


