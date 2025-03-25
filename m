Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1716D2571DB;
	Tue, 25 Mar 2025 12:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905931; cv=none; b=uBdnLBT7SbmCOfanu9L8LgTNsZ0limEDwlla5SayaFN0FFJmUgUwY5uBdRrA2haeuGJ+wY1uCe24v0y4GdiE/ud0rqv087rYrkUq+izdPmGxOwVqBvYlFBE6xGG1g5kPAVbhtMQsvatXtollVF2YJGCkOOK89uO43ki+9OcsikY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905931; c=relaxed/simple;
	bh=pZfg6irgD+Osgm2Ih6LbeanPsosT3S6pKmenlQVK9Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjOQYHYDmsOgHOQlUTpFg8yLznmbSCDv1n+wsWfZA7nE6gq00VbVNVhfuUgMC0UkKa4u55l+Ly2DXAzb4ctRNI5Z6YW7iG+fZaCGxXLJ77BIeyWvoNkqTGxUe9Ok9sANtQ2yZBCTcm14XBjReFSrkZgJMFPm3FOjBBY4WxUnE/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ozq8a+yr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ozq8a+yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED10C4CEE4;
	Tue, 25 Mar 2025 12:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905931;
	bh=pZfg6irgD+Osgm2Ih6LbeanPsosT3S6pKmenlQVK9Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ozq8a+yrX5gucTRKqi/xLmEs21sNPQF+lZYHN4j7dj1Ys/RkYpKRNeIGLH4qe1SRt
	 8uukUClepv6AI4sg6sDp5K2n322cQBQJUXDGnAp0alLvlO/yBxueOy7F+55OyuqSfW
	 RwGan1B8uxJONhIK5O3MraRpkE4gHLVIdym8Hl08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 042/119] dpll: fix xa_alloc_cyclic() error handling
Date: Tue, 25 Mar 2025 08:21:40 -0400
Message-ID: <20250325122150.132768318@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit 3614bf90130d60f191a5fe218d04f6251c678e13 ]

In case of returning 1 from xa_alloc_cyclic() (wrapping) ERR_PTR(1) will
be returned, which will cause IS_ERR() to be false. Which can lead to
dereference not allocated pointer (pin).

Fix it by checking if err is lower than zero.

This wasn't found in real usecase, only noticed. Credit to Pierre.

Fixes: 97f265ef7f5b ("dpll: allocate pin ids in cycle")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 32019dc33cca7..1877201d1aa9f 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -505,7 +505,7 @@ dpll_pin_alloc(u64 clock_id, u32 pin_idx, struct module *module,
 	xa_init_flags(&pin->parent_refs, XA_FLAGS_ALLOC);
 	ret = xa_alloc_cyclic(&dpll_pin_xa, &pin->id, pin, xa_limit_32b,
 			      &dpll_pin_xa_id, GFP_KERNEL);
-	if (ret)
+	if (ret < 0)
 		goto err_xa_alloc;
 	return pin;
 err_xa_alloc:
-- 
2.39.5



