Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617837;
	b=3saf5/RbZi56B8uYT8KGPhwBXf+sfMriuvxVmTR2kIflhOIpilmJO+rl0r2Tyt59PyyI
	 JOINFIi1kA/dO2+5u2sodei4+/Lbq7nGwlq2BH1B8VGMJGgR55QuU0GagmSyFJ/GlbO2S
	 TXZbXeHuTHgF4CHQBFfh3AOaii6z4fe+9Xho4H/bCKYfYwh97wXnvl5HZEkhLCURFGQD4
	 76lbi0Fq1rFlHrWm6rSkpbISaJ635l5vTV8zwTCHI/lJyfaY1zuIUVDwTz/P3W+PxnyrP
	 BsOZKL0tLOcC5uOeorRMXCqCzcxIG/eUBb5BlEdxSt3ML/bFxb5o/NMrIF1mRhAZbLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617837;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MyLISnnUjiCtnnBVl0zi0CbVgMBS6NXjMWI9TrwZ6sM=;
	b=bvZAU63K4QTziUHslF8w3pcRKQdddttpLfAcQel/bPQvuXqk93mISVtptL1QOkIs0DBd
	 AKZZqKtJzgTbQmjwmgBHBvuRYmEC92Ma8Xd8uyrOF1KTR6aWCSju6YJEYNH3UIfpnMI6Y
	 6+97BoLlXAbSCC/Aqka0lUZCVyKHZF1h8we1+j2eboUUOSylEdXcpEWHcbfruUj5cbSA0
	 HzIpRsvabKpj/JpI3rgPHgr/B4qzcUlm1r8mxJWrfPOKvImCbimvqP+Gi/nml3eO7lUMw
	 WlyQVg3VwGgOIv1EZNT5VYb99v5tcNnW1zYTCpSu+zp9BAdmOILnTbCy7DBGgpYZxCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s401dnDk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00599606A33C;
	Wed, 25 Nov 2026 14:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s401dnDk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E61B1F000D3;
	Wed, 25 Nov 2026 14:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617836;
	bh=MyLISnnUjiCtnnBVl0zi0CbVgMBS6NXjMWI9TrwZ6sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s401dnDkRb/K3Ww7c+/xbpNxDCtLVMvRzIouRs/rpl2SgAjtvpEX0vV3O+KX2w5UG
	 mMF/avQRyhIPFVDte+G5prJ0F9bKjx/5t5I0owY63hm7bUA8RlJyHq7/jYIcAkFjAK
	 DOxzr0mE2QoXffluyclInCraOzaBbVBm8BZS4D3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0090/1005] net: ipa: Fix double free of the interrupt structure on config error
Date: Wed, 25 Nov 2026 15:23:48 +0100
Message-ID: <20261125143823.849147224@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit cb284914e749388eef402938bdb3115fe1f6d337 ]

Since ipa_interrupt_init() allocates struct ipa_interrupt in ipa_probe(),
the structure is owned by ipa_probe() and released with
ipa_interrupt_exit() on its error paths and in ipa_remove().  The error
path of ipa_interrupt_config() still frees it with kfree().  If
ipa_interrupt_config() fails (called from ipa_config() via ipa_setup()),
ipa_probe() unwinds through err_interrupt_exit, which frees the same
structure again.

Drop the kfree() from ipa_interrupt_config(); it should only undo what it
set up itself. Drop the leftover initialization and cleanup of
ipa->interrupt now managed in ipa_proble() and ipa_remove() of ipa_main.c.

Fixes: ad1be80d7582 ("net: ipa: introduce ipa_interrupt_init()")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Alex Elder <elder@riscstar.com>
Link: https://patch.msgid.link/20261029082100.17722-2-fourier.thomas@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_interrupt.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index 131b9cc942014..766b094eb0694 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -260,10 +260,8 @@ int ipa_interrupt_config(struct ipa *ipa)
 	interrupt->enabled = 0;
 	interrupt->suspend_enabled = bitmap_zalloc(ipa->endpoint_count,
 						   GFP_KERNEL);
-	if (!interrupt->suspend_enabled) {
-		ret = -ENOMEM;
-		goto err_kfree;
-	}
+	if (!interrupt->suspend_enabled)
+		return -ENOMEM;
 
 	/* Disable IPA interrupt types */
 	reg = ipa_reg(ipa, IPA_IRQ_EN);
@@ -289,8 +287,6 @@ int ipa_interrupt_config(struct ipa *ipa)
 		goto err_disable_wakeup;
 	}
 
-	ipa->interrupt = interrupt;
-
 	return 0;
 
 err_disable_wakeup:
@@ -299,8 +295,6 @@ int ipa_interrupt_config(struct ipa *ipa)
 	free_irq(interrupt->irq, interrupt);
 err_free_bitmap:
 	bitmap_free(interrupt->suspend_enabled);
-err_kfree:
-	kfree(interrupt);
 
 	return ret;
 }
@@ -311,8 +305,6 @@ void ipa_interrupt_deconfig(struct ipa *ipa)
 	struct ipa_interrupt *interrupt = ipa->interrupt;
 	struct device *dev = ipa->dev;
 
-	ipa->interrupt = NULL;
-
 	dev_pm_clear_wake_irq(dev);
 	(void)device_init_wakeup(dev, false);
 	free_irq(interrupt->irq, interrupt);
-- 
2.53.0



