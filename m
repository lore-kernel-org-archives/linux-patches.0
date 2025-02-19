Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1F31DF263;
	Wed, 19 Feb 2025 09:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956503; cv=none; b=RWdK69vjns5nprmXF8PptNNL+w4yOSt2oTsJIEtZsrSXa1t8I66zs11zTITCuPO7KjK8ZwjmH68KW2pCviowqy7qLad0fOtk7xAX4PZgbIOcM0grO8mnfanXGqM7l209Hw0s0SIOA5MVZszwTwMAN5xYigGV00gR7opEv/tgNEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956503; c=relaxed/simple;
	bh=+jp2jAV+MOAiR/Cxyvew2SIDfS/rd5tla3yo8P5QyE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WJjMYApGeAQPlIhwXADrjeXdGOBYJEyNDTTmaH9L320gEF7KMcmFLjW6f8HgP6hjOTcArQKjxZDKFV6eKxAIf1SD55WFRbAoScnPnwJDJEK4LcZtiZLTpG1MbGBwFck0TR78WnmqB597tcAgHXWbvmLHCH/R5IG8vi+VrWLBUEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npac5p6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npac5p6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DC9C4CED1;
	Wed, 19 Feb 2025 09:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956503;
	bh=+jp2jAV+MOAiR/Cxyvew2SIDfS/rd5tla3yo8P5QyE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=npac5p6WnJ7UL3lRz4hQUb9bBiQz468bzpa3x6xR+bDscFIA5QkZVZ97ajMhaWCJq
	 ccgz16xgAD9icaEiZTQ+FxI7/bGSP7lGkHlR/L6YxD7PNmxOCCe1r3B+R/FkjlvNoh
	 u0vVu1ogdYIv/R8y+v1JPMgfKDjWYgu1g1Loan7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	King Dix <kingdix10@qq.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 200/578] PCI: rcar-ep: Fix incorrect variable used when calling devm_request_mem_region()
Date: Wed, 19 Feb 2025 09:23:24 +0100
Message-ID: <20250219082700.830407757@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: King Dix <kingdix10@qq.com>

[ Upstream commit 2d2da5a4c1b4509f6f7e5a8db015cd420144beb4 ]

The rcar_pcie_parse_outbound_ranges() uses the devm_request_mem_region()
macro to request a needed resource. A string variable that lives on the
stack is then used to store a dynamically computed resource name, which
is then passed on as one of the macro arguments. This can lead to
undefined behavior.

Depending on the current contents of the memory, the manifestations of
errors may vary. One possible output may be as follows:

  $ cat /proc/iomem
  30000000-37ffffff :
  38000000-3fffffff :

Sometimes, garbage may appear after the colon.

In very rare cases, if no NULL-terminator is found in memory, the system
might crash because the string iterator will overrun which can lead to
access of unmapped memory above the stack.

Thus, fix this by replacing outbound_name with the name of the previously
requested resource. With the changes applied, the output will be as
follows:

  $ cat /proc/iomem
  30000000-37ffffff : memory2
  38000000-3fffffff : memory3

Fixes: 2a6d0d63d999 ("PCI: rcar: Add endpoint mode support")
Link: https://lore.kernel.org/r/tencent_DBDCC19D60F361119E76919ADAB25EC13C06@qq.com
Tested-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Signed-off-by: King Dix <kingdix10@qq.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rcar-ep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-rcar-ep.c b/drivers/pci/controller/pcie-rcar-ep.c
index f9682df1da619..209719fb6ddcc 100644
--- a/drivers/pci/controller/pcie-rcar-ep.c
+++ b/drivers/pci/controller/pcie-rcar-ep.c
@@ -107,7 +107,7 @@ static int rcar_pcie_parse_outbound_ranges(struct rcar_pcie_endpoint *ep,
 		}
 		if (!devm_request_mem_region(&pdev->dev, res->start,
 					     resource_size(res),
-					     outbound_name)) {
+					     res->name)) {
 			dev_err(pcie->dev, "Cannot request memory region %s.\n",
 				outbound_name);
 			return -EIO;
-- 
2.39.5



