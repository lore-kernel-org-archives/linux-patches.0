Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F4F1ACB2
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E02EC433EF;
	Wed,  7 Jun 2023 20:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170409;
	bh=CuKgPgV6aZ3NzUMUfu26ivUi3ak9kLb/FiLkOUerykQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jonh4GeyfNIoo8eZpoyt5LwHXXD2AGRNS62n3FtJWE9KdHKCjQ+nbLN7aKeYSJk3O
	 9yhVnUnnKhjidzl7ANw5NeCrke8Yd6lDD/piE81bWqi+n8CS82Vudgd2s0ksndKNr/
	 kazMFnb45Un3zJShmcd1KTnsKoNjhGabVMd4Uykc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liming Sun <limings@nvidia.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/225] platform/mellanox: fix potential race in mlxbf-tmfifo driver
Date: Wed,  7 Jun 2023 22:14:26 +0200
Message-ID: <20230607200916.767379073@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liming Sun <limings@nvidia.com>

[ Upstream commit 3d43f9f639542fadfb28f40b509bf147a6624d48 ]

This commit adds memory barrier for the 'vq' update in function
mlxbf_tmfifo_virtio_find_vqs() to avoid potential race due to
out-of-order memory write. It also adds barrier for the 'is_ready'
flag to make sure the initializations are visible before this flag
is checked.

Signed-off-by: Liming Sun <limings@nvidia.com>
Reviewed-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/b98c0ab61d644ba38fa9b3fd1607b138b0dd820b.1682518748.git.limings@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-tmfifo.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
index 1ae3c56b66b09..b2e19f30a928b 100644
--- a/drivers/platform/mellanox/mlxbf-tmfifo.c
+++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
@@ -765,7 +765,7 @@ static void mlxbf_tmfifo_rxtx(struct mlxbf_tmfifo_vring *vring, bool is_rx)
 	fifo = vring->fifo;
 
 	/* Return if vdev is not ready. */
-	if (!fifo->vdev[devid])
+	if (!fifo || !fifo->vdev[devid])
 		return;
 
 	/* Return if another vring is running. */
@@ -961,9 +961,13 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virtio_device *vdev,
 
 		vq->num_max = vring->num;
 
+		vq->priv = vring;
+
+		/* Make vq update visible before using it. */
+		virtio_mb(false);
+
 		vqs[i] = vq;
 		vring->vq = vq;
-		vq->priv = vring;
 	}
 
 	return 0;
@@ -1260,6 +1264,9 @@ static int mlxbf_tmfifo_probe(struct platform_device *pdev)
 
 	mod_timer(&fifo->timer, jiffies + MLXBF_TMFIFO_TIMER_INTERVAL);
 
+	/* Make all updates visible before setting the 'is_ready' flag. */
+	virtio_mb(false);
+
 	fifo->is_ready = true;
 	return 0;
 
-- 
2.39.2



