Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99028481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20326C4339B;
	Fri, 10 Mar 2023 14:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457354;
	bh=TFZnL7m4xMb8fYDSSfuGEWY8OQQml9L7VvD9Xp3czrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqIy/e8lQPMuQDTFHDCU0+f5WlOHiI003L0mlMuYH7YRv2/tsn/V5CTlSHFEw1c7b
	 Mf3N16+yTik/L9QSRsB2r/a5HBUNQde2WmobuM/Sz70O2holA+fzjEWfbx1L7gfmod
	 ADizDS2//wG8BDFNflpWv+Fxt2YKp0/zht7bKc7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Martin Belanger <martin.belanger@dell.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/200] nvme-tcp: dont access released socket during error recovery
Date: Fri, 10 Mar 2023 14:38:36 +0100
Message-Id: <20230310133720.445545135@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akinobu Mita <akinobu.mita@gmail.com>

[ Upstream commit 76d54bf20cdcc1ed7569a89885e09636e9a8d71d ]

While the error recovery work is temporarily failing reconnect attempts,
running the 'nvme list' command causes a kernel NULL pointer dereference
by calling getsockname() with a released socket.

During error recovery work, the nvme tcp socket is released and a new one
created, so it is not safe to access the socket without proper check.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Fixes: 02c57a82c008 ("nvme-tcp: print actual source IP address through sysfs "address" attr")
Reviewed-by: Martin Belanger <martin.belanger@dell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 1dc7c733c7e39..bb80192c16b6b 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2488,6 +2488,10 @@ static int nvme_tcp_get_address(struct nvme_ctrl *ctrl, char *buf, int size)
 
 	len = nvmf_get_address(ctrl, buf, size);
 
+	mutex_lock(&queue->queue_lock);
+
+	if (!test_bit(NVME_TCP_Q_LIVE, &queue->flags))
+		goto done;
 	ret = kernel_getsockname(queue->sock, (struct sockaddr *)&src_addr);
 	if (ret > 0) {
 		if (len > 0)
@@ -2495,6 +2499,8 @@ static int nvme_tcp_get_address(struct nvme_ctrl *ctrl, char *buf, int size)
 		len += scnprintf(buf + len, size - len, "%ssrc_addr=%pISc\n",
 				(len) ? "," : "", &src_addr);
 	}
+done:
+	mutex_unlock(&queue->queue_lock);
 
 	return len;
 }
-- 
2.39.2



