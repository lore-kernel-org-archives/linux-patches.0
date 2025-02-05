Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E933C189F39;
	Wed,  5 Feb 2025 14:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767212; cv=none; b=OFpCB86Adn+OsfDX6jVd42/xKLectHmf7DzU0ZgQvcGmToZy2hogqpm8yn+c/XEfoX/ljoOq3fnzJDeUB6M9aStJaQEzNrSmddte3VcPAoTgbuTVOWvN1haj9QTbnjY7ZFXNVYHKCAyCQ0pnA7OYcDk8z5MI0kw7UacvqAr5DpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767212; c=relaxed/simple;
	bh=dgH5h+jENCAf/0QKfokHNUK2Ne1koiHET6tiVRMPvf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PgP5eE5xHsLP1OM/RLLIXn8O3D9/kf4LBsq9LV2xWCpOWP35rWq4l/KFCIxW+Ehe5qqCfIStzCeefmCqpZ9HfdcXQwDWNp12eoJDx0nOFk0bF0uhaowC2XjfaDObRTiyngxFG4CFtR0rPhEsFUw+17MT1te+ajiu06uL+bKqPY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aTmRFgoI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aTmRFgoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AF9C4CEDD;
	Wed,  5 Feb 2025 14:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767211;
	bh=dgH5h+jENCAf/0QKfokHNUK2Ne1koiHET6tiVRMPvf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aTmRFgoI1ukmrBwswxHC4aBguDvJzOLhNgRf/65RRBv7b5Pdcxg3WTCO8TV797oyt
	 6BEy5Jq2IrrkkX7cvxK4W8egHykUPQov3b3LBl+B/Y7ols/7OgZUgKmeIZT5hDAU9U
	 JXz9uz0isrrSj0/zHQIErlGGk/XRLe7x+B1POLMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	King Dix <kingdix10@qq.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 424/590] PCI: rcar-ep: Fix incorrect variable used when calling devm_request_mem_region()
Date: Wed,  5 Feb 2025 14:42:59 +0100
Message-ID: <20250205134511.487341607@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 047e2cef5afcd..c5e0d025bc435 100644
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



