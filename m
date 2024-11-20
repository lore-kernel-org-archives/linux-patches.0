Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE6D1BD501;
	Wed, 20 Nov 2024 13:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107681; cv=none; b=U2FYG5ugm4aPGOfoQdIAj6NJk/DE9cmI12BLwBXYhzHl08n3BxvPrCuydKjDVBqVDQ518Ygz+G9jhK82pNS5LoIv5gEVTO+37DUH4fLpkZx/QVDKuI870hdZT6c2cDhisLAy1G5VNehOTku3abTzLgFk32bwthuYo826B7VaTuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107681; c=relaxed/simple;
	bh=yXebHKcRGVuAZFkA/Jb0EPJYwrAeQ2pbajirEhQkTjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sigywliNHulJruNK71HzXTIx38BhWPVfnp6bPvBEElMX3OsTjeRZY0SPmbUy5LuGCyLsjUNJvF4aAshYGLDtP5Q3OyBl1P9zDhV9sFWOw8xxB2P7iXdpjCQh/Y9Ba0gmg7dEllcqLaieqNh+Fbe+xLrFHuHCexBQ9aF5LX2u3MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=02Xf86S8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="02Xf86S8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825D0C4CECD;
	Wed, 20 Nov 2024 13:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107681;
	bh=yXebHKcRGVuAZFkA/Jb0EPJYwrAeQ2pbajirEhQkTjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=02Xf86S8kY0e3XkhiuOsam+ji9n9sDTzxkzjyaLFkfLP+HE9kdF+Xz5A/cobqeOji
	 Vq9nUE0jX+zp802lNmn/gnpEBk2WS3L27qf128f0uQTKNj9RAYIHp/3P2PC8a84847
	 HTnSA97lVQwnQdqPf3lZB5gHMoFdCDHQsasIRUDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	Robert Richter <rrichter@amd.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 6.1 39/73] cxl/pci: fix error code in __cxl_hdm_decode_init()
Date: Wed, 20 Nov 2024 13:58:25 +0100
Message-ID: <20241120125810.547346183@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

When commit 0cab68720598 ("cxl/pci: Fix disabling memory if DVSEC CXL
Range does not match a CFMWS window") was backported, this chunk moved
from the cxl_hdm_decode_init() function which returns negative error
codes to the __cxl_hdm_decode_init() function which returns false on
error.  So the error code needs to be modified from -ENXIO to false.

This issue only exits in the 6.1.y kernels.  In later kernels negative
error codes are correct and the driver didn't exist in earlier kernels.

Fixes: 031217128990 ("cxl/pci: Fix disabling memory if DVSEC CXL Range does not match a CFMWS window")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -377,7 +377,7 @@ static bool __cxl_hdm_decode_init(struct
 
 	if (!allowed && info->mem_enabled) {
 		dev_err(dev, "Range register decodes outside platform defined CXL ranges.\n");
-		return -ENXIO;
+		return false;
 	}
 
 	/*


