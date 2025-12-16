Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181153446D2;
	Tue, 16 Dec 2025 12:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887557; cv=none; b=KDVieu3bWjLplyKmc1zVcJZjDNwI22lcMyBv81yA78OwWhRI5dW1FOnP3zvQ2TFw96H8UeKhwJOf0toCzmJo6MapwOp9EjAR+oCCVoYrreS5mqMjlSNEGM9BKQq1OAHw0SBFNCL7hXGpcqPbpSSdsHLatnYcNZuVWKTgNxq0K0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887557; c=relaxed/simple;
	bh=EcblMywMzXQI7p995g3pAXVCm9PFX9+1+CbRDqxdrb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUwAbKT/nWxuVdqFi82nFoLUHcPgwHIO1RrJFCT3XGfDDJsAaY9RNk+Nm476Q5idPGr/wb6kuNJYAZSCn/WJgxJv4wsrCArTi6SEUYIUmUbP/akSKSVKBBYkEixO13YELiFc8TdsPWxzqvaT/1777s34yKCYcoRFljcdS8vPt6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUwlSHN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUwlSHN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1BBC4CEF1;
	Tue, 16 Dec 2025 12:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887557;
	bh=EcblMywMzXQI7p995g3pAXVCm9PFX9+1+CbRDqxdrb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUwlSHN5iaaPX8h3mP7rNIyEZ/wu4q6orZqKtN8m7V9gB3nWb4olYgGcMmidmJhiT
	 TUyPOKVWKyS+UcvCSbeYurrnLDeSwad802oLb2fo9YvrAFcjmrlr78m3T7qJrDo2P2
	 tdcwwe0qer52iANY2r6bwxtD5zMrhXhVUDZwJ8AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 266/614] ACPI: property: Fix fwnode refcount leak in acpi_fwnode_graph_parse_endpoint()
Date: Tue, 16 Dec 2025 12:10:33 +0100
Message-ID: <20251216111411.010356927@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 43d5e457814e1..b12057baaae7b 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1714,6 +1714,7 @@ static int acpi_fwnode_graph_parse_endpoint(const struct fwnode_handle *fwnode,
 	if (fwnode_property_read_u32(fwnode, "reg", &endpoint->id))
 		fwnode_property_read_u32(fwnode, "endpoint", &endpoint->id);
 
+	fwnode_handle_put(port_fwnode);
 	return 0;
 }
 
-- 
2.51.0



