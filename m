Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828868;
	b=nZmkpJX2aXvGAVODMKBfjPRwQsh0ptWMGJiScuKqwJPDcIC5yZy4lJ0GOW+Odroij3t9
	 WOEWKC/1zTkP+RP0/eRjbsDFNLaecxgs7lOjNQwPsh6AB92EQeOy4ZspUqYjmDWvB1vio
	 AaVxKvzIk8svcUGOUrNjqeRCw2RWu7k2/Ijc+IzARUvzot0Qoc14v4F4ucIMmnP8s3DtI
	 X5tPoea55iEsxMeJiYGo7QF2Y9Pv+m4aJWH68VZ2ABa+/wnJsVNp2OCd+YYqu6PR9Rd8V
	 3CgxhvaqrsfhbPZP469XdLYRKIxq+htLgxx0rb4Sbr4/faRoRXWHBoUXiQmKoG+0VTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HNo/HUCAiGDu7aiWGKWo0qAlj9yap3LwrQk9IA+u0hQ=;
	b=CnOvIA9H7BF9FmiaV+m0K99RnHrWt20T8WrhkHgXOX98L2QO2AwvBZtYpcRgrYIPiuvj
	 3j04Flny9YRLA0yo+RH1AfwtWjnaUBf1h+i8V8IPG7u6YRX8KWM47TmTzBwfmCBZSTawl
	 COxz+UD1shNJHOEyX2k1w0iHNjF3W/awhDQevf5ewVKod2C1X2j4x+Eh5scw/2EJf5q/W
	 RcTDgFCNY2SMJTHp4CO6M4jfaoeT4mgu2dW0/0KTR6eNq3Y1mRZh4Et+9H4Xhb8sKgk0t
	 2sSjiwqKrIT5jEvCRmXubtLF5jtLEoMJzm42cMhAMpjvLMwIdIv1pbTemWT0mpSnw2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u1Es5HzE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16996070F27;
	Wed,  4 Nov 2026 21:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u1Es5HzE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E89E1F000C1;
	Wed,  4 Nov 2026 21:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828867;
	bh=HNo/HUCAiGDu7aiWGKWo0qAlj9yap3LwrQk9IA+u0hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1Es5HzEe3uwT7s+FuFQABBaN9FGMZPqLWhpd/o5R+Zg8sZVMsvQHwxMREdlcImnC
	 1Kx0Ghj6lvGclD/g3UoKNyYDdiAGIQLFBxXB/J9Iw+GdfM0HkaBEUbU17tyVT3IGWT
	 IagmgNNl8uJNQ+i4dMNmNE7tRBomIpYziYUBTQU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 7.3 264/547] media: rc: fintek-cir: process a full RX buffer instead of overflowing it
Date: Wed,  4 Nov 2026 16:07:28 -0500
Message-ID: <20261104211045.691133936@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weigang He <geoffreyhe2@gmail.com>

commit d1febef1bcfa7bbc401729f994c375b91a833911 upstream.

fintek_get_rx_ir_data() drains the CIR RX FIFO into fintek->buf[], which
holds RX_BUF_LEN (32) bytes, for as long as CIR_STATUS reports pending
RX data:

	do {
		sample = fintek_cir_reg_read(fintek, CIR_RX_DATA);
		...
		fintek->buf[fintek->pkts] = sample;
		fintek->pkts++;
		...
	} while (status & rx_irqs);

Nothing bounds fintek->pkts. If the hardware reports data for more than
RX_BUF_LEN reads in one interrupt, the loop writes past the end of
buf[], starting with the pkts counter that follows it in struct
fintek_dev.

Hand a full buffer to fintek_process_rx_ir_data(), which parses the
samples and resets fintek->pkts, before storing the next sample. This
keeps the parser state consistent and drops no samples. The loop still
relies on the status register to terminate.

The driver does not document the hardware FIFO depth, so it is not
known whether a working device can trigger this.

Found by static analysis tool CodeQL.

Fixes: 9bdc79ea07d9 ("[media] fintek-cir: new driver for Fintek LPC SuperIO CIR function")
Cc: stable@vger.kernel.org
Assisted-by: LLM codeql
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/fintek-cir.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -340,6 +340,10 @@ static void fintek_get_rx_ir_data(struct
 		sample = fintek_cir_reg_read(fintek, CIR_RX_DATA);
 		fit_dbg("%s: sample: 0x%02x", __func__, sample);
 
+		/* Process a full buffer before storing the next sample. */
+		if (fintek->pkts >= RX_BUF_LEN)
+			fintek_process_rx_ir_data(fintek);
+
 		fintek->buf[fintek->pkts] = sample;
 		fintek->pkts++;
 


