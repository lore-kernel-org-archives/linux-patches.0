Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062496;
	b=W8AgP6PlMYzl/3d6rl/RDs9P3cgprjXDgCTeDIEBKSHnQeF9JC+IHfhpUkxTP/0Kd2E7
	 f7wAqCkzxSXEe1Dc6/JabPt4+ljtb9aOfmDXt8w6RQHZcKLMQkY+NzHW7K24Q2iFT4LeX
	 dP3b34AX8bqa98g34mJQ1JB+uJjUb3XsoFLg6ttMR2JIEoWEdhZIJNFcx1HBidT6IG8Ct
	 7Jnbhl0bL6RD4zWE/XiBcNcLcPq7bl5bDNZGjNUiKjMr7SuFjtXa/3BtsimOalgxhGB0G
	 Q/EBfCwGpNUngn83+I23Yy4SjCvt6Ov162/c/ezQMO6xxeHOFCfRhwJO/YOPuR8D6Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=76SF3Z7GDwqgqR+RwLsUyylqKrlhRzxT8Xw3xXs3Dsc=;
	b=poih7waHsqqZm7qJOzf3sVAZ9O725EWi6y+Qm7khNJOCJYaVrcqy7GdFB3DbXLZPM9HU
	 +BB3amo5ugGuwvJ5AEYTKQq5umGzS61aWnnaF0i9lLtVgjyt0aX5oLQrSywB5ugV9gmGx
	 qG0xPaLzvLKG48Du6CcY72FVWaYS5MtjmjVOxDofoY9OhpXeNZjlLtwl+woEr++cUXPBq
	 BVTXkZNzGRxDEN5xXW52IKPssfsD64IKIfvcFRfi/yHp9HjjWrGFuY8FyXynhEF4FBdvD
	 1AuJrViE5e8d92UfJx3KgFEo4tzVmT8rqStOTbOVtfcoJE6oklmbB/4PKqyZBaLIg+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DTr5aWvD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0D8606D821;
	Sat,  7 Nov 2026 14:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DTr5aWvD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2931A1F008A2;
	Sat,  7 Nov 2026 14:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062496;
	bh=76SF3Z7GDwqgqR+RwLsUyylqKrlhRzxT8Xw3xXs3Dsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DTr5aWvDniXvxR6e1lNzgJEYo0IdocEiN00jBdkeCnvAN5IAud4SykWPdl2oS/Ijg
	 Cvfd/7XfLK+b/udxqhUXSCf/hb9B3L1fCUFTw/2p5iJbDUAaykx/IgorEK7bZ5ecvj
	 qD6a+e6ud/rrv1K3XOLn5Dxo+cedC8hGGnxWtCm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1394/1536] net/smc: queue the copied chunk when smc_tx_sendmsg() faults
Date: Sat,  7 Nov 2026 08:56:50 -0500
Message-ID: <20261107135036.979756667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 214ac3cbcf9ad..8e0a40ae74bac 100644
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



