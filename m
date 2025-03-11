Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECD325E473;
	Tue, 11 Mar 2025 15:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706556; cv=none; b=BCvYCErtd9wBSnDLiBoeAnX+tRwnR9pryyOayD5dZGSHuTnWmY2uY8r2exPq0O6QAy2Y517cY2FM37xl4sDjSKAjYE/HlBagE5LACFH3AySoShXzHoXHgGxjg1gn2RW5ujBNVI0LdjW18f+Idq6cr14ehQ7o0anmEhq7A0lOodw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706556; c=relaxed/simple;
	bh=6NFF8G70APIc6XO489Nvbea3AaJioVHTU6f0fOvvqwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BZXIVa7KVSrd2sKZfU/ea3VClmHpHi0b6/CnlbOPOgqGBIE4zQKR6KZLIRP3wZX131nbM7K1Pc+wZi967peLnUx8zUl52sJi2SytQF7J100pCvZc22XsOuocrTutFiZfJpzMoAR1a9hCljDvSale7t7ru+94nEqzUGd2cGJ7epM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auUOR7uT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auUOR7uT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882F2C4CEE9;
	Tue, 11 Mar 2025 15:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706556;
	bh=6NFF8G70APIc6XO489Nvbea3AaJioVHTU6f0fOvvqwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auUOR7uToHrUQOS18f9425blIfnQ7IAA/6uwDNpq/F6Q9DepynFt4NK3yasE333h6
	 G9U8g3hdQ/2Gb1/eV4K4ukgUYaSCjSFPQts8ZBilOe0uMBHc06PUChm7FvukGHvsN4
	 yPXFiFWGJUFec271Hm6Zu2NNBXsRjs7FxgVBsPys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	King Dix <kingdix10@qq.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/462] PCI: rcar-ep: Fix incorrect variable used when calling devm_request_mem_region()
Date: Tue, 11 Mar 2025 15:55:55 +0100
Message-ID: <20250311145801.866853758@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c91d85b151290..fc85263797e91 100644
--- a/drivers/pci/controller/pcie-rcar-ep.c
+++ b/drivers/pci/controller/pcie-rcar-ep.c
@@ -110,7 +110,7 @@ static int rcar_pcie_parse_outbound_ranges(struct rcar_pcie_endpoint *ep,
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



