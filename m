Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FDC13A265;
	Mon, 23 Jun 2025 13:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684550; cv=none; b=dM73m+h07Flm1iqva9L9+OTjCFZYeeB/XN6+FirDBtwc5/t9fPG1ZkMNtMIk6YkPGxXvv8sTwV3F6XmBNp4eyuoosnuR9eC9mDEW6z5pljS+4x0PxshwXsr1XD5XyUJWfv07pFgvjyISBOUcrmNKxcMLgt+Mlu5h1Z3VPhXumfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684550; c=relaxed/simple;
	bh=4GLLTXXHYQO9x008aaZ8zdO0Pmyy8TOD8PDnzKy1RRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N77Ak6Y1kZUxjYgDGSSeDnDiatiFM08eXZsbrFW/DYoO58ZXvZIq+RBtdTIQplQ5ltWe4pWfecqk+0yjgiPtdEbMbn/U3y3vVixTnSWp2enkDZadUKlUawDsMhT4ggcsRDFvSHKcj1qDRcSa+L0Yk2cEMVU0sdwIHM+BYsjimKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sK0btEPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sK0btEPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08433C4CEEA;
	Mon, 23 Jun 2025 13:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684550;
	bh=4GLLTXXHYQO9x008aaZ8zdO0Pmyy8TOD8PDnzKy1RRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sK0btEPpo1siT+Hyc93A2pOF5IJm3wD+HxSoNKF359pBVTLw2PEpvrARyOmBeSzz4
	 eJxF1LSxWgP4HfJlhZb9J97494/5MDeOIdUvK2E1rRJpDa2rD7ag3VnNhpDtKzlNKY
	 ea+W1AL45KfLLLTILB73u4Tp2YU2vdbrnWpf9pcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Korhonen <mjkorhon@gmail.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.15 109/592] ata: ahci: Disallow LPM for Asus B550-F motherboard
Date: Mon, 23 Jun 2025 15:01:07 +0200
Message-ID: <20250623130702.871494813@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


