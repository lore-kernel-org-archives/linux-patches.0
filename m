Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E811990A7;
	Tue, 13 Oct 2026 12:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895962; cv=none; b=TJNzIO4QoMMR3yK63H2vkaWnDuLVo7iM6KtJgsfgtFrKO78sFJV6SmSDWFHVo/9XIZWPeStE70dJm0+D7NhU6Jk4g+iYcJRssqwVGBeqQSIizmKEo2sSZLSRBT3u3oXy01BWqgTNMfaxsO66pWLozx9YtCYbRgCMg05p95K53gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895962; c=relaxed/simple;
	bh=eb/v/NN+6dqz5Ohb8WY+hEVZeFTGvC30Vo0DB+7HKGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5OHPhxhQUWiwx9t8gmfQ9oJ/PruRCUwS2hmatGgPOwDcNbar0CouzjPW/3WD3yHNJnsepgUtG8hlOs7w9NNlWwTQ71mcsEp6zGxTiMjUO61nrpHSmOjFUjb3JNYqtiXNuXf5P0RgWmJemHf3c5rlN8ACvctjbFLLD2z1kkvoQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSzFJ6Ku; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSzFJ6Ku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A675B1F00893;
	Tue, 13 Oct 2026 12:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895961;
	bh=GSbiiV8wjfvVDuvRkN92GYV0waQr4UGw5LzrVKa7h/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NSzFJ6KufTKn8Dm/DXY3huZX6KSJ+DA7xiRwc9ZrQrGFm6MSXT3bCxcGByhUaCfDq
	 VJH/IBj1/6vhd7LwyMuLRg0cSRUNTIPcMw7y6K2PTnbMSHMP+Cx6rgRVQLQTAQmVNT
	 9QFPXlD/N4qrYsOFyccAYtDsoR4agy4aXUxt9SQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Teja Aluvala <aluvala.sai.teja@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 450/497] Bluetooth: btintel_pcie: Add shared HW reset for clean start
Date: Tue, 13 Oct 2026 13:40:17 +0200
Message-ID: <20261013112918.563592053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 647e7a727520e..29ddadad6d36a 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1023,6 +1023,13 @@ static int btintel_pcie_config_pcie(struct pci_dev *pdev,
 	if (!data->base_addr)
 		return -ENODEV;
 
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



