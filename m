Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD79522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45C6C433C8;
	Sun,  9 Jul 2023 11:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902353;
	bh=L+jGtsg6pLirPNin5WnsDPkOYrNzMY7RWJ4E4xpB4SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1CK4JkqnTkz6o/quSd6oGpFsMuvqiNg5iMoc7vixnFntoB8vMflV5IO/GDHKKoRKF
	 KnDTPg3OSBVNNXGscd/uKrLArphzp0nm2aCCKA3ok6HyC8PnZZCePBbltjSjuG8cmJ
	 yq6/TjxVqln1nLtKoDUlyYeLGonkOaRs8XOvuI2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ding Hui <dinghui@sangfor.com.cn>,
	Sasha Levin <sashal@kernel.org>,
	Zongquan Qin <qinzongquan@sangfor.com.cn>
Subject: [PATCH 6.3 346/431] PCI/ASPM: Disable ASPM on MFD function removal to avoid use-after-free
Date: Sun,  9 Jul 2023 13:14:54 +0200
Message-ID: <20230709111459.279120365@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ding Hui <dinghui@sangfor.com.cn>

[ Upstream commit 456d8aa37d0f56fc9e985e812496e861dcd6f2f2 ]

Struct pcie_link_state->downstream is a pointer to the pci_dev of function
0.  Previously we retained that pointer when removing function 0, and
subsequent ASPM policy changes dereferenced it, resulting in a
use-after-free warning from KASAN, e.g.:

  # echo 1 > /sys/bus/pci/devices/0000:03:00.0/remove
  # echo powersave > /sys/module/pcie_aspm/parameters/policy

  BUG: KASAN: slab-use-after-free in pcie_config_aspm_link+0x42d/0x500
  Call Trace:
   kasan_report+0xae/0xe0
   pcie_config_aspm_link+0x42d/0x500
   pcie_aspm_set_policy+0x8e/0x1a0
   param_attr_store+0x162/0x2c0
   module_attr_store+0x3e/0x80

PCIe spec r6.0, sec 7.5.3.7, recommends that software program the same ASPM
Control value in all functions of multi-function devices.

Disable ASPM and free the pcie_link_state when any child function is
removed so we can discard the dangling pcie_link_state->downstream pointer
and maintain the same ASPM Control configuration for all functions.

[bhelgaas: commit log and comment]
Debugged-by: Zongquan Qin <qinzongquan@sangfor.com.cn>
Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Fixes: b5a0a9b59c81 ("PCI/ASPM: Read and set up L1 substate capabilities")
Link: https://lore.kernel.org/r/20230507034057.20970-1-dinghui@sangfor.com.cn
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 66d7514ca111b..db32335039d61 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1010,21 +1010,24 @@ void pcie_aspm_exit_link_state(struct pci_dev *pdev)
 
 	down_read(&pci_bus_sem);
 	mutex_lock(&aspm_lock);
-	/*
-	 * All PCIe functions are in one slot, remove one function will remove
-	 * the whole slot, so just wait until we are the last function left.
-	 */
-	if (!list_empty(&parent->subordinate->devices))
-		goto out;
 
 	link = parent->link_state;
 	root = link->root;
 	parent_link = link->parent;
 
-	/* All functions are removed, so just disable ASPM for the link */
+	/*
+	 * link->downstream is a pointer to the pci_dev of function 0.  If
+	 * we remove that function, the pci_dev is about to be deallocated,
+	 * so we can't use link->downstream again.  Free the link state to
+	 * avoid this.
+	 *
+	 * If we're removing a non-0 function, it's possible we could
+	 * retain the link state, but PCIe r6.0, sec 7.5.3.7, recommends
+	 * programming the same ASPM Control value for all functions of
+	 * multi-function devices, so disable ASPM for all of them.
+	 */
 	pcie_config_aspm_link(link, 0);
 	list_del(&link->sibling);
-	/* Clock PM is for endpoint device */
 	free_link_state(link);
 
 	/* Recheck latencies and configure upstream links */
@@ -1032,7 +1035,7 @@ void pcie_aspm_exit_link_state(struct pci_dev *pdev)
 		pcie_update_aspm_capable(root);
 		pcie_config_aspm_path(parent_link);
 	}
-out:
+
 	mutex_unlock(&aspm_lock);
 	up_read(&pci_bus_sem);
 }
-- 
2.39.2



