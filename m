Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C212882AB;
	Sat, 12 Sep 2026 16:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231069; cv=none; b=QfZx/898xTq3hmh2qQLLu0hAz3sBbfyPfK7ePI56viOAU2LqgdKLFXn4x0gPkrw6Km3v4xzHN5VYOXoSq1TjGUtyK7jBRoLjIyqJW8YekSkulBIQOwXn7rexyz3n5WIMzUdn82foj2BhAlL/ll61/UVRNpbwsNxzUVAbam6XOIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231069; c=relaxed/simple;
	bh=CY14ljdmpZqyiZnu4DV+DUpLGqNW8mYZnoB8/WeMVfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sUwIyXCCQ2mChdTLV0lsNNfrEuo6Hjjj2nVfC5KCfklw74QeRX2UFJ41+ZAJEAwGgMsxGm7wR7GYvshM+0eh87+5VYSJH+JqlaWPLWHItSWo/FhJbOes5FY4yso9SWB3Bi94Q6aQTVm7grKWquQrbdLxBWPw2X5nh0wbzt6ibx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKEtPNoR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKEtPNoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BBB1F000FF;
	Sat, 12 Sep 2026 16:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231067;
	bh=npbZO/MQ9Uq7BlkCbITBCiRDK8uc5Gx4mDMwk1kgPFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bKEtPNoR/gtYIXvMzvYVD0PLvKfzMEGJYLZ0h2+c8DfD2E/D3SMBPeIqUCZdKg2+c
	 XibVqy6XHFlkYS5jOk+EQKK3hD2373kha+acnSi7JSlfl3KKlIBPlwVPsjoMzUBC8t
	 5poKWG9cnxD5/3s/RnvHzoL4rPczyUJpwB2ztLrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0880/1191] of: property: add of_graph_get_next_port()
Date: Sat, 12 Sep 2026 09:00:08 +0200
Message-ID: <20260912065608.010731911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 02ac5f9d6caec96071103f7c62b5117526e47b64 ]

We have endpoint base functions
	- of_graph_get_next_endpoint()
	- of_graph_get_endpoint_count()
	- for_each_endpoint_of_node()

Here, for_each_endpoint_of_node() loop finds each endpoints

	ports {
		port@0 {
(1)			endpoint {...};
		};
		port@1 {
(2)			endpoint {...};
		};
		...
	};

In above case, it finds endpoint as (1) -> (2) -> ...

Basically, user/driver knows which port is used for what, but not in
all cases. For example on flexible/generic driver case, how many ports
are used is not fixed.

For example Sound Generic Card driver which is very flexible/generic and
used from many venders can't know how many ports are used, and used for
what, because it depends on each vender SoC and/or its used board.

And more, the port can have multi endpoints. For example Generic Sound
Card case, it supports many type of connection between CPU / Codec, and
some of them uses multi endpoint in one port. see below.

	ports {
(A)		port@0 {
(1)			endpoint@0 {...};
(2)			endpoint@1 {...};
		};
(B)		port@1 {
(3)			endpoint {...};
		};
		...
	};

Generic Sound Card want to handle each connection via "port" base instead
of "endpoint" base. But, it is very difficult to handle each "port" via
existing for_each_endpoint_of_node(). Because getting each "port" via
of_get_parent() from each "endpoint" doesn't work. For example in above
case, both (1) (2) endpoint has same "port" (= A).

Add "port" base functions.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87ldyeb5t9.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Stable-dep-of: 62bac3202042 ("drm/sun4i: tcon-top: Keep mixer routes distinct")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/property.c    | 54 ++++++++++++++++++++++++++++++++++++++++
 include/linux/of_graph.h | 28 +++++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index 0993417f071ad..c4bd3f0965dc0 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -631,6 +631,43 @@ struct device_node *of_graph_get_port_by_id(struct device_node *parent, u32 id)
 }
 EXPORT_SYMBOL(of_graph_get_port_by_id);
 
