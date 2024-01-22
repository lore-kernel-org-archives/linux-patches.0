Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC7C1DFEF;
	Tue, 23 Jan 2024 12:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706014220; cv=none; b=ABqXIUQmCBE7Lrhs4G0FnT8rOR4tPeUTbdYomOsEVLLI0dZgj6RdU76lYJkcJAXCzSho5wUjjfVOxD/88Ze+CodrRRuTOBpNmPLBy9vXg1wr+cFaG9PvHhI9GyC6A/k46r5qxk6599/HZIKdmqEIl7h3CTN5oFmuuvNDOBwvihU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706014220; c=relaxed/simple;
	bh=k+I9qSQvdZAtNv32uyWwqMba+CWj/0A5ZGQKByFmeZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G05O+hs4oKma6j351xE+D6WzwvbyskME7LPHrEhq77hvL4PQt4vH17pnO6aaoUZ9xBVQjCU2VveuaTXsqqXnvTCgqZsno4DU6v5n47KJczyzDmfzRbpVpvzX5mULGytZRndpAFvFP95qVgqfmv3CG3s+kKnqQUxMcx9JdSlyQCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enm/B8Jr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enm/B8Jr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34542C433C7;
	Tue, 23 Jan 2024 12:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706014220;
	bh=k+I9qSQvdZAtNv32uyWwqMba+CWj/0A5ZGQKByFmeZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enm/B8Jr6TjYkZN2BKzEcGAFTAWzPLKMdk5kZG+YPayfVVPz1fpqd1+PcqCMxgnFj
	 abASN0g1EbAAILMPdWB9M8xXGNE7BYoXgEjxMrS6xeN8A53jhaldGip+mq0UFvoiWN
	 SLp6onLxXQIuZaYeJ4L+uxCITHZVns7BcmF6Ckig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 259/286] nvmet-tcp: fix a crash in nvmet_req_complete()
Date: Mon, 22 Jan 2024 15:59:25 -0800
Message-ID: <20240122235742.002184874@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 0849a5441358cef02586fb2d60f707c0db195628 ]

in nvmet_tcp_handle_h2c_data_pdu(), if the host sends a data_offset
different from rbytes_done, the driver ends up calling nvmet_req_complete()
passing a status error.
The problem is that at this point cmd->req is not yet initialized,
the kernel will crash after dereferencing a NULL pointer.

Fix the bug by replacing the call to nvmet_req_complete() with
nvmet_tcp_fatal_error().

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Reviewed-by: Keith Busch <kbsuch@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 153150e8beb9..9ec8ed369eb7 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -938,8 +938,7 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 			data->ttag, le32_to_cpu(data->data_offset),
 			cmd->rbytes_done);
 		/* FIXME: use path and transport errors */
-		nvmet_req_complete(&cmd->req,
-			NVME_SC_INVALID_FIELD | NVME_SC_DNR);
+		nvmet_tcp_fatal_error(queue);
 		return -EPROTO;
 	}
 
-- 
2.43.0



