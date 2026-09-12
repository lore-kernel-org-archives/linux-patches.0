Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08553288B2;
	Sat, 12 Sep 2026 10:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208941; cv=none; b=Pch40vlrDjPRdhb+CJwBWrPvJ2DZsxolmM11tFNBm6Q8UOe3zcGAzEen6FP3jgxs/mEoKW2TfC639rMTu2CppzZQuZksOOBFaAR4Z9SRh6h6m9EYXShVO5SXKBmhF3F0vj+u0z3FBxnWCeAQT84TO5Qlsxn7z/gvcKi9aupzY8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208941; c=relaxed/simple;
	bh=cLLxAB2SRRQ9OieLA6UtwhUvxImYYgYB88dRs73ss6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d42APtg44PkeRF48c13/J9wIpTHyhe6JOPADsdKrJ9M1wAIe2bzLHtg6lf5tM9a+IXhgz/KehRDYDKnPBTpUIxooDxBKCM03ueKpYpCKhbkvDvW0DHus3wMFJ5VjgJMwAEGCbsRjrNvkleZ33Q4g+jJz2+RRz/hjuUkyA8Lmz9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCWrVZvR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCWrVZvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDCD21F00893;
	Sat, 12 Sep 2026 10:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208939;
	bh=v2lIKqI2ovzhn44r8CtYn8x/txrkrl7F/GMs8p/8l6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bCWrVZvRq9kwZzArNXSeAv4XLg8AJvyKvQ+uTcMQ+YaNiFvAgT0H0V3AEQ7xD81ds
	 o7vUxBCg+Bl0vk2dCYkFzxzzl2ttqsMVcNP1wqQ16LrvQqHuKSy4ymzzT5RWf1SUYa
	 BZw0B3Tkcd1x4/frTBSjFxzBFXG9KGv0um1JjOHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0719/1518] powerpc: implement get_direction() in cpm2
Date: Sat, 12 Sep 2026 08:48:08 +0200
Message-ID: <20260912065639.699797108@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

[ Upstream commit ca16219e9babc874349a6ac307d56523871a9137 ]

The lack of get_direction() callback in this driver causes GPIOLIB to
emit a warning. Implement it.

Fixes: e623c4303ed1 ("gpiolib: sanitize the return value of gpio_chip::get_direction()")
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/c6eb70aa0e1ba6e15f947c827006aa79edace05c.1785318836.git.chleroy@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/cpm_common.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/powerpc/sysdev/cpm_common.c b/arch/powerpc/sysdev/cpm_common.c
index 07ea605ab0e62..b5d200e3ad684 100644
--- a/arch/powerpc/sysdev/cpm_common.c
+++ b/arch/powerpc/sysdev/cpm_common.c
@@ -181,6 +181,18 @@ static int cpm2_gpio32_dir_in(struct gpio_chip *gc, unsigned int gpio)
 	return 0;
 }
 
+static int cpm2_gpio32_get_direction(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct cpm2_gpio32_chip *cpm2_gc = gpiochip_get_data(gc);
+	struct cpm2_ioports __iomem *iop = cpm2_gc->regs;
+	u32 pin_mask = 1 << (31 - gpio);
+
+	if (in_be32(&iop->dir) & pin_mask)
+		return GPIO_LINE_DIRECTION_OUT;
+
+	return GPIO_LINE_DIRECTION_IN;
+}
+
 int cpm2_gpiochip_add32(struct device *dev)
 {
 	struct device_node *np = dev->of_node;
@@ -199,6 +211,7 @@ int cpm2_gpiochip_add32(struct device *dev)
 	gc->ngpio = 32;
 	gc->direction_input = cpm2_gpio32_dir_in;
 	gc->direction_output = cpm2_gpio32_dir_out;
+	gc->get_direction = cpm2_gpio32_get_direction;
 	gc->get = cpm2_gpio32_get;
 	gc->set = cpm2_gpio32_set;
 	gc->parent = dev;
-- 
2.53.0



