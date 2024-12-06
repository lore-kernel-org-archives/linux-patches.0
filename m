Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033AC1474A9;
	Fri,  6 Dec 2024 14:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496246; cv=none; b=hRkbCRPIz5gowpRWzkDXvEZu+50Q7Mb4EKCcVjagrOf9SHT6kQT2VR+sfVAQLb8kwJoEyYvB0upICojxH6WAFZ8mc9i98shkL4J4Ek3ChYOy2n23wM1fMifRAR9m5h42o90aO8JKM6TWIH2TEJH0Lan0DxXGMuTo2sVXdCfURsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496246; c=relaxed/simple;
	bh=q/YqmTuva0TI/4hGmWdsWaK092rrBWUDnKmi8NUwVkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FZUYFYx0vlrAtdBT7ECIOM/iffAMz6IN1W8zzag1hP3nhUqRV+nodt2HmsDknaZkh/5DnDSaBde/B11k1/vDINP9Dp9YI6AzGTi5vGgiNaUJTN3v+jV50RwoQsIrcQfGTs7xAQ6fFveuuePMW7OrNodTE2iwZ6EWROvrS41d40o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UxtRigh+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UxtRigh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644EAC4CED1;
	Fri,  6 Dec 2024 14:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496245;
	bh=q/YqmTuva0TI/4hGmWdsWaK092rrBWUDnKmi8NUwVkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxtRigh+dK3dCIYlaVXPtiw6XTbAgTwSAcdYX4hP3AcGHu9W0W1ns/evXxb336ySx
	 NmDD7j5PBghzDG7034D3KD5IJRs4IHbUg7Hy0WoPyYhz3HhPLBpfg9ALRWjnkxTXsc
	 xJsLRR13KdElam8k8AuhHAtbxKdF9mIhUjJc2Nqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.12 096/146] PCI: dwc: ep: Fix advertised resizable BAR size regression
Date: Fri,  6 Dec 2024 15:37:07 +0100
Message-ID: <20241206143531.352973474@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Niklas Cassel <cassel@kernel.org>

commit 118397c9baaac0b7ec81896f8d755d09aa82c485 upstream.

The advertised resizable BAR size was fixed in commit 72e34b8593e0 ("PCI:
dwc: endpoint: Fix advertised resizable BAR size").

Commit 867ab111b242 ("PCI: dwc: ep: Add a generic dw_pcie_ep_linkdown()
API to handle Link Down event") was included shortly after this, and
moved the code to another function. When the code was moved, this fix
was mistakenly lost.

According to the spec, it is illegal to not have a bit set in
PCI_REBAR_CAP, and 1 MB is the smallest size allowed.

So, set bit 4 in PCI_REBAR_CAP, so that we actually advertise support
for a 1 MB BAR size.

Fixes: 867ab111b242 ("PCI: dwc: ep: Add a generic dw_pcie_ep_linkdown() API to handle Link Down event")
Link: https://lore.kernel.org/r/20241116005950.2480427-2-cassel@kernel.org
Link: https://lore.kernel.org/r/20240606-pci-deinit-v1-3-4395534520dc@linaro.org
Link: https://lore.kernel.org/r/20240307111520.3303774-1-cassel@kernel.org
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-designware-ep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pcie-designware-ep.c
+++ b/drivers/pci/controller/dwc/pcie-designware-ep.c
@@ -689,7 +689,7 @@ static void dw_pcie_ep_init_non_sticky_r
 		 * for 1 MB BAR size only.
 		 */
 		for (i = 0; i < nbars; i++, offset += PCI_REBAR_CTRL)
-			dw_pcie_writel_dbi(pci, offset + PCI_REBAR_CAP, 0x0);
+			dw_pcie_writel_dbi(pci, offset + PCI_REBAR_CAP, BIT(4));
 	}
 
 	dw_pcie_setup(pci);


