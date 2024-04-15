Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258168BF8;
	Mon, 15 Apr 2024 14:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191827; cv=none; b=k3liQ6AEzIRBFPakKfR11NDf4hjoVdpJaRQ6LAYQehpvt2FNgm3842PTYkqwHrxn+gZTMnpVh+Ns3xTgiPu5E6DitgaPpF0FMbpFboBHT4kusbPP5KLWoPVP3Pafw+ulEgx1SW5urDwSTeX4XF1eXtXxhKx0JP1JJ/IyDM9dgLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191827; c=relaxed/simple;
	bh=xxks4pLNfsngS6S7SYkanYCEpsAzI9yfNrC2W72614c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rISx0rXYjL7hX75ItqMTV7M6X8XnHbYQp61CKXBCfa+xWOLWh55R83MNZrcViD0vqUaaSEvGUVPs+jLG74PsH67Schnv3kdYD1VgMIAbYsF8xn/07jOEk+GNpsNdVRJQV6rBu3DXE/7oYxlscYPJt2EUrWHEb+uF0PtSYx/nMQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4sBk3Qs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4sBk3Qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1665C113CC;
	Mon, 15 Apr 2024 14:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191827;
	bh=xxks4pLNfsngS6S7SYkanYCEpsAzI9yfNrC2W72614c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4sBk3QsXztdL264EFOdrhXdOXXO59Crtms5qLpYcrvPXC0uGWiLft44m+46997pc
	 OjgwXRZCXEjTyTuF3FovMWaQ0guQN3wlRmLfJrP6QX/7M4Wb34vdDykOojExdwUgf6
	 lkykVFGgn56iyxMsr1D9Eb8mz5HIwggrJXLaN/jw=
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
Subject: [PATCH 6.6 100/122] vhost: Add smp_rmb() in vhost_vq_avail_empty()
Date: Mon, 15 Apr 2024 16:21:05 +0200
Message-ID: <20240415141956.374715688@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2799,9 +2799,19 @@ bool vhost_vq_avail_empty(struct vhost_d
 	r = vhost_get_avail_idx(vq, &avail_idx);
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
 


