Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C214E4C2C;
	Thu, 17 Sep 2026 15:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659002; cv=none; b=BYnBiBlBXukPQylvWU2GVhfFxpjzHzc6mLrxBsx0CCHVY+cRWltIoqkY0EfL51mQ1i/RONiu0A/FfUbhFJAUoVdE0irBLXTl+VYoOo2G8O/AiSsAqhNU+5mH3E4UPntHtzmkTJfS/73OPjc6INz1r+3D9KeOGTwJkm8u9uR6hG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659002; c=relaxed/simple;
	bh=HFzPYGRO//bLRs1c3l/+Bv3HOapYgt1wOz8CxGPQfQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWyzVH2qMiAlNbSnRi00zu4QkD5Gt2ouWwupd1f8pESLA/+QAFLi/VHO/0szDTBFRTeCcRzOXe0XcW9d+fHAnemx8zDU+BpJEHgxFRSwLkBOSkdLE5IbWYES55NXSrZ9ihMkHGKUdTgXDhEkeay8jsyLjmtmsyUfokaKQj5qfHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgBd9v0L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgBd9v0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0439A1F000FF;
	Thu, 17 Sep 2026 15:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658995;
	bh=vA0qzMrZrc2jMuYOtjxbLNjWh4VJ/5ndpk8ESQorvlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RgBd9v0L8nIyLts3O+6dBYjF5PJIJg9jTVeBdBK/tqcJumwyyxzRalyS4WMViBmQD
	 aqaMksuHs4AwdU/X8uGuZmtc7aavov8XRZprIzlCs+lGKNqo24Uh4g2WTKCoc2lYi/
	 hei8hSr9708EORUzlm149H0deaklmg/oMJyHv+gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 107/733] Bluetooth: btintel_pcie: Clear automask on spurious interrupts
Date: Thu, 17 Sep 2026 16:06:55 +0100
Message-ID: <20260917151353.638130485@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index 2b7231be5973d..6b6258d03dd84 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1634,6 +1634,9 @@ static irqreturn_t btintel_pcie_irq_msix_handler(int irq, void *dev_id)
 
 	if (unlikely(!(intr_fh | intr_hw))) {
 		/* Ignore interrupt, inta == 0 */
+		bt_warn_ratelimited("Bluetooth: btintel_pcie: Received spurious interrupt\n");
+		btintel_pcie_wr_reg32(data, BTINTEL_PCIE_CSR_MSIX_AUTOMASK_ST,
+				      BIT(entry->entry));
 		return IRQ_NONE;
 	}
 
-- 
2.53.0



