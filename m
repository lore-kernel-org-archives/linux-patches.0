Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864CE143C75;
	Tue, 27 Feb 2024 13:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042049; cv=none; b=h71BWJCFbPXinwED9A4OT9e9QutJTv5HcujolY7/Cts6tTJlFFZwKbeOoNUXle6dXh1cGCpZXVKr6URSHcyPWSYoX/9FJvVWahw2uAtkdE/UP0Z6kfyVQD+AQyp3p87TdlQnsUWA3/JNStGw0FTCzi29GLQ4eQL/Dx1Ay4RHj9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042049; c=relaxed/simple;
	bh=1K80piKRVozHdihLAQubO8KamF4wLQ+Q21khjvo6gxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNhJnZqb7xkKb2imLGYBjZkNnDvrV37ULpcqM/dXThxaT1CuAQj6lo8yZPutZspUvCdJt1Vpf0Rhoiw/GKl8ALREV+3dND3kdwdqoTl5GQoRrUycOl/AZDQnsiF5s1aQMD86GFAvEmyJN8zRy2qHCfBtxjTy+fBoMcFbELX1MTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tMYLLws+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tMYLLws+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1439BC433C7;
	Tue, 27 Feb 2024 13:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042049;
	bh=1K80piKRVozHdihLAQubO8KamF4wLQ+Q21khjvo6gxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tMYLLws+nPyh8yFhrnxQDLns9weADcUAqapqD+a0Cg+wQvjwgd7uEhlRVIqhmy6KU
	 UoY8kKYSKXZS4K+vrrSgLkCpVqA6h7G5xoUg3G29Y1go+tCZQKNCoOOfbAPN6X+n0o
	 0K1p01x3GrRxyKZXfODP18lYtuAUfnUga9oTYNtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Richter <rrichter@amd.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.6 153/299] cxl/pci: Fix disabling memory if DVSEC CXL Range does not match a CFMWS window
Date: Tue, 27 Feb 2024 14:24:24 +0100
Message-ID: <20240227131630.787358614@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Richter <rrichter@amd.com>

commit 0cab687205986491302cd2e440ef1d253031c221 upstream.

The Linux CXL subsystem is built on the assumption that HPA == SPA.
That is, the host physical address (HPA) the HDM decoder registers are
programmed with are system physical addresses (SPA).

During HDM decoder setup, the DVSEC CXL range registers (cxl-3.1,
8.1.3.8) are checked if the memory is enabled and the CXL range is in
a HPA window that is described in a CFMWS structure of the CXL host
bridge (cxl-3.1, 9.18.1.3).

Now, if the HPA is not an SPA, the CXL range does not match a CFMWS
window and the CXL memory range will be disabled then. The HDM decoder
stops working which causes system memory being disabled and further a
system hang during HDM decoder initialization, typically when a CXL
enabled kernel boots.

Prevent a system hang and do not disable the HDM decoder if the
decoder's CXL range is not found in a CFMWS window.

Note the change only fixes a hardware hang, but does not implement
HPA/SPA translation. Support for this can be added in a follow on
patch series.

Signed-off-by: Robert Richter <rrichter@amd.com>
Fixes: 34e37b4c432c ("cxl/port: Enable HDM Capability after validating DVSEC Ranges")
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240216160113.407141-1-rrichter@amd.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/pci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -475,9 +475,9 @@ int cxl_hdm_decode_init(struct cxl_dev_s
 		allowed++;
 	}
 
-	if (!allowed) {
-		cxl_set_mem_enable(cxlds, 0);
-		info->mem_enabled = 0;
+	if (!allowed && info->mem_enabled) {
+		dev_err(dev, "Range register decodes outside platform defined CXL ranges.\n");
+		return -ENXIO;
 	}
 
 	/*


