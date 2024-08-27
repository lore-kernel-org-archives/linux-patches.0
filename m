Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8256D1BB6BE;
	Tue, 27 Aug 2024 14:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770542; cv=none; b=XaBkpl/BEDJeDwJ4n/rIzfssKMnN9T55Vl01MT6yyDEQdQERW7wex2p2AseYlvBfc6Y4OuXGFZoOxSg5y2FNGost5zBjdp9HR/UE7twGflFEMiTwj0KRiHRLGr/rzdj4a9tDBjNcRBTMLm7Ng3k5Rz8NFYIUvUJHKpI5ueLggdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770542; c=relaxed/simple;
	bh=SW8C3U6EpucqLj5yzXZamxMpvprwj6zp+q/OhaysuYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkjUpwEljOYP3q1Q/I9xOAm2maV4hH8RtGqQvl2Kz8quY7ysyBUGTUVB72zf592facTCpz1llvyuMi76AQIj5PRaPz4M6eJaVj4/st6JYnEsrCyZC1AjKTVKEvTjw95NcONIEMYyl1axMaSceYdgYGfbzYYK9Jygp6/vGxG6CtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vT/uSqDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vT/uSqDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0007C4FDEE;
	Tue, 27 Aug 2024 14:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770542;
	bh=SW8C3U6EpucqLj5yzXZamxMpvprwj6zp+q/OhaysuYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vT/uSqDjeFWmsbaI0VnJ/bzOI0Sm5kzu3OnsBWVTWFR0fK69cxKkOd0mrzpWKw9AD
	 Hr6jACLtWzk5rz0feecsVvf5JGek3bmarRScxMgHE9JD5eV6SSh7XTv8U/uMoQJR//
	 KC/0XHoiaYzayS4LRorGJHfPQxDdYLsctDZ0R+mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 219/341] EDAC/skx_common: Allow decoding of SGX addresses
Date: Tue, 27 Aug 2024 16:37:30 +0200
Message-ID: <20240827143851.745814849@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit e0d335077831196bffe6a634ffe385fc684192ca ]

There are no "struct page" associations with SGX pages, causing the check
pfn_to_online_page() to fail. This results in the inability to decode the
SGX addresses and warning messages like:

  Invalid address 0x34cc9a98840 in IA32_MC17_ADDR

Add an additional check to allow the decoding of the error address and to
skip the warning message, if the error address is an SGX address.

Fixes: 1e92af09fab1 ("EDAC/skx_common: Filter out the invalid address")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20240408120419.50234-1-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/skx_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index f4b192420be47..8d18099fd528c 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -659,7 +659,7 @@ int skx_mce_check_error(struct notifier_block *nb, unsigned long val,
 	memset(&res, 0, sizeof(res));
 	res.mce  = mce;
 	res.addr = mce->addr & MCI_ADDR_PHYSADDR;
-	if (!pfn_to_online_page(res.addr >> PAGE_SHIFT)) {
+	if (!pfn_to_online_page(res.addr >> PAGE_SHIFT) && !arch_is_platform_page(res.addr)) {
 		pr_err("Invalid address 0x%llx in IA32_MC%d_ADDR\n", mce->addr, mce->bank);
 		return NOTIFY_DONE;
 	}
-- 
2.43.0



