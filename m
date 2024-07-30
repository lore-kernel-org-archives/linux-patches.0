Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8011A146D6B;
	Tue, 30 Jul 2024 16:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357453; cv=none; b=em2EMQJGUmtivI5mmhpylIz0jqS+8L8r+G5iRNN+LFNExgYKRuwgLh9EWFEVpBwLBKi4n5iR2izv3TU5s0Te4hzsiDuXgPU74/Tg9+EUk8OUlh1XTIsFFjnoLliS5SRTj4z0N5YUKE7jN0C8TRveKpvb0GGSle7dB7U/b34iscA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357453; c=relaxed/simple;
	bh=MyNjKRRED3UzTlV0YQkmkTKl3woB7SPnfOWS8G5r+gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLnQYcCKP8PlRFieMO5ONIPkpwMfU8Ssq662RFj+qMTKgkShDrvqUhRDQSS+XN+s1nVp2VprnZORjy7bICUj/IHhd9LPqOxm2YRp76tbN9aodBwrVmw9Q6QwLdCj1klwk/GOf5fCT91uriaZkJ62a9JQgQFkqvAbGpe3NP7845Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qx+A66xx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qx+A66xx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D88C4AF0C;
	Tue, 30 Jul 2024 16:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357453;
	bh=MyNjKRRED3UzTlV0YQkmkTKl3woB7SPnfOWS8G5r+gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qx+A66xxniIW2ugXYsc5Ds90iDiPC0jbAxGzVCe/C+Kycx9V2iaukX+/zFHzyAfFi
	 oWyCCa+/cwtyARItfgfAQIW248t5MoGhiamPizCp7EpuksiEU95tCjNIfDDhTJTyFE
	 vl+s6iwb9ZZZDKlDPkS7AvRQmZKgTqkA/rifuM6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 255/809] Bluetooth: btintel_pcie: Fix irq leak
Date: Tue, 30 Jul 2024 17:42:11 +0200
Message-ID: <20240730151734.667623362@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 041677e7aad6f57020aa271aafd4cb9e2af1536f ]

Free irq before releasing irq vector.

Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index dd3c0626c72d8..b8120b98a2395 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1327,6 +1327,12 @@ static void btintel_pcie_remove(struct pci_dev *pdev)
 	data = pci_get_drvdata(pdev);
 
 	btintel_pcie_reset_bt(data);
+	for (int i = 0; i < data->alloc_vecs; i++) {
+		struct msix_entry *msix_entry;
+
+		msix_entry = &data->msix_entries[i];
+		free_irq(msix_entry->vector, msix_entry);
+	}
 
 	pci_free_irq_vectors(pdev);
 
-- 
2.43.0



