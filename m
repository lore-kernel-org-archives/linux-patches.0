Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE1236D4E1;
	Wed, 20 May 2026 16:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295572; cv=none; b=Jv9VdcmxxBofin8JjrObYIXtxNU7xAEoTPSGNP/TsgCU1P1BsC44hDDA5+Vdo4rRDOa/L0n7QAFRufknsOvJik57kMwdz+Q+MnhnY9QGWqDX1xkji0pHt0QBmnuSovFHYuU9qfVhqtlMJZ5NtNZIX05im8Z4tgkrp8L5MaNhhW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295572; c=relaxed/simple;
	bh=YsUZizXiRHNB0uMhgbR8uEPvFTcARZU3kqL4F+6ptV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAuNopXZs0vsVjXuaUPD6s9pzA5SqCbi0+wgXB7t04cnQcsaQoSoUFqq5+GbopFFPeOHcwESQpLBuL4Yc9rxljh95Pd7t8XlOjKtfKRZs0TeqZOnCpjpLkd8E1BhSZdCWe5M/laFHS5aVKGSdKl3nFl5j64uNB7pGpWvD5Eu8No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OrHKX8hf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OrHKX8hf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18351F000E9;
	Wed, 20 May 2026 16:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295571;
	bh=QXstX8ribzRIUoBebAksI6onnxigtBjGIQgOaSDKNdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OrHKX8hfmCiKw3Pixia18uD6bsxRuOXG9SyWM9Z/ziObcammLsrf3jEC2THvQ+afz
	 WKnLQyY+lnmNgOnh7gqvvO+kUogqD+PMsB7dHSxg0kys3b9rtd8sEYWPgvhEAIGat5
	 0cEJCdeLMj6IqfkmaYLxg9lzVugQwTEPAeIz717c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0468/1146] memory: tegra124-emc: Fix dll_change check
Date: Wed, 20 May 2026 18:11:58 +0200
Message-ID: <20260520162158.785601218@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 9597ab9a8296ab337e6820f8a717ff621078b632 ]

The code checking whether the specified memory timing enables DLL
in the EMRS register was reversed. DLL is enabled if bit A0 is low.
Fix the check.

Fixes: 73a7f0a90641 ("memory: tegra: Add EMC (external memory controller) driver")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Link: https://patch.msgid.link/20260126-fix-emc-dllchange-v1-1-47ad3bb63262@nvidia.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/tegra124-emc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memory/tegra/tegra124-emc.c b/drivers/memory/tegra/tegra124-emc.c
index ff26815e51f17..5cfbc169c5f98 100644
--- a/drivers/memory/tegra/tegra124-emc.c
+++ b/drivers/memory/tegra/tegra124-emc.c
@@ -608,7 +608,7 @@ static int tegra124_emc_prepare_timing_change(struct tegra_emc *emc,
 
 	if ((last->emc_mode_1 & 0x1) == (timing->emc_mode_1 & 0x1))
 		dll_change = DLL_CHANGE_NONE;
-	else if (timing->emc_mode_1 & 0x1)
+	else if (!(timing->emc_mode_1 & 0x1))
 		dll_change = DLL_CHANGE_ON;
 	else
 		dll_change = DLL_CHANGE_OFF;
-- 
2.53.0



