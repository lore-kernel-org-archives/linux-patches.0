Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A0A4F6463;
	Tue, 13 Oct 2026 12:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893003; cv=none; b=jR9Y5ufUH+x+F5DVkh2ByT1YuiOFCqjStQQ/lMuRdTnKK/LrhdjhKU8uQF1af9TLI9dehBtD70ZsVFdgLJFqDn6bfa3ZBhyAISFJnDVGKyhjvjfkxetuDcRG0RBK0gmayPggDntUfVfnxAvF7X3vuppvrax6CfIr2JNuwtOy6MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893003; c=relaxed/simple;
	bh=aZxoMmr8VI1u4PVf+oZsj6HtXKfPH4NEhJCmua5NFCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6w/HL3xAjepov0RWyAHlUlppkPmZXG7EIkAQBwZqbcvGE4PyK4dUIfj0+A/jixvCMalArtDSyrHqzORXhYQHjBymQgALKvXURHKmAO+n9dbOKY53EDAo2Spyq1zTUaHe4mFdmR6As+4GstaZq/Tbh+5PJf+8WwEe8csBWo794A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXyZ6ix2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXyZ6ix2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAEB1F000FF;
	Tue, 13 Oct 2026 12:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893002;
	bh=/TsIYtfqfDrFHB3dj9w8Qu3UHGP4mLOpqvLkMt04p+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HXyZ6ix2Tl4zZ+8EKFSUdq8hDoboNy/bKwyisySOX1e6t+66cz5uWSupAMJ3uc3Oh
	 igmFdK1BsUlxJGlnCRQLb7ok8AfJZ32e7wDuEhvHL0Mbif/Pze+khVE3QDWXyqNciE
	 XgUPhYTI3XwhUya5WBCHMV0hAM+C8UyFPMV4ucNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Sebastien Royen <sebastien.royen@armadeus.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 080/621] net: dsa: microchip: fix KSZ8765 fiber detection
Date: Tue, 13 Oct 2026 13:31:15 +0200
Message-ID: <20261013112922.755205302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastien Royen <sebastien.royen@armadeus.com>

commit fc13ba44da197a186f2f4d77c5b7d73d0f99f053 upstream.

The KSZ8765 is similar to the KSZ8795 but has two fiber ports.

KSZ8_PORT_STATUS_0 is used to detect fiber mode. It is currently
defined as 0x08, which is the Global Control 6 MIB Control register
and has bit 7 defined as Flush Counter.

Set KSZ8_PORT_STATUS_0 to 0x18, which is the Port 1 Status 0 register
where bit 7 is the Fiber Mode bit.

This issue was discovered when upgrading an embedded device from kernel
5.10 to 6.16. The device was using a KSZ8765 device tree configuration
and the corresponding hardware, but during boot the kernel incorrectly
detected it as a KSZ8795. The relevant boot messages were:

  ksz-switch spi0.0: found switch: KSZ8795, rev 0
  ksz-switch spi0.0: Device tree specifies chip KSZ8765 but found KSZ8795, please fix it!

Cc: stable@vger.kernel.org
Fixes: 91a98917a883 ("net: dsa: microchip: move switch chip_id detection to ksz_common")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Sebastien Royen <sebastien.royen@armadeus.com>
Link: https://patch.msgid.link/20261007080557.15719-1-sebastien.royen@armadeus.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -775,7 +775,7 @@ static inline bool ksz_is_sgmii_port(str
 #define KSZ88_FAMILY_ID			0x88
 #define KSZ8895_FAMILY_ID		0x95
 
-#define KSZ8_PORT_STATUS_0		0x08
+#define KSZ8_PORT_STATUS_0		0x18
 #define KSZ8_PORT_FIBER_MODE		BIT(7)
 
 #define SW_CHIP_ID_M			GENMASK(7, 4)


