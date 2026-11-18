Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037998;
	b=J+bYxZyXmLlC4kIuvDuTFdZqPjmbBMUe9oEcTwTrrgQbOp/QBAWjMVGLyuQjSC738hFl
	 Bh/QZBSW1rHT9GW02OnaN9FteBnsRutunlqA3rMMDeN+K3SHndD+2r1U/G8bODtEgvStC
	 zbKmBnQGk01Dpdeu3lxVx+J87TW/cD2OzZU6EG9T8x3OJRAllWuVPifjfyfAHT0gbEpgj
	 Ym9zJCK3won11XSU/HU38L5yZENk2pR6b6NyHVUvvDHdqYOEayc6hZtqpbwY2fr+KVJO9
	 FcJNmbzdHeXGuNVLKYyyFShpNYkQyEZHg+hGiAUQpzh/etg1KtxPPf+qPxIqfLACBlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TJodzdY8ia6e6unG6ET3LOvuHTKTzHoX1aHFKaECuZQ=;
	b=qmYpJwFFPVW8ceDxyfwCLGXAc62GbPaDAGsgbM4QGzanwm7wTRRMjoQ9pFLjngUjxi6a
	 roXNFW0NxrapslZFLb/rbCrysUtFXL/hFTYDgcU/5s6whslDOGoqBY+N/niGPQrNjn5Tp
	 oCLO5x2bO99117uxdFHiTzQ5HU1nQp04YaV5TL7Z/O/TkHsocnbXKV3efbpHFW5tUoGYW
	 awL7e00SbO+r88ycdJMzswOUc5po/QkQ4ewgLp8br+8PJ+esQrsWVd+AT6IBwPvPmgnkf
	 AhD8QnTxbKK90R7mISZspwvKCxtTXa2Qz+R4AvyH4JQLQc5V6mcKcyQzzqH8Oa0+Org==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JXUOFRW7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82B1606A32F;
	Wed, 18 Nov 2026 21:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JXUOFRW7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497E91F000C6;
	Wed, 18 Nov 2026 21:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037997;
	bh=TJodzdY8ia6e6unG6ET3LOvuHTKTzHoX1aHFKaECuZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXUOFRW78x8i3HPMGhLlEZ9MWykO5JHmqs5Cjalk8thvDEXy6+GmwbAWGNixejO6l
	 UzbDbS/9PVNG5K/mla9ucHc+JkIElRAtxmilGf3dhBnniyE+R9Sgp32UAj7tPh+mD9
	 mxLlfkEEpBVvFo1vqqa/583SsYKGE4sgf1RxLRrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1590/3318] batman-adv: tpmeter: fix u32 truncation of reported bytes
Date: Wed, 18 Nov 2026 15:36:52 +0100
Message-ID: <20261118150408.840378044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 1025b76d13288a311e8259a0eefde0854fa63c41 upstream.

When more than 4 GB are transferred by the throughput meter,
batadv_tp_batctl_notify() will cut of the upper 32 bit of the u64 counter
and thus under-report the actual transferred bytes.

The data type of the temporary storage variable must therefore still
continue to use u64.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-08bb3be4-6c6a-452d-b4e4-606940c6cfa5
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 50b83e0438a07..e28c4923f52f2 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -226,9 +226,9 @@ static void batadv_tp_batctl_notify(enum batadv_tp_meter_reason reason,
 				    unsigned long start_time, u64 total_sent,
 				    u32 cookie)
 {
+	u64 total_bytes;
 	u32 test_time;
 	u8 result;
-	u32 total_bytes;
 
 	if (!batadv_tp_is_error(reason)) {
 		result = BATADV_TP_REASON_COMPLETE;
-- 
2.53.0



