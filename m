Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8381BDC3;
	Mon, 14 Oct 2024 15:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918413; cv=none; b=NctyiuJjlLj9S3/p0YrJF8zBi+/0Q/D5Y/QP9HwXzILlhhK+9Dg2KmolxbdL+KKDN84f75nO2ZoyFi4WVI/Iy2kF4U7h5qNCmEMCZP4dBV8+wBDpT7qnflE1dUy4+s6wjKw6GDFlil7wUGaBnsbie0d8jsNMh5b0NeqdeJu2EG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918413; c=relaxed/simple;
	bh=ikN5xmuyREPVnl74fjmvzkVfLgstvg6dyOkTQw+y+Mg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ex+Z8Uj90lH+6jhnXQDPhjaXQvwN1Zwn8cLqypP/CUFD6X3NsNO9nGpIsVC5UTuEPUti9fyQF9Qns9lEdj08jq+yiTaJ7D8+ZtB1AB0IfFpn2mlcy756F+b7eJYLbXIaBYMKkKtMiQGXJu9J6oN+ha2/POchGUCq8sbk4eIDyP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=woYg8Zfh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="woYg8Zfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699C4C4CEC7;
	Mon, 14 Oct 2024 15:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918412;
	bh=ikN5xmuyREPVnl74fjmvzkVfLgstvg6dyOkTQw+y+Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=woYg8ZfhoeueUTONdRtpMaZWSZzs7XDg2DGhVt//CJJ5hxdSZSw/0zhAECwcMMP5r
	 kPyF9XJz7VTZa3ZUb32+3Qx7lQejtRq2vTDnQR0rzGHRyBtKv87E/hnd54eQ+C+HV8
	 FqenzfpsUyed5wVxq1i/BemCA3+ZQc2PXUB/157M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 6.1 315/798] tty: rp2: Fix reset with non forgiving PCIe host bridges
Date: Mon, 14 Oct 2024 16:14:29 +0200
Message-ID: <20241014141230.325561504@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
@@ -597,8 +597,8 @@ static void rp2_reset_asic(struct rp2_ca
 	u32 clk_cfg;
 
 	writew(1, base + RP2_GLOBAL_CMD);
-	readw(base + RP2_GLOBAL_CMD);
 	msleep(100);
+	readw(base + RP2_GLOBAL_CMD);
 	writel(0, base + RP2_CLK_PRESCALER);
 
 	/* TDM clock configuration */


