Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01511494DF;
	Wed,  5 Feb 2025 14:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764714; cv=none; b=EBpluFAEXxcF4Xe5yit06aeFgFYXn7yZ5fvcBWm2qL+UagdJXcq4MbjwjqagZIegWbUHQluWME4vJELABDxU0kJOlRcPoV9KYMGLizrQxLbVDFmYxNOXHywU6S2umgq2ofGiYdkO28q2GNt9/r7OADbrLT/mcqLT4UO8wFtjY5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764714; c=relaxed/simple;
	bh=LFFFPFqrQtSWOfpUdXnIz/DZOePiBqjIuSGSTTTyFRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsBbVfV4vxBlPgtLq5w6HuhU9XMjDWUo/wWM/pRuuJ77ykUVjDAmsASo6QSRglol+YZFjb/qug1fJEaSD2y2TOzXhbLXwQrP0lq6xx3fwOGaTwGAA6f3ZHjnfvWxLilqXCP8opzJZs+Css4ErPajXK0u74g5gqnFe5xOwwolz2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFVcapgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFVcapgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A31EC4CED1;
	Wed,  5 Feb 2025 14:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764713;
	bh=LFFFPFqrQtSWOfpUdXnIz/DZOePiBqjIuSGSTTTyFRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFVcapgxAuR+cyKYSrJfr6NKcZbYrjptNYd8LGncltsGKDkJ7RhAJ2v9EfhB9vgrv
	 Reu+ykeavTWrT3Lw/1gok9TMCDK5wP0q4EJtPbmcd6ZvtDEis/WAYtX7bHF+6x+O7k
	 uWAUvdFTGnfwID2y3xrBtOT/TLDCLmd5KAa5dPMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 107/623] wifi: rtlwifi: pci: wait for firmware loading before releasing memory
Date: Wed,  5 Feb 2025 14:37:29 +0100
Message-ID: <20250205134500.310754628@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



