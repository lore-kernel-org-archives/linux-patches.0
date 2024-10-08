Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019211D618C;
	Tue,  8 Oct 2024 12:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390588; cv=none; b=NGUbknO9FUXPWTu4xJU2nkMZWf/zoKQAPuV+j2IyhbDEjkS/gdbdnTeBJygrkh7lN8dsV5GlWu+ZdF1d6/ZZd0OnqO+amYr/k5WRPmDjLe7Ouv7TICLscKgw6Q8hHVPGeDj6BAJxZzbQ51DV9HEZk8AIym92oOaHBWcgcMrV+uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390588; c=relaxed/simple;
	bh=18qIb6kOREnzLX8N+HsoQ/MGFOVuwSaDoy76z155KZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtDLqXtmNCLinIJf363ft3zW7TCH9qR7+CAPNLO0702HnH4ZMiYN2/+Boz+GT3u/jJiksIKMO2u/3hdnVwmZ9SysiT3e9tViTKxT/i1+sbiDR5j7XJl99PXdCQQ41k74pa1oYyOjLP8PIG7B0huNVrQff0W+C8IDgGrmZV0NJ8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CaG5x9sW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CaG5x9sW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C2BC4CEC7;
	Tue,  8 Oct 2024 12:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390587;
	bh=18qIb6kOREnzLX8N+HsoQ/MGFOVuwSaDoy76z155KZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CaG5x9sWuOa6teuvLrqejBQ8/AcWoXhEpzoPYfw0dmqPx5rxnf//fosJ8eUDwmE86
	 0piouY1kmCstDjEj50dj5rd43IQppCc+bjX941rc5Gwmc2yv52pJhnJZXT7Aj/4VLX
	 9X8OV+SU2Jj8tQDWbj0j4TxDYXXL7q4F7Ds6F8GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.10 299/482] i2c: synquacer: Deal with optional PCLK correctly
Date: Tue,  8 Oct 2024 14:06:02 +0200
Message-ID: <20241008115700.050476425@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit f2990f8630531a99cad4dc5c44cb2a11ded42492 upstream.

ACPI boot does not provide clocks and regulators, but instead, provides
the PCLK rate directly, and enables the clock in firmware. So deal
gracefully with this.

Fixes: 55750148e559 ("i2c: synquacer: Fix an error handling path in synquacer_i2c_probe()")
Cc: stable@vger.kernel.org # v6.10+
Cc: Andi Shyti <andi.shyti@kernel.org>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-synquacer.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-synquacer.c
+++ b/drivers/i2c/busses/i2c-synquacer.c
@@ -550,12 +550,13 @@ static int synquacer_i2c_probe(struct pl
 	device_property_read_u32(&pdev->dev, "socionext,pclk-rate",
 				 &i2c->pclkrate);
 
-	pclk = devm_clk_get_enabled(&pdev->dev, "pclk");
+	pclk = devm_clk_get_optional_enabled(&pdev->dev, "pclk");
 	if (IS_ERR(pclk))
 		return dev_err_probe(&pdev->dev, PTR_ERR(pclk),
 				     "failed to get and enable clock\n");
 
-	i2c->pclkrate = clk_get_rate(pclk);
+	if (pclk)
+		i2c->pclkrate = clk_get_rate(pclk);
 
 	if (i2c->pclkrate < SYNQUACER_I2C_MIN_CLK_RATE ||
 	    i2c->pclkrate > SYNQUACER_I2C_MAX_CLK_RATE)


