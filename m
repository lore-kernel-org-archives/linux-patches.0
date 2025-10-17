Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D5433291F;
	Fri, 17 Oct 2025 15:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713295; cv=none; b=t2ThourTehGQmKT8j0Y1XGEuInq9CqvALEk4ziNUOjx6maJhw/TXluPFJHSbOEMjOAUKUOddQPhf+EYmYGFKT5bkT9WdSz80USWQqGYLASzaXlV6zCx66jG02WcadIS439g0vR6t05DIPvxtE3OLVAeZS3qD30EUuY4B0wYTsOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713295; c=relaxed/simple;
	bh=XiqmK2+2I6BSBlu2quLF6RTFKQeiwGpNZheKk2n2WRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UADyfh2VIRHxXcsKVfvGvhOhml9vAMsmUb+BYP8cWZz7lDGKFgkXyXkEkVQXZVOOlYhv1I8ZXo389h+m+vEuMcRzzbjZSYdbZ/ym1t+WRmdA0Z091XKHQuuuwhZWZnAirzW4JN5QJUmSdgBBkiUWilyGYubbpheXZaKeY9l76UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRsRqfY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRsRqfY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363EEC113D0;
	Fri, 17 Oct 2025 15:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713294;
	bh=XiqmK2+2I6BSBlu2quLF6RTFKQeiwGpNZheKk2n2WRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRsRqfY1bzKqbTmOj3zZA1EbxhtBLiMppRRc18eYfcseGOu/kVXcfPm3LvyAyEB8H
	 BYOPqjWaQFJ6JbrtZBtgDBzA79iZlVsEU897iEE1/UeZGFWNiKXidsHGf1KX7gwCx2
	 vZXCWO1ZKpY1eJzrDTDCnYmgf6ERxYRkZDKq7doo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duy Nguyen <duy.nguyen.rh@renesas.com>,
	Thuan Nguyen <thuan.nguyen-hong@banvien.com.vn>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 6.1 115/168] PCI: rcar-host: Drop PMSR spinlock
Date: Fri, 17 Oct 2025 16:53:14 +0200
Message-ID: <20251017145133.262216042@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

commit 0a8f173d9dad13930d5888505dc4c4fd6a1d4262 upstream.

The pmsr_lock spinlock used to be necessary to synchronize access to the
PMSR register, because that access could have been triggered from either
config space access in rcar_pcie_config_access() or an exception handler
rcar_pcie_aarch32_abort_handler().

The rcar_pcie_aarch32_abort_handler() case is no longer applicable since
commit 6e36203bc14c ("PCI: rcar: Use PCI_SET_ERROR_RESPONSE after read
which triggered an exception"), which performs more accurate, controlled
invocation of the exception, and a fixup.

This leaves rcar_pcie_config_access() as the only call site from which
rcar_pcie_wakeup() is called. The rcar_pcie_config_access() can only be
called from the controller struct pci_ops .read and .write callbacks,
and those are serialized in drivers/pci/access.c using raw spinlock
'pci_lock' . It should be noted that CONFIG_PCI_LOCKLESS_CONFIG is never
set on this platform.

Since the 'pci_lock' is a raw spinlock , and the 'pmsr_lock' is not a
raw spinlock, this constellation triggers 'BUG: Invalid wait context'
with CONFIG_PROVE_RAW_LOCK_NESTING=y .

Remove the pmsr_lock to fix the locking.

Fixes: a115b1bd3af0 ("PCI: rcar: Add L1 link state fix into data abort hook")
Reported-by: Duy Nguyen <duy.nguyen.rh@renesas.com>
Reported-by: Thuan Nguyen <thuan.nguyen-hong@banvien.com.vn>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250909162707.13927-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-rcar-host.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/drivers/pci/controller/pcie-rcar-host.c
+++ b/drivers/pci/controller/pcie-rcar-host.c
@@ -65,20 +65,13 @@ struct rcar_pcie_host {
 	int			(*phy_init_fn)(struct rcar_pcie_host *host);
 };
 
-static DEFINE_SPINLOCK(pmsr_lock);
-
 static int rcar_pcie_wakeup(struct device *pcie_dev, void __iomem *pcie_base)
 {
-	unsigned long flags;
 	u32 pmsr, val;
 	int ret = 0;
 
-	spin_lock_irqsave(&pmsr_lock, flags);
-
-	if (!pcie_base || pm_runtime_suspended(pcie_dev)) {
-		ret = -EINVAL;
-		goto unlock_exit;
-	}
+	if (!pcie_base || pm_runtime_suspended(pcie_dev))
+		return -EINVAL;
 
 	pmsr = readl(pcie_base + PMSR);
 
@@ -100,8 +93,6 @@ static int rcar_pcie_wakeup(struct devic
 		writel(L1FAEG | PMEL1RX, pcie_base + PMSR);
 	}
 
-unlock_exit:
-	spin_unlock_irqrestore(&pmsr_lock, flags);
 	return ret;
 }
 


