Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD631DFDB3;
	Wed,  6 Nov 2024 13:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898168; cv=none; b=C00//KjHFRx0e5aSovas/SKEkv6i8DvmaDjFiSF26KvHo7aaWYwuZ7LQD0XxkyWoR3TMeCXGYHkC74+ZsY2vd2aThuWd9bZOArRg4uM0EX8pHyMMJNxVe7WI64IOPpT6ZGJRXX/5E2b7LwvhNph6YO/LCZ8bEwfpPrvPaXn0AWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898168; c=relaxed/simple;
	bh=Xr0oogi400ciQc6EJ0kfcMAukdSHUTpkY5lcBa/2kMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JeCwi0GXIDIQ26B3QCtiuZQ+Zjr3GZlfRO1LW7kUrP6Dxw+/ZXSsheUJDl4qMeMqHolw1eMSbDY09Xvw1LLzThlPWQJQlKlsThtqlWxJqU5VxHXJwEnjFfJCXb1ILmwUx6Fq++3lImStlb7owUBA53b4qM2lpTAjZJnYYP2Wtvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7nuDmQ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7nuDmQ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC96DC4CECD;
	Wed,  6 Nov 2024 13:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898168;
	bh=Xr0oogi400ciQc6EJ0kfcMAukdSHUTpkY5lcBa/2kMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7nuDmQ93tSJiwjRSNQx2tO+7Giw5aYbf3BVFTMwYAsnEZfTEpGuvky3LuYUh5T9O
	 HKrSRY2hHPhBACYmbcEltV82AAkX/A2XT46XduKOpIEs1IBMT3pR8vFm3kLyMd+vMz
	 Rild2SSRQQX5r54PIBq41Zqi3csPaB6qiFWSeJV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 5.4 146/462] tty: rp2: Fix reset with non forgiving PCIe host bridges
Date: Wed,  6 Nov 2024 13:00:39 +0100
Message-ID: <20241106120335.118346236@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -600,8 +600,8 @@ static void rp2_reset_asic(struct rp2_ca
 	u32 clk_cfg;
 
 	writew(1, base + RP2_GLOBAL_CMD);
-	readw(base + RP2_GLOBAL_CMD);
 	msleep(100);
+	readw(base + RP2_GLOBAL_CMD);
 	writel(0, base + RP2_CLK_PRESCALER);
 
 	/* TDM clock configuration */


