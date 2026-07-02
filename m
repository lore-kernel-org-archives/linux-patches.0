Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8CE34753B;
	Thu,  2 Jul 2026 16:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009504; cv=none; b=dz674EFDLTQsitDPWIwXtgcUR97ks3Cd7wpu6C6rol4OnxW+v1LVtc/DHOY7byEDyj+U7Fjhl7IbWQ7jUaKB/rxg9JLtykP20C+Ob6rfisIV9d/YpXkBjaOJH+X9Sdh/Lk9GY7MOsDfjXocqbns8PZiSWIE7kJh44q3cGvuevJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009504; c=relaxed/simple;
	bh=m3Gm34f64gl2Ocz894HNu9NhvFPwXJ0kG9YOM6N4hio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9vb5anNqLPukJOAh7cC3JN4sB8XbYtiki59qfML5LkWs+3uisC+Tlb4e5t7Bnf5Ry08euRd9zWUIyYigNhxDaX4B9nvOUi/SI1tRwk5RfmiM4yd9z5dfYxLRTpPll3WGrx+uztfXP2dgIJHg9qQjUUu0CX0eobEyrynFIS59CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pq6h5CCM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pq6h5CCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D522B1F000E9;
	Thu,  2 Jul 2026 16:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009497;
	bh=nyz6Wr5Kry8oCUZrfvlTVOGT5ih82IzlHJGnxx/MEmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pq6h5CCM3Vg5689Ks8ryHlnXUFmf0LB5XrOwo7MfyYjmFq8mSglE0p3oKLHDRnF6n
	 /4khaa1BoyWPbKZu+TkQspIUceD1VWCst21Qie3OLBtMc0iZaXYntrQ5zhFyPnuTGM
	 TzsloexFgxYglQX+XU1/OSjiqAuM4z6n625cPZIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 5.10 74/96] fpga: region: fix use-after-free in child_regions_with_firmware()
Date: Thu,  2 Jul 2026 18:20:06 +0200
Message-ID: <20260702155110.537535320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -166,11 +166,10 @@ static int child_regions_with_firmware(s
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


