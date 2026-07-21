Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95871175A74;
	Tue, 21 Jul 2026 17:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655547; cv=none; b=dFIW/C0RxJEamU61ASRvSbnRU+7N4LD4qNU3ONpam98QAGCdRte8avaHyIiItSJjXAb0BG5NVneIlj0BJAYFuW+h+TZR0aEuWO5ntmDMNcXKQkvDyMBQTNkiubCUKURpobmNluPVMl5HmXdghE3bjDNL/oPNJ+kgggJQkKgfrmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655547; c=relaxed/simple;
	bh=BNT1P5JB1ej/p2kX92kIptHtEDlGf46gx28GCfgunRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pinGqIHl9y8AbX6cV+d/FZhdVktnO/EN7v9i7NNfcIxUoyiFrgkzdIbxZ+EO5qwMT1cEzVMMwXfE+4AejS85NnwVTtQjNYSwKfALbi1n4SVzqrns0kU1gNOF7bIkfvDtM5TFIf0pyMDs3Hi5uVhzsL4p+VSfDRbT+aRJ79Kpsfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4m9iKCc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4m9iKCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036221F000E9;
	Tue, 21 Jul 2026 17:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655546;
	bh=+o0CltlTXSQ0kpGIokmtxGuMltheLWetktMPsmkQpRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4m9iKCcnlGP1elQdTnG0eo2IvKzi2h+Z4PrchmU8zOlgJLjpIC2sJLd2eI+6/MO0
	 TxCU9/xsFviVD39Ryoq9OqQY1hBJgSskDAVdN9vOluO2ynU6yVja4PK37Bvq/jKKFb
	 fIcFB3tkoXCfjKkYNeW+3qPTc8cncJADXxmgKyGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shivam Kumar <kumar.shivam43666@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 0008/1611] nvmet-tcp: Fix potential UAF when ddgst mismatch
Date: Tue, 21 Jul 2026 17:02:04 +0200
Message-ID: <20260721152514.967956202@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagi@grimberg.me>

commit dbbd07d0a7020b80f6a7028e561908f7b83b3d5a upstream.

Shivam Kumar found via vulnerability testing:
When data digest is enabled on an NVMe/TCP connection and a digest
mismatch occurs on a non-final H2C_DATA PDU during an R2T-based
data transfer, the digest error handler in nvmet_tcp_try_recv_ddgst()
calls nvmet_req_uninit() — which performs percpu_ref_put() on the
submission queue — but does NOT mark the command as completed. It
does not set cqe->status, does not modify rbytes_done, and does not
clear any flag. When the subsequent fatal error triggers queue
teardown, nvmet_tcp_uninit_data_in_cmds() iterates all commands,
checks nvmet_tcp_need_data_in() for each one, and finds that the
already-uninited command still appears to need data (because
rbytes_done < transfer_len and cqe->status == 0). It therefore calls
nvmet_req_uninit() a second time on the same command — a double
percpu_ref_put against a single percpu_ref_get.

Reported-by: Shivam Kumar <kumar.shivam43666@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/tcp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1344,8 +1344,10 @@ static int nvmet_tcp_try_recv_ddgst(stru
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


