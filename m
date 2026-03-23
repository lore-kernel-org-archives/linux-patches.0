Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1604F2C181;
	Mon, 23 Mar 2026 14:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275691; cv=none; b=NQlsLNBTtEJZNXKmtKLuVg3VIDvHklMXvZwylFOuWV8UDe3pYnPhEOJOfp5Tsxm7q1Fg7++r5OpGPug/4uSqatOjH3s0rp6ArVWRVBKDgO/At33nmFqKPHqIarNpqBkCAqrMi4vdftnn97+C054DUgWXCGgXN78WitXD8iDW2NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275691; c=relaxed/simple;
	bh=xmXccoLUHRb96XMtXe8+ONaj0ApHLFzK5XXS1F8ZiVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLjG7nqdiOfMatPmVwKLvmUta7y8IkbNSchTFTExL041KnfiojqYffDZnMXiV9mLMNYrBhIpFjwceZs+aDcrSB6TZrRZGJERbju+aRrIJIoMvB2LoiDlqCjCksX4T8eOZOP+MsFfLKjWCEDINzGDDYEGIdEJY3GYZZ1ZRlRgcH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8n2OLVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8n2OLVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DADDC4CEF7;
	Mon, 23 Mar 2026 14:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275691;
	bh=xmXccoLUHRb96XMtXe8+ONaj0ApHLFzK5XXS1F8ZiVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8n2OLVZo0yHNuJrBIXBoqL8p6/RkhvhQsb19CsH9eJ0NamvNHPhbQbHcDFvOx2my
	 CZ22X69T/NSw2SHET6fa8DVYizv9f7RMOCWM2p5FB6tmnnirzjDWnodVD43OOR41Lo
	 IBSbocwwnVdquME5SOFky/6RrI5leOW1qxu8huJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH 6.12 148/460] irqchip/gic-v3-its: Limit number of per-device MSIs to the range the ITS supports
Date: Mon, 23 Mar 2026 14:42:24 +0100
Message-ID: <20260323134530.215940404@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit ce9e40a9a5e5cff0b1b0d2fa582b3d71a8ce68e8 upstream.

The ITS driver blindly assumes that EventIDs are in abundant supply, to the
point where it never checks how many the hardware actually supports.

It turns out that some pretty esoteric integrations make it so that only a
few bits are available, all the way down to a single bit.

Enforce the advertised limitation at the point of allocating the device
structure, and hope that the endpoint driver can deal with such limitation.

Fixes: 84a6a2e7fc18d ("irqchip: GICv3: ITS: device allocation and configuration")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260206154816.3582887-1-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c   |    4 ++++
 include/linux/irqchip/arm-gic-v3.h |    1 +
 2 files changed, 5 insertions(+)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3393,6 +3393,7 @@ static struct its_device *its_create_dev
 	int lpi_base;
 	int nr_lpis;
 	int nr_ites;
+	int id_bits;
 	int sz;
 
 	if (!its_alloc_device_table(its, dev_id))
@@ -3405,7 +3406,10 @@ static struct its_device *its_create_dev
 	/*
 	 * Even if the device wants a single LPI, the ITT must be
 	 * sized as a power of two (and you need at least one bit...).
+	 * Also honor the ITS's own EID limit.
 	 */
+	id_bits = FIELD_GET(GITS_TYPER_IDBITS, its->typer) + 1;
+	nvecs = min_t(unsigned int, nvecs, BIT(id_bits));
 	nr_ites = max(2, nvecs);
 	sz = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1);
 	sz = max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -394,6 +394,7 @@
 #define GITS_TYPER_VLPIS		(1UL << 1)
 #define GITS_TYPER_ITT_ENTRY_SIZE_SHIFT	4
 #define GITS_TYPER_ITT_ENTRY_SIZE	GENMASK_ULL(7, 4)
+#define GITS_TYPER_IDBITS		GENMASK_ULL(12, 8)
 #define GITS_TYPER_IDBITS_SHIFT		8
 #define GITS_TYPER_DEVBITS_SHIFT	13
 #define GITS_TYPER_DEVBITS		GENMASK_ULL(17, 13)


