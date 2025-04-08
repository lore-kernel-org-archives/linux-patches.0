Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23F5266583;
	Tue,  8 Apr 2025 11:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111044; cv=none; b=uMlmPC8mWHYhSKlWfUm7yXh2kDTyBLZDJiSyb9o8/FVraJNiFH4ZffX46AaWCnl32TImafklcUFXtGjREvCpIptayquaIo/DRXMzqGTtuZirrWY4S5yxVfEEPgPWln+jrBG2NOo0nJJ7w6dpnF/i46g4fkdG+eaZeJNgv+1IsRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111044; c=relaxed/simple;
	bh=TKgKoKXzfG7WdheUlRZ55ateawGcVwc0Srp3wr0GDc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wc2pHxY6Oc6zyWB+TxMOc5z8XOnVB2wWrr69OBo8lLcWd8ek5zP7puChQgY6F2tJq+55xSQOeN67nwQhr+mF4ok8yhH3GHi2fTuaSOQgtGSCJ5asiZGZo9ON4NaaSdAWuthC0DoejBEN343ibHjMQ+hee/52kZKB3JBKKGMa3Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2O5iWSz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2O5iWSz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5085CC4CEE5;
	Tue,  8 Apr 2025 11:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111044;
	bh=TKgKoKXzfG7WdheUlRZ55ateawGcVwc0Srp3wr0GDc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2O5iWSz6Hc56yGr+fsf++66ZM2r5d+I35Z0/CneHnPoGMo4ufV01hz6zTYq2bRQ7E
	 1kzAnUGFQjHoeGWWSvdknEb9733lClkoS/vMaECxk92Q9Az64nyWXzS6revX8bS0BR
	 JOO6T8tzQBJ7h/T9H9A3MpBlCm2eUheOFiJi1hhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Xiaochun Lee <lixc17@lenovo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 288/731] PCI: Allow relaxed bridge window tail sizing for optional resources
Date: Tue,  8 Apr 2025 12:43:05 +0200
Message-ID: <20250408104920.977094551@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 67f9085596ee55dd27b540ca6088ba0717ee511c ]

Commit 566f1dd52816 ("PCI: Relax bridge window tail sizing rules")
relaxed the bridge window requirements for non-optional size (size0)
but pbus_size_mem() also handles optional sizes (IOV resources) using
size1. This can manifest, e.g., as a failure to resize a BAR back to
its original size after it was first shrunk when device has a VF BAR
resource because the bridge window (size1) is enlarged beyond what is
strictly required to fit the downstream resources.

Allow using relaxed bridge window tail sizing rules also with the optional
resources (size1) so that the remove/realloc cycle during BAR resize
(smaller and back to the original size) does not fail unexpectedly due to
increase in bridge window size demand.

Also move add_align calculation to more logical place next to size1
assignment as they are strongly related to each other.

Link: https://lore.kernel.org/r/20241216175632.4175-5-ilpo.jarvinen@linux.intel.com
Fixes: 566f1dd52816 ("PCI: Relax bridge window tail sizing rules")
Reported-by: Michał Winiarski <michal.winiarski@intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Xiaochun Lee <lixc17@lenovo.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index d9f129a7735a5..8707c5b08cf34 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1146,7 +1146,6 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	min_align = calculate_mem_align(aligns, max_order);
 	min_align = max(min_align, win_align);
 	size0 = calculate_memsize(size, min_size, 0, 0, resource_size(b_res), min_align);
-	add_align = max(min_align, add_align);
 
 	if (bus->self && size0 &&
 	    !pbus_upstream_space_available(bus, mask | IORESOURCE_PREFETCH, type,
@@ -1159,8 +1158,21 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 	}
 
 	if (realloc_head && (add_size > 0 || children_add_size > 0)) {
+		add_align = max(min_align, add_align);
 		size1 = calculate_memsize(size, min_size, add_size, children_add_size,
 					  resource_size(b_res), add_align);
+
+		if (bus->self && size1 &&
+		    !pbus_upstream_space_available(bus, mask | IORESOURCE_PREFETCH, type,
+						   size1, add_align)) {
+			min_align = 1ULL << (max_order + __ffs(SZ_1M));
+			min_align = max(min_align, win_align);
+			size1 = calculate_memsize(size, min_size, add_size, children_add_size,
+						  resource_size(b_res), win_align);
+			pci_info(bus->self,
+				 "bridge window %pR to %pR requires relaxed alignment rules\n",
+				 b_res, &bus->busn_res);
+		}
 	}
 
 	if (!size0 && !size1) {
-- 
2.39.5



