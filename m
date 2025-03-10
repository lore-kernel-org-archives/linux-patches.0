Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5A722B5AD;
	Mon, 10 Mar 2025 17:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628766; cv=none; b=ffMUeZVuLRZrbCiS8I66iL4HDNh3Fb0TI3uRdaxoOpRsUOn/sap75PZj5XYq7pdTjNhSlzv/UCjkoFFLoR3qyeelOS5Ly4njDYHr1ZJ/g6in43otSqzNbOomtX2ygTBP22y0PBi2OlCpX+xqF2s9prRksP+Eab2BkyPjIY9rLuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628766; c=relaxed/simple;
	bh=WjbXZ7UHG2nEhNCZYLeyho8TWuZMS2JtSueHNEyAdGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dW+ooL80+NZneFEqXebfzJ7vqeOr59Fgp5xRfHz4HsdgkbY9attR0VexNmLdCGXAgTeHPSKcLC6bz6PTULtmQWSVMoI+PN1O3t70oGnNqQZKphKBaHzXNHCySaxM6hzYXeIOtE1q8k7t3tl6+vySjz3PFHZpioXJ8zZ4wNkjvzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVCqZk8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVCqZk8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C8CC4CEEC;
	Mon, 10 Mar 2025 17:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628766;
	bh=WjbXZ7UHG2nEhNCZYLeyho8TWuZMS2JtSueHNEyAdGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVCqZk8dz3QdNzBwSaA3yVf9f+K1QbQh50/FCimEpN9Nt5qa2UPolBFNNM9wMZL9j
	 o49bg71A6ErF6coX2p+QZ8dBxd4LLlWn9Z8sKUy/lW/s/C2bnaRPlPqomH4Fc7MU6z
	 D28Z5CfigRmpIb/rTwulIrSIbC/iyHfpJhsHY5Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/620] wifi: rtlwifi: pci: wait for firmware loading before releasing memory
Date: Mon, 10 Mar 2025 17:58:10 +0100
Message-ID: <20250310170547.319277681@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit b59b86c5d08be7d761c04affcbcec8184738c200 ]

At probe error path, the firmware loading work may have already been
queued. In such a case, it will try to access memory allocated by the probe
function, which is about to be released. In such paths, wait for the
firmware worker to finish before releasing memory.

Fixes: 3d86b93064c7 ("rtlwifi: Fix PCI probe error path orphaned memory")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241206173713.3222187-5-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 5b0a5a22d06d2..925e4f807eb9f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2220,6 +2220,7 @@ int rtl_pci_probe(struct pci_dev *pdev,
 fail4:
 	rtl_deinit_core(hw);
 fail3:
+	wait_for_completion(&rtlpriv->firmware_loading_complete);
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 
 fail2:
-- 
2.39.5



