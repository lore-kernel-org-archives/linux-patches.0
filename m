Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820034E7816;
	Tue, 13 Oct 2026 12:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894497; cv=none; b=jeLCZwEI+Iqt3JsHKEfyJBsZ+8/t52smE+P9K6cD1LpyRU8lU3LCdmB+gjEaSA6n3gJDRd3QX3Yo4qLOycTZkE75Y/B01FYY9IM4GA4FlnqvDtV7aKpXffvIwnHANZN7F8z8+YtgM7SYbvQLvqHfIW9k+Z9Y/qqvI6m8LXblymQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894497; c=relaxed/simple;
	bh=Mbt5A9SuYXSjHJu/32l8fO6xt/vn2pYBWPd+VZhDtBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4r2wqNhq/Hv/yHW+ZqhJIXo9rRgQWzrQzMZdh9B+lvW9YIK2QC3cbZIHzhQE+Fiy915aSX2DtOVd0Wd7FtJHWS9ljAxCZMAdbBS/W4DIQp7I02bdoUc5p5H0GvtUjBTaKFHbMA2oDQu0VQihHpg6lIUTe9dfVP9pZpyElmZBUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKGwZUyx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKGwZUyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B961F000FF;
	Tue, 13 Oct 2026 12:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894496;
	bh=8xqEHj3pdhf0Z1tNT2AjAerGWL8NFr2oIIRqZnyS9bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKGwZUyxylCQafC+lVyRerlJPxZKW6gTiTRKgUqHkp4d1tlZJJwbF5ltpwwWUztee
	 YXdL/212AYtNAuaGvCL8CZt6w0ntE4UtarhwuXXmHd/9Euz5jCKf86D0LbB2yiSSrM
	 XGDSw/97igAyDiL46C61ilQxo6jpdUU0J2IiOWuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Teja Aluvala <aluvala.sai.teja@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 536/621] Bluetooth: btintel_pcie: Add shared HW reset for clean start
Date: Tue, 13 Oct 2026 13:38:51 +0200
Message-ID: <20261013112933.538925736@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 87f8b8b93f2ed..3e8c894fbf640 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1643,6 +1643,13 @@ static int btintel_pcie_config_pcie(struct pci_dev *pdev,
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



