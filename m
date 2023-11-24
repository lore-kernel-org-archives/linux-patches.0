Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2B339FC6;
	Fri, 24 Nov 2023 18:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVgFtssM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DE2C433C8;
	Fri, 24 Nov 2023 18:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848994;
	bh=vcsxQhQuS3M71sn0jWmTLn1OxvkioakeQfP8lswMimE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVgFtssMJywWh+vKO1WwdhoMVkfbYFslXXuFDA1K5uvgcJPYtevuZbyd+NyGwsUCx
	 fnkBc9hcfiAeVCyszzw3w1sw7aHJ0Lnd750ilZgnh7vG9IuzdDTCA2sy6R3TxPz5SZ
	 8jELQPgZSLubN4fFrRf+eJbdhSvdf/RuS6j1xhzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Kunkun Jiang <jiangkunkun@huawei.com>
Subject: [PATCH 4.14 56/57] scsi: virtio_scsi: limit number of hw queues by nr_cpu_ids
Date: Fri, 24 Nov 2023 17:51:20 +0000
Message-ID: <20231124171932.417823325@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171930.281665051@linuxfoundation.org>
References: <20231124171930.281665051@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dongli Zhang <dongli.zhang@oracle.com>

commit 1978f30a87732d4d9072a20abeded9fe17884f1b upstream.

When tag_set->nr_maps is 1, the block layer limits the number of hw queues
by nr_cpu_ids. No matter how many hw queues are used by virtio-scsi, as it
has (tag_set->nr_maps == 1), it can use at most nr_cpu_ids hw queues.

In addition, specifically for pci scenario, when the 'num_queues' specified
by qemu is more than maxcpus, virtio-scsi would not be able to allocate
more than maxcpus vectors in order to have a vector for each queue. As a
result, it falls back into MSI-X with one vector for config and one shared
for queues.

Considering above reasons, this patch limits the number of hw queues used
by virtio-scsi by nr_cpu_ids.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Kunkun Jiang <jiangkunkun@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/virtio_scsi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -891,6 +891,7 @@ static int virtscsi_probe(struct virtio_
 
 	/* We need to know how many queues before we allocate. */
 	num_queues = virtscsi_config_get(vdev, num_queues) ? : 1;
+	num_queues = min_t(unsigned int, nr_cpu_ids, num_queues);
 
 	num_targets = virtscsi_config_get(vdev, max_target) + 1;
 


