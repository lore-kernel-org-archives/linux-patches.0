Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048714;
	b=mGpZlSRXofXtaSySoxfp26PFPozO/KK/Y/1aFzdG6Jsbcd1M3OXuXbAirAX1mg0zFO6g
	 z12+Qdmv5TMyz1HokfIyMwosAEVvPhYB40xqQzF4mPveelxJdT4BEZ7v30SDl9384PgrH
	 AfLr9h5P2h/6IQwPZadZELSRWPCdIDAKK18XMsxolrcJpj2fDIlwB4mIfx5SLWhEHyZc/
	 7NtfGpUG+5mYnY/lbXyNJ6zxX4rRfihmerdg2KJ1pbuOLx2f36k1sRLiURlOkHcqQqeXI
	 fWQS7+aM8xTGjezxu3U72sLXZyJCK1dgKlLB1eMvsT1N+aMcukO4HkFQ1acjSUmpObA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mzo0Ej7okFDVl+uN/zJhC6OdzXioahI9QrepXeUnbA4=;
	b=Z4RDPD2tARtddGz9gVWBoWjakjJasKqlhCHj/2DFCOv/qlse0d7bIGl6JXeLa6XO9Pgn
	 1yhakveTNKecucwWr6riiRiWQRpv5MeBt2FIzbXwVb/nm7qgxX6BH4wN1ImbS/stGrs5g
	 VquiMoCrbO1tEy0r4MTnmkRP4B+ZrC8SEbedu10QDpmsMmrgmxbPFbAbwr6kWP4syjKVM
	 hXVbAqlEhpIvM/kY3Ek+oFfOn/xdkxLmShxGX5q2ChgNQp4VVrqmXTFSY8xEIynfe2/sN
	 l0mquPQQ0Xz962P/CwnCwj4j6o40CjFlngHpwhgXan+7TCfLOErlPsPb2dxmw7wFJ6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OhywqwYW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40188606A320;
	Thu, 19 Nov 2026 00:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OhywqwYW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4372E1F000C4;
	Thu, 19 Nov 2026 00:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048713;
	bh=Mzo0Ej7okFDVl+uN/zJhC6OdzXioahI9QrepXeUnbA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OhywqwYWt9ayKZfhNK/841I9+WNMXByVj03dbqh3wWs5kmOWCWLMOfC2G9y86+QJ/
	 ALGcSGlYmJMEpE1ITBzcrZhAnGeNeVQuUoYkmg4orvZ+GiUqx+ylvh9YyWLQsdCqKc
	 xLUUXLA4hasbxNJXtA7Kq1E8XmsTPdLL4DbxZRFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Palmer <daniel@0x0f.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2076/2857] m68k: apollo: Fix interrupt setup
Date: Wed, 18 Nov 2026 15:51:50 +0100
Message-ID: <20261118150316.159954807@linuxfoundation.org>
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

From: Daniel Palmer <daniel@0x0f.com>

[ Upstream commit 6cdbe63badcb524c88f2c8b3cee08f2ffc099a1b ]

The user interrupt vector needs to be installed before the interrupts
are unmasked otherwise the timer tick isn't handled and boot up gets
stuck in calibrate_delay().

Assisted-by: Claude:claude-fable-5 # Wrote Apollo DN3000 emulator using QEMU
Fixes: 0aa78106c661cf6c ("[PATCH] m68k: convert apollo irq code")
Signed-off-by: Daniel Palmer <daniel@0x0f.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://patch.msgid.link/20260828094940.3882602-1-daniel@0x0f.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/apollo/dn_ints.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/m68k/apollo/dn_ints.c b/arch/m68k/apollo/dn_ints.c
index 02cff7efc8342..e62c96c5b0dd6 100644
--- a/arch/m68k/apollo/dn_ints.c
+++ b/arch/m68k/apollo/dn_ints.c
@@ -2,6 +2,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 
+#include <asm/irq.h>
 #include <asm/traps.h>
 #include <asm/apollohw.h>
 
@@ -9,10 +10,13 @@ unsigned int apollo_irq_startup(struct irq_data *data)
 {
 	unsigned int irq = data->irq;
 
+	m68k_irq_startup(data);
+
 	if (irq < 8)
 		*(volatile unsigned char *)(pica+1) &= ~(1 << irq);
 	else
 		*(volatile unsigned char *)(picb+1) &= ~(1 << (irq - 8));
+
 	return 0;
 }
 
@@ -24,6 +28,8 @@ void apollo_irq_shutdown(struct irq_data *data)
 		*(volatile unsigned char *)(pica+1) |= (1 << irq);
 	else
 		*(volatile unsigned char *)(picb+1) |= (1 << (irq - 8));
+
+	m68k_irq_shutdown(data);
 }
 
 void apollo_irq_eoi(struct irq_data *data)
-- 
2.53.0



