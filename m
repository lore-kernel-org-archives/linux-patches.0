Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621058;
	b=af+eQq97s6tFlJEqhh5+O3QstGS0DVz9EnWruNlsVOY7wMPF1pdCsvJzg5S/lE/pQHsU
	 Dt+P5jPk2DLBE9WtATZ+jikRNxlJrVhFOfxHb/16eqA1rhGDZOHun2adDsUKK4ef37DNK
	 UWQmn46IUjFhpbzU7byuz0kHkplWdUO/KzekoOdO/Fl5IeQfgGgzWowZedLOdUCzLdCmJ
	 Y0YHJKh4VqYBHSzm6nfPSPXvYgn/BeUpZ8kEGTJeU5GbgTkwFWbdXashu0C8mKmgG6oUQ
	 PjyBT+A2KxT9qlUuVN8fEnAB1xpPi5kzm8FKNexzga7GrD6nbL/j+s6GEDszWvC+BWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z9WOnTNxcBWgigALNekcolo+hF6olphcIfI0SuR1zp8=;
	b=KmeA10ZJriv+cPWhlE2+Jdr/qQTSKq8I/eBKaRfau+moMf+dPS9u4/qIUsw8GL9P4C/g
	 TYRY6ufIrOcDjeG81fNssCo3qk4sWcqE6jf0rxw4k3lTnLhGh1mb9gas6cbG7jY9u/TID
	 vk5n6g1q7mQXMdnfhiy798ktU+l1TuE5V2TdR4DTF9/iBQaVKmPfQz0mD+yIXmbwe8/BQ
	 mWqKOdEq9naQGrkZBFbbIskD5i5uO/qzHQhW76BSzRjya9YSRkbX3LhAD338tlcRoGISQ
	 AAF//K7MWkwCGT/Pyc90siN7Ucgy0w6i+chGtrQ2kkTSx+5GHRcWu4quMlLXvYGjGOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ELQDd5iY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DBF606A333;
	Wed, 25 Nov 2026 15:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ELQDd5iY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4BD1F000C6;
	Wed, 25 Nov 2026 15:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621058;
	bh=Z9WOnTNxcBWgigALNekcolo+hF6olphcIfI0SuR1zp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ELQDd5iYkzf6WkSto8SE2fODDQlXu//fURFMUMArdYXjoGEyjuX6XOnRqZRpHshbe
	 K3Ib4zp43o7EiDZsBulilY2eFrlZpfFkrG5aHn1oVIxwk6/Ke04H7oG/K4gCEBffsl
	 IvHiv1tNrGCer9sxzUG9qyRssqhGb55Kx66O8nns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 105/990] net: ipa: Fix double free of the interrupt structure on config error
Date: Wed, 25 Nov 2026 15:24:32 +0100
Message-ID: <20261125143824.549118733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



