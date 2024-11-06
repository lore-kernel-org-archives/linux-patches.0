Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144E11E0E1F;
	Wed,  6 Nov 2024 12:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897604; cv=none; b=HheG5L00C4Y4QH23uVBekEFtJlbVdgkRBEqkBMgQLnH9Xii+YVdJuu5btBQMYDHHxUbGLS81NYR61p7GX3tqWyjt3STSirpwLjFhhquYV9PoWG5b1zCOIn+hE9PZmhyfiTxNeSWiZWBT2SxlSjb/QFVSiIizKxM865e3BKzYExc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897604; c=relaxed/simple;
	bh=bRluDnS99iIyFNfzUA8Y94Kf6cUtajLfKhXqW2QeKuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+BszyvTCkv52uPdXAv3VT3ySoBV49gzuDJK2WIWYn2Ewpdg25Xu1YeEnv76c4N9yvJ4CUS4roOLy+647GcECQe7OAXkf4MqTkb6rCF0Ro8LIa6E4fRwTniKFHpZrunQHQB4YYnzxysnR6EoXoRLdVZdFAxu1wdyU7dP3gkelLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K5ybWOcr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K5ybWOcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913C3C4CECD;
	Wed,  6 Nov 2024 12:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897604;
	bh=bRluDnS99iIyFNfzUA8Y94Kf6cUtajLfKhXqW2QeKuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K5ybWOcrwICMap0K/6yPC3Ipg7K0rWfkADHPbRF0ZDrU/VlDtmdl32ZVXLQwbqFtc
	 2hxdJn4zzT5vvt8pJVHGZY8b6e16oobSVao0YLIjBaQnTE5jzeqdd/T73C3Jv75o4U
	 V+buqBEwHn05YmnqfkgA1y/+kA2utA5ne0FmHWVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Chuang <ben.chuang@genesyslogic.com.tw>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 108/151] mmc: sdhci-pci-gli: GL9767: Fix low power mode in the SD Express process
Date: Wed,  6 Nov 2024 13:04:56 +0100
Message-ID: <20241106120311.843194206@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Chuang <ben.chuang@genesyslogic.com.tw>

commit c4dedaaeb3f78d3718e9c1b1e4d972a6b99073cd upstream.

When starting the SD Express process, the low power negotiation mode will
be disabled, so we need to re-enable it after switching back to SD mode.

Fixes: 0e92aec2efa0 ("mmc: sdhci-pci-gli: Add support SD Express card for GL9767")
Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
Cc: stable@vger.kernel.org
Message-ID: <20241025060017.1663697-2-benchuanggli@gmail.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-gli.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -1078,6 +1078,9 @@ static int gl9767_init_sd_express(struct
 		sdhci_writew(host, value, SDHCI_CLOCK_CONTROL);
 	}
 
+	pci_read_config_dword(pdev, PCIE_GLI_9767_CFG, &value);
+	value &= ~PCIE_GLI_9767_CFG_LOW_PWR_OFF;
+	pci_write_config_dword(pdev, PCIE_GLI_9767_CFG, value);
 	gl9767_vhs_read(pdev);
 
 	return 0;


