Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38BF1FA859;
	Thu,  2 Jul 2026 17:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011678; cv=none; b=SDL5qIfvtSpIUvmttTWtyxX3pj4qr+rnNH6GfoWMkyATqBnu6yUEh2JnUFYdb6SVCVIlVGqJF6WVejeALPkFZgXwB7iuu4tGKqKBxF84AVKnTQfGSYsd0PxXNp3vTEks5vYviwdtnQpG8c8yfgDF4EpB/+6I2qGYhPJyEI2kdOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011678; c=relaxed/simple;
	bh=c2SDuVK8c1f9LHx+Y9jrdL6GxUOYOqMJiv4t9fmgaCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAHXCaVso4BB1opNcWPxeEqnKlRkurU8cjddygaNvsG8d9InZ6y9JCWvPRpEwsVmGOrO5pAcKtpTl25D4+z1xmLKTD9rf4wR+B46d1UzwLZnLZmZNeZycnrqQBBP0X+SZrHh4R6HFLvUQC7yn39nZ8UhJMRI1OIKqXUmBK7TiL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYIbGRWZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYIbGRWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D551F000E9;
	Thu,  2 Jul 2026 17:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011677;
	bh=/kPupm844tCS3GxJK9UkXDgADfGwP3cg7aX9EHyBA/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aYIbGRWZg1scVt01JQ/tDX8iH1uVv6Qnc+ZazZYtmRsp7f6DG9hdB8AOrlw1B8gij
	 oMtZsNcYb6LEWaqfMRbF9ph4YdMo6jvYcK5k+/Qk7x6sVNuDGh9FQ8Tl9lucRD4mGX
	 3RO51XU3FypghFuGSF7qCvoTurNthzGT587lKdg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 7.1 089/120] fpga: region: fix use-after-free in child_regions_with_firmware()
Date: Thu,  2 Jul 2026 18:21:25 +0200
Message-ID: <20260702155114.800624697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 54f3c5643ec523a04b6ec0e7c19eb10f5ebebdd3 upstream.

Move of_node_put(child_region) after the error print to avoid accessing
freed memory when pr_err() references child_region.

Fixes: 0fa20cdfcc1f ("fpga: fpga-region: device tree control for FPGA")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
[ Yilun: Fix the Fixes tag ]
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20260408154534.404327-1-vulab@iscas.ac.cn
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/of-fpga-region.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/fpga/of-fpga-region.c
+++ b/drivers/fpga/of-fpga-region.c
@@ -168,11 +168,10 @@ static int child_regions_with_firmware(s
 						     fpga_region_of_match);
 	}
 
-	of_node_put(child_region);
-
 	if (ret)
 		pr_err("firmware-name not allowed in child FPGA region: %pOF",
 		       child_region);
+	of_node_put(child_region);
 
 	return ret;
 }


