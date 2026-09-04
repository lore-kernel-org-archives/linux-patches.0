Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC72D2264A3;
	Fri,  4 Sep 2026 05:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500466; cv=none; b=o0pEX61BAk3Wyi5Abj8Zx0cAFsKMpkR1fcxLyosE4LQPmamBelrmUXezqQUQkJKxV8eh9CAJnSAtUquy9c0PljvNtM6ZiRcs/Nzz4AY1IFV7IIfjSD8AK3QiV2y1PjkqhVWKn1+yZPu598w5v7ao/YYpkAF2UuUTSNTpqET4pDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500466; c=relaxed/simple;
	bh=asPfHcDi392ckTA5zAjTLmtt/jy0MUpO4kXShCO8ryg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n56OHmF/Vf9MZS+GSVZ11wxvanSRlXnHHRQWDsXXvfft3IxyUguTgPFdi2b1l3dKM1RSj274TBXf0rVYshzI2QW6k3WKV5JkFOJ5vZevgMRaIDV05WYPVqiJx9vo4ZWZaAPoxjL15cibPRRlkSG7lajkqzXhny1uGVFnWjZjhPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCf2C7wl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCf2C7wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318CB1F00A3D;
	Fri,  4 Sep 2026 05:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500464;
	bh=aS/Nmkq+ZUj5TLJYcO3AL7Hlvwt6nZQD4CXSOmh2wWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FCf2C7wlrEMKf7eXbPUsdX73On2H6u9R7GdPbxhlIZqon6J+MtA6XxjKJa2Gqn2HN
	 B7JV5vSFip/eq1vWhGQrUnF2blTJA8zrlR1irqeM4ueub7TddGkqCkQm0riU8ANKY7
	 DFGJXKGqKaNc8MvKt2TYKjYS/Zy8UX2Z/UkwezWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.18 064/552] device property: fix infinite loop in fwnode_for_each_child_node()
Date: Fri,  4 Sep 2026 06:53:41 +0200
Message-ID: <20260904045749.298175152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 1900692555826753adab8799a1a8d50bb1ee200c upstream.

When iterate over children of a fwnode that has a secondary fwnode,
fwnode_get_next_child_node() can enter an infinite loop if the secondary
fwnode has more than one child.

                       Parent        Child
      (Primary fwnode)   FWa:   {FWa1, FWa2, FWa3}
    (Secondary fwnode)   FWb:   {FWb1, FWb2}

In this case:

 ┌─> fwnode_get_next_child_node(FWa, FWa1)
 │    - fwnode_call_ptr_op(FWa, get_next_child_node, FWa1) returns FWa2
 │
 │   ...
 │
 │   fwnode_get_next_child_node(FWa, FWa3)
 │    - fwnode_call_ptr_op(FWa, get_next_child_node, FWa3) returns NULL
 │    - fwnode_call_ptr_op(FWb, get_next_child_node, FWa3) returns FWb1
 │
 │   fwnode_get_next_child_node(FWa, FWb1)
 │    - fwnode_call_ptr_op(FWa, get_next_child_node, FWb1) returns FWa1
 └────┘

This cause fwnode_for_each_child_node() to loop indefinitely, reapeatedly
output {FWa1, FWa2, FWa3, FWb1, FWa1, ...}.

The root cause is that when the current child (FWb1) belongs to the
secondary fwnode, calling get_next_child_node() on the parimary fwnode
incorrectly returns the first child (FWa1) again instead of NULL.

Fix this by dynamically checking the parent fwnode of the current child
before calling get_next_child_node(). This approach follows the pattern
established in commit b5b41ab6b0c1 ("device property: Check
fwnode->secondary in fwnode_graph_get_next_endpoint()").

Fixes: 2692c614f8f0 ("device property: Allow secondary lookup in fwnode_get_next_child_node()")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://patch.msgid.link/20260611203537.1786399-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/property.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -797,18 +797,31 @@ struct fwnode_handle *
 fwnode_get_next_child_node(const struct fwnode_handle *fwnode,
 			   struct fwnode_handle *child)
 {
+	const struct fwnode_handle *parent;
+	struct fwnode_handle *child_parent __free(fwnode_handle) = NULL;
 	struct fwnode_handle *next;
 
-	if (IS_ERR_OR_NULL(fwnode))
+	/*
+	 * If this function is in a loop and the previous iteration returned
+	 * an child from fwnode->secondary, then we need to use the secondary
+	 * as parent rather than @fwnode.
+	 */
+	if (child) {
+		child_parent = fwnode_get_parent(child);
+		parent = child_parent;
+	} else {
+		parent = fwnode;
+	}
+	if (IS_ERR_OR_NULL(parent))
 		return NULL;
 
 	/* Try to find a child in primary fwnode */
-	next = fwnode_call_ptr_op(fwnode, get_next_child_node, child);
+	next = fwnode_call_ptr_op(parent, get_next_child_node, child);
 	if (next)
 		return next;
 
 	/* When no more children in primary, continue with secondary */
-	return fwnode_call_ptr_op(fwnode->secondary, get_next_child_node, child);
+	return fwnode_get_next_child_node(parent->secondary, NULL);
 }
 EXPORT_SYMBOL_GPL(fwnode_get_next_child_node);
 


