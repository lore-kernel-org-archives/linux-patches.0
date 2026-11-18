Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046234;
	b=ERLtKKVnaOhBn6wKwQh76exdoj/tz62xXDDpcnjgtVr897TdyzJbNDPnminiTpY2UjEt
	 7QJOUMZ2w/ai6PPUeE8tx6p3qnfNa9G+r5WqJCp6T9e/8MxJks6lFZpm7aDQV0pqvChqQ
	 OlM5yhHdpkkBaWQP1TCACujzv7665R8zDAgOSP9mwxh0AyWsgj3LLxmRbLy0xgiY45+KE
	 vAgzu+0XR4tnU4urb9d+XaI3tkPlQx4KW0Mw7g0MRvfNUOotpdOMOQP2Re+fPakw7RIaA
	 4K4T7i8CTvPglMfzESUPREp56lh6YUyjA47hF8cLZyOPFJTahqucEQgqcGwwlBBSyag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S0uMM7r8shGQBC6s8J6oZv7gvIrZgpDiKBVxyTZXNkw=;
	b=JVORd4SnIPfzwwchYIdW98mjlVWEstb8l+8me2xaqOhYv9ijDpl86pYxanOIrmziAjbX
	 vxptACzhzqFpM8ciAd5tCrHwetaXFK1qi+9+QvmXE/qs6oXYmt5g4I9em7ET35+LgRAM/
	 yQe22hE5OT+13Ivqjy61Pfs1M2OGXj2EvdrfizwOxT96XPLOb4XidV5+4eiSgYoxhUNyC
	 SmxyA3ztndYTVe9gMFqB5sJJQ1fGym4bwB6CaEXpxr+HdMqvlOlBZaoRaGlzbpuYc/wTH
	 O6Qr8AiqEmskaqlGOCDKugYrROv9eGMrpoAwn87XUR7vGPrSKF6Xb7QqNA6OSeO03rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ckueF79n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584B6606A325;
	Wed, 18 Nov 2026 23:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ckueF79n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0681F000C4;
	Wed, 18 Nov 2026 23:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046234;
	bh=S0uMM7r8shGQBC6s8J6oZv7gvIrZgpDiKBVxyTZXNkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ckueF79nTugXfkgswqVyajXTMp9fYD4fCosXR3WSnAzu36T+ylfTHGTJQ5Ue2YOwm
	 MVzwNOW8nqyTnLJJ3fRxpufWlsBfMQDW8ovSlm57/E65ieFj1y7qRkyN00aoKLYzjG
	 MB/3o7sGoN21UwVDz6GUfkUgYIh73+K8nI7qd9TE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1168/2857] spi: bcm-qspi: reject oversized dummy bytes in mspi exec_mem_op
Date: Wed, 18 Nov 2026 15:36:42 +0100
Message-ID: <20261118150243.644188617@linuxfoundation.org>
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

From: Weibin Liu <liuwb@xiaopeng.com>

[ Upstream commit 9e44f0df3fff215d9033089e85980048c3ac132a ]

bcm_qspi_mspi_exec_mem_op() builds a local command buffer cmd[6]
holding one opcode byte, up to four address bytes and one spare
byte, and sets t[0].len = op->addr.nbytes + op->dummy.nbytes + 1.
bcm_qspi_exec_mem_op() only validates op->addr.nbytes <= 4 and never
bounds op->dummy.nbytes, which spi_mem_check_op() also leaves
unrestricted. With addr.nbytes = 4 and dummy.nbytes >= 2 the length
becomes 7 or more, so write_to_hw() reads past cmd[] on the kernel
stack and pushes the leaked bytes into the hardware TXRAM.

Reject operations whose dummy phase does not fit the remaining byte
of cmd[] by requiring op->dummy.nbytes <= 1, so such transfers fall
back to the generic SPI path instead of overrunning the buffer.

Reviewed-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Fixes: 5f195ee7d830c ("spi: bcm-qspi: Implement the spi_mem interface")
Cc: stable@vger.kernel.org # 4.18+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261015-bcm-qspi-dummy-bytes-v1-1-c319da3c2497@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ Adapted for 6.6.y: this tree returns -ENOTSUPP instead of -EOPNOTSUPP. ]
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm-qspi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index b24955910147c..846ec071baad8 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1197,8 +1197,9 @@ static int bcm_qspi_exec_mem_op(struct spi_mem *mem,
 	u32 addr = 0, len;
 	u_char *buf;
 
+	/* cmd[] holds 1 opcode + 4 address + 1 dummy byte at most */
 	if (!op->data.nbytes || !op->addr.nbytes || op->addr.nbytes > 4 ||
-	    op->data.dir != SPI_MEM_DATA_IN)
+	    op->dummy.nbytes > 1 || op->data.dir != SPI_MEM_DATA_IN)
 		return -ENOTSUPP;
 
 	buf = op->data.buf.in;
-- 
2.53.0



