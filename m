Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875411E892;
	Wed,  2 Oct 2024 14:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880387; cv=none; b=NKbBSgR+kR5UzeGBk/VudFsMNtZR1+XJVqZaYZFiE5mTc9SrkGx/cEKlpQNyJDTRMz3fVm+17rOoxgL9qcMRZnUI7m52lgJzRulYOt1gevsKTn9c0pMyVM4ig0enTgTQIEkmj8ZqIDxeeiG/FrnxD5oFIECwqdmg/ze5pFAxV14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880387; c=relaxed/simple;
	bh=3mmgyYLQd395U1kfO02TzOn1LIfzTUI0gEq4kQ421yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3iAmq8OEf2eft/5xe523Yorq448i89gWParVdYmDoGqS0r6FJp3K0zICETooKUWz6s4gSLs7wqxMqSWM9ocr7vTgWl/mANCMwi4bcQ7OtV1pUd7iQJc0yAk/0gvvO+Am9yK+15zBNUw01Bjmi7JodjzOLEyC1+liCz2GFnL8dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TnO+tBZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TnO+tBZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113D5C4CEC2;
	Wed,  2 Oct 2024 14:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880387;
	bh=3mmgyYLQd395U1kfO02TzOn1LIfzTUI0gEq4kQ421yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TnO+tBZBFxY1w539fW2MG7FPnJfle3F4PbH8hbaj7IvS2mEMIwREzzimMmRxRed8g
	 0rD+sBE3IHmcKpZGKXHLTHsVkzzcC6zDeOd4udbZ2LN8kH+16sx07LfQd1qhs1bVyj
	 c8JZL0N1d/FyqhwvWTHrrNz376ClqsdiFJD4vzKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.6 442/538] tty: rp2: Fix reset with non forgiving PCIe host bridges
Date: Wed,  2 Oct 2024 15:01:21 +0200
Message-ID: <20241002125809.887588386@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -578,8 +578,8 @@ static void rp2_reset_asic(struct rp2_ca
 	u32 clk_cfg;
 
 	writew(1, base + RP2_GLOBAL_CMD);
-	readw(base + RP2_GLOBAL_CMD);
 	msleep(100);
+	readw(base + RP2_GLOBAL_CMD);
 	writel(0, base + RP2_CLK_PRESCALER);
 
 	/* TDM clock configuration */


