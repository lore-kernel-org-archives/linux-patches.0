Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057047;
	b=yRjen0DwBQ+L+sp52DiPolb0qR6ToDwxyH6w0IfJMLwNWxsZxNkf7x0/POCKqkn9VYbR
	 LgbpE2wgvnFYZL0YKAG3sH39AAf6D9dXz/cBwy1a4Pb40+t2lwI6iGweH7KVvP9qQnVXQ
	 XL738x0qGDHq28yZ2cLyLpa2QtimcbRqw/21wOW5NiFFy/bL84PLtDbrtNJvtpZ7F3f6i
	 of2ur97vfIWNOsIJLr5a0KZXAD3uUm4STwtL4js0PCewOMM40pfdca7N85aj1T/UIb5b1
	 SB0AexYz6OTvL/CB1yhyTJUZItYRnDpBDdJV0QRYlIUbDV5fRuOnRtEe/9HEB2ovBiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Equxzl6O+Tvm6EXpqrChvlTJICbjOqSo08uwlwf43r4=;
	b=TeZBvi9KDfOY1fCShhcmDQWNeytuudfnd21EJdkwpk+nJWleC0IW6zlSn9cpgjEphmTj
	 axuqQpN9eGF+OL0bQRTl76BXkEXAQBXklzKbR3ueY/g+TC/kG8t2dsUMySKZtciN2w3/x
	 5GDe9h1qnyCbZx0DxFAT5d7fXuyHFqsrlmcuMMVotUIg/Ew4zZic3wZ1J01VstrvRbeDs
	 sabq6I/Rte9RM5ul+BEWH6U8Q8XnEaYssaWlGKugb8xfFyxDC0E+N8yHF3ctK/yKixjGz
	 FycAex2nU8Ev2usDi80hVRontC14Hx1BaybUdyMmJxnseUbA2fsVQjY+O9Q7/EYQpNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1eVSURmx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3ECB606A31C;
	Thu, 19 Nov 2026 02:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1eVSURmx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330381F000C4;
	Thu, 19 Nov 2026 02:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057047;
	bh=Equxzl6O+Tvm6EXpqrChvlTJICbjOqSo08uwlwf43r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1eVSURmxq1WmCbuAhEqLGxedvvRk9+osSIFDFfdUVQdFQLrnLcz5eeUylgWVjY1uw
	 1ucG24EnvNuG09VJjR42BGdUHjMy2Vrq+y2sE6kk5F2inb9SeGH/qiVK/xylzkw+62
	 ZG3Uxsl5TtFt2PP3o36nOci3Z9N28n8xjsdMHEW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 5.15 2204/2214] irqchip/gic-v3-its: Restore quirk probing for ACPI-based systems
Date: Wed, 18 Nov 2026 16:04:40 +0100
Message-ID: <20261118150138.447314530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Marc Zyngier <maz@kernel.org>

commit 8b02da04ad978827e5ccd675acf170198f747a7a upstream.

While refactoring the way the ITSs are probed, the handling of quirks
applicable to ACPI-based platforms was lost. As a result, systems such as
HIP07 lose their GICv4 functionnality, and some other may even fail to
boot, unless they are configured to boot with DT.

Move the enabling of quirks into its_probe_one(), making it common to all
firmware implementations.

Fixes: 9585a495ac93 ("irqchip/gic-v3-its: Split allocation from initialisation of its_node")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240213101206.2137483-3-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5137,6 +5137,8 @@ static int __init its_probe_one(struct i
 	u32 ctlr;
 	int err;
 
+	its_enable_quirks(its);
+
 	if (is_v4(its)) {
 		if (!(its->typer & GITS_TYPER_VMOVP)) {
 			err = its_compute_its_list_map(its);
@@ -5476,7 +5478,6 @@ static int __init its_of_probe(struct de
 		if (!its)
 			return -ENOMEM;
 
-		its_enable_quirks(its);
 		err = its_probe_one(its);
 		if (err)  {
 			its_node_destroy(its);


