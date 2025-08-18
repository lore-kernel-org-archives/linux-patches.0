Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ABC20126A;
	Mon, 18 Aug 2025 12:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521428; cv=none; b=pb2YxmJnPdHnKgy3S4qIAvAv8lD85hjPLOa8BGPCiXNFnvbTfOxr5C3hNzXO2P8sczjfYmOKP2b7QVjx9FD90SVSwnPSFAiTHvu4L0sjXPAwi9hr6xo+YqjasO/H83iCToLZ9BBcAoXoDbPiITB1g+eGe5BhLJYK7bR4GOwmgZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521428; c=relaxed/simple;
	bh=xRQSvhcTRCr3MjZx+fM4bTY9qP1EuCDj6nmLGyOB2xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxHQXWIcbOvDEKGZRvaJvoMSZkrNFX2vWHD3tycWXFPIKBEG0ll8uV6LIXV0+w44OWeQ0uM2hPY/itIZvBFsXlJDruLLlFCqQsOLUAsEP/xqI1DeWsna4Jb0WYE4DIaxPBWGuReBlXnKyiPD6yAqPbUwAzVuAhZZPrRPfmWFcCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbX9hBGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbX9hBGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA546C4CEEB;
	Mon, 18 Aug 2025 12:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521428;
	bh=xRQSvhcTRCr3MjZx+fM4bTY9qP1EuCDj6nmLGyOB2xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbX9hBGOZITtvsY2oBrqjmIuTiPzYRur/xHVB3KKTRP3qnvOwP+X7u+smNY8KlRTz
	 DxuMusPoR3v3qjt0iYhMSjDuH3w9iDG2X1eM0XF1/lZbKNSBBKK49c7IFIWML64ll+
	 iKQe4kUS1SqiLmHXrrdWlBWaLDEDAXKwUPao6tWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Johan Hovold <johan@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 018/444] net: enetc: fix device and OF node leak at probe
Date: Mon, 18 Aug 2025 14:40:44 +0200
Message-ID: <20250818124449.597388242@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
@@ -1182,19 +1182,29 @@ static int enetc_pf_register_with_ierb(s
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


