Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C5730EF7F;
	Fri, 21 Nov 2025 14:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733633; cv=none; b=oINIrpf6A0v6u7zbwUjK8PjqSjPwyogfwn+vIbrI7fSVnIN0h65e3P5XJTPFpUh3J2kJhS8VLTDp4wQPsjGDqKS+6NqqTTPpUx3CR7iyUxy+OtHpYlFyBtRzQlYHrSpNO/2v+lk5//KIYv3MN30gdoudm66w7+OJA2xINucZ1UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733633; c=relaxed/simple;
	bh=9nVuIh0QUp05dGxLbUT22k9uDGXP9UmuCQfoQKp4UgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfSXb3mEr7kwAtpV3aITDbG7IKABvThPl5fCVahBma3+vOyxjD5N7LihDrUKhMvaCuQIPQVmUwVG+hE7HuIWgLK5i7QLW5iH+I16RCXQVYMxhxcUqSXeLILHoeU8EQE9sKylCvcQGnP77fCmcv58GETdPMUrm+MNveCfl1DIrEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/VXJ+WY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/VXJ+WY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7872C4CEF1;
	Fri, 21 Nov 2025 14:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733633;
	bh=9nVuIh0QUp05dGxLbUT22k9uDGXP9UmuCQfoQKp4UgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/VXJ+WYFSSIiGL3JUqj/kRbYgr3JtPDCEXYvkvnXCOsMRyUFdZ+Q/9dZc1z8ER/T
	 Bw/CVOURoUdlSbr2Hr4U4zlMcj9/lU5V9pYk32Tm8Hv0T7lM0rjeVKPJt4+dkFL4f7
	 9bSMXfiI46pSlBdW7jY1vFbZEuMtLJ+HVkvxvYys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.6 528/529] ACPI: HMAT: Remove register of memory node for generic target
Date: Fri, 21 Nov 2025 14:13:47 +0100
Message-ID: <20251121130249.832091580@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Dave Jiang <dave.jiang@intel.com>

commit 54b9460b0a28c4c76a7b455ec1b3b61a13e97291 upstream.

For generic targets, there's no reason to call
register_memory_node_under_compute_node() with the access levels that are
only visible to HMAT handling code. Only update the attributes and rename
hmat_register_generic_target_initiators() to hmat_update_generic_target().

The original call path ends up triggering register_memory_node_under_compute_node().
Although the access level would be "3" and not impact any current node arrays, it
introduces unwanted data into the numa node access_coordinate array.

Fixes: a3a3e341f169 ("acpi: numa: Add setting of generic port system locality attributes")
Cc: Rafael J. Wysocki <rafael@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20240308220055.2172956-2-dave.jiang@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/numa/hmat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -729,12 +729,12 @@ static void __hmat_register_target_initi
 	}
 }
 
-static void hmat_register_generic_target_initiators(struct memory_target *target)
+static void hmat_update_generic_target(struct memory_target *target)
 {
 	static DECLARE_BITMAP(p_nodes, MAX_NUMNODES);
 
-	__hmat_register_target_initiators(target, p_nodes,
-					  NODE_ACCESS_CLASS_GENPORT_SINK);
+	hmat_update_target_attrs(target, p_nodes,
+				 NODE_ACCESS_CLASS_GENPORT_SINK);
 }
 
 static void hmat_register_target_initiators(struct memory_target *target)
@@ -818,7 +818,7 @@ static void hmat_register_target(struct
 	 */
 	mutex_lock(&target_lock);
 	if (*(u16 *)target->gen_port_device_handle) {
-		hmat_register_generic_target_initiators(target);
+		hmat_update_generic_target(target);
 		target->registered = true;
 	}
 	mutex_unlock(&target_lock);


