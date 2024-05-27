Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47C5168C4;
	Mon, 27 May 2024 19:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837691; cv=none; b=IoJpxwjkPT9nu3MJ99PDcdmVk1MdX5mfhdhA65rSrWXkvxjZgmmQzAI3hLus7oMZMYtZfA0l25GDytIpOjMgp0u01yNZe/60ov8GtIZRSHxRPfteqHDUlTZ6GdH337/arTyaFllrvB8zbWQbkCKRj/H+1alTdgV8bUuKfWk2RrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837691; c=relaxed/simple;
	bh=QfAXEXab6crRxqkB7sqoYUbffL75rMuczypMXOFgTr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqTKr/w30qvvZMx55u0BUStjUcLQ3zD/QOp3Y58Q/dRKCVjeXrza1MGltXA/LjlfTMK4MuVw8bJ/+BQQzIZK1UXI2XoGyFgw06IPGscYg5ORK77iiyAQhgRAJo0NWVZ9T5xWCuujnM8ROus2kbV8yDsBAdAh90y+g4BT1LO+++k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJL30mu2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJL30mu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1DDC2BBFC;
	Mon, 27 May 2024 19:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837691;
	bh=QfAXEXab6crRxqkB7sqoYUbffL75rMuczypMXOFgTr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJL30mu2CYW4lBxMa+UFfokYY8Xn+xThD/T809/ujtcJw2h4ANQXoKorL9+Vb5qSc
	 EG74089t7Tdac3ryZ6xopuHPb2D+Gj8B19z4fOrAbcTeJQOGBUrnE3ceRH6af9e3ey
	 s/b9kIQuHhXTDEjTf4750uzPDnar0i5mySxkGs1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 107/493] nvme-tcp: strict pdu pacing to avoid send stalls on TLS
Date: Mon, 27 May 2024 20:51:49 +0200
Message-ID: <20240527185634.022469845@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 50abcc179e0c9ca667feb223b26ea406d5c4c556 ]

TLS requires a strict pdu pacing via MSG_EOR to signal the end
of a record and subsequent encryption. If we do not set MSG_EOR
at the end of a sequence the record won't be closed, encryption
doesn't start, and we end up with a send stall as the message
will never be passed on to the TCP layer.
So do not check for the queue status when TLS is enabled but
rather make the MSG_MORE setting dependent on the current
request only.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index a6d596e056021..6eeb96578d1b4 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -352,12 +352,18 @@ static inline void nvme_tcp_send_all(struct nvme_tcp_queue *queue)
 	} while (ret > 0);
 }
 
-static inline bool nvme_tcp_queue_more(struct nvme_tcp_queue *queue)
+static inline bool nvme_tcp_queue_has_pending(struct nvme_tcp_queue *queue)
 {
 	return !list_empty(&queue->send_list) ||
 		!llist_empty(&queue->req_list);
 }
 
+static inline bool nvme_tcp_queue_more(struct nvme_tcp_queue *queue)
+{
+	return !nvme_tcp_tls(&queue->ctrl->ctrl) &&
+		nvme_tcp_queue_has_pending(queue);
+}
+
 static inline void nvme_tcp_queue_request(struct nvme_tcp_request *req,
 		bool sync, bool last)
 {
@@ -378,7 +384,7 @@ static inline void nvme_tcp_queue_request(struct nvme_tcp_request *req,
 		mutex_unlock(&queue->send_mutex);
 	}
 
-	if (last && nvme_tcp_queue_more(queue))
+	if (last && nvme_tcp_queue_has_pending(queue))
 		queue_work_on(queue->io_cpu, nvme_tcp_wq, &queue->io_work);
 }
 
-- 
2.43.0



