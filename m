Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299AF19B3FF;
	Tue, 15 Oct 2024 11:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993149; cv=none; b=JjYIiiQuF+F44j0acR4DAyemPdg2BYgjSV8Gy3jv+Mb7ZZDusVMzXooi7CnejNOIkHQUP0gFeFyluUSU/j4o8nBZ0CfV/d0iFml/oX4GioF1KHPgxM2DSv8LgJTPpG0eHq/JOMrw7/A8W/gWEQqalgV7yze95GEYHtP4lIRhn1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993149; c=relaxed/simple;
	bh=7WEYYDXNZgW6dUKnRlluzZsS6vj9JlaKSAqUXVB57a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qktCvTPuigvwOB0nFUV/ufgblmcf2ybkTKJgA4kPIEMOBe2IIwyFMuL8DxpoMNiboqUTBIrRXQxeZwE7vIqWBtK8BaaWlR87J2WQ5COB0BigwNHDACR9Q3RvODHw/LMq6x6qb91lmERXZ7h2bh2lFkpi1oYeXNB1sauL8N6c0+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nHNx8A8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nHNx8A8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8989C4CECE;
	Tue, 15 Oct 2024 11:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993149;
	bh=7WEYYDXNZgW6dUKnRlluzZsS6vj9JlaKSAqUXVB57a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHNx8A8c0kpgPfOOqm2fPuRzQIIqIcTH3XrHxiKwZuubEvuEKI2yMiLHn2jxWJBSO
	 DyunA8xbE2xOIn8yYoUVrAkp/lg6ir7blkvoUtK27Mz0zHPPQUom7ml/M/c4rKYjXA
	 Xj1fCGzoO5/K4CWdCDFF+BOwAreKa8xyvrftIhT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 5.15 326/691] tty: rp2: Fix reset with non forgiving PCIe host bridges
Date: Tue, 15 Oct 2024 13:24:34 +0200
Message-ID: <20241015112453.275962159@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -598,8 +598,8 @@ static void rp2_reset_asic(struct rp2_ca
 	u32 clk_cfg;
 
 	writew(1, base + RP2_GLOBAL_CMD);
-	readw(base + RP2_GLOBAL_CMD);
 	msleep(100);
+	readw(base + RP2_GLOBAL_CMD);
 	writel(0, base + RP2_CLK_PRESCALER);
 
 	/* TDM clock configuration */


