Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A089C77F30;
	Mon, 15 Apr 2024 14:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191184; cv=none; b=IX4emuO2ldSvUM8RRdi/1djpGXvgrmQ8ipfbgPdDFMOuIC85TUmy6yagaA/hHRaeCLYXutQ3Cza5E7P5M1AabIjVSPAnq7i7Qs5AsDK7MdxD8uC8jL+9Hw34u6bMngjQ04Lmk/yO1m/FjTwsg+ugN+95QMTnH+4M33n6GJtjmho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191184; c=relaxed/simple;
	bh=YXewG/j+niQY7XOrq5AN5ed0Jb3Xr25Pv4YzyK2tPAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUFh00XcsdSxLZYSU8unH2qUSQSRuYQvesSsk7eWp+cnxIdEs/Wu2KeS1MOQI0Z4qLb85gznmI9STPdb2cu6aJdLCGZsXec7zQ4CPyHJ20qYMnRFPmpYqBfvgrqUQSC0uM6wqaH9jJAN5eCmkZSoO2fDKjeVWx7DwcjqkR78MdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEcMBBkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEcMBBkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287D5C2BD11;
	Mon, 15 Apr 2024 14:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191184;
	bh=YXewG/j+niQY7XOrq5AN5ed0Jb3Xr25Pv4YzyK2tPAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEcMBBkLN9tLhwS1lfB4AGEtEzmMtsbVVWwVArm/FnBGUwfKgn5UjKi3Kf1qdNrJu
	 SjNPiDGK9r/lA6Wl16s8B3AG/aDOOUH+4h//pl7Rtw/2rS/X3zbCYWJ8aWh6WxREUM
	 QodseGvUcpMA/ZKI4OMf/cQuo0JSzTprQFR+nawE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 061/172] cxl: Fix retrieving of access_coordinates in PCIe path
Date: Mon, 15 Apr 2024 16:19:20 +0200
Message-ID: <20240415142002.270471825@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 592780b8391fe31f129ef4823c1513528f4dcb76 ]

Current loop in cxl_endpoint_get_perf_coordinates() incorrectly assumes
the Root Port (RP) dport is the one with generic port access_coordinate.
However those coordinates are one level up in the Host Bridge (HB).
Current code causes the computation code to pick up 0s as the coordinates
and cause minimal bandwidth to result in 0.

Add check to skip RP when combining coordinates.

Fixes: 14a6960b3e92 ("cxl: Add helper function that calculate performance data for downstream ports")
Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://lore.kernel.org/r/20240403154844.3403859-3-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 0332b431117db..4ae441ef32174 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -2128,6 +2128,11 @@ int cxl_hb_get_perf_coordinates(struct cxl_port *port,
 	return 0;
 }
 
+static bool parent_port_is_cxl_root(struct cxl_port *port)
+{
+	return is_cxl_root(to_cxl_port(port->dev.parent));
+}
+
 /**
  * cxl_endpoint_get_perf_coordinates - Retrieve performance numbers stored in dports
  *				   of CXL path
@@ -2147,27 +2152,31 @@ int cxl_endpoint_get_perf_coordinates(struct cxl_port *port,
 	struct cxl_dport *dport;
 	struct pci_dev *pdev;
 	unsigned int bw;
+	bool is_cxl_root;
 
 	if (!is_cxl_endpoint(port))
 		return -EINVAL;
 
-	dport = iter->parent_dport;
-
 	/*
-	 * Exit the loop when the parent port of the current port is cxl root.
-	 * The iterative loop starts at the endpoint and gathers the
-	 * latency of the CXL link from the current iter to the next downstream
-	 * port each iteration. If the parent is cxl root then there is
-	 * nothing to gather.
+	 * Exit the loop when the parent port of the current iter port is cxl
+	 * root. The iterative loop starts at the endpoint and gathers the
+	 * latency of the CXL link from the current device/port to the connected
+	 * downstream port each iteration.
 	 */
-	while (!is_cxl_root(to_cxl_port(iter->dev.parent))) {
-		cxl_coordinates_combine(&c, &c, &dport->sw_coord);
+	do {
+		dport = iter->parent_dport;
+		iter = to_cxl_port(iter->dev.parent);
+		is_cxl_root = parent_port_is_cxl_root(iter);
+
+		/*
+		 * There's no valid access_coordinate for a root port since RPs do not
+		 * have CDAT and therefore needs to be skipped.
+		 */
+		if (!is_cxl_root)
+			cxl_coordinates_combine(&c, &c, &dport->sw_coord);
 		c.write_latency += dport->link_latency;
 		c.read_latency += dport->link_latency;
-
-		iter = to_cxl_port(iter->dev.parent);
-		dport = iter->parent_dport;
-	}
+	} while (!is_cxl_root);
 
 	/* Get the calculated PCI paths bandwidth */
 	pdev = to_pci_dev(port->uport_dev->parent);
-- 
2.43.0



