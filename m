Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A8522157E;
	Mon, 23 Jun 2025 21:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714221; cv=none; b=GvFNQli4mg5kWMh6lkYWnToiJNNNjbIXoJ52IG2pP4Uz8wGkgrsu9T1D6xaFfueXOcrXpCOLi/q03pFcvoIVSfkS0d07ZbOHtuRqi53HLo0v7q7ZZnVC81aUz/vlCqhye5YSNJLdIiRqFc+cxinLuNrgu4bUto4f3tzxuzvxMAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714221; c=relaxed/simple;
	bh=6x7GEenNuSzexhYQDAxrurdiDV5OqE2vRrm7LTP1FNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlmskDsX4FGmYJEFnANt2A03OtFTCtlFzHqWAOIj2GIoiarJbbJaVtNpFlwyfQsCwXRhOmA+uqioqAa8qnw2seOltzp44NWFzqFXvCLVHo9iPoyEuriKLRAFSdu6piUcM3n61FulpVev03pBEKTEVH4RIVneEYrbG2wz65aYwBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjAM85LT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjAM85LT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1F9C4CEEA;
	Mon, 23 Jun 2025 21:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714221;
	bh=6x7GEenNuSzexhYQDAxrurdiDV5OqE2vRrm7LTP1FNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjAM85LTW+7UXxYH8U6YkJgLFpJ8zJAUeGcnqMhCT3CXgeQ3OPh1O1EFPqgmoBELY
	 BD4IbG4oWYg0qYVeNoM44tjVbTlYKClukjvTA5S7MKhoO8BiPX2togmTgfL/h+mwLL
	 pKSEIAWP0dSrhYeLC9grJ7EhdxrOb83MOBof/xos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Korhonen <mjkorhon@gmail.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 089/414] ata: ahci: Disallow LPM for Asus B550-F motherboard
Date: Mon, 23 Jun 2025 15:03:46 +0200
Message-ID: <20250623130644.312806577@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Korhonen <mjkorhon@gmail.com>

commit a7b3b77fd111d49f8e25624e4ea1046322a57baf upstream.

Asus ROG STRIX B550-F GAMING (WI-FI) motherboard has problems on some
SATA ports with at least one hard drive model (WDC WD20EFAX-68FB5N0)
when LPM is enabled. Disabling LPM solves the issue.

Cc: stable@vger.kernel.org
Fixes: 7627a0edef54 ("ata: ahci: Drop low power policy board type")
Signed-off-by: Mikko Korhonen <mjkorhon@gmail.com>
Link: https://lore.kernel.org/r/20250617062055.784827-1-mjkorhon@gmail.com
[cassel: more detailed comment, make single line comments consistent]
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/ahci.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1458,7 +1458,23 @@ static bool ahci_broken_lpm(struct pci_d
 				DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 				DMI_MATCH(DMI_PRODUCT_VERSION, "ASUSPRO D840MB_M840SA"),
 			},
-			/* 320 is broken, there is no known good version yet. */
+			/* 320 is broken, there is no known good version. */
+		},
+		{
+			/*
+			 * AMD 500 Series Chipset SATA Controller [1022:43eb]
+			 * on this motherboard timeouts on ports 5 and 6 when
+			 * LPM is enabled, at least with WDC WD20EFAX-68FB5N0
+			 * hard drives. LPM with the same drive works fine on
+			 * all other ports on the same controller.
+			 */
+			.matches = {
+				DMI_MATCH(DMI_BOARD_VENDOR,
+					  "ASUSTeK COMPUTER INC."),
+				DMI_MATCH(DMI_BOARD_NAME,
+					  "ROG STRIX B550-F GAMING (WI-FI)"),
+			},
+			/* 3621 is broken, there is no known good version. */
 		},
 		{ }	/* terminate list */
 	};


