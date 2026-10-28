Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211787;
	b=4aCCm4dfGCOvbt0wmsQQEu8IzHJzvRo7dTuzrXs8vPf4VnBl9fmSquIqI/RW6rt451sV
	 /PM/e5nV4dpnhawgGyf20nv1UrYzpOdBsi2q254UCeMZtRf5my/UOnYBanPdgPpOgEJUG
	 HfREurJnTdWJ5dTnwNus5dtuyirAL90Oha+yislmEFM0/pzTdG7DZ1n4TFc8HZu23eAPr
	 uckBLmYn1o0w4wa2OgHNODZ3xJ6Jk9QSoVa2BEwuMbHPNuf5zs4quSPxKzpVKg+WQIwy8
	 4zBRsrz9lVzbpGf50sxKONxRu54UGhqn0Ka48laUnXpzFTPjvNw0by5Oar3giuMOfBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8AvtkIHfHzPUASImKWyNPX5N8samJKmTVgZJ9XXwGYw=;
	b=uuK1jNzrplGI69Xy1oK/RaieXWv3Qe5ulZfQntz+FsQyuDaSAvMIa4145im7ujyf2vYi
	 wnHfgWnup7VeCGSFMp7o7p6Iv7eIBooBTO45SQkRw+2us+ne3gFltv2XJJBWKYkxe9bKb
	 OeUhKa+cl7s1+j7Q3iMqhRO9tbxrxyFu/zT5VC85ySqcwAtg9Atm5Y2nnaF3JxkTqiwNi
	 rplitojTgAvbSVsr0bSwbOBj/XlUeAwj3GlITZUdyz5NwgZkisMQ2YaAfkf3wispygv5E
	 0PQzWycsxX1Q4FOWx/HyJEZFJA4Zmo7KdjYTeKsrmC2UHUrFe+s1ZXF+wgZw8b9AAVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XyuX9Zh0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5FB60A380F;
	Wed, 28 Oct 2026 18:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XyuX9Zh0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF491F01829;
	Wed, 28 Oct 2026 18:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211786;
	bh=8AvtkIHfHzPUASImKWyNPX5N8samJKmTVgZJ9XXwGYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XyuX9Zh0YDdBye9KfpnFbSFc2vNlUnv3AbaNOLHlTwOXIiVFJCSfFDuUq9DPer4ad
	 3TduMWq52IXJvxcYasuSERMf9zX8rdVzTw+Mop3LaNyvj/+jivgrFTKZgUp3yngGgW
	 fc9qcfmQQ1zZnP0q4Awqp/bYfWHeCmUv4UeyskkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 499/571] i2c: qcom-cci: Fix HALT_ACK reset request being dropped
Date: Wed, 28 Oct 2026 18:00:46 +0100
Message-ID: <20261028170019.869639102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

commit 195f3d74b5de98969dc4fad956393bb00787efd1 upstream.

A HALT_ACK interrupt indicates that the corresponding I2C master has
entered the halted state and must be reset before further operation.

The M0 and M1 HALT_ACK status bits may be asserted simultaneously in a
single interrupt. However, the interrupt handler currently overwrites
the reset mask when processing each HALT_ACK condition, causing the
first reset request to be lost if both events are reported together.

Accumulate reset requests instead of overwriting them so that both
masters are properly reset when M0 and M1 HALT_ACK events occur in the
same interrupt.

Fixes: e517526195de4 ("i2c: Add Qualcomm CCI I2C driver")
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: <stable@vger.kernel.org> # v5.8+
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20261012-cci-fixes-v1-1-8cd4eb1fc5f9@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-qcom-cci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-qcom-cci.c
+++ b/drivers/i2c/busses/i2c-qcom-cci.c
@@ -168,12 +168,12 @@ static irqreturn_t cci_isr(int irq, void
 	}
 
 	if (unlikely(val & CCI_IRQ_STATUS_0_I2C_M0_Q0Q1_HALT_ACK)) {
-		reset = CCI_RESET_CMD_M0_MASK;
+		reset |= CCI_RESET_CMD_M0_MASK;
 		ret = IRQ_HANDLED;
 	}
 
 	if (unlikely(val & CCI_IRQ_STATUS_0_I2C_M1_Q0Q1_HALT_ACK)) {
-		reset = CCI_RESET_CMD_M1_MASK;
+		reset |= CCI_RESET_CMD_M1_MASK;
 		ret = IRQ_HANDLED;
 	}
 


