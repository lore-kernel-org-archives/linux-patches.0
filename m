Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418B64315F;
	Mon, 17 Aug 2026 14:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976512; cv=none; b=HJIUSBlEQpPijYMFnByO4/YlHyMF1VxtT+bzWpbCQvwYDq0RfGHw0DxUYzU8Z/WXkW/TIivs0+4EhV4+WnooXuJexyzwuTlVPCfK2zvan6V9wlLES6UNACczTrm8+J7IdA+9rCcKBhoQMfSBMko/hAYX0X/Y12EBgl3ywkv6KdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976512; c=relaxed/simple;
	bh=fEgNO4ZsWOHcHzL1abwire5YtjaVRXO0PoxVtWMUNho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrWVatMDbOkAn8IXNqnOkpUqafiDS+u3YD0QNueRRMGX9yXY8gyQ1oKWUGOo2VNeMv7vcjpTe2ZH37WqvkgjGb8ePHs9MahaxijsDgxd/LC28PfqpL72jHmZjqRek9ZJuw80DHFKlrkXiLWpyFpbLfeTMaeRBSJzDmVII9gyJXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmgzwHvQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmgzwHvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 968CF1F000E9;
	Mon, 17 Aug 2026 14:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976511;
	bh=JwyD0/EoiDjEws6RGrL+RLLl2JAk86/IaD5u7sO3tEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DmgzwHvQs0u8YQnGz/q+QBdeJTsrpe/c5g11JZ+AdVLhgHgl0S3zH+FTh9R71nNBY
	 jXz+KgGGTIdh4PXVmcfyRwCcceHNMQ9JNZ987bDqPZQH7sUqaL5aK8CVNcfG6mOvDN
	 X9D+r3PmNDi/IPRtdZfxxmg9Pc3FNQj7wjMiYHEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivam Kumar <kumar.shivam43666@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/456] nvmet-tcp: Fix potential UAF when ddgst mismatch
Date: Mon, 17 Aug 2026 15:26:31 +0200
Message-ID: <20260817132539.869648797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Sagi Grimberg <sagi@grimberg.me>

commit dbbd07d0a7020b80f6a7028e561908f7b83b3d5a upstream.

Shivam Kumar found via vulnerability testing:
When data digest is enabled on an NVMe/TCP connection and a digest
mismatch occurs on a non-final H2C_DATA PDU during an R2T-based
data transfer, the digest error handler in nvmet_tcp_try_recv_ddgst()
calls nvmet_req_uninit() - which performs percpu_ref_put() on the
submission queue - but does NOT mark the command as completed. It
does not set cqe->status, does not modify rbytes_done, and does not
clear any flag. When the subsequent fatal error triggers queue
teardown, nvmet_tcp_uninit_data_in_cmds() iterates all commands,
checks nvmet_tcp_need_data_in() for each one, and finds that the
already-uninited command still appears to need data (because
rbytes_done < transfer_len and cqe->status == 0). It therefore calls
nvmet_req_uninit() a second time on the same command - a double
percpu_ref_put against a single percpu_ref_get.

Reported-by: Shivam Kumar <kumar.shivam43666@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Shivam Kumar <kumar.shivam43666@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 95081052dce78f..8fe51218441e46 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1239,8 +1239,10 @@ static int nvmet_tcp_try_recv_ddgst(struct nvmet_tcp_queue *queue)
 			queue->idx, cmd->req.cmd->common.command_id,
 			queue->pdu.cmd.hdr.type, le32_to_cpu(cmd->recv_ddgst),
 			le32_to_cpu(cmd->exp_ddgst));
-		if (!(cmd->flags & NVMET_TCP_F_INIT_FAILED))
+		if (!(cmd->flags & NVMET_TCP_F_INIT_FAILED)) {
+			cmd->req.cqe->status = NVME_SC_CMD_SEQ_ERROR;
 			nvmet_req_uninit(&cmd->req);
+		}
 		nvmet_tcp_free_cmd_buffers(cmd);
 		nvmet_tcp_fatal_error(queue);
 		ret = -EPROTO;
-- 
2.53.0