+/**
+ * of_graph_get_next_port() - get next port node.
+ * @parent: pointer to the parent device node, or parent ports node
+ * @prev: previous port node, or NULL to get first
+ *
+ * Parent device node can be used as @parent whether device node has ports node
+ * or not. It will work same as ports@0 node.
+ *
+ * Return: A 'port' node pointer with refcount incremented. Refcount
+ * of the passed @prev node is decremented.
+ */
+struct device_node *of_graph_get_next_port(const struct device_node *parent,
+					   struct device_node *prev)
+{
+	if (!parent)
+		return NULL;
+
+	if (!prev) {
+		struct device_node *node __free(device_node) =
+			of_get_child_by_name(parent, "ports");
+
+		if (node)
+			parent = node;
+
+		return of_get_child_by_name(parent, "port");
+	}
+
+	do {
+		prev = of_get_next_child(parent, prev);
+		if (!prev)
+			break;
+	} while (!of_node_name_eq(prev, "port"));
+
+	return prev;
+}
+EXPORT_SYMBOL(of_graph_get_next_port);
+
 /**
  * of_graph_get_next_endpoint() - get next endpoint node
  * @parent: pointer to the parent device node
@@ -831,6 +868,23 @@ unsigned int of_graph_get_endpoint_count(const struct device_node *np)
 }
 EXPORT_SYMBOL(of_graph_get_endpoint_count);
 
+/**
+ * of_graph_get_port_count() - get the number of port in a device or ports node
+ * @np: pointer to the device or ports node
+ *
+ * Return: count of port of this device or ports node
+ */
+unsigned int of_graph_get_port_count(struct device_node *np)
+{
+	unsigned int num = 0;
+
+	for_each_of_graph_port(np, port)
+		num++;
+
+	return num;
+}
+EXPORT_SYMBOL(of_graph_get_port_count);
+
 /**
  * of_graph_get_remote_node() - get remote parent device_node for given port/endpoint
  * @node: pointer to parent device_node containing graph port/endpoint
diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
index a4bea62bfa290..44518f3583a44 100644
--- a/include/linux/of_graph.h
+++ b/include/linux/of_graph.h
@@ -11,6 +11,7 @@
 #ifndef __LINUX_OF_GRAPH_H
 #define __LINUX_OF_GRAPH_H
 
+#include <linux/cleanup.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 
@@ -37,14 +38,29 @@ struct of_endpoint {
 	for (child = of_graph_get_next_endpoint(parent, NULL); child != NULL; \
 	     child = of_graph_get_next_endpoint(parent, child))
 
+/**
+ * for_each_of_graph_port - iterate over every port in a device or ports node
+ * @parent: parent device or ports node containing port
+ * @child: loop variable pointing to the current port node
+ *
+ * When breaking out of the loop, and continue to use the @child, you need to
+ * use return_ptr(@child) or no_free_ptr(@child) not to call __free() for it.
+ */
+#define for_each_of_graph_port(parent, child)			\
+	for (struct device_node *child __free(device_node) = of_graph_get_next_port(parent, NULL);\
+	     child != NULL; child = of_graph_get_next_port(parent, child))
+
 #ifdef CONFIG_OF
 bool of_graph_is_present(const struct device_node *node);
 int of_graph_parse_endpoint(const struct device_node *node,
 				struct of_endpoint *endpoint);
 unsigned int of_graph_get_endpoint_count(const struct device_node *np);
+unsigned int of_graph_get_port_count(struct device_node *np);
 struct device_node *of_graph_get_port_by_id(struct device_node *node, u32 id);
 struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 					struct device_node *previous);
+struct device_node *of_graph_get_next_port(const struct device_node *parent,
+					   struct device_node *port);
 struct device_node *of_graph_get_endpoint_by_regs(
 		const struct device_node *parent, int port_reg, int reg);
 struct device_node *of_graph_get_remote_endpoint(
@@ -73,6 +89,11 @@ static inline unsigned int of_graph_get_endpoint_count(const struct device_node
 	return 0;
 }
 
+static inline unsigned int of_graph_get_port_count(struct device_node *np)
+{
+	return 0;
+}
+
 static inline struct device_node *of_graph_get_port_by_id(
 					struct device_node *node, u32 id)
 {
@@ -86,6 +107,13 @@ static inline struct device_node *of_graph_get_next_endpoint(
 	return NULL;
 }
 
+static inline struct device_node *of_graph_get_next_port(
+					const struct device_node *parent,
+					struct device_node *previous)
+{
+	return NULL;
+}
+
 static inline struct device_node *of_graph_get_endpoint_by_regs(
 		const struct device_node *parent, int port_reg, int reg)
 {
-- 
2.53.0



