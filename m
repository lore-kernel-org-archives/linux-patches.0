Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774835;
	b=IXHTRlv3uzUZGXRhVg3x9Kx2CgE/dfJzQH3BOredri+mThH3h8j44jxGzb41Zwcweqh7
	 H1+PXZOb/Mo5NOQe0AApyZm7I0rxwz6TWgIitjdouiakcDtFJ8P5/R3HXZ9KRW4tO1xEU
	 +k0GmUjCkZseDKHojkR0YiLXC0xmPgWYWiKPRfleNz2mylumR6qAECA8fu9F1qUL5RFD0
	 7KTI+5FcBOHtDmGTRTj5Kc047/x5dW9uxBC1lH4YY5U7sthRejuVFPSfld1nyQTclYQUB
	 la22H3aYpA9sHLqiPXtzQvtdJq7hSkYH6fJB+MDg8JDFsoYe4mndYuwz9/8m4yF/B9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D8U2IgQzMep2xcgrOpGQp6pv501EWsprg99S0300q28=;
	b=vTrGwlbuv5UYTE1ldvXzzpdEtvcEWQiVE6A/xh2P7nRzAS8tX4xp1olCBP9fDIHCrYp5
	 3m0Ef6Mru3HZemhuZoGdGg/AgtaMeG6SgkZ5CMB3NFQ2s94lpMSPCDKb42KTL7tB9CR5n
	 6IjEGVbGf4ZhkOJ/0uS9tRDVpPAq8U/Ul9ki7AdqGzBNjOZp/fp80uUR4Z9QK3N6MlgV0
	 o0CnBPMZTeSIXbBMOwcgssfr5YcEII9Fqp+J5el1b0L+JIQO0ruUcM5YCGCGAUGNkLh5p
	 IKXndT03VmAkaMZAk5vgAWisSDMfKv+h/B425Mae5lrtXPmxm/lr2ocwB6guPRCUgbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2jNj3vVM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4E0606A31B;
	Fri, 23 Oct 2026 17:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2jNj3vVM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20CD1F01828;
	Fri, 23 Oct 2026 17:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774834;
	bh=D8U2IgQzMep2xcgrOpGQp6pv501EWsprg99S0300q28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2jNj3vVM6lDIh20X5Oph2yhK4oyoO43H8rRev8iPqXz1fk5wLe68AM7Kjt52SXl8M
	 IpEszJEzXvBKbTDQBQBEcK8F4WPC0eKN+PvgnfOSERAhaN3nHXSGfSRQsYROME0ZFM
	 +vmlJCoV5l6axVoRw1YTAhoLJNI3ZjUL4ODUZQCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.2 136/242] i2c: qcom-cci: Fix HALT_ACK reset request being dropped
Date: Fri, 23 Oct 2026 18:39:38 +0200
Message-ID: <20261023163716.994527473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -164,12 +164,12 @@ static irqreturn_t cci_isr(int irq, void
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
 


