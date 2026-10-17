Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69AA33BB133;
	Sat, 17 Oct 2026 17:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257265; cv=none; b=myrSJ4sP7xj0xlrdv847xalgtnGzSGBsWQ5C3BFCM8kbSnqXOyYyuAUh1KuoiaHAb9ebdqXHnDei0f4Apyr7PyGJtDBzUeaDzAnCoyQ29MgSUcMbOcVN3eD1fguupUVBdJHfwDkocrhvK2iCkcDN2RhZeWlkfxyaLB/iFOuSeQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257265; c=relaxed/simple;
	bh=8dkJ5i1nMJq9KQbNIRP5VcCQnYV0ST1YvnhkmYsFXMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/c+DgPU+tMgahDtgtHHYkkJ6im7JuB+Nb5jeGwyPit6GSejfxIHF1qzKbPsQrccxJ06PJKxX4S+M5Ia8UWFat6ePoMNLnI2TDa540ySxCcBXc6GW3iZ1ac7Ju459RAz77bf/jeifDsP0ORtlkrAs/TUN/rORh4dYgum+Tjt54w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BE4Lr2I8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BE4Lr2I8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F371F000C4;
	Sat, 17 Oct 2026 17:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257264;
	bh=vAKlND1cIwD+qgdd9Jcern4XvFGjC6vCxDVZbSzvtpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BE4Lr2I8h266eqVdBa1n1F1f5YBX86K9RYmyq9nNZyY2NEMIRYK7vgVtQFSPndwoN
	 o1N54jGUmnOS7uEHr1Yxku34lS0984F54v4EPsLCC3OgEei3XNB7L2+FpKPhK7FZ4L
	 hX8qYyyxCVsJGJhUUx3PJ5MgAo7LH+CJXpo8j/Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Sebastien Royen <sebastien.royen@armadeus.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0504/1674] net: dsa: microchip: fix KSZ8765 fiber detection
Date: Sat, 17 Oct 2026 17:46:16 +0200
Message-ID: <20261017160444.044490173@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -636,7 +636,7 @@ static inline int is_lan937x(struct ksz_
 #define KSZ87_FAMILY_ID			0x87
 #define KSZ88_FAMILY_ID			0x88
 
-#define KSZ8_PORT_STATUS_0		0x08
+#define KSZ8_PORT_STATUS_0		0x18
 #define KSZ8_PORT_FIBER_MODE		BIT(7)
 
 #define SW_CHIP_ID_M			GENMASK(7, 4)


