Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8206183CD2;
	Sun,  1 Sep 2024 16:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209187; cv=none; b=ksVtP45DJg2y8tCilhn9EHYfwvOMFEUNWqH0IX3GECo6FhtxfLffqWo6PpLu6tWp7MAIruxp8StNlZmTrCJ1P+4jOHw68H1p8RtclY4AOXUJAlSEQf3/qp8TSE+7IzKEYVSz1SQUDKLUvTyvVatV36HgWPTMQHUH9qaxzd3zkQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209187; c=relaxed/simple;
	bh=6NAK0sQycs92IGvXFHu+cU7RQrWAf5ll2NYr84kOQgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2m+qi7w5Em4UPkoS8z7YabinZcq2dSmyAQxGsN0ObPMkICkAf67EzB6FkZJluKC4EolrppJU0jy5bwd7LVJ8v/8gOoa5DArn4qN6QgOvON4W0HUIJLcfLaRxxqLWuclPe8tz0XKunzGhbIrCWEELfVsJI1j2s0VdQ7BTAsJ9eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PzOTDuRy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PzOTDuRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4ABAC4CEC3;
	Sun,  1 Sep 2024 16:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209187;
	bh=6NAK0sQycs92IGvXFHu+cU7RQrWAf5ll2NYr84kOQgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PzOTDuRy18i+qrw8718lsthhc2sD1dHfIdynQD5nGlCGFnteXWFin9nVGuoBZ/JfW
	 NU8AxaRG1ebfbaWhKmOsdqdJKmxnuQlf9tsLfJ0fTmMclWuC2b8TispFNgLrWOpXIN
	 0RLoQtMJv+wXpOrBCtT1wDoVx+NgU2ohE1pDul9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 28/71] of: Introduce for_each_*_child_of_node_scoped() to automate of_node_put() handling
Date: Sun,  1 Sep 2024 18:17:33 +0200
Message-ID: <20240901160802.952136431@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 34af4554fb0ce164e2c4876683619eb1e23848d4 ]

To avoid issues with out of order cleanup, or ambiguity about when the
auto freed data is first instantiated, do it within the for loop definition.

The disadvantage is that the struct device_node *child variable creation
is not immediately obvious where this is used.
However, in many cases, if there is another definition of
struct device_node *child; the compiler / static analysers will notify us
that it is unused, or uninitialized.

Note that, in the vast majority of cases, the _available_ form should be
used and as code is converted to these scoped handers, we should confirm
that any cases that do not check for available have a good reason not
to.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20240225142714.286440-3-jic23@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Stable-dep-of: afc954fd223d ("thermal: of: Fix OF node leak in thermal_of_trips_init() error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/of.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/of.h b/include/linux/of.h
index 506e30e4c959c..2960e609ca05e 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -1373,10 +1373,23 @@ static inline int of_property_read_s32(const struct device_node *np,
 #define for_each_child_of_node(parent, child) \
 	for (child = of_get_next_child(parent, NULL); child != NULL; \
 	     child = of_get_next_child(parent, child))
+
+#define for_each_child_of_node_scoped(parent, child) \
+	for (struct device_node *child __free(device_node) =		\
+	     of_get_next_child(parent, NULL);				\
+	     child != NULL;						\
+	     child = of_get_next_child(parent, child))
+
 #define for_each_available_child_of_node(parent, child) \
 	for (child = of_get_next_available_child(parent, NULL); child != NULL; \
 	     child = of_get_next_available_child(parent, child))
 
+#define for_each_available_child_of_node_scoped(parent, child) \
+	for (struct device_node *child __free(device_node) =		\
+	     of_get_next_available_child(parent, NULL);			\
+	     child != NULL;						\
+	     child = of_get_next_available_child(parent, child))
+
 #define for_each_of_cpu_node(cpu) \
 	for (cpu = of_get_next_cpu_node(NULL); cpu != NULL; \
 	     cpu = of_get_next_cpu_node(cpu))
-- 
2.43.0



