Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5A920B09
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fq+kVGtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA01AC433C8;
	Mon,  6 Nov 2023 13:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276961;
	bh=osJ3JxPDuH6ZmMH+EhRqi400+POPxpUeCk64nWkyJew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fq+kVGtQjUtkhX6atwKPhejYP4tPSc9jaV2Bq4gd7vxN7sHf+YPxAIw0fUcixZo/4
	 z7vvSOGxuJFuxCfd3UEymj5gJpqWSC7TQi/Esz8A0k1yv6oVOulOB+kzPmWGwx5Hqv
	 oHmxlTK7srmyifPYRphbN7kq1DGnK+5jEtrhspwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Dragos-Marian Panait <dragos.panait@windriver.com>
Subject: [PATCH 5.4 66/74] nvmet-tcp: move send/recv error handling in the send/recv methods instead of call-sites
Date: Mon,  6 Nov 2023 14:04:26 +0100
Message-ID: <20231106130303.963062589@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.687882731@linuxfoundation.org>
References: <20231106130301.687882731@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagi@grimberg.me>

commit 0236d3437909ff888e5c79228e2d5a851651c4c6 upstream.

Have routines handle errors and just bail out of the poll loop.
This simplifies the code and will help as we may enhance the poll
loop logic and these are somewhat in the way.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/tcp.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -321,6 +321,14 @@ static void nvmet_tcp_fatal_error(struct
 		kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 }
 
+static void nvmet_tcp_socket_error(struct nvmet_tcp_queue *queue, int status)
+{
+	if (status == -EPIPE || status == -ECONNRESET)
+		kernel_sock_shutdown(queue->sock, SHUT_RDWR);
+	else
+		nvmet_tcp_fatal_error(queue);
+}
+
 static int nvmet_tcp_map_data(struct nvmet_tcp_cmd *cmd)
 {
 	struct nvme_sgl_desc *sgl = &cmd->req.cmd->common.dptr.sgl;
@@ -714,11 +722,15 @@ static int nvmet_tcp_try_send(struct nvm
 
 	for (i = 0; i < budget; i++) {
 		ret = nvmet_tcp_try_send_one(queue, i == budget - 1);
-		if (ret <= 0)
+		if (unlikely(ret < 0)) {
+			nvmet_tcp_socket_error(queue, ret);
+			goto done;
+		} else if (ret == 0) {
 			break;
+		}
 		(*sends)++;
 	}
-
+done:
 	return ret;
 }
 
@@ -1167,11 +1179,15 @@ static int nvmet_tcp_try_recv(struct nvm
 
 	for (i = 0; i < budget; i++) {
 		ret = nvmet_tcp_try_recv_one(queue);
-		if (ret <= 0)
+		if (unlikely(ret < 0)) {
+			nvmet_tcp_socket_error(queue, ret);
+			goto done;
+		} else if (ret == 0) {
 			break;
+		}
 		(*recvs)++;
 	}
-
+done:
 	return ret;
 }
 
@@ -1196,27 +1212,16 @@ static void nvmet_tcp_io_work(struct wor
 		pending = false;
 
 		ret = nvmet_tcp_try_recv(queue, NVMET_TCP_RECV_BUDGET, &ops);
-		if (ret > 0) {
+		if (ret > 0)
 			pending = true;
-		} else if (ret < 0) {
-			if (ret == -EPIPE || ret == -ECONNRESET)
-				kernel_sock_shutdown(queue->sock, SHUT_RDWR);
-			else
-				nvmet_tcp_fatal_error(queue);
+		else if (ret < 0)
 			return;
-		}
 
 		ret = nvmet_tcp_try_send(queue, NVMET_TCP_SEND_BUDGET, &ops);
-		if (ret > 0) {
-			/* transmitted message/data */
+		if (ret > 0)
 			pending = true;
-		} else if (ret < 0) {
-			if (ret == -EPIPE || ret == -ECONNRESET)
-				kernel_sock_shutdown(queue->sock, SHUT_RDWR);
-			else
-				nvmet_tcp_fatal_error(queue);
+		else if (ret < 0)
 			return;
-		}
 
 	} while (pending && ops < NVMET_TCP_IO_WORK_BUDGET);
 


