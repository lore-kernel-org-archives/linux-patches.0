Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B064DEC18;
	Thu, 17 Sep 2026 17:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665298; cv=none; b=lhFvGzsmHN9OTaaCF1Cv08oM8dliGmvLzPiHFXmVr2I7ogBuVv/7FjDqnRHDQFlpRvaqrspUWsDjxoRcnDP6fVkO5w2G98pm0TNjoZs02VmJ+S5lcDA8r8BQoM/FHYoHNqt92Hh4TJ/JroF4LtwW1q2yLNxe16XxK5ftVz47468=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665298; c=relaxed/simple;
	bh=0qzTlDGPWoltegvE7cs0TXwd2zueFwRY9qXv6JhcGY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKmF16M7tj42/MbGrUFarYVMYyWYH+sS8Zpj4jjEf/7bBPJ9Z3T5b+MGA0cA3rJB8f2gMoOr9cDlRiNxNSzyVfTk568cRLshRfSW0Tt6sYPMnwNnnjH2lbPCtuuJfpTIDMRlq12n7t7SdtIWEby+4zAnDOvty3FY9+EYBl/HVAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0wxhbjZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0wxhbjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272F11F000FF;
	Thu, 17 Sep 2026 17:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665296;
	bh=Cab2AUMwS87dQojdqZzSOJbimqXebptoIj+K9+1udc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0wxhbjZLR0fR0txsYaFYFbAh/2XH+WPyJO4B3U5oHnA6JZ94k4+jaRqHeRxRuFz4
	 UP/Ou0OiyeJPOWJyhrETZ6khSQgK0Gwn0PdcyPCfmQDY8vWpyN9/hCwORbVYEdScYv
	 fZ+xmtPzeCYueir3MCeHLVnqneary6tqYH/VW8R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0659/1250] Bluetooth: btintel_pcie: Clear automask on spurious interrupts
Date: Thu, 17 Sep 2026 16:07:34 +0100
Message-ID: <20260917151609.755567036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit ea2ee8b222306208d2b094d1a11894da6c106d42 ]

On spurious interrupt where the TX and RX causes are not set, driver was
not clearing the auto mask which can block all the interrupts. Driver
needs to clear the automask even if no causes are set.

Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index c0441541c0862..6b7a8c044119a 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1462,6 +1462,9 @@ static irqreturn_t btintel_pcie_irq_msix_handler(int irq, void *dev_id)
 
 	if (unlikely(!(intr_fh | intr_hw))) {
 		/* Ignore interrupt, inta == 0 */
+		bt_warn_ratelimited("Bluetooth: btintel_pcie: Received spurious interrupt\n");
+		btintel_pcie_wr_reg32(data, BTINTEL_PCIE_CSR_MSIX_AUTOMASK_ST,
+				      BIT(entry->entry));
 		return IRQ_NONE;
 	}
 
-- 
2.53.0



