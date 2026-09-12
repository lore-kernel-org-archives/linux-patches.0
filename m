Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C353C37E2F3;
	Sat, 12 Sep 2026 19:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240725; cv=none; b=mY6eyyeolUX/stgqwzJFZwr80xfAtUkbITMtQ2TEapK+L+IT+C9Q3J+lYGwvM1/g6bLvJFlXyF9WXdZwNiYQBb0HKasKTUM9wZJ0zBxE/VYaYvbICHalT7J2fI2WDDy4tAHCve35cWOPJiF4lwKxNo0bC8FGUEWz3LnIpUB1zr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240725; c=relaxed/simple;
	bh=N/Z5dAa0TTs7mOJcwP/Ct0R91lfArr+V6lzOJQRDl0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHXUmmszHlI/MKnYy1BmzQa2mEtX3oNQscR2DFjhSWb97j2u1t73y+ZZJqnKl8ix5qxCR0NQByjRKA34HlFIZ/s4ivKOeOURHMwfsY8tJoyOTJfy06bZNaT5Z+4YHh1Uk2EnHDL+aO9UN/tWbJMzm568RTtxmNU6q5jelIjlAdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MkP1B3P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MkP1B3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FED81F00893;
	Sat, 12 Sep 2026 19:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240723;
	bh=JZDTlhx/ZPa8VJLFOQN1bdv5YIYLLLHD1LqiwGw335o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2MkP1B3PtTi89B28HIp7y5et0N9KshxiKNmO4v9JPOgtWFCJ2Spxy9keNjysr/TQC
	 6DeIvTB2Fla8y9OqQn8LncbIxMElsDajUv+6KE7gU7rvMBqtO9pxVpzwu3o0qG199l
	 hdY1hcXyXsENTXQg8SX61np8Dnsy1ixTO9OTqDOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 926/935] nvme: target: rdma: fix ndev refcount leak on queue connect
Date: Sat, 12 Sep 2026 09:05:56 +0200
Message-ID: <20260912065548.057778537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit badc53620fe813b3a9f727ef9526f98567c2c898 ]

nvmet_rdma_queue_connect() calls nvmet_rdma_find_get_device() which
acquires a reference on the returned ndev via kref_get(). On the path
where the host queue backlog is exceeded and the function returns
NVME_SC_CONNECT_CTRL_BUSY, reference of ndev is not released, leaking
the kref.

Fix this by adding a goto to the existing put_device label before the
early return.

Fixes: 31deaeb11ba7 ("nvmet-rdma: avoid circular locking dependency on install_queue()")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 41e47fe71c372..f8ee057b9af6b 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1625,8 +1625,10 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
 				pending++;
 		}
 		mutex_unlock(&nvmet_rdma_queue_mutex);
-		if (pending > NVMET_RDMA_BACKLOG)
-			return NVME_SC_CONNECT_CTRL_BUSY;
+		if (pending > NVMET_RDMA_BACKLOG) {
+			ret = NVME_SC_CONNECT_CTRL_BUSY;
+			goto put_device;
+		}
 	}
 
 	ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
-- 
2.53.0



