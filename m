Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FED151CF3;
	Tue, 20 Feb 2024 21:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465136; cv=none; b=Ha7hatQeC2UhAipl18lp14TB83N5/8aKIOKYhS4PGdlbQmhFpnktBiLu7dW4ldsv/kQe5WkhTIB4cjF0YPCaDRQJlyOVMXXiYAuxb82BIs6aqXYlkEfShnSFa3SwDQLYmlqRRKbujLGzmHsP83oqp2zttT91S6AYstwnTuvCYkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465136; c=relaxed/simple;
	bh=81p8J9ad0H3T30CPNB0ix2F/nCL2V9VR9mH0BbmGBR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7gSWeOOPi2AZgTnRUHaLzWm9EABjeDKP2GbRt+s7glFJ3l0CBvng7Kv4hQQkbvu+cysq2qc2H8dDTP4cYvM2mavQwQ2CkUa5OUqJKt3p42XnGRahRaqQbYeOcnj2wAMdSEOnVcqGBe93m9A/T8zjBpBDRvnGFQZctiFkk0GMCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXFkXn/9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXFkXn/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2EEC433C7;
	Tue, 20 Feb 2024 21:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465135;
	bh=81p8J9ad0H3T30CPNB0ix2F/nCL2V9VR9mH0BbmGBR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXFkXn/9AekK0rJ7ujKP5ePmrdR9cu8aMtEFROxq8/3HiryCfKqrfC3hGWQSHXy/R
	 6SMwkZqSqTg2Pn2r5ZWeVSj52gLALye5EuBvduKTqTRdwPxyyibvBaySFIqddrH47r
	 wtYEbbWQm8CG9whlmyS1LOIRAiVFK11gPYtB/fMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Basilio <daniel.basilio@corigine.com>,
	Louis Peens <louis.peens@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 247/309] nfp: use correct macro for LengthSelect in BAR config
Date: Tue, 20 Feb 2024 21:56:46 +0100
Message-ID: <20240220205640.898464120@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Basilio <daniel.basilio@corigine.com>

commit b3d4f7f2288901ed2392695919b3c0e24c1b4084 upstream.

The 1st and 2nd expansion BAR configuration registers are configured,
when the driver starts up, in variables 'barcfg_msix_general' and
'barcfg_msix_xpb', respectively. The 'LengthSelect' field is ORed in
from bit 0, which is incorrect. The 'LengthSelect' field should
start from bit 27.

This has largely gone un-noticed because
NFP_PCIE_BAR_PCIE2CPP_LengthSelect_32BIT happens to be 0.

Fixes: 4cb584e0ee7d ("nfp: add CPP access core")
Cc: stable@vger.kernel.org # 4.11+
Signed-off-by: Daniel Basilio <daniel.basilio@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
@@ -537,11 +537,13 @@ static int enable_bars(struct nfp6000_pc
 	const u32 barcfg_msix_general =
 		NFP_PCIE_BAR_PCIE2CPP_MapType(
 			NFP_PCIE_BAR_PCIE2CPP_MapType_GENERAL) |
-		NFP_PCIE_BAR_PCIE2CPP_LengthSelect_32BIT;
+		NFP_PCIE_BAR_PCIE2CPP_LengthSelect(
+			NFP_PCIE_BAR_PCIE2CPP_LengthSelect_32BIT);
 	const u32 barcfg_msix_xpb =
 		NFP_PCIE_BAR_PCIE2CPP_MapType(
 			NFP_PCIE_BAR_PCIE2CPP_MapType_BULK) |
-		NFP_PCIE_BAR_PCIE2CPP_LengthSelect_32BIT |
+		NFP_PCIE_BAR_PCIE2CPP_LengthSelect(
+			NFP_PCIE_BAR_PCIE2CPP_LengthSelect_32BIT) |
 		NFP_PCIE_BAR_PCIE2CPP_Target_BaseAddress(
 			NFP_CPP_TARGET_ISLAND_XPB);
 	const u32 barcfg_explicit[4] = {


