Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18DE443E21;
	Mon, 17 Aug 2026 15:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980346; cv=none; b=dTPGyziY/UOfb2or86W95r6JdBNk6+QG+i9OdCJL5PmUuUx04ZFBhOaVu7V3r3XcZDBbh4CMDWuSZnPELh99FAGm35Hej8tsV460X8jihDh6Zo5bd1NRrK8LTLqhNk/8HCCyLZfJMGhTGJQI3bAwzg788H3kfBgcYq4LpLshpXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980346; c=relaxed/simple;
	bh=CQL4A9jwmMkTZUTvQzv8HEZmVpDVoOv5DZ3Mzcl0Jh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcp0FPt8b4r7Tp6EzbLB9ztTcR/QublJLDivDRKbaDpiuxp7i2WyGVEixSPnWqVVyfjy3ZCM4kraZFy32g78rMCOKNeJhFBxnprFyck5nLac2oazguj2LHVII9gQ2TUFtRWZntAILif32/MGknNsHmB9RN0w96Pnv3P6pQPFW6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvI9q+ZI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvI9q+ZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E591F000E9;
	Mon, 17 Aug 2026 15:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980345;
	bh=+3aOxMegBziBQX+DiZgY7mN7IJEEGvn0jtqGvlzsogw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kvI9q+ZIiD1ySVlYc/UqNSTg/9UsmXPjI18K6Q/DR5e1UD+Ysls3Fy6hjjwvP7YTY
	 YX0blfTbf8cPlyN2K+KV06zRi/QWANv8hRJYM0md1+IFcihawB5P+b2cpRO5SY6rdp
	 hAF+27lYz6BNR3FNIV4OErce79fItgofBWPay6V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	stable <stable@kernel.org>,
	Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 6.1 542/609] usb: cdnsp: fix incorrect endian conversions for APB timeout register
Date: Mon, 17 Aug 2026 15:33:58 +0200
Message-ID: <20260817132601.901942283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Laszczak <pawell@cadence.com>

commit 50b303f3d0f7de543ee90d50879970783d06da33 upstream.

readl() already returns a CPU-endian value. Passing its return value to
le32_to_cpu() is therefore redundant and causes an incorrect double byte
swap on big-endian systems.

Similarly, writel() expects a CPU-endian value, so passing the result of
cpu_to_le32() is incorrect.

Remove the unnecessary conversions and operate on the MMIO register value
as a CPU-endian u32.

Fixes: 241e2ce88e5a ("usb: cdnsp: Fix issue with resuming from L1")
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: stable <stable@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260720-endian-fix-v1-v1-1-b5681fa1ea9f@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -154,9 +154,9 @@ static void cdnsp_set_apb_timeout_value(
 	offset = cdnsp_find_next_ext_cap(base, offset, D_XEC_PRE_REGS_CAP);
 	reg = base + offset + REG_CHICKEN_BITS_3_OFFSET;
 
-	val  = le32_to_cpu(readl(reg));
+	val  = readl(reg);
 	val = CHICKEN_APB_TIMEOUT_SET(val, cdns->override_apb_timeout);
-	writel(cpu_to_le32(val), reg);
+	writel(val, reg);
 }
 
 static void cdnsp_set_chicken_bits_2(struct cdnsp_device *pdev, u32 bit)


