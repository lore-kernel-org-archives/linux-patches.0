Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0AD1A6161;
	Tue, 30 Jul 2024 16:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356329; cv=none; b=W+B3tBCtocu6MAK7k7O80poj1QGg33PQmiDUaaeRr1R1lHzFAarJUBFNQyQIDZ9Bo5A/+7HAwB8KzjWYmGhOEc43Fb9uHRIQmSFjWjbcw/5wUjYsSF4N9FvFcgp4uO62GJ4di0tgtq1wy5BstD1TgtmEGMUOD6CaHf4ysjFiI5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356329; c=relaxed/simple;
	bh=adxDEgmL1/jD03Gr6Oc6PRf6xoLUZ2QluFSWn8wwldE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TJ4QZLldZfNBW30ez8oizWiG2AGgIsDg2uXpo9aclbwTqJQR85GE+SQtUi7YiJO51GhjlglC1tmw0uPv4kFfH5a0UHktR6Iyf+vtO3L8r317SLO84EHV6AOhjemzqM6P6uTkdyaFhmfZOjDVGOVOsR9qTlgbS2DAMKdT7ISfpfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZYfixri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZYfixri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8838DC32782;
	Tue, 30 Jul 2024 16:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356329;
	bh=adxDEgmL1/jD03Gr6Oc6PRf6xoLUZ2QluFSWn8wwldE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lZYfixrilStO5ezt6WZz+vRdtmQtRJJDKSz9+3jukxvXzBG7id97EtHRl6lJun87T
	 kmiScgkjkTf8CLJv708PEor4Ky7ksDvQqG2mt6x6eq3e72gRN1ncWa0sWr3cc860rI
	 ygFDPJ0ozcd4SGG8IxJexKLu/qOTUK+xg6QOblgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cochran <richardcochran@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Wei Fang <wei.fang@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>,
	Csókás
Subject: [PATCH 6.6 138/568] net: fec: Fix FEC_ECR_EN1588 being cleared on link-down
Date: Tue, 30 Jul 2024 17:44:05 +0200
Message-ID: <20240730151645.269861590@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Csókás, Bence <csokas.bence@prolan.hu>

[ Upstream commit c32fe1986f27cac329767d3497986e306cad1d5e ]

FEC_ECR_EN1588 bit gets cleared after MAC reset in `fec_stop()`, which
makes all 1588 functionality shut down, and all the extended registers
disappear, on link-down, making the adapter fall back to compatibility
"dumb mode". However, some functionality needs to be retained (e.g. PPS)
even without link.

Fixes: 6605b730c061 ("FEC: Add time stamping code and a PTP hardware clock")
Cc: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/netdev/5fa9fadc-a89d-467a-aae9-c65469ff5fe1@lunn.ch/
Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 08d6d7a6ac42e..5604a47b35b2a 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1342,6 +1342,12 @@ fec_stop(struct net_device *ndev)
 		writel(FEC_ECR_ETHEREN, fep->hwp + FEC_ECNTRL);
 		writel(rmii_mode, fep->hwp + FEC_R_CNTRL);
 	}
+
+	if (fep->bufdesc_ex) {
+		val = readl(fep->hwp + FEC_ECNTRL);
+		val |= FEC_ECR_EN1588;
+		writel(val, fep->hwp + FEC_ECNTRL);
+	}
 }
 
 static void
-- 
2.43.0



