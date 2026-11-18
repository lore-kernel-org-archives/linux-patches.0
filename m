Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044841;
	b=d15neCheNToORQnwRLrRD0T12kUKhbnB1w8U2/Fi8emG5QrU8OSOrV9mmeNY4oJD3Ptw
	 lcxCxDw8VHxNFGkgkDZNV7zhRXq5blfTFfVZwljbVO/VzPYZDT2b1glEbHTCrPxKgKXFP
	 3rVKFysSn1MXj9FojL57Ohelw940MTft3SQumyccvEx9Mm6PtCVwDdMUPKM6gEOEtw7nA
	 rgKErRu/ufmuTXJNjJKiftU5PIIdBRlKNCKI9QBSjDdrVFaAtAksg3r+/gNBxUbPteB53
	 3a1ZweJVUBOHiHjRl5um8bwE7JsrmWrDvNwS2zMreyZM/vhSjH3yMbdxD6GP51yukwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MteMwodhlcOl8dxkn5wpA/kV3o0jogppupTzHlsjIZ4=;
	b=X18d8kYt9Sh577W4APP3HeDCB+QpPN9IHy3LavZ+VWAefoLgc1ELlhx22kUdpgrWTTRs
	 8Ngl2UE7VygoIZlz9ByQyRJD18TkIhAiTDbWC844fcIWqAqBLRAhmV52PT6TgHLdABeie
	 ufx6NWdbbWOjkx+sFyg4IHqMsRq68G4An4lt7kh633CqBgIiRjzsf8Ik9h0WCIc/DleAR
	 oA4OjWWBMQwt2hXp0YRSgEJnD15TPnXduH6s8go+CJOKmWayAbZM0crjoP8zXEQzm1wHu
	 tW6Uxp9cj4xortiqSaMV0mS4NlGVs0btsEQuqhoF7nxpWf+vVwnBZY3LwiQnSziW9eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i9dKaR7b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F69C606A9C0;
	Wed, 18 Nov 2026 23:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i9dKaR7b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF41C1F000C5;
	Wed, 18 Nov 2026 23:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044841;
	bh=MteMwodhlcOl8dxkn5wpA/kV3o0jogppupTzHlsjIZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9dKaR7bQ9RwxD/UjobhEd3P2VytrIDDDzdjTEpYXI0FC9zyn3kEk+mJcrwt/c08b
	 yH6qYQupuKNO2AeSmtWuJR8yGJp2yt1rzx+oIyPZhyQCSgNWftWZbnOnZKIFd9W0dl
	 7U+Xn+GsHFVgJOSyBynsdbcSOCGu15UmccI0srMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0710/2857] media: redrat3: Ensure we dont read beyond the end of the packet
Date: Wed, 18 Nov 2026 15:29:04 +0100
Message-ID: <20261118150227.115910673@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit cd49f62f4161c7340d9c9f53b67757575900c0bc ]

The length and offset is provided by the usb device, so it should be
validated.

Fixes: 2154be651b90 ("[media] redrat3: new rc-core IR transceiver device driver")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 978694482ad24..c0363be118f2f 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -358,8 +358,24 @@ static void redrat3_process_ir_data(struct redrat3_dev *rr3)
 
 	/* process each rr3 encoded byte into an int */
 	sig_size = be16_to_cpu(rr3->irdata.sig_size);
+
+	/*
+	 * Note we are not checking if we are reading beyond the end of the
+	 * packet which was sent, and reading stale data. If the device
+	 * sends a packet which is short then we get garbage IR, but no
+	 * out of bounds read.
+	 */
+	if (sig_size > RR3_MAX_SIG_SIZE) {
+		dev_err(dev, "length %u is incorrect\n", sig_size);
+		return;
+	}
+
 	for (i = 0; i < sig_size; i++) {
 		offset = rr3->irdata.sigdata[i];
+		if (offset >= RR3_DRIVER_MAXLENS) {
+			dev_err(dev, "offset %u is incorrect\n", offset);
+			return;
+		}
 		val = get_unaligned_be16(&rr3->irdata.lens[offset]);
 
 		/* we should always get pulse/space/pulse/space samples */
-- 
2.53.0



