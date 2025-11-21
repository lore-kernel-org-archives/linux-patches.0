Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4001F09B3;
	Fri, 21 Nov 2025 13:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731116; cv=none; b=MimJHvJi7pEkjRJyHdROFu26K1h5HFO6GeBsQ78FPAQXILa08iD2K2JVDx6RCws+7ofryuN6mA9rggP+h4x8NaUJ13uhrH6liXUOVdzNfrl7q7dkeiXYxcS7bZBettuzTNNKQXGfoonn/kY1lhb7nW249eNMcVRCJ81eQcBDAzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731116; c=relaxed/simple;
	bh=3F39PmUWWmOnB0PHfssgC+OEDbZlUP5mo+UbQ/ktbjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qX8l1Dy0hfRFgnrq0daPTMMnTCUPCzEOqZEh+BeVGJ4VmMR8LmYeb2csB9yFZJe4HkBAbQ0uPDbOZKp/wHEaAI2Iwwh4UQGJj7vqen7DJiNCGiHhsUknw+UHm82EvJey1++CU5049O09RPuKtOkrTVBTJ82mFww6+0SHM0SVBJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEElPdyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEElPdyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7261CC4CEF1;
	Fri, 21 Nov 2025 13:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731115;
	bh=3F39PmUWWmOnB0PHfssgC+OEDbZlUP5mo+UbQ/ktbjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aEElPdyIQf6cDDheIJT6aVKv9kQhTryeCIqMEnVMcWGJujKPGq61HinYAHxg3ct7i
	 6ApcnTkYR8Xh1/ZQtGS9EnWP7hsPtcyGIhVygDYU3z4mF2B0ezv9vjd9+TNxOPMbfr
	 CBkUE2/8WGkY7dKO621ZRzg5yDgPP1rpqeK+Qaas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wu Zongyong <wuzongyong@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 096/247] acpi,srat: Fix incorrect device handle check for Generic Initiator
Date: Fri, 21 Nov 2025 14:10:43 +0100
Message-ID: <20251121130158.037013816@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

[ Upstream commit 7c3643f204edf1c5edb12b36b34838683ee5f8dc ]

The Generic Initiator Affinity Structure in SRAT table uses device
handle type field to indicate the device type. According to ACPI
specification, the device handle type value of 1 represents PCI device,
not 0.

Fixes: 894c26a1c274 ("ACPI: Support Generic Initiator only domains")
Reported-by: Wu Zongyong <wuzongyong@linux.alibaba.com>
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://patch.msgid.link/20250913023224.39281-1-xueshuai@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/numa/srat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
index 53816dfab6452..aa87ee1583a4e 100644
--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -237,7 +237,7 @@ acpi_table_print_srat_entry(struct acpi_subtable_header *header)
 		struct acpi_srat_generic_affinity *p =
 			(struct acpi_srat_generic_affinity *)header;
 
-		if (p->device_handle_type == 0) {
+		if (p->device_handle_type == 1) {
 			/*
 			 * For pci devices this may be the only place they
 			 * are assigned a proximity domain
-- 
2.51.0



