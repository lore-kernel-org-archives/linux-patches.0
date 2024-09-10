Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2499A18C021;
	Tue, 10 Sep 2024 10:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964335; cv=none; b=eULgQysgTMGdO0e+k2v5PvZKp12KONuu00Q+Klmc3Q5/8C5JmegtCVAZ7g3D+8+koCpuAz38bQS64PyWhg9KcSAiBNfwGz+to8lIDfnccpQzGuZdDUsWJYZJHfTqP2f/mxbMywBFer9XsMb07tijKymQpRVwAnBe/y+zG9biPY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964335; c=relaxed/simple;
	bh=Z4OAeZpIj+OGnwtI4HvxVgZDhGZMjZ/2BxPzAxEwbPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyiwEndveSKgxM3YhxhdUl0eChoMplfCPtSq5/U+8vC3oQa26eBdGh22blhKv1L9WOmCF6ybZ+oNCOBieeO9u06c52PLwd114eKg+B0jk6a85RnidzXYbpx7Fbtrm5UDEQlqkx6CzHanhbTsmAl1KxRNgVbVAE2FJo7Wwytw0iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Zb5vNVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Zb5vNVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AA8C4CEC3;
	Tue, 10 Sep 2024 10:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964335;
	bh=Z4OAeZpIj+OGnwtI4HvxVgZDhGZMjZ/2BxPzAxEwbPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Zb5vNVmJU/ROsvTapZXHmrWTsh4+5EtwZVCK3vTEUildrO2VdGBvEStV03E6wAlN
	 Kwgha6JB100MR1BW35ZOhqnRubUxMc/321ZEEqLhxwgyb5fe2KyLqIhjWorTzvbtSk
	 SGiPwC8HAmYnYDYFzkB/bq3GY+E74uIQYXRsTExQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/269] igc: Unlock on error in igc_io_resume()
Date: Tue, 10 Sep 2024 11:31:47 +0200
Message-ID: <20240910092612.451240686@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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
index 21fb1a98ebca..da1018d83262 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -7288,6 +7288,7 @@ static void igc_io_resume(struct pci_dev *pdev)
 	rtnl_lock();
 	if (netif_running(netdev)) {
 		if (igc_open(netdev)) {
+			rtnl_unlock();
 			netdev_err(netdev, "igc_open failed after reset\n");
 			return;
 		}
-- 
2.43.0



