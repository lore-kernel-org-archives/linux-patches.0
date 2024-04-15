Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA2941C75;
	Mon, 15 Apr 2024 14:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191545; cv=none; b=os3KltSIg5PfJlf2c5g4PzS2i/8wzxs/pJz9HPSZfxiHjpU3aHFjoVcC1r+jk1j7YZOKs+LRtAmXpQyMeL3bxrtQq0bThf8kvFUYC8HbAWL+XJwyusY2UfJxWQSCzX9DzJnYxWg1eNNUMd0mZ6myttXk46IeJA7Y8MzqegQg/k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191545; c=relaxed/simple;
	bh=kQErcpES5NeUrv2hYw13VUYP/DW0oM2KosR4bnVd/K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cu5s1U6tmK7F1q2lJThiYWiVsDLxB4xw13Q23VgHcofStbxkU5WntVRuiEIVedyECCO/FhMlXlM/ggZCAMYd9oKY6ARexro07k6HAb9HXezddprk/S8M6iNbpnW8WDQ3CiTjEOngDM8UUlfoETB3G4KqIJ3y0QeCY6oXot17GNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7ymBb2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7ymBb2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BF7C113CC;
	Mon, 15 Apr 2024 14:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191545;
	bh=kQErcpES5NeUrv2hYw13VUYP/DW0oM2KosR4bnVd/K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7ymBb2VqjZIQ3d/kN17++x+zK5Laq9DgvAVLK9wVb3TkBIu9Z1xE3h0ueVw4nlAt
	 IkH23n+0fRvR4XYc7XmHxFnKVwkFiVZGlEjXc45HStzZ1PJtSUywPU1WVXxtt30WeW
	 aACLbDJ7UosEoaZz5U7IQDCNlPruCyqEJGG6+5GU=
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
Subject: [PATCH 6.8 140/172] vhost: Add smp_rmb() in vhost_enable_notify()
Date: Mon, 15 Apr 2024 16:20:39 +0200
Message-ID: <20240415142004.625744465@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <gshan@redhat.com>

commit df9ace7647d4123209395bb9967e998d5758c645 upstream.

A smp_rmb() has been missed in vhost_enable_notify(), inspired by
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

Add the missed smp_rmb() in vhost_enable_notify(). When it returns true,
it means there's still pending tx buffers. Since it might read indices,
so it still can bypass the smp_rmb() in vhost_get_vq_desc(). Note that
it should be safe until vq->avail_idx is changed by commit d3bb267bbdcb
("vhost: cache avail index in vhost_enable_notify()").

Fixes: d3bb267bbdcb ("vhost: cache avail index in vhost_enable_notify()")
Cc: <stable@kernel.org> # v5.18+
Reported-by: Yihuang Yu <yihyu@redhat.com>
Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20240328002149.1141302-3-gshan@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vhost.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2848,9 +2848,19 @@ bool vhost_enable_notify(struct vhost_de
 		       &vq->avail->idx, r);
 		return false;
 	}
+
 	vq->avail_idx = vhost16_to_cpu(vq, avail_idx);
+	if (vq->avail_idx != vq->last_avail_idx) {
+		/* Since we have updated avail_idx, the following
+		 * call to vhost_get_vq_desc() will read available
+		 * ring entries. Make sure that read happens after
+		 * the avail_idx read.
+		 */
+		smp_rmb();
+		return true;
+	}
 
-	return vq->avail_idx != vq->last_avail_idx;
+	return false;
 }
 EXPORT_SYMBOL_GPL(vhost_enable_notify);
 


