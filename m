Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB16313E13;
	Tue, 16 Dec 2025 11:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884299; cv=none; b=I+qpGnoB+Ls+3ttzqmXPHtJvFhWJSVYdo/UeyoN+WJ+Hf+uRI2akO79rK1/8u36loemdaIhYn7wJ+4qf8GYhka1Y9/fMhh40ej8drGvdBywMyxyXw8ldspc52PEdhUo0KdaS7ZhoyDATiK8bNhPfd4Mu7ge9C5pWa48PTSez9q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884299; c=relaxed/simple;
	bh=f1ogkjWaJaVnnqJw3Uq5Ux07kStk17IQXo4UVeYH3gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kdlc2FRRgi/im4+OVIQ08GRVjyWTeEkrXUwgiseN5mrWeQgC0+4B1M6SPodzaoqtGjbU1IY1naV0YI6OtTEzrDmXsq7wq3Y7Ml5FlRRZtw4MLbXKMeOEUWPaHRRf9rqkQdQ+rJB2qwl3P4ntxBxp8wilFuqhB14P9uicEvx5dGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytDcOJGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytDcOJGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00F2C4CEF1;
	Tue, 16 Dec 2025 11:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884299;
	bh=f1ogkjWaJaVnnqJw3Uq5Ux07kStk17IQXo4UVeYH3gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ytDcOJGN4ZHHc9cXBBElNzVKYYA+09lCLb0RdT4g1cPqP/KzN8zfDi9QhPeQGKwe1
	 hcB8HP39MmQwq8LiGn99+gDOb0IyLe3XdgYvP5t3M3wDaqCLNPABT61iML5q57SB2z
	 6yYeYZIz6E4+m7Ge9vaWLIGYoVIuiLEO7YjmFOGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/354] ACPI: property: Fix fwnode refcount leak in acpi_fwnode_graph_parse_endpoint()
Date: Tue, 16 Dec 2025 12:11:59 +0100
Message-ID: <20251216111326.422379249@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 593ee49222a0d751062fd9a5e4a963ade4ec028a ]

acpi_fwnode_graph_parse_endpoint() calls fwnode_get_parent() to obtain the
parent fwnode but returns without calling fwnode_handle_put() on it. This
potentially leads to a fwnode refcount leak and prevents the parent node
from being released properly.

Call fwnode_handle_put() on the parent fwnode before returning to prevent
the leak from occurring.

Fixes: 3b27d00e7b6d ("device property: Move fwnode graph ops to firmware specific locations")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
[ rjw: Changelog edits ]
Link: https://patch.msgid.link/20251111075000.1828-1-vulab@iscas.ac.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/property.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
index b51b947b0ca5b..b7ee463e757d2 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1693,6 +1693,7 @@ static int acpi_fwnode_graph_parse_endpoint(const struct fwnode_handle *fwnode,
 	if (fwnode_property_read_u32(fwnode, "reg", &endpoint->id))
 		fwnode_property_read_u32(fwnode, "endpoint", &endpoint->id);
 
+	fwnode_handle_put(port_fwnode);
 	return 0;
 }
 
-- 
2.51.0



