Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E891FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89153C433C7;
	Tue,  1 Aug 2023 09:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883112;
	bh=7Mf8wvQQrHW024RmVALhiI1c7yA37AEAl9OfI5tfrNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDroQAYIgUS63VsXyg/jBf2koXna2/GREUfnXv6CdhVOK3hc2BNhgZuVL/YVAgxXL
	 hDx/wxGon1OUHNGc5Iba2cZsUfTcAyu1IdEcV6wgGfT7o1MCdyI72SHrE9OZfAQPyD
	 flrVHfqJ7r2hztLqPyLfEY2Uo8oGjUqgZMbVeY6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 119/239] cxl/acpi: Fix a use-after-free in cxl_parse_cfmws()
Date: Tue,  1 Aug 2023 11:19:43 +0200
Message-ID: <20230801091930.013223090@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 4cf67d3cc9994a59cf77bb9c0ccf9007fe916afe ]

KASAN and KFENCE detected an user-after-free in the CXL driver. This
happens in the cxl_decoder_add() fail path. KASAN prints the following
error:

   BUG: KASAN: slab-use-after-free in cxl_parse_cfmws (drivers/cxl/acpi.c:299)

This happens in cxl_parse_cfmws(), where put_device() is called,
releasing cxld, which is accessed later.

Use the local variables in the dev_err() instead of pointing to the
released memory. Since the dev_err() is printing a resource, change the open
coded print format to use the %pr format specifier.

Fixes: e50fe01e1f2a ("cxl/core: Drop ->platform_res attribute for root decoders")
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/r/20230714093146.2253438-1-leitao@debian.org
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/acpi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 7e1765b09e04a..973d6747078c9 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -296,8 +296,7 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
 	else
 		rc = cxl_decoder_autoremove(dev, cxld);
 	if (rc) {
-		dev_err(dev, "Failed to add decode range [%#llx - %#llx]\n",
-			cxld->hpa_range.start, cxld->hpa_range.end);
+		dev_err(dev, "Failed to add decode range: %pr", res);
 		return 0;
 	}
 	dev_dbg(dev, "add: %s node: %d range [%#llx - %#llx]\n",
-- 
2.40.1



