Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5773425E832;
	Tue, 11 Mar 2025 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706371; cv=none; b=Bm7w53HjezIXs0cS6Qcn8o3+7wv9PSOrj7BKv//DI7iR7BSv2r/J2EI0i5tDVpAwnR0y6iHzFsrUQI2UGuqqC8uCo6k+5L5hCsxa8TrH48avOW+qUDOYhDwkjUCfm9wpwQvyC279AHWFm6iVZRAKFVJu6aZ+F5qtFauWwXqipFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706371; c=relaxed/simple;
	bh=oKoaVlFG2tskZA4Oxy65+ZLBfUlu6G+rOKShqTHBYrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+rLQGhXmAzcTrh5udBE95jsDXdckeNr90bL1zWMngQN5dzN3kp0wthIW6U+dP7qiekR113okbQKuHFSpTvicibz7Fpz4IRjQUtJvzMz+BdfH64S0I58iPZCHYESp1kxl5L1yGXnthehvCg+IEAtqwkVTWpRqIWbr1i96GgLk1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKvkuFqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKvkuFqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3625C4CEEA;
	Tue, 11 Mar 2025 15:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706371;
	bh=oKoaVlFG2tskZA4Oxy65+ZLBfUlu6G+rOKShqTHBYrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKvkuFqOUYSQo5EGum+QveDYGDwa6gVpHzhUZXKYZl7SRMxnxCY1M8IoLjpp1RLhA
	 4NHbQ1DOBO70yJFAF16QO+DPwpgj1NW5WzJJJNS7lLw7gMDI+SBqt6ZR4N6b+YnT1n
	 VDSZWwYMt8b/rSf/T/DL49Iwo4Ou/lKox4gOzwC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/462] wifi: rtlwifi: pci: wait for firmware loading before releasing memory
Date: Tue, 11 Mar 2025 15:54:52 +0100
Message-ID: <20250311145759.386959037@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



