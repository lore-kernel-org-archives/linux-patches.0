Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDDC23F417;
	Fri,  9 Jan 2026 12:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961714; cv=none; b=pa48U1uQRlwWmsJu2tSMDgikgSNW95ojnQdFgQm448HWNHqxvwduHMf/oRZ3d7VlvZbe49d+G2aVaT9oZGg089eAFhet8qMadsWOZr1YNUpoZfP/IYW4Vhh63YnzvelLyimRouqhIJtAUGL54IUCb1WHVOZAumitYzNP4zBNHRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961714; c=relaxed/simple;
	bh=Sf/omHDuY0f/JKwqeUQf/KcpxoiLeyCH+kBbXou54ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nK6EGurHl8J3ZzqHsmIlp5quni67sRoBYGDKQwnxJ+ycR1m0GKSM6ce0wj9R7mRjdRKo1xCR9V8WrmCX/yYExHbV9AEOjiFbUV5wcQ143FU258GwdDUzxA9Y/ePZZtYgw1rA7Bz7td5bgz7TsCpL6TTrzcSfrK1YhGRo7jHOcrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zDsHSmHV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zDsHSmHV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00D4C4CEF1;
	Fri,  9 Jan 2026 12:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961714;
	bh=Sf/omHDuY0f/JKwqeUQf/KcpxoiLeyCH+kBbXou54ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zDsHSmHVOv5yBIKepf1ronQeOAkt2iMc9iFyN8IgfJXMNJX354TDsLc1WObBrh6cY
	 +jWoVgV1Zakd560jWnVRwdAz6zO/vW1sGWiR9nvWwv/r5xgM70onrt3zn4oH469kZS
	 3/rmVgN48HrNr7sfFIpD1vMbtfh2q2FlN2NLSzpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/634] ACPI: property: Fix fwnode refcount leak in acpi_fwnode_graph_parse_endpoint()
Date: Fri,  9 Jan 2026 12:36:29 +0100
Message-ID: <20260109112121.611092943@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
index 9f7880cc2bd8c..0ff1c3d2504d4 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1634,6 +1634,7 @@ static int acpi_fwnode_graph_parse_endpoint(const struct fwnode_handle *fwnode,
 	if (fwnode_property_read_u32(fwnode, "reg", &endpoint->id))
 		fwnode_property_read_u32(fwnode, "endpoint", &endpoint->id);
 
+	fwnode_handle_put(port_fwnode);
 	return 0;
 }
 
-- 
2.51.0



