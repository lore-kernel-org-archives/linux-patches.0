Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FE822488E;
	Tue,  8 Apr 2025 12:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115707; cv=none; b=e2iWGqXKmxx0s9Y8LwyUr7YwZzJgCkoCAPCkkJYqt93zghZ1eD3smpTU+3e8OSp2eLM/KG/8yVInsN8DDma8wW67OCRtfqOJircL3B228+HTT1z+zj0zUvczZWgQnJ6j89QNQFKkoY/JLh8c4G+asZ+qreGfN16A0OBgX/iAXNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115707; c=relaxed/simple;
	bh=dtO7xHLCsM52V7ny7hfYHJB4fYF0aT2NI2z0PhrsqpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TyNyigPkKlzwRTFfKmXM4qYNj7ffKoexKn4ElJi7Nd7MsBKrMWjApThyzCdaxBUiLzYQNa9WR+svgerF0IEMY7bMXmIh9EL4I3MAZalUev3cC8xXPhgb/AtXzG7sNySX0bvuWm77mLjX6XCCbiiRdkWRZ0+NyIcAdNVvNEQ3SaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otSpE+wD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otSpE+wD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEA2C4CEE5;
	Tue,  8 Apr 2025 12:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115707;
	bh=dtO7xHLCsM52V7ny7hfYHJB4fYF0aT2NI2z0PhrsqpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otSpE+wDEcu5V/9fAusgUi63DWABVd+g5guK27NQDDJ3t59KLYUSku4seG7eFE2YP
	 N602S7iHoLEN26TRWmWrweIGYtMlYMAN1ckt7iQrfwpaYb//EAjX98fiXf2mRziA/w
	 4KOvtNM8bzV8MB3hZkppAFnjXgnHHhucK0+lmrCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Stodden <dns@arista.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/204] PCI/ASPM: Fix link state exit during switch upstream function removal
Date: Tue,  8 Apr 2025 12:49:25 +0200
Message-ID: <20250408104821.369522142@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

From: Daniel Stodden <daniel.stodden@gmail.com>

[ Upstream commit cbf937dcadfd571a434f8074d057b32cd14fbea5 ]

Before 456d8aa37d0f ("PCI/ASPM: Disable ASPM on MFD function removal to
avoid use-after-free"), we would free the ASPM link only after the last
function on the bus pertaining to the given link was removed.

That was too late. If function 0 is removed before sibling function,
link->downstream would point to free'd memory after.

After above change, we freed the ASPM parent link state upon any function
removal on the bus pertaining to a given link.

That is too early. If the link is to a PCIe switch with MFD on the upstream
port, then removing functions other than 0 first would free a link which
still remains parent_link to the remaining downstream ports.

The resulting GPFs are especially frequent during hot-unplug, because
pciehp removes devices on the link bus in reverse order.

On that switch, function 0 is the virtual P2P bridge to the internal bus.
Free exactly when function 0 is removed -- before the parent link is
obsolete, but after all subordinate links are gone.

Link: https://lore.kernel.org/r/e12898835f25234561c9d7de4435590d957b85d9.1734924854.git.dns@arista.com
Fixes: 456d8aa37d0f ("PCI/ASPM: Disable ASPM on MFD function removal to avoid use-after-free")
Signed-off-by: Daniel Stodden <dns@arista.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index cf4acea6610d5..20ec2a4aae65f 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1031,16 +1031,16 @@ void pcie_aspm_exit_link_state(struct pci_dev *pdev)
 	parent_link = link->parent;
 
 	/*
-	 * link->downstream is a pointer to the pci_dev of function 0.  If
-	 * we remove that function, the pci_dev is about to be deallocated,
-	 * so we can't use link->downstream again.  Free the link state to
-	 * avoid this.
+	 * Free the parent link state, no later than function 0 (i.e.
+	 * link->downstream) being removed.
 	 *
-	 * If we're removing a non-0 function, it's possible we could
-	 * retain the link state, but PCIe r6.0, sec 7.5.3.7, recommends
-	 * programming the same ASPM Control value for all functions of
-	 * multi-function devices, so disable ASPM for all of them.
+	 * Do not free the link state any earlier. If function 0 is a
+	 * switch upstream port, this link state is parent_link to all
+	 * subordinate ones.
 	 */
+	if (pdev != link->downstream)
+		goto out;
+
 	pcie_config_aspm_link(link, 0);
 	list_del(&link->sibling);
 	free_link_state(link);
@@ -1051,6 +1051,7 @@ void pcie_aspm_exit_link_state(struct pci_dev *pdev)
 		pcie_config_aspm_path(parent_link);
 	}
 
+ out:
 	mutex_unlock(&aspm_lock);
 	up_read(&pci_bus_sem);
 }
-- 
2.39.5



