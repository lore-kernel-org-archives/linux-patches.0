Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44FA1519B4;
	Wed,  5 Feb 2025 14:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764004; cv=none; b=VR8Uqi79WosMWd7p4jnDerEXOctWegaHE0R6qOPG72ZOJ5tR94T1bjbXujzht3n9681wGwCX/YNEsm6yH5KjfdozM32Pa573bjm7cnLPACoDlrUUVrmuxYvwr6WQNDOof+qfdOpD0wBIddEgo/S3oUHpoTd2qOLyrMaCZzSLTE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764004; c=relaxed/simple;
	bh=9/0fTXDoYhQdx2bmFupTATLPiP3x7KUx8lTxoeIJ34w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiAb61wdJeqR0NiqpLLaJ8qorXj589XdOP7xUutjSj7F7Afd9YYpg72pE/JhAhYe43Gap9lRVDFZ3u5EEpH9Nn5WfOK8d5KxVr6x/hanJnzRXBu1FYj1s2Y1l1xIsGn2pGcZG2JcYt6RUfqR669DUQq5hovH94AtPrTaEGXlI4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u3ptveRZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3ptveRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23403C4CEDD;
	Wed,  5 Feb 2025 14:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764004;
	bh=9/0fTXDoYhQdx2bmFupTATLPiP3x7KUx8lTxoeIJ34w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3ptveRZdJAFWuADoZUlBTdhIu7xNEiTZoBsotz55d85MkDILM1CtVUKFT2+4m4xI
	 JroZrGtAtxRiKa8rA+pni1YUFDIayiE4ySzuYmTmQlylu/dR1TzWxjWvWNNXq1J8/N
	 3bw0aGzmPSpLzribBZjIMy4tmkbYAPE6051Mz+70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/590] wifi: rtlwifi: fix init_sw_vars leak when probe fails
Date: Wed,  5 Feb 2025 14:37:15 +0100
Message-ID: <20250205134458.313968207@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit 00260350aed80c002df270c805ca443ec9a719a6 ]

If ieee80211_register_hw fails, the memory allocated for the firmware will
not be released. Call deinit_sw_vars as the function that undoes the
allocationes done by init_sw_vars.

Fixes: cefe3dfdb9f5 ("rtl8192cu: Call ieee80211_register_hw from rtl_usb_probe")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241107133322.855112-5-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index c27b116ccdff5..8ec687fab5721 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1037,6 +1037,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 
 error_init_vars:
 	wait_for_completion(&rtlpriv->firmware_loading_complete);
+	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 error_out:
 	rtl_deinit_core(hw);
 error_out2:
-- 
2.39.5



