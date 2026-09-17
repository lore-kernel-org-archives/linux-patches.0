Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682BA4D9F6E;
	Thu, 17 Sep 2026 18:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668811; cv=none; b=aQ2z/Ma+1RZWQc9hVdaQDKKMdV4tg3UcJ1CZq8+8tSKMEoH144mulw9q51ik6Vln33kKxg27/5naUP9aYi1tb5CwjxxNPU4XSRSqyis8+s93Q3CoObAqqoVTNob6HFvx1j5xKoN4mhcdVrmcAsGfWGSC/zuqY3+gw2JWFOBYAy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668811; c=relaxed/simple;
	bh=OQi4dKtzL/nRj7KM/62ho8ZFbDPc/G5Shv/DzwiSlck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ga4FmN4AyFkAxdtqCGwB2cK5phY4ror2Hi6ReOBDqO8RWYBCsFrKitDbInM9/h2jnJNTFmz8wWIyGbG0edCfHjYAlXkkb2ldxoy0fowFCTfTQGG50ukHrLjl3QEtjcdRh75MfKp8XiJ+eXEHg1x7LWZodbZ1Txrb7C6k6upqY2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imWc82BA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imWc82BA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A5D1F000FF;
	Thu, 17 Sep 2026 18:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668809;
	bh=wJorrgkIdMTlkpy1uaq867/OmxekdeQqBtx4zoV+s8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=imWc82BAMAx/9rb22csue/FPPG91xwogX0x0tBcowNcPjdv9hIgAojUAeALoIqmSx
	 HyfWl56tFraBpDou0dGmDPBVSKS2iCyu/lAT57dLZjIv9wLqq8nhMqxb4XyYQX5ghz
	 9B5U6Ri5RCbWM1sSqXH5x765JW8OwrZyX55RSiZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0547/1102] Bluetooth: btintel_pcie: Clear automask on spurious interrupts
Date: Thu, 17 Sep 2026 16:08:10 +0100
Message-ID: <20260917151553.565179350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index e1ea2c85520f3..7acfa6e657984 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -838,6 +838,9 @@ static irqreturn_t btintel_pcie_irq_msix_handler(int irq, void *dev_id)
 
 	if (unlikely(!(intr_fh | intr_hw))) {
 		/* Ignore interrupt, inta == 0 */
+		bt_warn_ratelimited("Bluetooth: btintel_pcie: Received spurious interrupt\n");
+		btintel_pcie_wr_reg32(data, BTINTEL_PCIE_CSR_MSIX_AUTOMASK_ST,
+				      BIT(entry->entry));
 		return IRQ_NONE;
 	}
 
-- 
2.53.0



