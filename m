Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9153ACEFE;
	Tue, 21 Jul 2026 21:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670345; cv=none; b=gB8h0D5CxD+ECkwKwsMPmy8vLXpHU/2vcjlCJ3Nf+ftRPyYvfMnHdsTVI/VqCTULnduJ61BRxAgklhkSj3v03sq72Kqe6ejo7MUbqgmST6a8BT0Gf3nm0m/uuvLfmWD40OBkvQULbQ9UEBojexGcmDaB9A2yCkm3lQ4k3IYlT3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670345; c=relaxed/simple;
	bh=VZH6mC1tMEsgm2/jWLZsWNjTuNi/246FfTfipp9lwgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2rSu9yJ7LsLjPr9zEnOyeXPlbr4Muqvng7GGAXOasU+0yVApl5O5t+h9LiFxJ8Osv5Fz+Bj8iSIHq35SHZ7QfHSqOWfxtaVMd/258CXkTKVB7KZH0bcgvIpMXP0TZIbSF658AYPgcIwdlCrNXSBwesTcQBOnlONeMQypNPFmug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBVT4oqp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBVT4oqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6501F000E9;
	Tue, 21 Jul 2026 21:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670344;
	bh=BvzeDJ3zGl0PZffbUK1A7leZJboPlrmLuAy/pvZyBhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zBVT4oqpQMWViQmzWy5fwWyX7Otj8FKLIBm1enu+SvwGO3kM2gYYjXGgljKqTFP6q
	 0mMywXO4PrKk6HMvCi8pYYxb5RFIMfJjKhuzFn44xAokm+oTorT85mKUxP2A78t3ip
	 m2KOjbgfmngN9ds4RbZophwtZ+ARj6/eGLNlCwEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0898/1067] net: liquidio: fix BAR resource leak on PF number failure
Date: Tue, 21 Jul 2026 17:24:59 +0200
Message-ID: <20260721152444.621489827@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit c63ee62a3c4ac1a1542f4c1a4b87e2f41df5a496 upstream.

If cn23xx_get_pf_num() fails, the function returns without
unmapping either BAR. Unmap both BARs before returning from
the error path.

Found by manual code review.

Fixes: 0c45d7fe12c7 ("liquidio: fix use of pf in pass-through mode in a virtual machine")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://patch.msgid.link/20260624064013.2809570-1-haoxiang_li2024@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c |   18 ++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
+++ b/drivers/net/ethernet/cavium/liquidio/cn23xx_pf_device.c
@@ -1334,18 +1334,14 @@ int setup_cn23xx_octeon_pf_device(struct
 	if (octeon_map_pci_barx(oct, 1, MAX_BAR1_IOREMAP_SIZE)) {
 		dev_err(&oct->pci_dev->dev, "%s CN23XX BAR1 map failed\n",
 			__func__);
-		octeon_unmap_pci_barx(oct, 0);
-		return 1;
+		goto err_unmap_bar0;
 	}
 
 	if (cn23xx_get_pf_num(oct) != 0)
-		return 1;
+		goto err_unmap_bar1;
 
-	if (cn23xx_sriov_config(oct)) {
-		octeon_unmap_pci_barx(oct, 0);
-		octeon_unmap_pci_barx(oct, 1);
-		return 1;
-	}
+	if (cn23xx_sriov_config(oct))
+		goto err_unmap_bar1;
 
 	octeon_write_csr64(oct, CN23XX_SLI_MAC_CREDIT_CNT, 0x3F802080802080ULL);
 
@@ -1376,6 +1372,12 @@ int setup_cn23xx_octeon_pf_device(struct
 	oct->coproc_clock_rate = 1000000ULL * cn23xx_coprocessor_clock(oct);
 
 	return 0;
+
+err_unmap_bar1:
+	octeon_unmap_pci_barx(oct, 1);
+err_unmap_bar0:
+	octeon_unmap_pci_barx(oct, 0);
+	return 1;
 }
 
 int validate_cn23xx_pf_config_info(struct octeon_device *oct,


