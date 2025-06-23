Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FC44409;
	Mon, 23 Jun 2025 22:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716090; cv=none; b=bkygkOW/IgtLfpLh9avdw9RMmYmWBMLID5rdhbVFelURQh/aWLW7F3J+uG1vqOuABVvDsHlO7r+Z8F7l+8nZlQygBQtB6cI3t8vKoyF739DYLUggyDDFc3rFRoGf8VMQBHyQE5SOcNyQUg/1VEsGBza8tYnQEhtKddoL6EKLDnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716090; c=relaxed/simple;
	bh=6FfMaLHvTPnIPR3dsmKJzg5qnyRNXATgaEt2b+FtDHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q1nAkbxgCmVcm+Z9nuZ11363QQ6gv7r6SJkYcrg+XSkzzYvhccDi50+UDTZ/6j9AWIxcTxzLnqE1LfUB7cixeEonqv+FU2VwaRqathDSMS3doKJMr27awoRxOfHjSnMffaLfh1b6cUaJi3b75EDIua397y9kgp7ogDvoH9CY51g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M840zE9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M840zE9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29238C4CEEA;
	Mon, 23 Jun 2025 22:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716090;
	bh=6FfMaLHvTPnIPR3dsmKJzg5qnyRNXATgaEt2b+FtDHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M840zE9gBXruHS16sq9NknsjsDODjohDYKzVsmDElr7bEJVKU5cYEJyq0iTtQnQzC
	 vPTxqJs1NKOdrUFr/d8w2Z7OOVDGeIMahD5c6lqWciI+t7DWTZ7xA6EkrA6nApWvIm
	 5IzMY8UqKU3v6EEcGB3hFgUWt8HXhsQnzqEWPf4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Roger Quadros <rogerq@kernel.org>,
	Kevin Hilman <khilman@baylibre.com>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 5.10 320/355] ARM: dts: am335x-bone-common: Increase MDIO reset deassert delay to 50ms
Date: Mon, 23 Jun 2025 15:08:41 +0200
Message-ID: <20250623130636.385337147@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

commit 929d8490f8790164f5f63671c1c58d6c50411cb2 upstream.

Commit b9bf5612610aa7e3 ("ARM: dts: am335x-bone-common: Increase MDIO
reset deassert time") already increased the MDIO reset deassert delay
from 6.5 to 13 ms, but this may still cause Ethernet PHY probe failures:

    SMSC LAN8710/LAN8720 4a101000.mdio:00: probe with driver SMSC LAN8710/LAN8720 failed with error -5

On BeagleBone Black Rev. C3, ETH_RESETn is controlled by an open-drain
AND gate.  It is pulled high by a 10K resistor, and has a 4.7µF
capacitor to ground, giving an RC time constant of 47ms.  As it takes
0.7RC to charge the capacitor above the threshold voltage of a CMOS
input (VDD/2), the delay should be at least 33ms.  Considering the
typical tolerance of 20% on capacitors, 40ms would be safer.  Add an
additional safety margin and settle for 50ms.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/9002a58daa1b2983f39815b748ee9d2f8dcc4829.1730366936.git.geert+renesas@glider.be
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/am335x-bone-common.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -381,7 +381,7 @@
 		/* Support GPIO reset on revision C3 boards */
 		reset-gpios = <&gpio1 8 GPIO_ACTIVE_LOW>;
 		reset-assert-us = <300>;
-		reset-deassert-us = <13000>;
+		reset-deassert-us = <50000>;
 	};
 };
 


