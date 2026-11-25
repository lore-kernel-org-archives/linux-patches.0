Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624242;
	b=BKDgadGWO4kakwbVpRwm+S1DZqT983v12rnzkSpOQ2D3qSB/1ZNVXQpnWuSnT+2TkKMd
	 NfBPDwfPfeI+RHBXfrWOrpQKAdnwniXLpee7hzAZ9UQIb3enZEdPxo4KfJWOmjiP1kvbE
	 /iWMxa8+yemakXiH/0UPn75rJDBilzWCuMvZTjPYU4C5e4h3j9h19looXrx5InQ96rKuh
	 8ajwBu4bQy65KouQgJSEpdmMwL8/NnGUPlDpozRyfvWTUBj1zasNxkeexoX05m3nCudbX
	 ekTZtooemhKOX55cDwYtGB/h+nRGHSulceN786ii4GQ+wvB4aFL5QcQ50sUkqw4M3eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624242;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xvatjj1hHAF5m+4nBynBO7l3StGzKppLpYiOX2OaWJw=;
	b=FN/XoLScRJkmRrtm7n98IuHf6i1tukolHGhNfdl4DlVm7iEFvJ1ak4hTrObQJn1+Uc2+
	 4VcmchDfJtNZVd9yosQGGYQGeDuSzDZfM/tVALGHnjjXjnyb7w2HrIp8tBHdd+C3PQ7uv
	 lBV2NDh1yWVYHY/76Zt9uqseG7YA0WgnI254npFh+mgYIJuUcey7bRZKbdgYuv2+vWkNj
	 9lAf8/PMsz9WJCqIUYUZrdNUY5OcVp102K9du5gEje6FewMnCAYIYnCTPXdVUj3AsT6TB
	 y78vCT+YghKPBBZARzh5WEci4JiorboljajXQLr2nFBK2EHtVqaOGb0sAR+6rLO6tZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gdJQdiMf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC35606A691;
	Wed, 25 Nov 2026 16:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gdJQdiMf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673EE1F000C0;
	Wed, 25 Nov 2026 16:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624241;
	bh=xvatjj1hHAF5m+4nBynBO7l3StGzKppLpYiOX2OaWJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gdJQdiMfW43inKVGrshx/1j1F+xRx4QIX0/zSTZtIEutkEw9XUQv2WSJZpRTCgCUu
	 TAKEjtDN/DbRwLSFmzr1gEMsXnN48isjtL4RIiG1mQsPziUQ+lhpY+56aWRDFv94o/
	 b1l3Q4P0vH0eOrSG5//0IvRnjGUcJVV7yN3kYqsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 084/816] net: ipa: Fix double free of the interrupt structure on config error
Date: Wed, 25 Nov 2026 15:27:12 +0100
Message-ID: <20261125143851.165618644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 245a069970556..dc5315ce31d32 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -261,10 +261,8 @@ int ipa_interrupt_config(struct ipa *ipa)
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
@@ -290,8 +288,6 @@ int ipa_interrupt_config(struct ipa *ipa)
 		goto err_disable_wakeup;
 	}
 
-	ipa->interrupt = interrupt;
-
 	return 0;
 
 err_disable_wakeup:
@@ -300,8 +296,6 @@ int ipa_interrupt_config(struct ipa *ipa)
 	free_irq(interrupt->irq, interrupt);
 err_free_bitmap:
 	bitmap_free(interrupt->suspend_enabled);
-err_kfree:
-	kfree(interrupt);
 
 	return ret;
 }
@@ -312,8 +306,6 @@ void ipa_interrupt_deconfig(struct ipa *ipa)
 	struct ipa_interrupt *interrupt = ipa->interrupt;
 	struct device *dev = ipa->dev;
 
-	ipa->interrupt = NULL;
-
 	dev_pm_clear_wake_irq(dev);
 	(void)device_init_wakeup(dev, false);
 	free_irq(interrupt->irq, interrupt);
-- 
2.53.0



