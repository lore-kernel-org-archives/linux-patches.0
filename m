Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F3115198D;
	Wed,  5 Feb 2025 14:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764180; cv=none; b=LgyIeXYEeLthLV58aOPqx7GkK9CABhyJX0s2iMhkqiNm5SU3wx3jE/jl/i/iMNgmzLE/MvYOQAzA+5H2ufH59AGx5NxeeiPcLvdlszwH0Y0+3R/jwYsHOpPn0tE9pTdr+xF3910/F2dsPzBlSgB1FYrXOrN1eXj9U6K2ZUvHsNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764180; c=relaxed/simple;
	bh=o93doGUJB9Cciokxh3QHgfbTwbjsxhYfxfozd7kUo80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aL4CDdtPim8VGwZsNuCK0D34DJeKHUXDCoNg6K2HXsMiT72UhZrua4qC43l582Xt8JK4pOchaHCpcCZB5IX1PT5v5/95/fnh5GC+E14hsrupBIPreUJKK4hWm+0CpmC/IgDA/3UZY50sxGct02pyzWIhvF+yq84fXbmW1yhp8PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ooDZYo2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ooDZYo2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F01C4CED6;
	Wed,  5 Feb 2025 14:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764180;
	bh=o93doGUJB9Cciokxh3QHgfbTwbjsxhYfxfozd7kUo80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ooDZYo2zr73BmACDdh9HWFfZbF4WjOcekNuXaC45DyNnvqgc+I0bTurNl7/1HDX26
	 W7zw5wIzSJasmDy/HhS8swisaoo7VQtesPzuS5Zlkcbd3jMflKzqb4rUT8FoBKijd1
	 ik2iLvE9SDX4x7iQTf6w414nAZ0CLsjgMHREB9u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/590] wifi: rtlwifi: pci: wait for firmware loading before releasing memory
Date: Wed,  5 Feb 2025 14:37:31 +0100
Message-ID: <20250205134458.929258482@linuxfoundation.org>
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
index a870117cf12af..0eafc4d125f91 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2218,6 +2218,7 @@ int rtl_pci_probe(struct pci_dev *pdev,
 fail4:
 	rtl_deinit_core(hw);
 fail3:
+	wait_for_completion(&rtlpriv->firmware_loading_complete);
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 
 fail2:
-- 
2.39.5



