Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A258335561;
	Fri,  9 Jan 2026 11:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959715; cv=none; b=cFlx8pb1E9dHgwfgp+xBqbGQBk7zhdc0d4tZZBjz80rRderdvUdg0CMMydpY1O7Mb0Vpafw20xzT6fYu+bijFMsaF+fDgQaC7R4nBjZjlQ9DZVzirCCD0vXWT7gBB5SofWurGs054a4kyvd3DF1HncvTNabHtvtZEQnm57WzBRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959715; c=relaxed/simple;
	bh=LWTeG71UT1ITPGZUIt0DbLfU1jEdX+GLrGjd47+kvI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFVUzR9069A3Cg7zMoKYhyHwH+A5A4hGFQKrdlM4Cs5yVh/UoRGfmAYa+lzv+6Ha8i8n5vqsD3WqpCYqR6PC60Fwa/51tV51epy7le1urOdyor1UguP1ywoEghgYFE9ENjXgGH+2j+CAfz1w4PwSl4z3m5xPlmgmXk+0To1nGso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1Gb68e3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1Gb68e3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF862C4CEF1;
	Fri,  9 Jan 2026 11:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959715;
	bh=LWTeG71UT1ITPGZUIt0DbLfU1jEdX+GLrGjd47+kvI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1Gb68e3AsK5Zf0WlTYUZV9BrPVIYsvsPAaOlzLjaYRkb1KZBSDVIwhr7gYmqII2b
	 Ct+YTuBhbaweQf6sGwAVBSRvOh39C+igE1v5bygOs1x8Kx3DkPxpjr3OfuMFlFpIqS
	 gXdXzcM8u8wRrYcA5s6XQ46p/BLtClM3C2MJfA5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/737] ACPI: property: Fix fwnode refcount leak in acpi_fwnode_graph_parse_endpoint()
Date: Fri,  9 Jan 2026 12:34:49 +0100
Message-ID: <20260109112139.641032898@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d02b332744e64..1b8f3958b0edb 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1622,6 +1622,7 @@ static int acpi_fwnode_graph_parse_endpoint(const struct fwnode_handle *fwnode,
 	if (fwnode_property_read_u32(fwnode, "reg", &endpoint->id))
 		fwnode_property_read_u32(fwnode, "endpoint", &endpoint->id);
 
+	fwnode_handle_put(port_fwnode);
 	return 0;
 }
 
-- 
2.51.0



