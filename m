Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F521BDC3;
	Mon, 14 Oct 2024 15:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918353; cv=none; b=t/Ww/BSNV+Gij9WthrCikByR3tQZtGjWUjSHuK8w5epaKZ5HMQ+c1UR5cx7C3fMPrGar/AsnGNIxxWRYFRt73itoCbVrRneVmf9nZ0Y/IUjaFK0oai+D5kp8SlrQpEtl65dXZTqosB2XIPLa8zMLNfXs8c3BtVwnH2CEoQ4jlR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918353; c=relaxed/simple;
	bh=3PNMWv/al0xUoixjl+SchFmnJIox29ZYqvkJm4c2Hgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZbloX2AYorcXOc/hKJytzxV3OukwANBpK+65U5fAq55rixG6UZEmdvSejKByXfcvsKb15EuuQkKha382lNbCrs525/O4pPDEUmac17xGRulpQEUlIsauqfhvzKUNcalsOwIpztQ6HThuUMTPvXe0nl5ag1hxXLfil58uSMMu+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQxR+3SL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQxR+3SL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA63C4CEC3;
	Mon, 14 Oct 2024 15:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918353;
	bh=3PNMWv/al0xUoixjl+SchFmnJIox29ZYqvkJm4c2Hgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HQxR+3SLqfQNybzSIq6I+146H/ZCW7kc51UcpGK7XAZX4c/n09JeVIVi9MxXBM/dD
	 GH02QC1JMG7Ox9xR20IczGZ0+nEDzsqZIjS+Xaj9ZAf/Tcg4n66WgowdPSI9xoxHYP
	 P4O/iOcjGfX6YAz420wHmBqRdsp+UhuaRvmV4kCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Yanfei Xu <yanfei.xu@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 256/798] cxl/pci: Fix to record only non-zero ranges
Date: Mon, 14 Oct 2024 16:13:30 +0200
Message-ID: <20241014141227.991974168@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yanfei Xu <yanfei.xu@intel.com>

[ Upstream commit 55e268694e8b07026c88191f9b6949b6887d9ce3 ]

The function cxl_dvsec_rr_decode() retrieves and records DVSEC ranges
into info->dvsec_range[], regardless of whether it is non-zero range,
and the variable info->ranges indicates the number of non-zero ranges.
However, in cxl_hdm_decode_init(), the validation for
info->dvsec_range[] occurs in a for loop that iterates based on
info->ranges. It may result in zero range to be validated but non-zero
range not be validated, in turn, the number of allowed ranges is to be
0. Address it by only record non-zero ranges.

This fix is not urgent as it requires a configuration that zeroes out
the first dvsec range while populating the second. This has not been
observed, but it is theoretically possible. If this gets picked up for
-stable, no harm done, but there is no urgency to backport.

Fixes: 560f78559006 ("cxl/pci: Retrieve CXL DVSEC memory info")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Yanfei Xu <yanfei.xu@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20240828084231.1378789-2-yanfei.xu@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pci.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index 194c8024216df..8d92a24fd73d9 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -471,10 +471,6 @@ static int cxl_dvsec_rr_decode(struct device *dev, int d,
 
 		size |= temp & CXL_DVSEC_MEM_SIZE_LOW_MASK;
 		if (!size) {
-			info->dvsec_range[i] = (struct range) {
-				.start = 0,
-				.end = CXL_RESOURCE_NONE,
-			};
 			continue;
 		}
 
@@ -492,12 +488,10 @@ static int cxl_dvsec_rr_decode(struct device *dev, int d,
 
 		base |= temp & CXL_DVSEC_MEM_BASE_LOW_MASK;
 
-		info->dvsec_range[i] = (struct range) {
+		info->dvsec_range[ranges++] = (struct range) {
 			.start = base,
 			.end = base + size - 1
 		};
-
-		ranges++;
 	}
 
 	info->ranges = ranges;
-- 
2.43.0



