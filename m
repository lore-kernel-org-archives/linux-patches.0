Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063129;
	b=ypAgC152xYwJkeNBKeTn5NoabBO/7HlyFeFbd0UnWwY+eZOovMBG9a/pN21E1GpPQav/
	 kxoIxnRZE04Ba2lBAU5/oNkPooUkA2jIbmqpFN7yGppQsImtSnRIYd0JhVjHmD6gMdT1v
	 Y2UolOmgiqWKLiq0BecJIOiOwR1OAOJGue9Tq72YB5L2+jihUhryG66pYaxbHvcS2Tkxj
	 lGS//wcABzLLpKJYD9DYl5AFtM7C/C4TrBse2b7g6m5KYOI+RgCCZ07OxuNn4BktC+6VD
	 PZ8JOFgQRjN1hhEFazagHA4s1WEJVgpQsrwzXDOvPhlEMkGotSrxwi6tkatfyq71bSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JXq0dv1cLoThzv5vyf8QSqIweqBxLfJuOP9wiONvfjQ=;
	b=Tv0732a3U3bWj355d0CfUPauTj4VJO+TMpJWehqMO11bscHeUNlys6Jyk0DuICXuKhqs
	 dXjEXB7tL38Jau56ExXbE3Jf3GtOXcNoCP0jySwSOCowo++iQvIz/TKHXr65cVIiHEEKM
	 brokCs3bRzuODVDoWe3JFJh9tl1nZcGS2Ihr/jK3+cO/Kv/TFU9VH5n6ODKlsEME6ZvFZ
	 R+3/6yt2v2WmAAO18vd68HUn3Y/2oC0s7FCjRFrTKvR+U0uLexY3SUFDHbVeQqYUlgTiW
	 vxn66Xp2X1p3ySuDWgz6tIakTaMMokD/8TftGa90oFYz0faMJYGwARR1xK1E+oayuJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AsX88WIL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F384D606A330;
	Sat,  7 Nov 2026 14:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AsX88WIL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBF51F0089F;
	Sat,  7 Nov 2026 14:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063128;
	bh=JXq0dv1cLoThzv5vyf8QSqIweqBxLfJuOP9wiONvfjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AsX88WILGYHeVJXpaSoyvz6UFAnae5QO3fX1PG00FD0sa4BFoJt6H/KzzjY8Eoqkv
	 xTCyQHUcZGCW4YwNvDIi80n6nhYCLj67+YwmIHsz45hEBCBX/wutO55IFH/E1fJRG0
	 jF/oHl1y647AXIclMxjkrLHUjF1KxYudUjvEex8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 309/869] staging: rtl8723bs: fix RX buffer OOB write from device-reported length
Date: Sat,  7 Nov 2026 08:49:51 -0500
Message-ID: <20261107134903.002781011@linuxfoundation.org>
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
index 54228c41579ee..811720775eb83 100644
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



