Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D827918C90A;
	Tue, 30 Jul 2024 16:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355544; cv=none; b=IKxROufk5EOM08IH2y9aVpr1ED64lmyeMd5HATzbQ8PsQua7zOQxpJSN0AQsm+yidtA6ZrSyWmiKoZ1L+fokz1etRy6SCCzmulO8Vz0KQQYykm0sc9TvhpQx8lnnlNfJWxn9iED1u8PcAFxd1CuPUo5fcbItM0r8kcNx0Q/tEG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355544; c=relaxed/simple;
	bh=PRSTkCIH35jiN0abqRC9ji85868Hle1MbFHiObSaW3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MDDeOAa3p9l1FKtv5keTTXpFBUrEM8gjePKS/FDi0lotwwAJXV0Vq/I7e6cZrIywp8lbMdzr2ljrfCTdFH4gvtEbAYswDYMYRXRFf10Ds2dyYit3tlW6x9SwpgJfjGN4bRaLhduXpOu3P8qj5JvrqJ01t2FE1v1vR1/TqGHUu6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6B3j+Zv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6B3j+Zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD0EC32782;
	Tue, 30 Jul 2024 16:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355544;
	bh=PRSTkCIH35jiN0abqRC9ji85868Hle1MbFHiObSaW3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6B3j+Zv+MjSEAWGAMsxra0TBI9xs11m70F/NdYkg/7lmxYyOFDlk48CHzTfHMmpe
	 EU4VLdW/helnQ7BNSwForB2Ojqft+agJWZr4/3CJo0PyKtma37weO4hs110p4yS14m
	 IueBUgEBQYH1MdRlDwN1L3QDX/KxWeET1j3TVS4o=
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
Subject: [PATCH 6.1 104/440] net: fec: Fix FEC_ECR_EN1588 being cleared on link-down
Date: Tue, 30 Jul 2024 17:45:37 +0200
Message-ID: <20240730151619.950289122@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ef70290beaeb0..0a5c3d27ed3b0 100644
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



