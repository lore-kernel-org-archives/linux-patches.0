Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F6E1F959
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7945FC433C9;
	Tue,  1 Aug 2023 09:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882488;
	bh=DTkJxz3/2TgfE2GBjpQgR1MsLiLUEEVAou0uXS9Uk/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1cnh4M/KnEBIodr+qjiM2bMNyNaeQLXxCaUGbnL33efeWb4m8B67ycLZKYoxbTJtG
	 qvMEiFrxGAYSJZPDCwftOeEiub8qUG9qyhb/4BV5j976VoGTHTK/AN6OII0CGcoavL
	 Wn3q/Qm3DsiKuuHsTJQsF/ZUgmoZiSD2YgHxl0cU=
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
Subject: [PATCH 6.1 124/228] cxl/acpi: Fix a use-after-free in cxl_parse_cfmws()
Date: Tue,  1 Aug 2023 11:19:42 +0200
Message-ID: <20230801091927.227821219@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
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
index fb649683dd3ac..55907a94cb388 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -154,8 +154,7 @@ static int cxl_parse_cfmws(union acpi_subtable_headers *header, void *arg,
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



