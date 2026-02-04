Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1EE2C11E4;
	Wed,  4 Feb 2026 14:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216748; cv=none; b=RywIxY5nMg8ZwUK9abIewldv6eTuAyVurvRdN+fz88SHrB9dfYQqkfNcIwoumM08qqoAblExm4400FGdvmsxpfeRmFUPDc7McbazXtOlhcJmMVUN0/Oej93c99KL5mRL92BAQZzlqYssW/2iTTUjCmVmX9cAxA1us9+Dj3AQFDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216748; c=relaxed/simple;
	bh=NPNamhv5UyYiO531a6UrPmQIYzV67voouFsgA4fe/ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7br9sqGiUxKy7ekEUIMAzSHCxm0OpgZdjOPNXGpZpgZY3gtaBddrJgtUPolcpVTTtawSgLIpoCATqYeAe7clmolt5pOSuiBlL31oxNLiy9C1xRWgoaFoqDffct2wCELKPJnMYF9VLEJH/kykhvc7twTmHj99ZY0IV+R5FnFGO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=awyJUq7f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="awyJUq7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DF5C4CEF7;
	Wed,  4 Feb 2026 14:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216748;
	bh=NPNamhv5UyYiO531a6UrPmQIYzV67voouFsgA4fe/ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=awyJUq7f6Jr0Pint3kBjKe3qL1Pa+d/ZicUbPhYYIroTIjvsWRucDkB72Uguc4jog
	 38xByxdRNSFL76p3TkZLYdzVAY9MfWBHbAJdyjnUOQezCbCbfv3Vf/EwPEphwzr2PY
	 6QY8GxGcvboQ+64rba3ImyXzMJaDvjAdE9U1SIiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/206] nvmet-tcp: remove boilerplate code
Date: Wed,  4 Feb 2026 15:37:14 +0100
Message-ID: <20260204143858.322104414@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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
index 18127bbc64230..9610f0981b9ec 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -945,8 +945,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 		if (unlikely(data->ttag >= queue->nr_cmds)) {
 			pr_err("queue %d: received out of bound ttag %u, nr_cmds %u\n",
 				queue->idx, data->ttag, queue->nr_cmds);
-			nvmet_tcp_fatal_error(queue);
-			return -EPROTO;
+			goto err_proto;
 		}
 		cmd = &queue->cmds[data->ttag];
 	} else {
@@ -957,9 +956,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 		pr_err("ttag %u unexpected data offset %u (expected %u)\n",
 			data->ttag, le32_to_cpu(data->data_offset),
 			cmd->rbytes_done);
-		/* FIXME: use path and transport errors */
-		nvmet_tcp_fatal_error(queue);
-		return -EPROTO;
+		goto err_proto;
 	}
 
 	exp_data_len = le32_to_cpu(data->hdr.plen) -
@@ -972,9 +969,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 		     cmd->pdu_len == 0 ||
 		     cmd->pdu_len > NVMET_TCP_MAXH2CDATA)) {
 		pr_err("H2CData PDU len %u is invalid\n", cmd->pdu_len);
-		/* FIXME: use proper transport errors */
-		nvmet_tcp_fatal_error(queue);
-		return -EPROTO;
+		goto err_proto;
 	}
 	cmd->pdu_recv = 0;
 	nvmet_tcp_map_pdu_iovec(cmd);
@@ -982,6 +977,11 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
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



