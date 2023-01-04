Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A07AD49
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E3FC433F1;
	Wed,  4 Jan 2023 16:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848855;
	bh=5tHrMX6FgdCnjydWDq4GPmhVF0KkNZY7YSxPIIyBsqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEv329bnI/oWYDs3ls77S8ZSLsi9otD39eXwpcHStAR6eeLys+rZYbDeVV2rWo4dE
	 3e3R6uqbHgjj2EB+bW97kwMPJWmCBxlu7QIBEhRAxjeUuIrA6LZP/kxjTeO4fHUdgy
	 4MnivmSnHWECqYIERlKmjKD4S/m7dlsrBceqN9Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.0 025/177] cxl/region: Fix missing probe failure
Date: Wed,  4 Jan 2023 17:05:16 +0100
Message-Id: <20230104160508.430077416@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Williams <dan.j.williams@intel.com>

commit bf3e5da8cb43a671b32fc125fa81b8f6a3677192 upstream.

cxl_region_probe() allows for regions not in the 'commit' state to be
enabled. Fail probe when the region is not committed otherwise the
kernel may indicate that an address range is active when none of the
decoders are active.

Fixes: 8d48817df6ac ("cxl/region: Add region driver boiler plate")
Cc: <stable@vger.kernel.org>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/166993220462.1995348.1698008475198427361.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/region.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1922,6 +1922,9 @@ static int cxl_region_probe(struct devic
 	 */
 	up_read(&cxl_region_rwsem);
 
+	if (rc)
+		return rc;
+
 	switch (cxlr->mode) {
 	case CXL_DECODER_PMEM:
 		return devm_cxl_add_pmem_region(cxlr);


