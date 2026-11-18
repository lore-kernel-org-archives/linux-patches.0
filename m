Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046722;
	b=PWvaCqVGv25juT2o4LVqUwQkZ3k0AG46vVaEM5tGZHB+L2HEiIuuS5bfOE2pjcw736D7
	 Anbn6k/VHGTnTP2rmaI0Nwy3iCvtS5d8jPRtoWnx5/c2HhZDuXkSFU43YMEwpqymM33Kn
	 PX7mJ/zKGuLfDX9oVZBtfWcHMJDSze12dhpE4/L4UnX8x6WI9NvKg40ANqYxPBV1H9Opb
	 44wu8LUBm1RGViao/eAX0pmue7stw55wDj9yWV4NJVB2jZBumseGA5dxyZR+7uoeV9Wi2
	 xvzdz8oPAoLU71kV/XMtdREetN7vmSlCugqQV/1ysc8EDjWl46SRQg5vspvLCKspM6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BXJnVmbqAf+GzVN2bO074lb6q9/NRHH4DzGUtIcjIWY=;
	b=cvkHRkMizbVMO9lfmJDm4nRoqC718FbpJRLopa/z8lQyE2bAT3A5gh9yJDul4dcEwI1i
	 NDWrvG7v+In300/noWj5IPfghaJgYkW/UynpprkCETAQ6z7csV6cap89o7xKCevPwNzj/
	 3an3DBhLYracC1Jek0/WAMiEOcJE3ArPKJ4YEyrboTU6xPJt8BJ/X1tl1W5W6n6S2Fgwe
	 b+N7SektVi7+HE3kpNzEoaQkBZlNCYotTU2dwV2p9iLxl9h5qjKfBXMhbnU9mI/DEPY4W
	 zgqhJ/Lfy1PISRngiIuk3xaKZpz0zGNem4ljorcrTTj7nSuUDeNFFYbz/ePRvqL62lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TpVik6a0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62CA6606A31C;
	Thu, 19 Nov 2026 00:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TpVik6a0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B906D1F000C4;
	Thu, 19 Nov 2026 00:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046722;
	bh=BXJnVmbqAf+GzVN2bO074lb6q9/NRHH4DzGUtIcjIWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TpVik6a0kbNzzruPVNLFegz+jLLIN0QnkpX68gTxxyUNo5GyQsbCOEJbVtaUvINMa
	 k62U1bxPovdXs9iI+UusFxjAvs3/hRiqwS0yt2x/tPwAvgpa89pkDPQ8+4ichzdNze
	 GH8OqgCR8KeLV//okRP43CMG2ig4qIKzwKbB+kNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1342/2857] batman-adv: tpmeter: fix u32 truncation of reported bytes
Date: Wed, 18 Nov 2026 15:39:36 +0100
Message-ID: <20261118150249.745889068@linuxfoundation.org>
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



