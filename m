Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA12CEEC9;
	Tue, 10 Sep 2024 09:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961746; cv=none; b=ldyyaQFkIZ/2TsxXI3BzgHIcsOoxRROAVKctFOWqfJSBJlTWbLjo6z/gwzr5dqPdLuyhHv0947AC60HqnrXklIHWE98YrPPA7/sYDk2Qu0xew4iRheIgvT7plfW9S9uEHq3o4iv+MzN1BCdTvTLv3sw47yBMTOP41VFDRSmd8zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961746; c=relaxed/simple;
	bh=Zgcq8htuXuEnmDBsReJSwn3iMxZjgLdWCiwJXDXCQKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkCVqg1MfATMDnhY+kF/UUWFSNIRea7uGcgPHuHEnQZkEJpkOAEcvvE0cZsqpioMKfBlII/dGUvbaC1E4sTpBbcFTjNlZy+H8yGw/LQ7e2jPQUkgIGEuQr5ZYO2cHwaQ1fFZTUdKppr+hmlhBTZ8RKM86OabYkDNdcr99ApnTgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYzFNVqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYzFNVqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A8CC4CEC3;
	Tue, 10 Sep 2024 09:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961746;
	bh=Zgcq8htuXuEnmDBsReJSwn3iMxZjgLdWCiwJXDXCQKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYzFNVqCyjFVOdUKcCopK0LhVKG9SVv5PD7NlspfJwk/3V1+FbSdgdrruOVVWDSyg
	 zovoX1gC8Xgj2Bm11E+HCBs5EiPJ/8m5asXyrLoZ2LqLOZgQVKpzulw7To2NL4z5un
	 MPzhkbCXghLsqCYZjtjJhEt8Trt7yLZ3F6jagQtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 175/375] igc: Unlock on error in igc_io_resume()
Date: Tue, 10 Sep 2024 11:29:32 +0200
Message-ID: <20240910092628.356014217@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit ef4a99a0164e3972abb421cbb1b09ea6c61414df ]

Call rtnl_unlock() on this error path, before returning.

Fixes: bc23aa949aeb ("igc: Add pcie error handler support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 3041f8142324..773136925fd0 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -7417,6 +7417,7 @@ static void igc_io_resume(struct pci_dev *pdev)
 	rtnl_lock();
 	if (netif_running(netdev)) {
 		if (igc_open(netdev)) {
+			rtnl_unlock();
 			netdev_err(netdev, "igc_open failed after reset\n");
 			return;
 		}
-- 
2.43.0



