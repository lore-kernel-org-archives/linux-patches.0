Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C222BEFE4;
	Tue, 22 Jul 2025 13:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192636; cv=none; b=RTOrrTncCGWGVpDyLzvEkGOC3+ztXobVyNsarHTV9vg9QRUlOM1FnBsJEnj7kKZQrsrqY8mV/QtpxCVb6vCCpQEdVkmVxm9nEmaltLwBB/t0u+JjAO42gU/Bk2WpDxG7Pwb4ejgUyj3ikdULbSXWCNDhdnnaxMFgcZRB+hDu4NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192636; c=relaxed/simple;
	bh=BqHA6bXr/FDJo0Ai6G12wHJ4/LdItIZM3FsCvnFBTCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaFTg0hwQSuAXLO2gT6C9NWCIzKuU/4cpUo8TVxj+Pr6z4KzLjUotMNKtX6hM9hq+z5lA9ad+rjI/SgPfRRLbBHfeoiv3eGmX8Gv+4MlOmorSRLMhFZerOSm5Siv4Op8XZMhkx++R5QrdGXGC5pCWUaIqqem9D14wcDcoQQa1KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ggEzx1r4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ggEzx1r4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D64C4CEEB;
	Tue, 22 Jul 2025 13:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192634;
	bh=BqHA6bXr/FDJo0Ai6G12wHJ4/LdItIZM3FsCvnFBTCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ggEzx1r4drhpUjVn2aLTltaRPnPh+nBqfF7lz6MBDzm6FXSvU/+1k838V3o289zT1
	 4GUFLULnoC+RSIGQ9+rx19eV8BCAp1l299sae5IKN5jypIImAvsiE0H2mPv2J2vtAP
	 0kQz4gu6D4TwspJ/oQs4rXmcVCoR4Dw7UkuG4L6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 6.12 013/158] thunderbolt: Fix bit masking in tb_dp_port_set_hops()
Date: Tue, 22 Jul 2025 15:43:17 +0200
Message-ID: <20250722134341.230954036@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

commit 2cdde91c14ec358087f43287513946d493aef940 upstream.

The tb_dp_port_set_hops() function was incorrectly clearing
ADP_DP_CS_1_AUX_RX_HOPID_MASK twice. According to the function's
purpose, it should clear both TX and RX AUX HopID fields.  Replace the
first instance with ADP_DP_CS_1_AUX_TX_HOPID_MASK to ensure proper
configuration of both AUX directions.

Fixes: 98176380cbe5 ("thunderbolt: Convert DP adapter register names to follow the USB4 spec")
Cc: stable@vger.kernel.org
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/switch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -1450,7 +1450,7 @@ int tb_dp_port_set_hops(struct tb_port *
 		return ret;
 
 	data[0] &= ~ADP_DP_CS_0_VIDEO_HOPID_MASK;
-	data[1] &= ~ADP_DP_CS_1_AUX_RX_HOPID_MASK;
+	data[1] &= ~ADP_DP_CS_1_AUX_TX_HOPID_MASK;
 	data[1] &= ~ADP_DP_CS_1_AUX_RX_HOPID_MASK;
 
 	data[0] |= (video << ADP_DP_CS_0_VIDEO_HOPID_SHIFT) &


