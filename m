Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16351433AD;
	Mon, 15 Apr 2024 14:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191830; cv=none; b=Jg20SigNWitTgZqbjcdL7OP/KWHzM2BfT5RKuCA1qYuFaqi9TLIXHu57JhovTYbCNU5jOKdRn7ofN2C9Zcz0IiZFv2S4TiM1+YYNlY/35NWQb5ERHHxFsOqjpHB/sFIra0/mUD997FH0yNxV3sH2cBfeQAaYGUSzjM3mXP5ugkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191830; c=relaxed/simple;
	bh=ZrdkxJz41zk2BB8WvvqwNNmfienUlIB5uwiaTZJ4f9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUBNts/w0OwIIjuV+RQJn5/tRXoUnAlz3swGI00hrmeyeVqXJT/AQR7UXz04mfWhBcfpAff2krjF2juWWIm13rgayOnMTRCn9P4Sw6w6Vv56bZgkcz6mt+3OSP5VEWHUFqyk2Is2TsHuuMRoVe9LyABiMqWwwfHiVlO1RnFsX/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYt9P5s3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYt9P5s3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AFDC113CC;
	Mon, 15 Apr 2024 14:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191830;
	bh=ZrdkxJz41zk2BB8WvvqwNNmfienUlIB5uwiaTZJ4f9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYt9P5s3S58YOFGmSUlWhHuQO7hypV2f6MxTmEgNFYCLM9ij8LH4vYDa3ySr0Q/Ly
	 fBdEMwBNpFZvRwkOgsmiWLXSWrcgLga0SQz1Jp3ZizYJe7T8OCjhS7aMuJpBZB81BW
	 ASrc1pFLaanK/veJWfADeem2oyc3GzofaIT4QV7I=
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
Subject: [PATCH 6.6 101/122] vhost: Add smp_rmb() in vhost_enable_notify()
Date: Mon, 15 Apr 2024 16:21:06 +0200
Message-ID: <20240415141956.406023711@linuxfoundation.org>
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
 


