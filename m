Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2CF126C18;
	Wed,  5 Feb 2025 13:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763466; cv=none; b=aIATTYNPIvjrhx1auZ5IB2w8YSyUE+iwGboeDyEMuKDJj61SGydeoFEMyiAMjcIQc7azbZuO76PMNPUoczR/zo2/q+P2g+GnuugEyL4cCuhuncnRnKOPaJabGBIBI0g/CILbcB78fSzcCc5naI0F+frrPB0+671kyvFVzRPEVYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763466; c=relaxed/simple;
	bh=Fz+I96vPbsMNsGwo3tWIZ7oqDt2zOS5d0lALahflZjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhJ/BnnlYJSemSE9hNUPKrYSb3h8gU+7EcPow7gA3LYsoBC95l6zB0OXAdKLDn+kEHVk7bD87Yi8Xyc/lDy2c4LDT4Uumia6aCnePWzhFE+/vYXTXgYH/C3St2zI5Jkc/dtNx8mDedinjzn94+2taob0McJaPcEDMeuBBv5TeQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FayKSgoo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FayKSgoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63955C4CED1;
	Wed,  5 Feb 2025 13:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763466;
	bh=Fz+I96vPbsMNsGwo3tWIZ7oqDt2zOS5d0lALahflZjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FayKSgooycH5n1TPiCfsLssg2/I53akRalCztha/8ydUSekjXpP/EPYl5sRppWrZV
	 ySeKkPN5cZuICo519WCAd8lvbqE5Wn2fmXNSrsMB/EOjCaapGZKT3JGwDEURuaoD+9
	 b8DpT8PO7GE3sdlv5dOqZgXADYeNtlUwhuCIyaow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/393] wifi: rtlwifi: pci: wait for firmware loading before releasing memory
Date: Wed,  5 Feb 2025 14:39:48 +0100
Message-ID: <20250205134422.933655022@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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
index 711f75ce7690a..3abd0c4c954bc 100644
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



