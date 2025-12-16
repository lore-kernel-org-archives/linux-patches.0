Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB2434B693;
	Tue, 16 Dec 2025 11:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885727; cv=none; b=GEMkaN2pa2BwjXhv4WjGCrmcvdMgRMX5601dJHiIU9QpN+5XhA/+dlg6jXbsQPt+r/1VC170aINAsY6apVH4F4ACd0xZ7XOIvqad0uI8M6Nye1zSleL7CWlLuddh7MICRSMQ1TybXP0GUevCzoqAISOmTIJXtUOxPW0NxNCl5v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885727; c=relaxed/simple;
	bh=ogoDaV5LJoyo9DsZGLYGrNJm7TTqvAhbJ43yaGkQycI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mhy7iwmc/vY852+niHhMw0slEkT1MYAzQxY56J4cXSSAOsFWJsKragP7KhOqN1m9e47wIFpP/lDbIz3djF1WCcP+xjDAmyMDtHmfHf2FV1muCWOFPUAei4Jw7ay7D8lzBrY7N0cWBL6Jb/qHR+jpgr/pEGicfH++GyZIyNCbUdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FV3F672c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FV3F672c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0173C4CEF1;
	Tue, 16 Dec 2025 11:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885727;
	bh=ogoDaV5LJoyo9DsZGLYGrNJm7TTqvAhbJ43yaGkQycI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FV3F672cnuYnSYFDKTUQuCP+wcR5mfMAKiYBh5rubiT9t3sGUyrj0KZuSGa9Yz+yl
	 1HFeNtg4rFNn/lp351XXkW1qsH+dudNfpny2s840k8A9MtIYKoweJCN02CErCVni/l
	 Cz2zPecEAzxgLYDC8A82UbYF/XJn3y5tVUF1qmf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 226/507] ACPI: property: Fix fwnode refcount leak in acpi_fwnode_graph_parse_endpoint()
Date: Tue, 16 Dec 2025 12:11:07 +0100
Message-ID: <20251216111353.693425090@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index d74678f0ba4af..57bf9c973c4f7 100644
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



