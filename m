Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61374E4302;
	Tue, 13 Oct 2026 11:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892480; cv=none; b=cisrIUMLNNWh3AfymkLj5fzdbL+PYiXY6Raxq0BJpWJVOaaW800cTfjDuDTdmGZB6jpTmO191J+iKQO09+BNoFg3PxibMxYj81RNXYkZgfQvME5/6Feqy+il5xD8zGDyWEZ+dsO0pGTsV6EWW88BmB9uiQkqSGha0E+Yy5FhAcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892480; c=relaxed/simple;
	bh=Vlfs4SJ6Qhu4o/hPpVdjGXcMNjtW5jZsARUDP0T/ooo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzLGA+X44UwSCeC4POMg3d2tcgmrHSiUk9Kt9ANErCCyrGKBAeyOp6XGVXuvA6NsKhJLpxE/yJjbN3q+sLEKrxGX6Fc0Whd1wVRs/BS0pydP4qD16DEHsCFooXioC0R1ZGedMKv2PYRtDCkoLIHSxEeG6RWCBOt63gTUUT7sxG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOB/NxZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOB/NxZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA4E1F000FF;
	Tue, 13 Oct 2026 11:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892479;
	bh=wgSQCKwEb5SwJx5/gpj/Tswu/URwMcZNzZwd5WfpssQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sOB/NxZ1YXDc3nOYGqNtnofoiZxmXKvhqMeV3fVdAh9Y8p8FT/JBMQ5v/rHvAb0Oc
	 EnH1iYfF6+uyYrb2P2HpG7VwWetzDNEAZiGkYk0dHWioWge6Mfq9nGCYhkaf/nkmNY
	 BGyK8Ny9ReQAWCx872f9YAnTJbVLvdkEN4yG0++M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Teja Aluvala <aluvala.sai.teja@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 188/281] Bluetooth: btintel_pcie: Add shared HW reset for clean start
Date: Tue, 13 Oct 2026 13:38:24 +0200
Message-ID: <20261013112859.727702654@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sai Teja Aluvala <aluvala.sai.teja@intel.com>

[ Upstream commit 1465494e8d07426fa41c0021530cccb2a1ac38fa ]

Reset shared Bluetooth hardware after mapping the BAR and before setting
up MSI-X interrupts, so stale device state is cleared before IRQ handlers
and interrupt masks are configured.

Propagate reset errors so probe aborts rather than continuing when the
reset fails.

Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Signed-off-by: Sai Teja Aluvala <aluvala.sai.teja@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 34899a5507339..ed4ba2e469ac7 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1819,6 +1819,13 @@ static int btintel_pcie_config_pcie(struct pci_dev *pdev,
 	if (IS_ERR(data->base_addr))
 		return PTR_ERR(data->base_addr);
 
+	/* Do shared hardware reset to ensure a clean start before
+	 * configuring interrupts.
+	 */
+	err = btintel_pcie_reset_bt(data);
+	if (err)
+		return err;
+
 	err = btintel_pcie_setup_irq(data);
 	if (err)
 		return err;
-- 
2.53.0



