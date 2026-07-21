Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06982399015;
	Tue, 21 Jul 2026 22:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674433; cv=none; b=IULDt9iq1A7Zaup3Pv1qJyczkbBl6ZYVaXUjEV/S08QqoIT9Na+F7oYqBTLLXj1vcYrusITpivWGD2N5EnPwqEfqROT1SwDpuRwAj//3jk8siCwgzn4zSpGMFJrsIY5qAidXtD/JzhD6PIJxvhwo/QVb/mUJN8P7ViHbLd2yMf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674433; c=relaxed/simple;
	bh=LWF0CCnJUj5mN25n+nETCgRHb2AzgZ6WgKAvVAd5hRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKfbTZ+P5pVHQiNbjn4WarVg8ZS4luI0fk+tOAMvQZi0VwcFJe/BMJM3hCPM7x7JWe+i2O7CkYvu4u7BB5AUkv6WhsJxV+yGTjn6ThU3adbl+w+Sg93bO0xQERc1G9i3BFTvC01LYxhhn6RkgtCFzHq6cQfhH+D1Ez6BEcPqERQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gx/s3aqg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gx/s3aqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A721F00A3A;
	Tue, 21 Jul 2026 22:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674431;
	bh=6e5VwdarFYM4SVGHfwE+NpCTGbRkhbLFdTq4pRH2AU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gx/s3aqgK1C86Vi3TchoaZLkpifQS6QV4T0S/7K9EA0pR6MHKR/FWQn+qWiBNH44w
	 MmDwLTc1MdUWAhuMDoS0qNjwMQ+ypQxudn5KpiDr+zMLAkR9HtLNLoSFRNTyAyM3pM
	 J0CmcqZgvnf4XF/GsjUx7mbO8Y3KL2/0Rgxv9mNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Shivam Kumar <kumar.shivam43666@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 537/699] nvmet-tcp: check INIT_FAILED before nvmet_req_uninit in digest error path
Date: Tue, 21 Jul 2026 17:24:56 +0200
Message-ID: <20260721152407.812011909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivam Kumar <kumar.shivam43666@gmail.com>

commit 4606467a75cfc16721937272ed29462a750b60c8 upstream.

In nvmet_tcp_try_recv_ddgst(), when a data digest mismatch is detected,
nvmet_req_uninit() is called unconditionally. However, if the command
arrived via the nvmet_tcp_handle_req_failure() path, nvmet_req_init()
had returned false and percpu_ref_tryget_live() was never executed. The
unconditional percpu_ref_put() inside nvmet_req_uninit() then causes a
refcount underflow, leading to a WARNING in
percpu_ref_switch_to_atomic_rcu, a use-after-free diagnostic, and
eventually a permanent workqueue deadlock.

Check cmd->flags & NVMET_TCP_F_INIT_FAILED before calling
nvmet_req_uninit(), matching the existing pattern in
nvmet_tcp_execute_request().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Shivam Kumar <kumar.shivam43666@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
[shivam: inlined nvmet_tcp_finish_cmd() at the fix site for 5.10.y]
Signed-off-by: Shivam Kumar <kumar.shivam43666@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 4bd82e9b113ff5..3d9a830950ef26 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1227,7 +1227,9 @@ static int nvmet_tcp_try_recv_ddgst(struct nvmet_tcp_queue *queue)
 			queue->idx, cmd->req.cmd->common.command_id,
 			queue->pdu.cmd.hdr.type, le32_to_cpu(cmd->recv_ddgst),
 			le32_to_cpu(cmd->exp_ddgst));
-		nvmet_tcp_finish_cmd(cmd);
+		if (!(cmd->flags & NVMET_TCP_F_INIT_FAILED))
+			nvmet_req_uninit(&cmd->req);
+		nvmet_tcp_free_cmd_buffers(cmd);
 		nvmet_tcp_fatal_error(queue);
 		ret = -EPROTO;
 		goto out;
-- 
2.53.0



