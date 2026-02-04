Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A574219ED;
	Wed,  4 Feb 2026 15:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217442; cv=none; b=gqUgPlP7aUACoKhMaq5KdJIDDIH2ILWgPXes2aEm5fop2kpzAvb+1gIl/hXmcanXduqCh3vjnnXTi9tZ6MM+AImbvNNlkdhPrV++2mC24NPy3Pj4jAu1SOAwqxSx6a6KxmsPiadztA2nlpxlQDki8qIPFb65GjHFmjZB8Wx3OIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217442; c=relaxed/simple;
	bh=6bhQLK+5pRob8v+JnLg2809Mwvo3LL3Wfx2MTuSW4a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SrzXCvlQYZRZa9MtDJoNXH+GaSN4HFviNveP8FX04CuIPiFig0nSBm1HndJSoOhwtjaHJbP56eGWGAr+HzS06/JvqOudZOf460por36RwBkcOgmwGZYd41COdpuzBjCmwadsXRNcEANc+l9wFrT9STbN/A5gozSBv2ej5k272jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcRVW2cU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcRVW2cU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C925C116C6;
	Wed,  4 Feb 2026 15:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217442;
	bh=6bhQLK+5pRob8v+JnLg2809Mwvo3LL3Wfx2MTuSW4a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YcRVW2cUN54UZ0wBxWVlA9LgB1yoklmMQnItnrzvHhAq8NMI9Re9wXwVd7BPf1QG2
	 B+sxIJTOcqCoeKRtjPZYzyRU3xOlnvGJPA5Q4UoJ2Z+PD2gv1BGv5gepseQd8z3hbw
	 GKOM7gbPM0v25Toccl/0iYCS1vZQ58gMETe5YlPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Shivam Kumar <kumar.shivam43666@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/280] nvme-tcp: fix NULL pointer dereferences in nvmet_tcp_build_pdu_iovec
Date: Wed,  4 Feb 2026 15:36:22 +0100
Message-ID: <20260204143909.927511373@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivam Kumar <kumar.shivam43666@gmail.com>

[ Upstream commit 32b63acd78f577b332d976aa06b56e70d054cbba ]

Commit efa56305908b ("nvmet-tcp: Fix a kernel panic when host sends an invalid H2C PDU length")
added ttag bounds checking and data_offset
validation in nvmet_tcp_handle_h2c_data_pdu(), but it did not validate
whether the command's data structures (cmd->req.sg and cmd->iov) have
been properly initialized before processing H2C_DATA PDUs.

The nvmet_tcp_build_pdu_iovec() function dereferences these pointers
without NULL checks. This can be triggered by sending H2C_DATA PDU
immediately after the ICREQ/ICRESP handshake, before
sending a CONNECT command or NVMe write command.

Attack vectors that trigger NULL pointer dereferences:
1. H2C_DATA PDU sent before CONNECT → both pointers NULL
2. H2C_DATA PDU for READ command → cmd->req.sg allocated, cmd->iov NULL
3. H2C_DATA PDU for uninitialized command slot → both pointers NULL

The fix validates both cmd->req.sg and cmd->iov before calling
nvmet_tcp_build_pdu_iovec(). Both checks are required because:
- Uninitialized commands: both NULL
- READ commands: cmd->req.sg allocated, cmd->iov NULL
- WRITE commands: both allocated

Fixes: efa56305908b ("nvmet-tcp: Fix a kernel panic when host sends an invalid H2C PDU length")
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Shivam Kumar <kumar.shivam43666@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 8fc626ddc1275..7fae0103a515b 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -956,6 +956,18 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 		pr_err("H2CData PDU len %u is invalid\n", cmd->pdu_len);
 		goto err_proto;
 	}
+       /*
+	* Ensure command data structures are initialized. We must check both
+	* cmd->req.sg and cmd->iov because they can have different NULL states:
+	* - Uninitialized commands: both NULL
+	* - READ commands: cmd->req.sg allocated, cmd->iov NULL
+	* - WRITE commands: both allocated
+	*/
+	if (unlikely(!cmd->req.sg || !cmd->iov)) {
+		pr_err("queue %d: H2CData PDU received for invalid command state (ttag %u)\n",
+			queue->idx, data->ttag);
+		goto err_proto;
+	}
 	cmd->pdu_recv = 0;
 	nvmet_tcp_build_pdu_iovec(cmd);
 	queue->cmd = cmd;
-- 
2.51.0



