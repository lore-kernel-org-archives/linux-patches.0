Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747B5347536;
	Thu,  2 Jul 2026 16:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010073; cv=none; b=hhX9h63Dfk0ZeCiYFbEOmhigRGhL/NFBk5AYSMNDjrAlEAQcATGgm2eySKdyRyFO33c1yReBQ8V6LExIn7yQ7/q6MsHCg0kat3f3M+1nUhmBlSm1slQbCAqRPMR1B2bTcR9w1hBfpJ9tL/rci3ih3pwV6eu3wt/9Z3goj5UHYHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010073; c=relaxed/simple;
	bh=Y149Q/GRu2AbUTwzpUracXH8iRgxCwQHUd1uDOjX/dY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLOsOr48O7FPNGqjeFlgm2nWk/mlBQb+ePafc5ie05i8iQsw/ZVP8IwosTqwwKzo5wG7Yk1aqoLaMfbgKb4GMu20m0mSA/qm0SufLpZ7kNV5eC62+WCsfw5RQ33HY6nUDytgre9SsO5IRQf0uIOgdkxxJOCvgf8jwU+EohopBGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kntluYxp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kntluYxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F931F000E9;
	Thu,  2 Jul 2026 16:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010072;
	bh=bEg9HPftDJUA3TBrb8vPRCogS/Tjp9G8AKxmuZunBMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kntluYxpi77oZNZ8y+7HvaEkPgCbijl1Sg59EGN5PsdOO+ahHcLOpzpv3VofyIYeu
	 iGq/6RVdoNEA3QzqxDbMpJUEvA34IXdxXfDP84GduW0jJYf43iV/Zq6NegXul3mGLl
	 Tz0mgEhx5Mb9670nv5TJd8VmRgjmOxY/2NySa8jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [PATCH 6.1 098/129] fpga: region: fix use-after-free in child_regions_with_firmware()
Date: Thu,  2 Jul 2026 18:20:17 +0200
Message-ID: <20260702155114.170105355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


