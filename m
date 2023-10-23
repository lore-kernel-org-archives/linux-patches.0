Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920C414A81
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pO3t+L3Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF3FC433C7;
	Mon, 23 Oct 2023 11:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059023;
	bh=5/0mFXJE8CReIk6SGxvCdFmejHVjqZtXiPpx9TvcclU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pO3t+L3YnX7p+2ns2sH7kVvF0sx21Q/68oCwTDclK81mScUkL8f9LregpNlfEYgka
	 1PRXHV3gFU9IGItwE6P50+ezOqCWhRHHhP8w0IGk01IeCiylEKCY/nqyBiy+avveHw
	 Kty4M7j46bM68UMbmKnYP3/XmvjQO0AH6GWjhYVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alon Zahavi <zahavi.alon@gmail.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.5 038/241] nvmet-tcp: Fix a possible UAF in queue intialization setup
Date: Mon, 23 Oct 2023 12:53:44 +0200
Message-ID: <20231023104834.850434303@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagi@grimberg.me>

commit d920abd1e7c4884f9ecd0749d1921b7ab19ddfbd upstream.

>From Alon:
"Due to a logical bug in the NVMe-oF/TCP subsystem in the Linux kernel,
a malicious user can cause a UAF and a double free, which may lead to
RCE (may also lead to an LPE in case the attacker already has local
privileges)."

Hence, when a queue initialization fails after the ahash requests are
allocated, it is guaranteed that the queue removal async work will be
called, hence leave the deallocation to the queue removal.

Also, be extra careful not to continue processing the socket, so set
queue rcv_state to NVMET_TCP_RECV_ERR upon a socket error.

Cc: stable@vger.kernel.org
Reported-by: Alon Zahavi <zahavi.alon@gmail.com>
Tested-by: Alon Zahavi <zahavi.alon@gmail.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/tcp.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -372,6 +372,7 @@ static void nvmet_tcp_fatal_error(struct
 
 static void nvmet_tcp_socket_error(struct nvmet_tcp_queue *queue, int status)
 {
+	queue->rcv_state = NVMET_TCP_RECV_ERR;
 	if (status == -EPIPE || status == -ECONNRESET)
 		kernel_sock_shutdown(queue->sock, SHUT_RDWR);
 	else
@@ -910,15 +911,11 @@ static int nvmet_tcp_handle_icreq(struct
 	iov.iov_len = sizeof(*icresp);
 	ret = kernel_sendmsg(queue->sock, &msg, &iov, 1, iov.iov_len);
 	if (ret < 0)
-		goto free_crypto;
+		return ret; /* queue removal will cleanup */
 
 	queue->state = NVMET_TCP_Q_LIVE;
 	nvmet_prepare_receive_pdu(queue);
 	return 0;
-free_crypto:
-	if (queue->hdr_digest || queue->data_digest)
-		nvmet_tcp_free_crypto(queue);
-	return ret;
 }
 
 static void nvmet_tcp_handle_req_failure(struct nvmet_tcp_queue *queue,


