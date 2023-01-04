Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF80AD38
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04895C433F0;
	Wed,  4 Jan 2023 16:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848549;
	bh=hIuJOjy+6j8o/kIvhaV8Fg6fyu2Too4DxdaKvwkrDO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00Ul59l4ck2l+mjmsfGNnOR9m+27a2e2jf0i8ohioTenJC3KACz/4qu1UaiTn1y2r
	 CwzlRy2gBe9M47TPdC9pWst9lhEh7F6JRqWx7LuKSpDKYAb7qKrboKv9+uKX8Em+4f
	 kRKte2RLASSEfC58YlmTiOwDNmEKDAmBkRr5cgC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Ni <fan.ni@samsung.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.1 004/207] cxl/region: Fix memdev reuse check
Date: Wed,  4 Jan 2023 17:04:22 +0100
Message-Id: <20230104160512.057985569@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fan Ni <fan.ni@samsung.com>

commit f04facfb993de47e2133b2b842d72b97b1c50162 upstream.

Due to a typo, the check of whether or not a memdev has already been
used as a target for the region (above code piece) will always be
skipped. Given a memdev with more than one HDM decoder, an interleaved
region can be created that maps multiple HPAs to the same DPA. According
to CXL spec 3.0 8.1.3.8.4, "Aliasing (mapping more than one Host
Physical Address (HPA) to a single Device Physical Address) is
forbidden."

Fix this by using existing iterator for memdev reuse check.

Cc: <stable@vger.kernel.org>
Fixes: 384e624bb211 ("cxl/region: Attach endpoint decoders")
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Link: https://lore.kernel.org/r/20221107212153.745993-1-fan.ni@samsung.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/region.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1226,7 +1226,7 @@ static int cxl_region_attach(struct cxl_
 		struct cxl_endpoint_decoder *cxled_target;
 		struct cxl_memdev *cxlmd_target;
 
-		cxled_target = p->targets[pos];
+		cxled_target = p->targets[i];
 		if (!cxled_target)
 			continue;
 


