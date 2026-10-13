Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4856E4DDB33;
	Tue, 13 Oct 2026 12:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894942; cv=none; b=ZgqyufT5YR0KW7by8oqJLhd6kV/n0UcXPbd2zpONgEUNQm8WiCXq0Ejq7xNBIIxl4jxA7EHvnqIVr/IXpX2Sda3h0hepKpKCJIkebXCSjD2sVle3JREI4nMPKgNFv8kRQ3dDIca4uIY+quyb4REaph7PFMd1sIMyU5h75vmUKBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894942; c=relaxed/simple;
	bh=2jmU2cgVC3MIMwu0kxEhulUDa+l0fTO03uaFH7brJ9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7ihGyDY7IuZyraTaR3Tj0BJcEaTJHS6lFiBTVMGfv9CTbtvhKsldtKdp+yaR6VRLoox2oZKTGFSuqevZlT7eY7XEMc2zs7Q53In9yvJEE8frMIoTJjep5UL+7lo0OcNemPO+cdgw5jhJUnM8bBLpl6wkQ5r9FyrHRZzVtf8SJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rx/SNJa0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rx/SNJa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C12C1F000FF;
	Tue, 13 Oct 2026 12:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894941;
	bh=qughcl4FlIFWJLnmUv5oszg78pqAXIlb64fDacjAJD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rx/SNJa0qqugh73Ln/lsPGoSKc0GEjtxyF4ovkCjhAbwgRweU5GRwOALtSPQQ92oH
	 MglBnJ+V2jYScki4X7YbgKxjkcQhC3st/kMEuJk4jnTaMV7ZSXtivgpgIq1MOjY1xz
	 2pXwcWEsOGBTWD2HJRqSX19czKdOWFTDkvBpqm7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongjian Dai <daihongjian@kylinsec.com.cn>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/497] i2c: at91: release DMA channels when probe defers
Date: Tue, 13 Oct 2026 13:34:35 +0200
Message-ID: <20261013112910.455133937@linuxfoundation.org>
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

From: Hongjian Dai <daihongjian@kylinsec.com.cn>

[ Upstream commit c98bf3b86609a18ab16d067280257326e557c636 ]

at91_twi_probe_master() can return -EPROBE_DEFER from
at91_init_twi_recovery_info() after at91_twi_configure_dma() has already
claimed the tx/rx DMA channels. at91_twi_probe() then returns without
releasing them, and since dma_request_chan() is not devres-managed the
channels leak on every deferred probe attempt.

Release the channels before deferring the probe.

Fixes: f7eeb1af8537 ("i2c: at91: release DMA channels on remove and probe error")
Assisted-by: LLM
Signed-off-by: Hongjian Dai <daihongjian@kylinsec.com.cn>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/7D85C6CB6BF0A82E+20260929164340.41628-1-daihongjian@kylinsec.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-at91-master.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-at91-master.c b/drivers/i2c/busses/i2c-at91-master.c
index f265a41cf31f6..5d901fd773df7 100644
--- a/drivers/i2c/busses/i2c-at91-master.c
+++ b/drivers/i2c/busses/i2c-at91-master.c
@@ -921,8 +921,14 @@ int at91_twi_probe_master(struct platform_device *pdev,
 	at91_calc_twi_clock(dev);
 
 	rc = at91_init_twi_recovery_info(pdev, dev);
-	if (rc == -EPROBE_DEFER)
+	if (rc == -EPROBE_DEFER) {
+		/*
+		 * The DMA channels were already set up above, release them
+		 * before deferring the probe so they are not leaked.
+		 */
+		at91_twi_dma_release(dev);
 		return rc;
+	}
 
 	dev->adapter.algo = &at91_twi_algorithm;
 	dev->adapter.quirks = &at91_twi_quirks;
-- 
2.53.0



