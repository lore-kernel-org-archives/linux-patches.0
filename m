Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045683;
	b=vY7QGulsJ3+74uvXbJKsoHDWD1qL0cOVDNSrh6Cj+z9mvK4GYmP61vSNpgBJH/VX5esv
	 IvsQdKiMjisMpzCIV+srvmtHpEZLWgA2/f27iPd9OVa3L2t7TGtUwmiJTFuvYQf913Gdy
	 4kerp/brLcrwwFsq3K+nbgiI2k0qNlLe6Bq8I53Wjq1L34XC0qEbITEODyyG+2DhqiNDc
	 +OqJJC1wrjH8sMy/LeXz4dpXI9raCfmEJKjIy8p5eq7ge+DmXHshSTRAEHRTYWAdozcQK
	 IiBUqwK7UXwkpZ3Kueb6SJW2Kxw2ZOumqdYMXtp9+QyKkfU9E4hkS8SSOUOBOJpVa0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045683;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uTTIzLwvdkRSPb25vMD+zJcsh6TFgWVN5cIKutiv7DU=;
	b=X/8aSrBqBeG9aMXLQDF2TxO9DHeQGvF081+uza4l1UhV7Na1PG2HwuMyV9VOULcEeZN6
	 PyQDgpCEVFKnitq3OqWMsf4VeMHn90sKdez60Qozwn0ai3Hv0fhMUqHszU8RaZC58RPfZ
	 YNCSF+Y3BBm/dx16ttNT2WGTGikODMKqVt8nEYfKX0uoHAH1A257ioq6N2EUDOb/n7pVK
	 TzbAKEb/ptpjsP+1ZZf94OFZOKXVsN0Wo6vZo8VvlUvKytwfLt/ChBDaHCsJBP4sJuysW
	 THcPfVs1oCx+oVqflBSaUaj7l6LvfPVRzP9rVHu2v3r2VsywIt13vIe0FHfdm9hFUIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0rsOniQU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C5E606A332;
	Wed, 18 Nov 2026 23:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0rsOniQU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65131F000C4;
	Wed, 18 Nov 2026 23:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045683;
	bh=uTTIzLwvdkRSPb25vMD+zJcsh6TFgWVN5cIKutiv7DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0rsOniQUA48Sq9MloV68u6fhNeZ5QG/AwNXWW8PB4zpuoHa34kuiokH1Xqu21J8Kb
	 k6CllPCAo8WPMqyaAVC6UPze7GkvQGkOn79ZEwc+R3x5c5xEjNNVoiae0h4CEJ98Yv
	 RikbdmLgPd98Q8ual2HdKIGEtvy4JixuOx2pVXKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1011/2857] net/smc: queue the copied chunk when smc_tx_sendmsg() faults
Date: Wed, 18 Nov 2026 15:34:05 +0100
Message-ID: <20261118150237.997841233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9b9e0a1907347..056f18116d14f 100644
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



