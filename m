Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063559;
	b=AX3/3wt0L3DYW10Bl3GXxWnvc7QU/x70Lkz5H5jshRHkv4eKw/zp8KQdCmoVIZcPS06o
	 slpOTLkgr6LJxuUZV3ZHjkL1sWT3NJCj1cp7HoGdedinQ7+Gcsa7U6Q3Tw0NA9euUp8UM
	 I2s66Cn1EWr9IAJMUfLlaPwUan86clNkWRcpPLU8uy6s3MwQCNP+2v2kkyrNy2g3IEtxX
	 rFKdaoDlVborqxPJQJZ57UTJOf2dJL5sCIo4PH6eFwOmxZk6obaQ9hRMZX9GJ2NCQsfTU
	 K29nCg7P8eSCJJjxKM2fbks3jTK4jKwOh1HaXo52naX9SpoVCUk6e+T/d55FuV8FYjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eWcg7ws4mmFaJ6gJlCdyIjFMIEAOyN8p31q6vA/7dpg=;
	b=lMLjlMZnSFP0zhCNY0L9sExqdpaC624yl4wrO9zPTps6U7RYt1t4hUXllMDwN8jQmK6i
	 F16wCOLXndv0jBXQxe/xlWsrxTcxBC7hXXI30wojePUHNMNO73HRnj1L0Ypmi7iYh21CE
	 5J+j7LUuL49Aaur8fNupKn7mMrNMnubNIi7+0Ao65AUHvbjgm861XD4C5GfumGYlHsj/4
	 gRj76HN+BVm9rqLtNQwRPVPKwwpA19Ked4d3JIVLOszaQ0zz7wKbGK+gHFuL+okcmsChv
	 WJR5QxSje38GYy0QIo5ZhR6nUZbVFkjrS8zREE7nYawmN7iGXom+w93IPeX9tvemqnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SdD/tLpx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E58A606EE8A;
	Sat,  7 Nov 2026 14:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SdD/tLpx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AE71F008A1;
	Sat,  7 Nov 2026 14:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063559;
	bh=eWcg7ws4mmFaJ6gJlCdyIjFMIEAOyN8p31q6vA/7dpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SdD/tLpxe3BoDKzjOO5mVo400MF1r9ES4bxcMGUdqsronLkTUzIliwMpUMmZ783LI
	 MxmdnWyqbPjx0sN7/GA9LvfdaWuXYsNff49MQIyVFySSj+85Otzdnv6434AOboE7U+
	 4swoBMil6b5bRqj3oWqHP0rr8z3v5qpGhZ7aEjdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 693/869] net/smc: queue the copied chunk when smc_tx_sendmsg() faults
Date: Sat,  7 Nov 2026 08:56:15 -0500
Message-ID: <20261107134916.493539725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit c0703534b223a5c6993e0f000fd1c3abe621fb65 ]

When a send wraps the end of the send buffer, smc_tx_sendmsg() copies
the data in two chunks. If memcpy_from_msg() faults on the second one,
smc_tx_sendmsg() returns send_done, which already counts the first
chunk, but leaves tx_curs_prep and sndbuf_space as they were. send()
reports bytes the peer never receives, and the next send() overwrites
them. Any caller can hit this on its own stream with a buffer whose
tail is unreadable.

On a fault in the second chunk, queue the first one. The next pass
retries the rest and returns send_done if it faults again, so send()
reports only what it queued, as TCP does.

Fixes: e6727f39004b ("smc: send data (through RDMA)")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20261013-b4-disp-872a3689-v1-1-2a4c63b04761@proton.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_tx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 3144b4b1fe290..495fb1354728c 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -249,6 +249,13 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
 			rc = memcpy_from_msg(sndbuf_base + chunk_off,
 					     msg, chunk_len);
 			if (rc) {
+				if (chunk) {
+					/* send_done counts the first chunk:
+					 * queue it and retry the rest
+					 */
+					copylen -= chunk_len;
+					break;
+				}
 				smc_sndbuf_sync_sg_for_device(conn);
 				if (send_done)
 					return send_done;
-- 
2.53.0



