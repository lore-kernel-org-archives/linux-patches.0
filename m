Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052910;
	b=Wzhtduxgkc446YafhMGdKNDg2iqMjYGiOOLEeVBze4qAK5V2VzHWUQms+9O3Lo8Avgg+
	 3Ru2+CaEkOwehEHTzQcAHeOJuZzcJFCIDR2ulgEp2FERrE7sS/lStsXu5mixvyUG6T8vI
	 6q7cjsoPklqnBQcu1/N9cppggyMeivmQ/jEsCQE2fEWyr2Jn6e0zXAd1A0OVlgso4bzk6
	 aOr5nc19EnOxFyOUmkFO5SCUfSwcdWXOhJOIknG4u06nVpV0glDV1splvOrUUvxBDSH22
	 V0BWGd4jn+WKYwq4WsqfBHxmElmuc5usYB4av5Q2Ivi2HkbbfccRRv4uBuHYrLZKwLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r8g5uNXMgMgguDZsxXx/0jbOnDC+SMHCvlitwsiKkQo=;
	b=AW0asNFRf4vbH8HhAvWZIQwEPboC19Jgg++i5Efm807+qE+6f/MWMWk5zky2YE7Qtd8N
	 hYa4qoJvY2GwpqkAOCBZ8qNh06kpNXgINhrwETwIdVvAt8H1Q0pYK5c3k7fMDkhTwaFd/
	 6DFbMEBN7uKou/+xZA60STQ+xMhhtyoMSJHkk6TZ+uDCdks+A9tu9y0bDrHzsLZLSNlw2
	 nv/5dQTRB38LrbG3RPZEkdpzuvDZXQnKB3TfH7OvvfBp3kijzSjAhOeW9NjX8a/NlABsX
	 MbqpS0jzKOO0qJN1e4NN50mgMB64UdKQpEh02LPI7Xx9bsynUGvkLck1+z5N5JsCI5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=agzayfKw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F13606A31C;
	Thu, 19 Nov 2026 01:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=agzayfKw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A27E1F000C4;
	Thu, 19 Nov 2026 01:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052909;
	bh=r8g5uNXMgMgguDZsxXx/0jbOnDC+SMHCvlitwsiKkQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=agzayfKwkkQPmGXzH14e2wJm5mMzFBo2fdJlihhEl/RMrUEHwjY8pAXrdGFT1as8A
	 motwOT4qcKVDjuF/4Q+MpPogoS1EtGrUKN0ZpN0cyUgnDLjy/tTvvrZPeFhmjvc6FH
	 lu76Pyf7sTg+TfnqQSQA8krBkjY1+3vPXHjiChtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0684/2214] net/smc: queue the copied chunk when smc_tx_sendmsg() faults
Date: Wed, 18 Nov 2026 15:39:20 +0100
Message-ID: <20261118150039.117004924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index eb03fd0f6dc8d..16315281ee8a1 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -206,6 +206,13 @@ int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len)
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



