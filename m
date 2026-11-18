Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060374;
	b=gySA0bKTqlvkatEDzM290bOTOyG81eWcXrhSF0ogKw7cmh5FQ/PwW0MmffVqaSQ3fwlc
	 lHe0ewXZmj6EjsD2nxBzRFyTWoBkwyK/YoEobIiLvcrwuKLDq+aBoio97EvTiU1//QwWu
	 qg1cI/C6rYcLK/D6UCaPfdTGzlZT3OFT0O7U7jeKK/s5HKRTYb35tqCL/lsrDXtpkW8Tf
	 ZVz5FLsIAkdkXBJbq/gtJf/2Ws3YjsT6SOXmIc/WmDRIzWG9HXkGcqdJt4pSKMnD6q5lH
	 i163xYau8FXev5ZxM3zX0k5BFljcLrpkvQZtfz3kvdpCol1xvF5DqcsGWhgSgUtO7ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=meM9OV5Vk7maiLjg2qlzan0xpeuA5o0fN6meyoryiVk=;
	b=psk902S+OvA21cv2eFFor7mOIBFCiKdwhtSF+f9mKcJqmYSqpuOm2wYbwGWPNTVrstxz
	 FNJYkx84XveVBsnbEyjyss7Rsioed7DjrMh0J2VWgnXfIPY1GXAQ5bUCq8cNqWZ0Pt6KH
	 fUMLihPVLt0EcYZD8VJiOCZwacRieUsf/oHL2eotOqXxsf1ViF62gYD4EgY5CzLyK6K6y
	 kd7AaBGLByihN1foEHqHrw6uPDliwO0ByoGm9G0zNenXduhO3vOsNMB5puxh21t567lke
	 yosfblDT69UZxjGf7ZMYqMkxZiSQ3DnL4OQHXleSxyxlwY7YnoQkig6/0ESn/3Mpehg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ln7uyeFN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BEE4606A334;
	Thu, 19 Nov 2026 03:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ln7uyeFN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37361F000C6;
	Thu, 19 Nov 2026 03:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060374;
	bh=meM9OV5Vk7maiLjg2qlzan0xpeuA5o0fN6meyoryiVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ln7uyeFNtFQDR9Y5R3EhfDNA+raG2Mg23fHmMn8OnkETLOhsui01zoTTzy6ro4OJq
	 pC3ew4PcAZr5yF9x+NxewUWYiGhopv35K+8UkA4vJwXMK852eqS1eNCYAsbtNX8DF0
	 CcgKj0UoW6VKKvdwUpn+3/Yjcc89EQ6Njjsn7fRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1176/1848] irqchip/gic-v3: Switch to bitmap_zalloc()
Date: Wed, 18 Nov 2026 15:53:34 +0100
Message-ID: <20261118150008.821367247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit ff5fe8867a5feaf90b1cb9b766f3de3a1caf9f33 ]

Switch to bitmap_zalloc() to show clearly what we are allocating.
Besides that it returns pointer of bitmap type instead of opaque void *.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210618151657.65305-4-andriy.shevchenko@linux.intel.com
Stable-dep-of: 135d9e67f7ab ("irqchip/gic-v3-its: Don't WARN on LPI free allocation failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 6 +++---
 drivers/irqchip/irq-gic-v3-mbi.c | 5 ++---
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index cd165d8d0c0d5..5094ef561bd2c 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2166,7 +2166,7 @@ static unsigned long *its_lpi_alloc(int nr_irqs, u32 *base, int *nr_ids)
 	if (err)
 		goto out;
 
-	bitmap = kcalloc(BITS_TO_LONGS(nr_irqs), sizeof (long), GFP_ATOMIC);
+	bitmap = bitmap_zalloc(nr_irqs, GFP_ATOMIC);
 	if (!bitmap)
 		goto out;
 
@@ -2182,7 +2182,7 @@ static unsigned long *its_lpi_alloc(int nr_irqs, u32 *base, int *nr_ids)
 static void its_lpi_free(unsigned long *bitmap, u32 base, u32 nr_ids)
 {
 	WARN_ON(free_lpi_range(base, nr_ids));
-	kfree(bitmap);
+	bitmap_free(bitmap);
 }
 
 static void gic_reset_prop_table(void *va)
@@ -3417,7 +3417,7 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	if (!dev || !itt ||  !col_map || (!lpi_map && alloc_lpis)) {
 		kfree(dev);
 		kfree(itt);
-		kfree(lpi_map);
+		bitmap_free(lpi_map);
 		kfree(col_map);
 		return NULL;
 	}
diff --git a/drivers/irqchip/irq-gic-v3-mbi.c b/drivers/irqchip/irq-gic-v3-mbi.c
index e81e89a81cb5b..b84c9c2eccdc0 100644
--- a/drivers/irqchip/irq-gic-v3-mbi.c
+++ b/drivers/irqchip/irq-gic-v3-mbi.c
@@ -290,8 +290,7 @@ int __init mbi_init(struct fwnode_handle *fwnode, struct irq_domain *parent)
 		if (ret)
 			goto err_free_mbi;
 
-		mbi_ranges[n].bm = kcalloc(BITS_TO_LONGS(mbi_ranges[n].nr_spis),
-					   sizeof(long), GFP_KERNEL);
+		mbi_ranges[n].bm = bitmap_zalloc(mbi_ranges[n].nr_spis, GFP_KERNEL);
 		if (!mbi_ranges[n].bm) {
 			ret = -ENOMEM;
 			goto err_free_mbi;
@@ -329,7 +328,7 @@ int __init mbi_init(struct fwnode_handle *fwnode, struct irq_domain *parent)
 err_free_mbi:
 	if (mbi_ranges) {
 		for (n = 0; n < mbi_range_nr; n++)
-			kfree(mbi_ranges[n].bm);
+			bitmap_free(mbi_ranges[n].bm);
 		kfree(mbi_ranges);
 	}
 
-- 
2.53.0



