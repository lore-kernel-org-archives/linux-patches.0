Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B9417CA12;
	Mon, 10 Mar 2025 17:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629109; cv=none; b=Yy94UBca4WwVV/XAgVlM5bC/vLviQa9kuVogL4NhrPIhTSpuSzh6/999ZdQLZsBq8E2iaGFeJMk+55MhOCj4UjLGn3597yiEMm4zOO3H7uC+mNlAtRylsiNTBRXQ/wclQU2V8m/Vit+oprOErWtkgVjY1w8oNMZYgHS327hyrR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629109; c=relaxed/simple;
	bh=hTAziL1u7vC6BKiTcJ/DxLlI7gCDxjLSsxs0g16xdLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mAV3FQvv5cCAGK17GG6AUmiZg91rz1+HY0vZoZh3atjWHkwwH5EIYJbpFlq3osq665bzeFcHMpHlU+3U6QShOcDQWpeEn5Q5795rZK5YIzokMs6SIuPQxspCmc8TGYADe0zzwEGgP2L3XAC65BerH41WXFTZZ3+Slni8Tkm7tRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFN4iuFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFN4iuFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BA7C4CEE5;
	Mon, 10 Mar 2025 17:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629109;
	bh=hTAziL1u7vC6BKiTcJ/DxLlI7gCDxjLSsxs0g16xdLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFN4iuFOiY7fqAxNihBcDiF7FNSAHBa6d8jnLDqezNJB4WUjKPSh+Manr+7xfn6VR
	 AjlPZhcxcvbSREQoWwGWafywwuTrs/poTpLGSDfTZt9/Nu1TjDFwBqrW59b1sFp9IT
	 57J05dhJffAFeL4C3i+T6xMyTsC5jA0S58UUtNsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	King Dix <kingdix10@qq.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/620] PCI: rcar-ep: Fix incorrect variable used when calling devm_request_mem_region()
Date: Mon, 10 Mar 2025 17:59:55 +0100
Message-ID: <20250310170551.483563402@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index aa1cf24a5a723..c143ee1740ce7 100644
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



