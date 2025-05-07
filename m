Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F252144C1;
	Wed,  7 May 2025 19:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644945; cv=none; b=N00ccJa8ewM02yiBble+9+ay41JkMlr1wiv7ntG9MW8uigCJUxdWx+DDclR2dNzS8mRuLWLrHVJcx8NmQD4z7OV7ExNWgd23JMaYi58PCoQ7jGKiZ9qCHps8B/9xLecz4GSfZyPqdNVLsDEV3avgADO710dm0eL87KdSgI5JC88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644945; c=relaxed/simple;
	bh=LpU0CNyuzOxHF0XHwjoEewtOnRLxN8MBPES3c2WPT5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=os2K99dD8rW83xaApibjBtRnlavflDcF1BZgvIU6wr7w8LjXEWcbEj1hZRCM+KbjSx5n0D+L1TWCPZHUNWIEnOVbsWeERsQ8i4RG5k1mHGXhBQr/xSbvfESyGBlhvV0hdkI7Com3OuoP0ZL/2AIfJqdRiNDCufttHCgG/o435hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FaSsRm8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FaSsRm8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68C7C4CEE2;
	Wed,  7 May 2025 19:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644945;
	bh=LpU0CNyuzOxHF0XHwjoEewtOnRLxN8MBPES3c2WPT5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FaSsRm8InCt2LL8HR6nwM431H255b6kyx9uhiH0V9/wYgB7jaZlYd7gTZGTR+HBAD
	 acCha0lOezqZr6egz/71osSDgqpIpr75OH1nM7C/OsKPcv5iyjCJtGEc16lcQJHXdv
	 Cf6Rdcud97PVp/hV3BDrrw74sJbRkAuFPECVnm/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Matthews <ryanmatthews@fastmail.com>
Subject: [PATCH 6.6 043/129] Revert "PCI: imx6: Skip controller_id generation logic for i.MX7D"
Date: Wed,  7 May 2025 20:39:39 +0200
Message-ID: <20250507183815.287638433@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Matthews <ryanmatthews@fastmail.com>

This reverts commit 2a12efc567a270a155e3b886258297abd79cdea0 which is
commit f068ffdd034c93f0c768acdc87d4d2d7023c1379 upstream.

This is a backport mistake.

Deleting "IMX7D" here skips more than just controller_id logic. It skips
reset assignments too, which causes:

 imx6q-pcie 33800000.pcie: PCIe PLL lock timeout

In my case, in addition to broken PCIe, kernel boot hangs entirely.

This isn't a problem upstream because before this, they moved the rest of
the code out of the switch case.

Signed-off-by: Ryan Matthews <ryanmatthews@fastmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1281,6 +1281,7 @@ static int imx6_pcie_probe(struct platfo
 	switch (imx6_pcie->drvdata->variant) {
 	case IMX8MQ:
 	case IMX8MQ_EP:
+	case IMX7D:
 		if (dbi_base->start == IMX8MQ_PCIE2_BASE_ADDR)
 			imx6_pcie->controller_id = 1;
 


