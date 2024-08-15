Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D583419FA9D;
	Thu, 15 Aug 2024 13:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729510; cv=none; b=WuSPYDF43fC3b+6HP29OEzfttYVTMWRxQ66gUPNv+Ubs78O/HA21JGqVj1/pSc3YRVsswghRiciibjXJjkWdvbVvlpM08liv8YL41HXsCA1JCS+EEVovGhWwd+4dhT3Rak9Fyy0kJ+kQmWk4cy1Q6VWibNtKS/lWip6r4iGpQO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729510; c=relaxed/simple;
	bh=RoVkF2NScyNb0nvtEdgkYIj07aC9c12vHiaXmFqpFbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CwFn8ESAtrUzXKYfmjrhyNKUNOkUGEJpfgBRcs5J0ZHJfpT9EhwCdEC1rn+VJNqJ/9k9nZXrSCqQD+aIwlQs87hlD9ASjonxkYkZ51zkOS6FESsZpEqvZL0Naq5kn/ff5krDqUqbcxob6uSM3eQgFblvq1tHZzrE0FCouL4F9uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FN6OirEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FN6OirEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1048FC32786;
	Thu, 15 Aug 2024 13:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729510;
	bh=RoVkF2NScyNb0nvtEdgkYIj07aC9c12vHiaXmFqpFbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FN6OirEUwk7jH+XjvLaLRXatW+p22q54UOYopJTSzIXtHDWf7ZbUxKBtl/Qvun1+F
	 RPW04rYRU7icr3JS7q7XnHFk3kkSk7zJCmatPgyLovPm0GyWrj9swVIN26oaaBBsFh
	 xapAORHB1CFB/GbhS7HkvUoUaC1mmRTruNXtJKJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lidong Wang <lidong.wang@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/484] PCI: Fix resource double counting on remove & rescan
Date: Thu, 15 Aug 2024 15:19:38 +0200
Message-ID: <20240815131945.927626233@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 903534fa7d30214d8ba840ab1cd9e917e0c88e41 ]

pbus_size_mem() keeps the size of the optional resources in
children_add_size. When calculating the PCI bridge window size,
calculate_memsize() lower bounds size by old_size before adding
children_add_size and performing the window size alignment. This
results in double counting for the resources in children_add_size
because old_size may be based on the previous size of the bridge
window after it has already included children_add_size (that is,
size1 in pbus_size_mem() from an earlier invocation of that
function).

As a result, on repeated remove of the bus & rescan cycles the resource
size keeps increasing when children_add_size is non-zero as can be seen
from this extract:

  iomem0:  23fffd00000-23fffdfffff : PCI Bus 0000:03    # 1MiB
  iomem1:  20000000000-200001fffff : PCI Bus 0000:03    # 2MiB
  iomem2:  20000000000-200002fffff : PCI Bus 0000:03    # 3MiB
  iomem3:  20000000000-200003fffff : PCI Bus 0000:03    # 4MiB
  iomem4:  20000000000-200004fffff : PCI Bus 0000:03    # 5MiB

Solve the double counting by moving old_size check later in
calculate_memsize() so that children_add_size is already accounted for.

After the patch, the bridge window retains its size as expected:

  iomem0:  23fffd00000-23fffdfffff : PCI Bus 0000:03    # 1MiB
  iomem1:  20000000000-200000fffff : PCI Bus 0000:03    # 1MiB
  iomem2:  20000000000-200000fffff : PCI Bus 0000:03    # 1MiB

Fixes: a4ac9fea016f ("PCI : Calculate right add_size")
Link: https://lore.kernel.org/r/20240507102523.57320-2-ilpo.jarvinen@linux.intel.com
Tested-by: Lidong Wang <lidong.wang@intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 16d291e10627b..a159bfdfa2512 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -824,11 +824,9 @@ static resource_size_t calculate_memsize(resource_size_t size,
 		size = min_size;
 	if (old_size == 1)
 		old_size = 0;
-	if (size < old_size)
-		size = old_size;
 
-	size = ALIGN(max(size, add_size) + children_add_size, align);
-	return size;
+	size = max(size, add_size) + children_add_size;
+	return ALIGN(max(size, old_size), align);
 }
 
 resource_size_t __weak pcibios_window_alignment(struct pci_bus *bus,
-- 
2.43.0



