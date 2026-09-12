Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F3823A562;
	Sat, 12 Sep 2026 16:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232159; cv=none; b=JENjLdSPRMUm/2W1De5wW2cl4xns5z5VzgAP8N7MSr0g6t133PgKaLor0gvFeMW7CNuuWvOLGUa3PiUjUD8JklKGTll7JxgerJIqdRH3ltgHaYdQ5bOJAha0249aVcB/8NcH98y3ah+EemBefvQcdpLusiZ728nNeFzFG7t3jAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232159; c=relaxed/simple;
	bh=JvO3DII1Sr37H40wkvBVOhZWKuXszRKX4miQTQT7Fq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0a/BlGUAvIy/MYMdvgvu7kkvjRq4GJUHaXG79tRWeybzf19l2nLXYXlTy0hgPNIoIxU/ROBxYUG72cSuDL1EjHq8+A61sZqBRvsbkn+uo16ffxfpBr642t7KYY78YIp+R+W6cjoGcKKsj3jchfuKdT+mPkYUDlFEMsAkxQ9uhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQh0/amL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQh0/amL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255451F000FF;
	Sat, 12 Sep 2026 16:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232158;
	bh=47ptUybdK7XgXJheqhhaNfolePn1uXO/nYvjgWEDm1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQh0/amLKRnoo0kncRuqBLaWrHTgQefgTcZiLUnyx1vOUcs7PI4y7hpSWoDJTa8gC
	 qvcykI60bNyQeO+Gv9M/4wppiN0UgBgKVaD8lKmsSAu20VyWq9qO4vA+uCuzzLYDDP
	 sUU+GIbmS9HhvsIRb6zrQwE9KBkk/N1waWi36GCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Wentao Liang <vulab@iscas.ac.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1143/1191] nvme: target: rdma: fix ndev refcount leak on queue connect
Date: Sat, 12 Sep 2026 09:04:31 +0200
Message-ID: <20260912065613.822828814@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0533effc15e22..aa87f5f6158d6 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1626,8 +1626,10 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
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



