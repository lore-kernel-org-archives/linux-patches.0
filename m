Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5E33290D1;
	Sat, 12 Sep 2026 16:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231074; cv=none; b=aZF1NeMektt6v0O7paqHhb2Xb7OzWlMptnI66skh23MI3RTPN0Bm9fDsnPkLkcOZM2sTIibv1yCDQxDqJN5m13bgts1y80TrWV61gr2a/yZbWxlYNuRC3oTw9ybMQaRUECMvE2oVVlTjCnNFIbIoV0YNu/i/Fy1aQLkRI2n5wBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231074; c=relaxed/simple;
	bh=X4s/fq8O1xYZJgVOY35SKHvUr4oYBMRGWeztI5jIcwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nt0s2ENIiF7LAH8wU7C93qNLEK02kSk3hwMLk7s0YiNR0btgnJcolnnnM80QnlAL4SvSr7Et98UIj8ZJHiXh+JfJocnFtOfG3gHgAVXWkAWMS+HshXmOKKDbreTkOTcl8mMt+OV3JiBhv2v+Nyo2l0y1I4oxNPRJINh1P/yHwL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YJJ/KCjL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YJJ/KCjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F011F000FF;
	Sat, 12 Sep 2026 16:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231072;
	bh=x4OF1SUdGgYkQ6ofHTM8iWVlTWEnKC5lravfo8IFaAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YJJ/KCjLiJO0ZpOMiDFEHsnQwAmb18X+4BJmcIJM+rIT/gnMRzjclK/4obZ9Cj4M7
	 X+vT8mdbhbIbTN9z8INBZuPvn+rMfl4lxT3C8lzxnqQuCPGcWW7CMNMTayzKXfvX83
	 8f1HnmYUfWxHNu3bS1iXORVzbJXFc16LkIg2V5b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0881/1191] of: property: add of_graph_get_next_port_endpoint()
Date: Sat, 12 Sep 2026 09:00:09 +0200
Message-ID: <20260912065608.032461828@linuxfoundation.org>
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

[ Upstream commit 58fe47d6ac7413172e1fa88324fb1b4c0eb2c0a2 ]

We already have of_graph_get_next_endpoint(), but it is not
intuitive to use in some case.

(X)	node {
(Y)		ports {
(P0)			port@0 { endpoint { remote-endpoint = ...; };};
(P10)			port@1 { endpoint { remote-endpoint = ...; };
(P11)				 endpoint { remote-endpoint = ...; };};
(P2)			port@2 { endpoint { remote-endpoint = ...; };};
		};
	};

For example, if I want to handle port@1's 2 endpoints (= P10, P11),
I want to use like below

	P10 = of_graph_get_next_endpoint(port1, NULL);
	P11 = of_graph_get_next_endpoint(port1, P10);

But 1st one will be error, because of_graph_get_next_endpoint()
requested 1st parameter is "node" (X) or "ports" (Y), not but "port".
Below works well, but it will get P0

	P0 = of_graph_get_next_endpoint(node,  NULL);
	P0 = of_graph_get_next_endpoint(ports, NULL);

In other words, we can't handle P10/P11 directly via
of_graph_get_next_endpoint().

There is another non intuitive behavior on of_graph_get_next_endpoint().
In case of if I could get P10 pointer for some way, and if I want to
handle port@1 things by loop, I would like use it like below

	/*
	 * "ep" is now P10, and handle port1 things here,
	 * but we don't know how many endpoints port1 have.
	 *
	 * Because "ep" is non NULL now, we can use port1
	 * as of_graph_get_next_endpoint(port1, xxx)
	 */
	do {
		/* do something for port1 specific things here */
	} while (ep = of_graph_get_next_endpoint(port1, ep))

But it also not worked as I expected.
I expect it will be P10 -> P11 -> NULL,
but      it will be P10 -> P11 -> P2,    because
of_graph_get_next_endpoint() will fetch "endpoint" beyond the "port".
It is not useful for generic driver.

To handle endpoint more intuitive, create of_graph_get_next_port_endpoint()

	of_graph_get_next_port_endpoint(port1, NULL); // P10
	of_graph_get_next_port_endpoint(port1, P10);  // P11
	of_graph_get_next_port_endpoint(port1, P11);  // NULL

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87jzdyb5t5.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Stable-dep-of: 62bac3202042 ("drm/sun4i: tcon-top: Keep mixer routes distinct")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/property.c    | 27 +++++++++++++++++++++++++++
 include/linux/of_graph.h | 21 +++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/of/property.c b/drivers/of/property.c
index c4bd3f0965dc0..c7183c5aa221d 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -668,6 +668,33 @@ struct device_node *of_graph_get_next_port(const struct device_node *parent,
 }
 EXPORT_SYMBOL(of_graph_get_next_port);
 
+/**
+ * of_graph_get_next_port_endpoint() - get next endpoint node in port.
+ * If it reached to end of the port, it will return NULL.
+ * @port: pointer to the target port node
+ * @prev: previous endpoint node, or NULL to get first
+ *
+ * Return: An 'endpoint' node pointer with refcount incremented. Refcount
+ * of the passed @prev node is decremented.
+ */
+struct device_node *of_graph_get_next_port_endpoint(const struct device_node *port,
+						    struct device_node *prev)
+{
+	while (1) {
+		prev = of_get_next_child(port, prev);
+		if (!prev)
+			break;
+		if (WARN(!of_node_name_eq(prev, "endpoint"),
+			 "non endpoint node is used (%pOF)", prev))
+			continue;
+
+		break;
+	}
+
+	return prev;
+}
+EXPORT_SYMBOL(of_graph_get_next_port_endpoint);
+
 /**
  * of_graph_get_next_endpoint() - get next endpoint node
  * @parent: pointer to the parent device node
diff --git a/include/linux/of_graph.h b/include/linux/of_graph.h
index 44518f3583a44..a692d9d979a64 100644
--- a/include/linux/of_graph.h
+++ b/include/linux/of_graph.h
@@ -50,6 +50,18 @@ struct of_endpoint {
 	for (struct device_node *child __free(device_node) = of_graph_get_next_port(parent, NULL);\
 	     child != NULL; child = of_graph_get_next_port(parent, child))
 
+/**
+ * for_each_of_graph_port_endpoint - iterate over every endpoint in a port node
+ * @parent: parent port node
+ * @child: loop variable pointing to the current endpoint node
+ *
+ * When breaking out of the loop, and continue to use the @child, you need to
+ * use return_ptr(@child) or no_free_ptr(@child) not to call __free() for it.
+ */
+#define for_each_of_graph_port_endpoint(parent, child)			\
+	for (struct device_node *child __free(device_node) = of_graph_get_next_port_endpoint(parent, NULL);\
+	     child != NULL; child = of_graph_get_next_port_endpoint(parent, child))
+
 #ifdef CONFIG_OF
 bool of_graph_is_present(const struct device_node *node);
 int of_graph_parse_endpoint(const struct device_node *node,
@@ -61,6 +73,8 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 					struct device_node *previous);
 struct device_node *of_graph_get_next_port(const struct device_node *parent,
 					   struct device_node *port);
+struct device_node *of_graph_get_next_port_endpoint(const struct device_node *port,
+						    struct device_node *prev);
 struct device_node *of_graph_get_endpoint_by_regs(
 		const struct device_node *parent, int port_reg, int reg);
 struct device_node *of_graph_get_remote_endpoint(
@@ -114,6 +128,13 @@ static inline struct device_node *of_graph_get_next_port(
 	return NULL;
 }
 
+static inline struct device_node *of_graph_get_next_port_endpoint(
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



