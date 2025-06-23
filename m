Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0243719049B;
	Mon, 23 Jun 2025 21:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715465; cv=none; b=N3z+PeAKYsExNQwmEk0z9pBaExelAoRGCgUbTsnExdlkj5IkD6DBrkUasBWRZxLgAEF08yukQ+hHtQ08yoDT2Ib0P6KIFFXiim9hHHHfFE18cOt9kVxgJ014SUU0OQ/hxEw+EgXDc9QpxXoQhCyc4XpkRTOxyIgae+h7ClQEmOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715465; c=relaxed/simple;
	bh=n0rv/3GPQlrmTW4QXYlFI+bPrQHiN9SGUTtQEnnen+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlqI8ikWm7axuMVGUsNQHlgmmRD5ebYw7J2NfVVeXMiXHuUTpCGiKNVSzMW+sMWxpMPTaIkF7rsyKhEhGSt7mNouG5GA7pgJeixEjS4rRNsEiQYkkcpfZZJW5kJ1TLPk7e7zBe+foSxAE08m24nsU5sI5TU52UmTyyCEDbxwF0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZEHqJyA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZEHqJyA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3EAC4CEEA;
	Mon, 23 Jun 2025 21:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715464;
	bh=n0rv/3GPQlrmTW4QXYlFI+bPrQHiN9SGUTtQEnnen+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZEHqJyAooYHJ0hWoEjZHHu34BUSJowQaNrL+bGmRPOEE2ALserJD6Srv+4BtxCvC
	 ihhjEO5ZAgx9kCmHJdP+d68shn8RSYho+cmUc3mtKaGfn8/itu0OgZ97l4p7pPMzrj
	 taIOq689IYmO+yk6sNHNYc0rR1yOfwV+iZn2FoOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/414] platform-msi: Add msi_remove_device_irq_domain() in platform_device_msi_free_irqs_all()
Date: Mon, 23 Jun 2025 15:05:21 +0200
Message-ID: <20250623130646.622077415@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 9a958e1fd40d6fae8c66385687a00ebd9575a7d2 ]

platform_device_msi_init_and_alloc_irqs() performs two tasks: allocating
the MSI domain for a platform device, and allocate a number of MSIs in that
domain.

platform_device_msi_free_irqs_all() only frees the MSIs, and leaves the MSI
domain alive.

Given that platform_device_msi_init_and_alloc_irqs() is the sole tool a
platform device has to allocate platform MSIs, it makes sense for
platform_device_msi_free_irqs_all() to teardown the MSI domain at the same
time as the MSIs.

This avoids warnings and unexpected behaviours when a driver repeatedly
allocates and frees MSIs.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/all/20250414-ep-msi-v18-1-f69b49917464@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform-msi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
index 0e60dd650b5e0..70db08f3ac6fa 100644
--- a/drivers/base/platform-msi.c
+++ b/drivers/base/platform-msi.c
@@ -95,5 +95,6 @@ EXPORT_SYMBOL_GPL(platform_device_msi_init_and_alloc_irqs);
 void platform_device_msi_free_irqs_all(struct device *dev)
 {
 	msi_domain_free_irqs_all(dev, MSI_DEFAULT_DOMAIN);
+	msi_remove_device_irq_domain(dev, MSI_DEFAULT_DOMAIN);
 }
 EXPORT_SYMBOL_GPL(platform_device_msi_free_irqs_all);
-- 
2.39.5



