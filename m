Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D71A1DE2B5;
	Wed, 19 Feb 2025 09:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956061; cv=none; b=oZD3IEAcIYL4I133UTwA8sDy3vyAO5unFeM4qi0jy8T9ZE3QSghJd2kfKXvp8lgH6bnfVuerE10rVojpqKNlbPq8t3Hi/07pcK7u1CrdQqMk4IaC8Ay96xtgTY8jKzXeY0GU7JXG+GkARVHh3apHtPKnJT76mqCrBopqlXYabxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956061; c=relaxed/simple;
	bh=Yr/ogtrXBvaZmHpGdZJOu3lloT4bS52tJ+Qi7wPnscM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRVFx94NWu9CUtgqYqjKZSdsUqtZl16ER9BfIoHqoLCFCBU/Gt2oEv4+fZB6bptPYvGhrojo5dS9dZpwU1WPNlqYuCqP0t2KsxS1xqMjdoBEX1UDDNyRIvm81x5TS8XtqZam3kM0LbQ/NngXgG/cypMZiuVohkL0+cabN2KAtrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ci80NaBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ci80NaBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CE6C4CED1;
	Wed, 19 Feb 2025 09:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956061;
	bh=Yr/ogtrXBvaZmHpGdZJOu3lloT4bS52tJ+Qi7wPnscM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ci80NaBCfNIizpfr2FL6aKBi6HadX8snusbwlG1VVNphCNVDqK/WaUJN5mqtwvQ9r
	 36105t+4H6MAbpvkPqnT0ySsE6LyU3/wqo/H7cSV6nYNeZ3E4iCXLrgppxAylqm0yK
	 w1jSnVmjrtsiEVU3UobJolyhMQuNiQj3bHHF8Ysc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/578] wifi: rtlwifi: pci: wait for firmware loading before releasing memory
Date: Wed, 19 Feb 2025 09:20:57 +0100
Message-ID: <20250219082654.978150318@linuxfoundation.org>
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
index 737ab425da995..2a1bc168f7715 100644
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



