Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921DF14F12D;
	Mon,  6 Jan 2025 15:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176838; cv=none; b=De7ovqEyHoxYyHp8PmXOrNOh0ltLmWraMBsOUzjSlHJwautgdISRrC8f5QrwUyz9RUBDhMCLsXzE/SimZWDR6WweP3KsjPIgqaw/7OumMrlAzCokTFKnm5dgH9LLT0hD49Cp+aDkEE0X4KsCqDMaJA3G2a1uhiJ6fe+yo7q+5+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176838; c=relaxed/simple;
	bh=BWYEKX4Ff31hG2f+qMQAz+hKrCCAnAxLkPdimV2bHH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGpNt4dAyCEm1VBCm8SF0Agfw3SpfzCwPy0dqKkpHv9T3zeKHA0zNGNUCcP40OxR+f8RUwpSENk8D6RcyKNPwhr0hzvgSrnOHDq7tFLN1UjALf6vBElonW6RoIHGSqxflZXARHoDSbDiLqwKzZwOwtmGz2ZijtkI9jV1R3wyTjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jg7ILg7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jg7ILg7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C804CC4CED2;
	Mon,  6 Jan 2025 15:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176838;
	bh=BWYEKX4Ff31hG2f+qMQAz+hKrCCAnAxLkPdimV2bHH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jg7ILg7pp7Dq3pLAhMMT0E3RNN3RR6KeBD6rbl8WEacbwoL1Xf2JLB7LGFtofe/F/
	 kSFwoTte1fDerND2DRoJv+SD4C/0bX7Uqllip1hCXhnlZA7Qt1SRcwfS2Y1w1wevrS
	 6EQ5jmeYF6McOIdGoE1vZoavQhn8xUDpxwoQt8Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 47/81] net: wwan: iosm: Properly check for valid exec stage in ipc_mmio_init()
Date: Mon,  6 Jan 2025 16:16:19 +0100
Message-ID: <20250106151131.210824406@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151129.433047073@linuxfoundation.org>
References: <20250106151129.433047073@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej S. Szmigiero <mail@maciej.szmigiero.name>

[ Upstream commit a7af435df0e04cfb4a4004136d597c42639a2ae7 ]

ipc_mmio_init() used the post-decrement operator in its loop continuing
condition of "retries" counter being "> 0", which meant that when this
condition caused loop exit "retries" counter reached -1.

But the later valid exec stage failure check only tests for "retries"
counter being exactly zero, so it didn't trigger in this case (but
would wrongly trigger if the code reaches a valid exec stage in the
very last loop iteration).

Fix this by using the pre-decrement operator instead, so the loop counter
is exactly zero on valid exec stage failure.

Fixes: dc0514f5d828 ("net: iosm: mmio scratchpad")
Signed-off-by: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Link: https://patch.msgid.link/8b19125a825f9dcdd81c667c1e5c48ba28d505a6.1735490770.git.mail@maciej.szmigiero.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/iosm/iosm_ipc_mmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_mmio.c b/drivers/net/wwan/iosm/iosm_ipc_mmio.c
index 63eb08c43c05..6764c13530b9 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mmio.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_mmio.c
@@ -104,7 +104,7 @@ struct iosm_mmio *ipc_mmio_init(void __iomem *mmio, struct device *dev)
 			break;
 
 		msleep(20);
-	} while (retries-- > 0);
+	} while (--retries > 0);
 
 	if (!retries) {
 		dev_err(ipc_mmio->dev, "invalid exec stage %X", stage);
-- 
2.39.5



