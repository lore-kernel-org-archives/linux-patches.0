Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE371DF97A;
	Tue,  8 Oct 2024 13:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393703; cv=none; b=Q0Uu0gx+/WzS6enB3GOSOf6DOLxAGwXFRxhuoBf9O14hs4MT6F211tUy5CsI/clgxeXQH4K/RRAibH1PiJcLQZnfYBa+Pgos4PcCwTADPmBdc1vnVvT5gpMyKpuwc4DYoEch5BVxbD3OKVBa2RRvD+6BqWKMYe/JswA5BW6JveA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393703; c=relaxed/simple;
	bh=DVIy1o1OrokRooawjd1rfFWLDOEYfFX4n/5tlle1bI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9VQMt7YBDaZjSSY3iv+TVBiOWbr9Dgt/yO7UY+IbqMJxQbbBVrxGj/T0xt4fA26JBX35IsDnWr2k4/YyWY3c30MvsBIHUAQqJOc0ARNz63+8elgCOY8W8j6nN3Hy0+lnQlZIoHawz3mLvoGgYnbjddclSCOZQb5W2zBLWYNIMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dGq/Fdhu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dGq/Fdhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B7DC4CEC7;
	Tue,  8 Oct 2024 13:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393702;
	bh=DVIy1o1OrokRooawjd1rfFWLDOEYfFX4n/5tlle1bI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dGq/FdhuWJoiI1rocPTJxZTU2EqLfC+7CClnGDX9g2JvEPCR1HsvLM//2RaNG/bFm
	 S4zOcQJgYIm0yfi8bk4JjfjAjbhMaRLw0vlB/oW2G398t35DLbzOnvt8fx+n8/yVlY
	 ohp1n5MkGm4VuE2EHx8plomhiZfyFVXLtbgo5188=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 189/386] spi: spi-cadence: Fix missing spi_controller_is_target() check
Date: Tue,  8 Oct 2024 14:07:14 +0200
Message-ID: <20241008115636.848125554@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 3eae4a916fc0eb6f85b5d399e10335dbd24dd765 ]

The spi_controller_is_target() check is missing for pm_runtime_disable()
in cdns_spi_remove(), add it.

Fixes: b1b90514eaa3 ("spi: spi-cadence: Add support for Slave mode")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20240923040015.3009329-4-ruanjinjie@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-cadence.c b/drivers/spi/spi-cadence.c
index 316da99f798c8..81edf0a3ddf84 100644
--- a/drivers/spi/spi-cadence.c
+++ b/drivers/spi/spi-cadence.c
@@ -688,8 +688,10 @@ static void cdns_spi_remove(struct platform_device *pdev)
 
 	cdns_spi_write(xspi, CDNS_SPI_ER, CDNS_SPI_ER_DISABLE);
 
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
+	if (!spi_controller_is_target(ctlr)) {
+		pm_runtime_disable(&pdev->dev);
+		pm_runtime_set_suspended(&pdev->dev);
+	}
 
 	spi_unregister_controller(ctlr);
 }
-- 
2.43.0



