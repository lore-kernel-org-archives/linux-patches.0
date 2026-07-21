Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1783472553;
	Tue, 21 Jul 2026 20:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665510; cv=none; b=mge5VkvRHoS40iVng1sQsFxSRMmD/Sw5g3Jn2AlbBdaSnkMwbY3nXFsYSOTKFWVAf0XQPjBtAGUf5lW4emiWC5lEWlT6F2hgS+bDGoiXqi65n3xHbJWGU4Vnt9oEDAKdl1ffVAywKBzeo2mVRQ3mdgkHKvQnk9z68Op2XE7zQhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665510; c=relaxed/simple;
	bh=tF7CVfANT7V/RqDI9ynOUOZNqBjttfBN2UA1Xu2UdcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tog6lSs8HOBFJJ6K0fDdHkPk0ARZJPncUXRMYVaoOioZInmDM3HL0jBsZ9rdH3pymLP17l2r2UdMSMtiXDFXNrtqXSA48b966yAogAEnHq57/rcGmS7195Lt429i4YsbU+s88ON9TTJXqX1MziFypJgcpyOAlM4eSczzejSRb9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCEgPrbL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCEgPrbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1954A1F000E9;
	Tue, 21 Jul 2026 20:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665509;
	bh=JfleS3NkRhkRWjMU/RqUtUBH6M4JOcmajsbDh6cHJtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TCEgPrbL1Tq1FMTUzeqS3T/BRwbVyifqvnsvO75Pq93apTCsmjPPWioQVH7Y9LG/R
	 IpGsP2QNYSq/2HhroO1HGVfg7kPProlsCVwaR/M6lxMgg0RmeFN2fkY2DmcE1w/FZ4
	 PGjbBFDallglTNpe+2trLOAN9EWtxGMLfvjEAu5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Shivam Kumar <kumar.shivam43666@gmail.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 0332/1266] nvmet-tcp: check INIT_FAILED before nvmet_req_uninit in digest error path
Date: Tue, 21 Jul 2026 17:12:49 +0200
Message-ID: <20260721152449.261916338@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -1297,7 +1297,8 @@ static int nvmet_tcp_try_recv_ddgst(stru
 			queue->idx, cmd->req.cmd->common.command_id,
 			queue->pdu.cmd.hdr.type, le32_to_cpu(cmd->recv_ddgst),
 			le32_to_cpu(cmd->exp_ddgst));
-		nvmet_req_uninit(&cmd->req);
+		if (!(cmd->flags & NVMET_TCP_F_INIT_FAILED))
+			nvmet_req_uninit(&cmd->req);
 		nvmet_tcp_free_cmd_buffers(cmd);
 		nvmet_tcp_fatal_error(queue);
 		ret = -EPROTO;


