Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8122054EF;
	Thu, 12 Dec 2024 16:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020777; cv=none; b=NCN7t1+30YlKed+QUv8+OULfi/uc1ASYQAm8m+ZRz2lRy2N113c5UPeeAw9j/uKQ0LEsgVEwbjYD8yoINrg9z1usRsY+/Db5VejYzzWI+sUgKSzOIG0AzKoYDpwMwTW3jlSbFewy99clX7sS/Rgkyz4UTbQa/X74HJLhu0PTf5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020777; c=relaxed/simple;
	bh=hMUdtS87Az8Kl18gdcQA/+ykVRj8FzOVPlwYtIItJQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLkSNdgkafRbMowG8mQusHuJy8Z8CTY+rFP7NvqhT4DbzzfD/iDd51VdpSdzWpJ45Q0OFPrBGxPiDllIW/1ujuuZwLw7tMk8xFiRQoP7PR0VWRagTJOn30ekxLO/2gIZP0bI+bGjLXj9AmlUEn6jmipGzQPzvIBWn7brVUpL51I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qbypnezw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qbypnezw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18454C4CED0;
	Thu, 12 Dec 2024 16:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020777;
	bh=hMUdtS87Az8Kl18gdcQA/+ykVRj8FzOVPlwYtIItJQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbypnezwhloeAsHEoBLGmQ7EPlM+iuTvUO/zTIf+oL+ca0ha3f0I+vh9+ldXB/rDn
	 32DpCoNLLC4wO4LH9P1nbcp/Q67rsxLXa7j1PBwknFel5DwVYOqA0CYb6vfm3eDdHH
	 NObYOCNaCDFuGFjXKSJCXDgilH/x93KBK+ru3t8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 550/772] gpio: grgpio: Add NULL check in grgpio_probe
Date: Thu, 12 Dec 2024 15:58:15 +0100
Message-ID: <20241212144412.688340373@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 050b23d081da0f29474de043e9538c1f7a351b3b ]

devm_kasprintf() can return a NULL pointer on failure,but this
returned value in grgpio_probe is not checked.
Add NULL check in grgpio_probe, to handle kernel NULL
pointer dereference error.

Cc: stable@vger.kernel.org
Fixes: 7eb6ce2f2723 ("gpio: Convert to using %pOF instead of full_name")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/r/20241114091822.78199-1-hanchunchao@inspur.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-grgpio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-grgpio.c b/drivers/gpio/gpio-grgpio.c
index 56b6808c3e4a9..b7a9e5edd566f 100644
--- a/drivers/gpio/gpio-grgpio.c
+++ b/drivers/gpio/gpio-grgpio.c
@@ -362,6 +362,9 @@ static int grgpio_probe(struct platform_device *ofdev)
 	gc->owner = THIS_MODULE;
 	gc->to_irq = grgpio_to_irq;
 	gc->label = devm_kasprintf(dev, GFP_KERNEL, "%pOF", np);
+	if (!gc->label)
+		return -ENOMEM;
+
 	gc->base = -1;
 
 	err = of_property_read_u32(np, "nbits", &prop);
-- 
2.43.0



