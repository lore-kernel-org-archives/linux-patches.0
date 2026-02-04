Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34FC4218A8;
	Wed,  4 Feb 2026 15:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217438; cv=none; b=Yv8hacCg/CbPTrU+UVzTnmRpbpDUB3wOYxXS7IFC/pz+tBJEYJjKumm8HsK8bDtlKssheEV+HT0kTEjQxihd0aw0hbDntZPiYEVq0DKUmglqDiQ/lU5/uhMlqqOwoUo6figw2Mm4CH+n5SkUY/U2inKPlnbTJ+adKmIV1oPjXr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217438; c=relaxed/simple;
	bh=7hIS0F4/quzd8CZEJ9my07kozPpNem2TioZwG6SXx+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPzJ3SFOsQH9nD3zyvRJMRONQ3ZrjUBfWUTA5AXYAdhTV3+VffLch3BOKJUrZTiEq8eCAiPttN8HFChidA+RW2vvuMbWJrb2K8JOuSNwI7LMxN3PG6A6ShRrhr/uILjX5B3WI6g+m4xGQQKFkuwU2xM1cbj+YLrGl7uEBON8m2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDRKubcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDRKubcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4FB8C4CEF7;
	Wed,  4 Feb 2026 15:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217438;
	bh=7hIS0F4/quzd8CZEJ9my07kozPpNem2TioZwG6SXx+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDRKubcKGzj7GdHmUsdZLvizFldMrXvKHnV2q4DKU2hdlNiiy045jc0zMpfgKrQCq
	 ukxTMylc/UICwauaoldJriHcoU2dJXffkndC28iQGpGFvAl15/bP1u9EO7n6dPEVqf
	 fY437APeKhHt0t5tH/84sn1wVM3kXpRKSGYJODeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/280] nvmet-tcp: remove boilerplate code
Date: Wed,  4 Feb 2026 15:36:21 +0100
Message-ID: <20260204143909.891584992@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 75011bd0f9c55db523242f9f9a0b0b826165f14b ]

Simplify the nvmet_tcp_handle_h2c_data_pdu() function by removing
boilerplate code.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 32b63acd78f5 ("nvme-tcp: fix NULL pointer dereferences in nvmet_tcp_build_pdu_iovec")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index eee052dbf80c1..8fc626ddc1275 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -930,8 +930,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 		if (unlikely(data->ttag >= queue->nr_cmds)) {
 			pr_err("queue %d: received out of bound ttag %u, nr_cmds %u\n",
 				queue->idx, data->ttag, queue->nr_cmds);
-			nvmet_tcp_fatal_error(queue);
-			return -EPROTO;
+			goto err_proto;
 		}
 		cmd = &queue->cmds[data->ttag];
 	} else {
@@ -942,9 +941,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 		pr_err("ttag %u unexpected data offset %u (expected %u)\n",
 			data->ttag, le32_to_cpu(data->data_offset),
 			cmd->rbytes_done);
-		/* FIXME: use path and transport errors */
-		nvmet_tcp_fatal_error(queue);
-		return -EPROTO;
+		goto err_proto;
 	}
 
 	exp_data_len = le32_to_cpu(data->hdr.plen) -
@@ -957,9 +954,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 		     cmd->pdu_len == 0 ||
 		     cmd->pdu_len > NVMET_TCP_MAXH2CDATA)) {
 		pr_err("H2CData PDU len %u is invalid\n", cmd->pdu_len);
-		/* FIXME: use proper transport errors */
-		nvmet_tcp_fatal_error(queue);
-		return -EPROTO;
+		goto err_proto;
 	}
 	cmd->pdu_recv = 0;
 	nvmet_tcp_build_pdu_iovec(cmd);
@@ -967,6 +962,11 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 	queue->rcv_state = NVMET_TCP_RECV_DATA;
 
 	return 0;
+
+err_proto:
+	/* FIXME: use proper transport errors */
+	nvmet_tcp_fatal_error(queue);
+	return -EPROTO;
 }
 
 static int nvmet_tcp_done_recv_pdu(struct nvmet_tcp_queue *queue)
-- 
2.51.0



