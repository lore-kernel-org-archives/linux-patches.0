Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB301C07E5;
	Tue, 15 Oct 2024 13:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997600; cv=none; b=seEuIg6GxFNE8jr3mqNt+qx54fIbH66FAaCMFuTH4VkDh/XSm1aZCWvqOIXFUy2HQnYDEqZlVwL/GIZo3DquVssMNPijqIXdeMs2jh0vpc+ea2pHWlFKqUxKmh5JQXc8bk6m11taxPB+/RE9N0SfNZRyDDjegLynSGRqhbvCaLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997600; c=relaxed/simple;
	bh=JnZjIGxXq7K2t7qWNGz/U/jko6URe2oU/EGUGoJ9YHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHn5HmonURAlLQTHoGtFGH1/+mvwIfBPvwOF9W0/7Ul2tppC1WEv3sE89P6ok4A5ZKDQqLy24F9riQHkeUy0Rym1+1zsf3KEg6mcuq596WE6DjMo4jYqmrYlsSEggHGNk7I8HZsvwEcGUeB7OJSOk9YZJFC3c0hvQPDyGL8sPeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kni0tLTl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kni0tLTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A84C4CEC6;
	Tue, 15 Oct 2024 13:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997599;
	bh=JnZjIGxXq7K2t7qWNGz/U/jko6URe2oU/EGUGoJ9YHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kni0tLTl67i02gHYJP61BSu5jksIO5ljdi9gsxqEprJEefB44o5xG70NFWAFgpvZ8
	 ebtvS3WLxiVtY08dpCnvHuuxoOnxX6BjoRVyIjeqNj7I0TxGR3JLOjg6ViHfWngLDi
	 1yabj+Irl/r6CLo29lzb055KvbJyz03QX681OpSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 5.10 229/518] tty: rp2: Fix reset with non forgiving PCIe host bridges
Date: Tue, 15 Oct 2024 14:42:13 +0200
Message-ID: <20241015123925.833376711@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


