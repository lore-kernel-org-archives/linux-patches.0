Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062198;
	b=vkZwV6iOlYAiW2NwIlJcJQzfghjRAgbJtmYaJxAGmvRRazobrTEJ7rZmr84K/kUAWCm3
	 O96HqiaqZTEuLU8ptGbhaMiXiY04kUCoUbkgGYLpqBYlEwFrKI3yKJEIWvWm4/NPmKruo
	 hZ0NGRBPh7PkDEPYTn6lisJG5Z7o8mLfh2ZEiVEp/YDhjxMPk9CXPnaPHWGa+9JtaqTRU
	 nTyh+TNoCUj7Mbc6KStRaoY5mWGow7mQaK+C2ia1JkKqA/Foeh0a/Dj9Sww+AuaWnJI96
	 EribwQDvWGbu8yXBuxITBGYsOP+RWKWyErVuhHq3hEjonRhQSXqYtD2vx0To5DHDMJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZeeIrwD5dKAhThp1Z2OA7rWq7Lx8wfMDmyv4X4B+Jgw=;
	b=1SKkY6+sKS9+SICaGb9bgD96PblzGXjgWd8V0gsVr2jEkmdUno4RdUzCcPlyhx16DSOi
	 BDplRbkgH3prCIju4R3GoJi1PrcQ496+Pivpz+R60WhjYJe4xshMch0OuwpDIlA+mLzLu
	 bLAmJPY0Pq4AdzkZ3zZhRu+9JlRNOPKpU9JuYB5kYF52YLWU5Gip7pymwAFuCeUvCZ1y+
	 MV4+H6OqzftDGd66nm2Q60XJ6g09w/55Ef32sLGtADh6Di0uoF6GrZdDkzh3TKrlv0TU1
	 SbGEgldMgsxLV322f0oh5thUm3gARh1WRWHuuo44IYCDLCxXY5+Kx09Pe+M7tEftZAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6JKpuLO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3E7606A326;
	Sat,  7 Nov 2026 14:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6JKpuLO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6241F008A1;
	Sat,  7 Nov 2026 14:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062197;
	bh=ZeeIrwD5dKAhThp1Z2OA7rWq7Lx8wfMDmyv4X4B+Jgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6JKpuLOcu/oYCHt58095lAhJJIvX7dhEiE4pRNgum/aJE29XgQK2gtUdpiVyOr3T
	 ZhBBW/Zh1ce67MBiq2WRQlBSZnV1+08Zme5ilLrgvT2e9wBqZ3a+T1g/18lMMynfPs
	 iXUVQpXxsbJ6zlIMcQciLl38b4ahLu6KL/2PEhKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1116/1536] staging: rtl8723bs: fix RX buffer OOB write from device-reported length
Date: Sat,  7 Nov 2026 08:52:12 -0500
Message-ID: <20261107135029.054492208@linuxfoundation.org>
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

From: Tianchu Chen <flynnnchen@tencent.com>

[ Upstream commit c52929073fccbc149267a2fd7458626a7e9abcfc ]

sd_recv_rxfifo() trusts the device-reported RX0_REQ_LEN value
(hal->SdioRxFIFOSize, a u16 read from the card via CMD52) as the
size of the next RX packet and passes it to sdio_read_port(), which
copies that many bytes into the recvbuf skb whose data area is only
MAX_RECVBUF_SZ (10240) bytes. A bogus device on SDIO can report up to
65535 bytes, causing a heap overflow of up to ~55KB past the skb
buffer.

Bail out when the RX0_REQ_LEN exceeds MAX_RECVBUF_SZ. This is expected
to keep behavior unchanged on normal devices.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: 554c0a3abf216 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Link: https://patch.msgid.link/8114c3adc1acaea78523cc0fb4d4b25f7665cee9@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/hal/sdio_ops.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/staging/rtl8723bs/hal/sdio_ops.c b/drivers/staging/rtl8723bs/hal/sdio_ops.c
index 21e9f18587452..b2b7c5f3a4bff 100644
--- a/drivers/staging/rtl8723bs/hal/sdio_ops.c
+++ b/drivers/staging/rtl8723bs/hal/sdio_ops.c
@@ -791,6 +791,13 @@ static struct recv_buf *sd_recv_rxfifo(struct adapter *adapter, u32 size)
 	struct recv_priv *recv_priv;
 	struct recv_buf	*recvbuf;
 
+	/* RX0_REQ_LEN is device-reported; the skb buffer is only
+	 * MAX_RECVBUF_SZ bytes, reject bogus lengths instead of
+	 * overflowing past it.
+	 */
+	if (size > MAX_RECVBUF_SZ)
+		return NULL;
+
 	/*  Patch for some SDIO Host 4 bytes issue */
 	/*  ex. RK3188 */
 	readsize = round_up(size, 4);
-- 
2.53.0



