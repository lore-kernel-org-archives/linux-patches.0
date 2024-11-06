Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6431D5AD7;
	Wed,  6 Nov 2024 12:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895121; cv=none; b=eQM/hrSez0zyZnFXEcyMDu34c+z+hT9QtFlg2pqRbgmpfltKd/0QPcs4ceakIYbrFAQ/+zIeQZKw3iutd6aRuvbVpjSoBT6UCvjacqi3Z9A9hxArpROkOz3WK4oZecYmIfa9iCH/EtnzOBzAs2AEckImNS6jgzEJlpeo9VyAye0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895121; c=relaxed/simple;
	bh=0mXofywJ8B8G58GGRmBIT5Z/hYIr1h0C9euHpKZnRBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTuyXHkg71wzbl1hHGuMKVzZTZm9wJCj/PTrE49RdVwOyiPGjHFyxG2yDcYV7DKtNbHrdJHa1h0j2XTL3EAsoqltX/V1iPIQdgnq4StRQZXB8gZ8QdnB3LgzgyNUP+OfLb1IGQ7yMrKXO4n2addkeA7xYxv/AX/hJ0YURuSJrEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vS4oFPJW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vS4oFPJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3013BC4CECD;
	Wed,  6 Nov 2024 12:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895121;
	bh=0mXofywJ8B8G58GGRmBIT5Z/hYIr1h0C9euHpKZnRBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vS4oFPJWASSog4/j/UgZmhXR1WHYSppqbUK2OwYzY7BSDSn5OkzH78CFV4Dc9WO85
	 ZmLV9QoCSSSH/kDhjRgx8jACzgNp7s454ChMiQoFhYDNvhGeVjFucjbHlqta/ai7fa
	 FQ+lUlIRAHRL+SzNqPW6qbK2akomrB3ihPwFlIa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: [PATCH 4.19 112/350] tty: rp2: Fix reset with non forgiving PCIe host bridges
Date: Wed,  6 Nov 2024 13:00:40 +0100
Message-ID: <20241106120323.667760171@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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


