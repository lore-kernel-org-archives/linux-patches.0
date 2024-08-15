Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E94963C;
	Thu, 15 Aug 2024 14:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732169; cv=none; b=QbsBaLcL4kh+MCSEP0hv1bA04vqnyaiAZbbDzPJahLXoRYJCvrEgw8g5pIODScrD6e5vusGJVAvQxZTDNl37l4AH36MOX74+7oMG81EqMcFTPtSbaCDJ9ueyq5JoyIokjl5/+WqQJ9vF7miTydBjNhcXs2oJ1+QDu8tnbD0g06w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732169; c=relaxed/simple;
	bh=5i3EJYl4RhAO9jD/9jWXdAAR/yJ9R8xKdRg5/5pGXZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HEEaZGUbmiWDNedrmSYxgpnpJSX8mbvR9za9uyU2w9FsGo0X/I8Gf/McrN4s6e7uDL+xKkRE8HEe36UT6rdH0+yUWnOEhF3tD5qPRv6m7iK66LNuM16w/y/3e4zfJG/vxiShluoWGWAlZ4bajMdZVY+saFU3qaAaJuKoxtflI60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4rIhfBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4rIhfBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A928AC32786;
	Thu, 15 Aug 2024 14:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732169;
	bh=5i3EJYl4RhAO9jD/9jWXdAAR/yJ9R8xKdRg5/5pGXZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4rIhfBUTMJ8R6oCvgN9UM03VaO9MBna97XIb1NyRQ9MqVs+rOTAFziuQjj4INNV+
	 qhpqaWUD03eH7+WF7IUPl/hTTtvvFlpO0q8RKThdRLJOSnbQZpLWiYHVkB0PHVbqyc
	 tUQz2uw9W9j6wMBiQiCzJbaHJQJl64s1GHU87LfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lidong Wang <lidong.wang@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/352] PCI: Fix resource double counting on remove & rescan
Date: Thu, 15 Aug 2024 15:22:42 +0200
Message-ID: <20240815131922.970848408@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



