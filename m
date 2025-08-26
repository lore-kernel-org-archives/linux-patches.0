Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AC62AD04;
	Tue, 26 Aug 2025 13:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215420; cv=none; b=Pu6BIM9rZGpfMMlqWbIrpiPVGfsjGBXyedORzzWJ/kf6MegIZJxvEqpE3HeoTf9ZZZTcTehraYVkjC89l9XX0SuOmJJ3QRi1+TVP/7WS1J0ulZS3A5UtYsPvdrsKHNxXF/L20cSkboLMCUEaBn7B4DzxjcOihIFFj6OKGA0UCHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215420; c=relaxed/simple;
	bh=c/Y798mS82sHD46fuX+BsedUKAbVX+va+drWsCFcAMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9guPxv4u7G3hCmZOUwtcv21i0ASJVqKBtDstn5gghGaFqDiBW6ZIljwa9n3km8PedYUQTxBC1Gaybquip0RLP5vmjgt1HfilxFhPli2mconR5yDsfBDzrlhV8vRWyYc82sdngsAw4Ccvu1bBSNCbaJ1gdSwLvsJNPiSOCjP2Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=puaY0Vzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="puaY0Vzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E041C4CEF1;
	Tue, 26 Aug 2025 13:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215419;
	bh=c/Y798mS82sHD46fuX+BsedUKAbVX+va+drWsCFcAMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=puaY0VzutEkpGfNoaAg1d44cOHX8pycMYrc8PQsk2UwBr4AghqZxiXqIMMDBisE+x
	 YTPINoFOLtq5CoBuq7e6vmtCpfQH/EVpkih8Bd0RyVd73qi6n53P9Xc75epw1FQhqN
	 OEXq+Aub1ajZPQT8MgiJEKJCgCLrVSo4mzMAAJMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 007/644] thunderbolt: Fix bit masking in tb_dp_port_set_hops()
Date: Tue, 26 Aug 2025 13:01:38 +0200
Message-ID: <20250826110946.693154279@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1333,7 +1333,7 @@ int tb_dp_port_set_hops(struct tb_port *
 		return ret;
 
 	data[0] &= ~ADP_DP_CS_0_VIDEO_HOPID_MASK;
-	data[1] &= ~ADP_DP_CS_1_AUX_RX_HOPID_MASK;
+	data[1] &= ~ADP_DP_CS_1_AUX_TX_HOPID_MASK;
 	data[1] &= ~ADP_DP_CS_1_AUX_RX_HOPID_MASK;
 
 	data[0] |= (video << ADP_DP_CS_0_VIDEO_HOPID_SHIFT) &


