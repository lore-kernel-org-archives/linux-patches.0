Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5EA1DFE1C;
	Wed, 19 Feb 2025 09:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956047; cv=none; b=tDMGXmHY2Y9d1q/jDcQjVa5zFR9dlLemZTSqUozOP9poho/p4bffSKZ9H6DENd/I2MEsUCtWnfiEY1BX+m6TaPUAgiwRxigvJPUg+NzhVILJA4Yu4gci++eI1xljO2HPDz4beGtAio8HNQClbBjta3O44aElvMxNwAC7kni0/lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956047; c=relaxed/simple;
	bh=gXUcKo2g3hvOCeAVLlClShgga8GpAC2DP3Y7+9fZSGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCQhmLCIsxMVl5ypzd5+wyBnS758TCxKDuSOscJbUaUVHz4BvwNg4oNVOBnkQzmG+lANpef+KzRHx+gyYfP0W9OxlEPBbF4hFyjqe3JuJwnQ1Ti6SCbKT3Cl/k+7sq885Gs0trtBYTYGCqAOrc/WPTaqBYPE2s+4OXg4gGRLaFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQKQW2lt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQKQW2lt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56879C4CED1;
	Wed, 19 Feb 2025 09:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956046;
	bh=gXUcKo2g3hvOCeAVLlClShgga8GpAC2DP3Y7+9fZSGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQKQW2ltaTT6Fjb13l0XZjR94YNkfTU4303DWLf1PCPIFugIAHvSrp62bSJmU1fQA
	 nmPmbUzLZtjuvfA+GCcrffFGDSMacA6pQKej7/pImyYQWZ9yyR07VLJflwBnbfyKh8
	 r9JArAzzaRsvkxRCnf3Rkm1k/VpJucaeM21Zga4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/578] wifi: rtlwifi: usb: fix workqueue leak when probe fails
Date: Wed, 19 Feb 2025 09:20:44 +0100
Message-ID: <20250219082654.472257902@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit f79bc5c67867c19ce2762e7934c20dbb835ed82c ]

rtl_init_core creates a workqueue that is then assigned to rtl_wq.
rtl_deinit_core does not destroy it. It is left to rtl_usb_deinit, which
must be called in the probe error path.

Fixes: 2ca20f79e0d8 ("rtlwifi: Add usb driver")
Fixes: 851639fdaeac ("rtlwifi: Modify some USB de-initialize code.")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241107133322.855112-6-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 1753eccbefdd9..04590d16874c4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1084,6 +1084,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 	wait_for_completion(&rtlpriv->firmware_loading_complete);
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 error_out:
+	rtl_usb_deinit(hw);
 	rtl_deinit_core(hw);
 error_out2:
 	_rtl_usb_io_handler_release(hw);
-- 
2.39.5



