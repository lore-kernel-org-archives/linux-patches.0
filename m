Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99518378838;
	Fri,  4 Sep 2026 06:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501980; cv=none; b=ZPqH1sKNSIeB3llPScMY9F9n3jhs2/F6ngFt7YfRbDMx2xVnqGxkYK+mrBgBIOveqR4rhX+BVG7lG3wtfiKqe0t50OEYAdFcBPC0IVL5RpJguwMkdU32eCWmtNIfoXdGfNZWwTUOc7cZODgBfB9q0B6GgcYKrTvKKYawU+E91nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501980; c=relaxed/simple;
	bh=NeBFtwp7HoAkFHSU+VD783QWzxiAvizTe9CiBgim2gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f4hmZqgvkpvkenxT2DoMhVPalpn9DwRdr2JCad6JQylXXL5/7G1dl4xWTVe0uRWtuc+RHBAK1/dRWWkZ83PJHQxSxjAOPfdddJPKvS/Gfsvs/W45U/maoLUU0LA5wHjZLUdfZeVRCMa5bE5ENE9TREDvLhhIP1GH6bakPBhISmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8RPdJnB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8RPdJnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 004E11F00A3E;
	Fri,  4 Sep 2026 06:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501979;
	bh=J0NbR52R7mYNNwORlak001LkRv7chdgltCR8VPE7l2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O8RPdJnB2+RM7+5lnt7jxBaUwhH4c0UcmAF+3pE4LiLyDl5sR4kWrviAznHGa9RL7
	 iiWWH+Ri+ZpNOcMh6vF2+ELR+5hXO/cdXbOaSg7vPQOeGqS6qLvs/lAWt7iCPwcI6D
	 SPm7PFcTp2ZPpI12NJnE4rJIqRjkDIeWzXxyfKC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.12 040/403] device property: fix infinite loop in fwnode_for_each_child_node()
Date: Fri,  4 Sep 2026 06:57:23 +0200
Message-ID: <20260904045735.727044590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -759,18 +759,31 @@ struct fwnode_handle *
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
 


