Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C97F2AF15;
	Tue, 10 Sep 2024 10:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965043; cv=none; b=o9vjHFdcUjARThk+BbuJSkW3fAagjS/4mx8cB2uMxcy2ubGTennL/O0gtiPTVqzKI8lUTEKXEaE1Y30OYvHOf+OZdSgRAWdmGW/WhBayNq2X/oL5WxwtevOOj1r7qxJ3Cj2f9uoxVtKKJ14T/Zl0B/GeNTD9s45K/enwQTWSdOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965043; c=relaxed/simple;
	bh=dp5Y+egzA4lHU6bppoouXNh2heqiqhMZiQIsaW/td3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRbGXg3G/uiBwS8qWiHmE5I9ADg7ttttBbLaLFdM+9wlWpW8fB80GVD2rrIPnQaHoY8SYQlOG8sTffZYiYO48qUyITdZ9Ctze19umg5BOsZ4PDXAdYhzFH6EF53onGo/ttZr1c9rzcPr10bMbdc5RW1RVq02TKkNX65a73uuB6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z310kOlh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z310kOlh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A806FC4CEC3;
	Tue, 10 Sep 2024 10:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965043;
	bh=dp5Y+egzA4lHU6bppoouXNh2heqiqhMZiQIsaW/td3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z310kOlh8HxCzUgp8unNUSfaJfPEfy12z9ULLScgYJIprwB0mKhGIOH1QpiUuHNaK
	 rnl7neoq2Uj4l4NPON+dEm8E6H1DSmYdy85XKs8xTq1KznFzLBDGJmm/XU0KTMu8Au
	 VVcAau6U7D2qakARwVR/58L1Ateqb2pxh10vIUUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/186] igc: Unlock on error in igc_io_resume()
Date: Tue, 10 Sep 2024 11:33:32 +0200
Message-ID: <20240910092559.345076659@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 631ce793fb2e..65cf7035b02d 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5740,6 +5740,7 @@ static void igc_io_resume(struct pci_dev *pdev)
 	rtnl_lock();
 	if (netif_running(netdev)) {
 		if (igc_open(netdev)) {
+			rtnl_unlock();
 			netdev_err(netdev, "igc_open failed after reset\n");
 			return;
 		}
-- 
2.43.0



