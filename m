Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3013346797;
	Tue, 17 Mar 2026 17:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767965; cv=none; b=oywJxiyTjsiypXtl8tV25RZEFQVn+AOoKPYW6ebOcY8rMX/ssRXLWw/Ajhn1wHykqnNVB+6RVbFqAxvrZCeMrgEDPBiyP1gJvYR5HRtjyKDXhUicKYJS+O90RolkKEtheVzL+9Z0PPT0Sg9NXUbhgFamLyWkFuoF9FjbMkNhVr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767965; c=relaxed/simple;
	bh=vcU711aL05sHZZ0YJEP2fgdN1Ff54bxaQ8OCd3t39s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZIRYjXhWBVVoKnAtgX3ZRpQmK6oyPgb7Nn497LnEqy5fe1/07dogiII0ZMFpt9MoA88tBUWMolvQKIZkDS3xEUkXIBnnFlz+98OSjyJ0R/yM8uoaVKvEZNn0HHD7FNjxxti0NV0lX/gB0Xt+0kaqDJE/ISRkK0qZxX/Ni8Bbtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbGAWfs2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbGAWfs2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED00C4CEF7;
	Tue, 17 Mar 2026 17:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767965;
	bh=vcU711aL05sHZZ0YJEP2fgdN1Ff54bxaQ8OCd3t39s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbGAWfs2cG+UJJmNjw4vJIqB3iyl+HA2pTDu0domULjzaGwBxFvQPndU18+OqHWnc
	 6u3W6iEgH1YZvx5NtMv9Ueb7mVt7/vUZv1q5IrLWSLMewTe9CPYPQfXvpHd/fGO3aH
	 qO4xHIOKOqDZjtHmFnC4ieV+9DF192aJm3rUWR60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 201/333] device property: Allow secondary lookup in fwnode_get_next_child_node()
Date: Tue, 17 Mar 2026 17:33:50 +0100
Message-ID: <20260317163006.810295770@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 2692c614f8f05929d692b3dbfd3faef1f00fbaf0 upstream.

When device_get_child_node_count() got split to the fwnode and device
respective APIs, the fwnode didn't inherit the ability to traverse over
the secondary fwnode. Hence any user, that switches from device to fwnode
API misses this feature. In particular, this was revealed by the commit
1490cbb9dbfd ("device property: Split fwnode_get_child_node_count()")
that effectively broke the GPIO enumeration on Intel Galileo boards.
Fix this by moving the secondary lookup from device to fwnode API.

Note, in general no device_*() API should go into the depth of the fwnode
implementation.

Fixes: 114dbb4fa7c4 ("drivers property: When no children in primary, try secondary")
Cc: stable@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Link: https://patch.msgid.link/20260210135822.47335-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/property.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -797,7 +797,18 @@ struct fwnode_handle *
 fwnode_get_next_child_node(const struct fwnode_handle *fwnode,
 			   struct fwnode_handle *child)
 {
-	return fwnode_call_ptr_op(fwnode, get_next_child_node, child);
+	struct fwnode_handle *next;
+
+	if (IS_ERR_OR_NULL(fwnode))
+		return NULL;
+
+	/* Try to find a child in primary fwnode */
+	next = fwnode_call_ptr_op(fwnode, get_next_child_node, child);
+	if (next)
+		return next;
+
+	/* When no more children in primary, continue with secondary */
+	return fwnode_call_ptr_op(fwnode->secondary, get_next_child_node, child);
 }
 EXPORT_SYMBOL_GPL(fwnode_get_next_child_node);
 
@@ -841,19 +852,7 @@ EXPORT_SYMBOL_GPL(fwnode_get_next_availa
 struct fwnode_handle *device_get_next_child_node(const struct device *dev,
 						 struct fwnode_handle *child)
 {
-	const struct fwnode_handle *fwnode = dev_fwnode(dev);
-	struct fwnode_handle *next;
-
-	if (IS_ERR_OR_NULL(fwnode))
-		return NULL;
-
-	/* Try to find a child in primary fwnode */
-	next = fwnode_get_next_child_node(fwnode, child);
-	if (next)
-		return next;
-
-	/* When no more children in primary, continue with secondary */
-	return fwnode_get_next_child_node(fwnode->secondary, child);
+	return fwnode_get_next_child_node(dev_fwnode(dev), child);
 }
 EXPORT_SYMBOL_GPL(device_get_next_child_node);
 


