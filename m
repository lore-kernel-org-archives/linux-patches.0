Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208130;
	b=l0nIvUqDHTWF+DRX04FBjPTKaopGQ/I2yu8iFvTgtYU2axXnyBPqNWmX4skRnzFCq2fx
	 PfmZYQOSa1z6EviTMP/o8acv6yzhmrtOCtsAkKbsA8deYT56oDdRqv1k9NKrkj+ak2yB9
	 OhmxejE/dskTcT8xfmYivG1uohId/2FaiKvxYsHazpyRvWmcd/fp89Hg5ehYEMYEN0Woj
	 CaZYxAnCq4oTryHAQhyZfdbyAyVslhqnyxBUciIMQShM1mt/oPVQ490nL1LUI23um9Fsg
	 6jM1v+OdRSF4vLc1cgWRLgZiQdcfpVREwFCLgef4snypa6QYe9rBQN92WAbSrGWbRyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=AwKYHpiBBsa2I3YuvDgz5iNUuviSwSrYb7fLM6O8p3k=;
	b=Rprzm3/2ZNscs1IzyfTxbbEPg8H3J/VqlZUchFioDecgfeij91sqwhgPBVc1fB1qjD8z
	 X1xfB21exfTMROrKNWiOhnjj+TihUowEuHSZjGb4uoTZv3ktf9oRRPB/cf36J+yKVxDDH
	 7gRPcH3OHfJaOI18/7nLtARKhm2I4SmJSqzlb3OIAd17Ta7GnopTgIfQELJvxiSAOPORB
	 NcGgT80MjaLcPaDmpfa0RDWOL4/g7GSUsEl7PZhCLjSJXhwl8oygfieEAQi2Z5T1IDpky
	 u1cbEerSopa4cOmqUdsXYy73WdB0RwHnwekaqkm9vTyd0RlGmUtESJPuV+b4DDtdKZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FgdA8vo+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF270606A331;
	Wed, 28 Oct 2026 17:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FgdA8vo+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F6E1F01825;
	Wed, 28 Oct 2026 17:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208129;
	bh=AwKYHpiBBsa2I3YuvDgz5iNUuviSwSrYb7fLM6O8p3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FgdA8vo+pDWjixYhlvd0GQesECo/f1WUH83/dxjnS/EFdIsMwrN8NG2SyW47tYaX4
	 cRtcUFfPJhLysH6kqsjGuLh9iEtCY+/zmFkvEyGWNqYTAEx0v3Tr20LA6vQixJKaMx
	 AlN29/rDbd0eSrayaeOVRihuUsxQXiKataUmft5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/516] device property: fix infinite loop in fwnode_for_each_child_node()
Date: Wed, 28 Oct 2026 17:52:36 +0100
Message-ID: <20261028170003.631388847@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 1900692555826753adab8799a1a8d50bb1ee200c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/property.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 4b16531d77916..2601c1d806c51 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -740,18 +740,31 @@ struct fwnode_handle *
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
 
-- 
2.53.0



