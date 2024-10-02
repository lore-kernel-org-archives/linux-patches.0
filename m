Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EF51D0E18;
	Wed,  2 Oct 2024 14:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878782; cv=none; b=QmzXYcCLj3s8L5uxyAv+f+RD8uhWh6Go7xFI7+RCj5+CnRqLloZMmCvBSbV5f/DbfsPLGX26sg3ZN9KMm1Faw8oqtlHyPhS3wel74fddGL0nRf/Al9iRia5QXvdipvLTQNbRZHTpS/wrTs+/OG4ON9xMZCIHLRvKEUQcnVmSEow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878782; c=relaxed/simple;
	bh=kU2QIW1iOCsfPNiBXP5y7DAw+YEBJefEN/qRDT6bPmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjFKB/DRJX51l2vRZaCfZNYqrlSvefKSLUT3IY46e/LtOly4ODrukj/KJr+LZ6ZmdC7Px2BlGYOKbm8/y5blQhrn6GtqDEC4O1+QGa6g0UOeXuLF+3pKYyU7918e+kZGy78noNiH/zChYpt2XyOP8oC4TeBTzF8lsn79FI8Fk5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2Vw9tGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2Vw9tGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00995C4CEC2;
	Wed,  2 Oct 2024 14:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878782;
	bh=kU2QIW1iOCsfPNiBXP5y7DAw+YEBJefEN/qRDT6bPmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2Vw9tGOOafsT0lHfDYAjxiH7rG5W8gtPvdS9wCGB61fdiZuSubHNc+1gxpAzT4T9
	 Fidde5XPOZE1N+AdWoehpfiix6pPgHy5SzJs0EVYhLm0FC0ByNcgJXhw1Ur9+FJeQS
	 85sx6yRaZBoHLZrRQA32d/5R0nfYx/moDoD6RvGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.10 530/634] tty: rp2: Fix reset with non forgiving PCIe host bridges
Date: Wed,  2 Oct 2024 15:00:30 +0200
Message-ID: <20241002125832.026496346@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

commit f16dd10ba342c429b1e36ada545fb36d4d1f0e63 upstream.

The write to RP2_GLOBAL_CMD followed by an immediate read of
RP2_GLOBAL_CMD in rp2_reset_asic() is intented to flush out the write,
however by then the device is already in reset and cannot respond to a
memory cycle access.

On platforms such as the Raspberry Pi 4 and others using the
pcie-brcmstb.c driver, any memory access to a device that cannot respond
is met with a fatal system error, rather than being substituted with all
1s as is usually the case on PC platforms.

Swapping the delay and the read ensures that the device has finished
resetting before we attempt to read from it.

Fixes: 7d9f49afa451 ("serial: rp2: New driver for Comtrol RocketPort 2 cards")
Cc: stable <stable@kernel.org>
Suggested-by: Jim Quinlan <james.quinlan@broadcom.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20240906225435.707837-1-florian.fainelli@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/rp2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/rp2.c
+++ b/drivers/tty/serial/rp2.c
@@ -577,8 +577,8 @@ static void rp2_reset_asic(struct rp2_ca
 	u32 clk_cfg;
 
 	writew(1, base + RP2_GLOBAL_CMD);
-	readw(base + RP2_GLOBAL_CMD);
 	msleep(100);
+	readw(base + RP2_GLOBAL_CMD);
 	writel(0, base + RP2_CLK_PRESCALER);
 
 	/* TDM clock configuration */


