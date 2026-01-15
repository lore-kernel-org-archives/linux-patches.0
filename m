Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616CE2D541B;
	Thu, 15 Jan 2026 17:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499004; cv=none; b=b+IHS8eymvBc0X2+Q9v/dH/T60nGAHnEw9L4qRgq5POAhbVpNnE2t0Z+V8KVxUZLmJHbL4KRk75kaEyLAYU9CEerNMB6BJad5aEBAiagX+7+UbVWmMFspksZe7zofkmwCcEMaAhpxpkjtttyNDsJ84VjI4uM38Ut6DxkdWnKPyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499004; c=relaxed/simple;
	bh=iL8HG70ghfCwCJxpOoNOwpdXjOx+4klQhX6ogx+6EmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7CCnr31xiFkpAQJikYMMWWgpwLzkdmLMY9vdx47Axs0EJ1NtaeaAdc2WcisAB0ygn/UpLKqIybfpG+H1uFi9CNMHv3Z13E1/4fhfiP65mdrKkF6J2+Wevc4xURC7IZxkbzYUsoGDgyi3LiK5PlH/1f71Z3dVbhtkDxi5Snwdkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dmk35ycK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dmk35ycK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39C6C116D0;
	Thu, 15 Jan 2026 17:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499004;
	bh=iL8HG70ghfCwCJxpOoNOwpdXjOx+4klQhX6ogx+6EmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dmk35ycKuCJhF6NIPdQeNJ3GCpz8243vdvfOeNaA9QTRiVzEscJS5vp0JaGE/iD2O
	 lvkSHA8l5AI4EC8fFvjKzwhHT43z7IGPzYszhB6sjw6im+ino+RnlO4ijBzgYUJyRm
	 Yb+IOIu/nvlCrIXc3lYSxAJ4/L2rscD4cnShJ2Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/451] ACPI: property: Fix fwnode refcount leak in acpi_fwnode_graph_parse_endpoint()
Date: Thu, 15 Jan 2026 17:44:35 +0100
Message-ID: <20260115164233.577414774@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 821150dcb9762..7c3d98fae457d 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1423,6 +1423,7 @@ static int acpi_fwnode_graph_parse_endpoint(const struct fwnode_handle *fwnode,
 	if (fwnode_property_read_u32(fwnode, "reg", &endpoint->id))
 		fwnode_property_read_u32(fwnode, "endpoint", &endpoint->id);
 
+	fwnode_handle_put(port_fwnode);
 	return 0;
 }
 
-- 
2.51.0



