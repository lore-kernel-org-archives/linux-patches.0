Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C2117E90E;
	Mon, 27 May 2024 19:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836786; cv=none; b=A7atwtfvUIJOV2AnD5wnpp1QS6yx1WHfX07/JTh7zbfqZWcphUuRP/RnzB/4/kE4MzR0yEkwnTdRxOHh9PJL+/f+s1ZKioe2iW2cYf0C1SndNhD0Nv2IzZtl2S8gwtgnSqkAuCdFakoEMV95zTDQ03+qDTMbRb0AB+1vYBhnBbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836786; c=relaxed/simple;
	bh=9cxUG7XVLpEmlAVDdW5HICZ0du52RqqEWYAHWKw43ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2A775g1PBwXWsU8PxaoWLti7VNK5tca076nOj+YfuiwHuN8oPU+c3LT+WCnj3vfSya227z4PQ48vCP+TVlZj0ehi1tnEzv1AAi80e+v/pFjcwE0QTUhuv5RXzXRFIw4XmUQ6CnqfpVpjW3w37jLT4K3l6lR4C6g/T4rOBVD9Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAbYZPH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAbYZPH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0175C32781;
	Mon, 27 May 2024 19:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836786;
	bh=9cxUG7XVLpEmlAVDdW5HICZ0du52RqqEWYAHWKw43ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAbYZPH6/EoJMn4cdLLhPCCx13R+x2lKQzd36kT2WxMdv95MoCWScLykusetAr/Sj
	 px/AhKecK2riz1hiD+r0S80KIkind6KFhfvjtbfci5eyqptz3KylCF9sySODMQXuaY
	 yqdEm4xBn6TYy+NkTh0GEkS1slKnX4693AJ6S+lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 135/427] EDAC/skx_common: Allow decoding of SGX addresses
Date: Mon, 27 May 2024 20:53:02 +0200
Message-ID: <20240527185614.466318168@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 9c5b6f8bd8bd5..27996b7924c82 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -648,7 +648,7 @@ int skx_mce_check_error(struct notifier_block *nb, unsigned long val,
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



