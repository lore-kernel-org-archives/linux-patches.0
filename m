Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05B82882A7;
	Mon, 18 Aug 2025 13:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522944; cv=none; b=hcjzh4eyzkhb3xL9f06uZ4NfVnMAKEsmoLjktr/68IpjvfuFc2ePLKyK6Q0ZJWkK7jZ+Lw1wsQWX0AN2euZp/w3ihuvUbWAX3Xczo7f5ioRjRwCEialcSP09+rZMfXF3abKRORjEwluduZT4CLPLXaE2KCsi9PWApsJAudCelUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522944; c=relaxed/simple;
	bh=jo39OaiLw98/Xw3kuA7yxziuoDoATFM6k8+gpGjnXZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=di5S6/0LsRAcWy/VT40j0MxeG+3G+ZT67U9Yb8XdyoahMRGhCNef0D/W90BCQkGRvSENpDeFJGUDqA5870iQLrTRfrrvikrK5YC5EQorkHDHBi2PAZ+kKtdwznx5KTFbdidDRma3SNUZ7QnS5U1Dq4utWteJugptDB0179T3t7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyi6bBlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyi6bBlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375E4C4CEEB;
	Mon, 18 Aug 2025 13:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522943;
	bh=jo39OaiLw98/Xw3kuA7yxziuoDoATFM6k8+gpGjnXZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cyi6bBlbzgSYyzAA+J1bq3xV22ygkhguLuJ1bY8GzeIfFrqb6FZYO1bJIb3sEx/KA
	 bRfskcJkoyjXjjqM3HgKTmRZCZdQ0gwR9+WEPxrA7NM8BooMhjrdA/ehSxF0K110wV
	 kM5EIGVQW5H73MU3rT9agzNnyu+iE5SUKg6PLCks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 023/515] net: enetc: fix device and OF node leak at probe
Date: Mon, 18 Aug 2025 14:40:09 +0200
Message-ID: <20250818124459.358354380@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 70458f8a6b44daf3ad39f0d9b6d1097c8a7780ed upstream.

Make sure to drop the references to the IERB OF node and platform device
taken by of_parse_phandle() and of_find_device_by_node() during probe.

Fixes: e7d48e5fbf30 ("net: enetc: add a mini driver for the Integrated Endpoint Register Block")
Cc: stable@vger.kernel.org	# 5.13
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250725171213.880-3-johan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -924,19 +924,29 @@ static int enetc_pf_register_with_ierb(s
 {
 	struct platform_device *ierb_pdev;
 	struct device_node *ierb_node;
+	int ret;
 
 	ierb_node = of_find_compatible_node(NULL, NULL,
 					    "fsl,ls1028a-enetc-ierb");
-	if (!ierb_node || !of_device_is_available(ierb_node))
+	if (!ierb_node)
 		return -ENODEV;
 
+	if (!of_device_is_available(ierb_node)) {
+		of_node_put(ierb_node);
+		return -ENODEV;
+	}
+
 	ierb_pdev = of_find_device_by_node(ierb_node);
 	of_node_put(ierb_node);
 
 	if (!ierb_pdev)
 		return -EPROBE_DEFER;
 
-	return enetc_ierb_register_pf(ierb_pdev, pdev);
+	ret = enetc_ierb_register_pf(ierb_pdev, pdev);
+
+	put_device(&ierb_pdev->dev);
+
+	return ret;
 }
 
 static struct enetc_si *enetc_psi_create(struct pci_dev *pdev)


