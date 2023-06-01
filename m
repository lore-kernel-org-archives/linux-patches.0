Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A766E54A
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF3FC433D2;
	Thu,  1 Jun 2023 13:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625857;
	bh=blpFw6Hs25H0Wrulu6P5M0Y/actFofid44YwKWg/m0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vTq+wKmTOtxOTqWiIg+Qvi8AlOCkVCQOuRdRkIoo9HxSUf/x3uuN2IuezSrFiktZs
	 UvblIwCLgT4ogMFP7F1ji1tvuUW+d3cf/MGS0P8IYzt8yVV4FFq37imqp5ZLcnvMjg
	 RkFUjv76uamMjXOJTvJmuaHHveWDhSO4tYHeOHiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 21/42] net: dsa: introduce helpers for iterating through ports using dp
Date: Thu,  1 Jun 2023 14:21:08 +0100
Message-Id: <20230601131937.674646135@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131936.699199833@linuxfoundation.org>
References: <20230601131936.699199833@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 82b318983c515f29b8b3a0dad9f6a5fe8a68a7f4 ]

Since the DSA conversion from the ds->ports array into the dst->ports
list, the DSA API has encouraged driver writers, as well as the core
itself, to write inefficient code.

Currently, code that wants to filter by a specific type of port when
iterating, like {!unused, user, cpu, dsa}, uses the dsa_is_*_port helper.
Under the hood, this uses dsa_to_port which iterates again through
dst->ports. But the driver iterates through the port list already, so
the complexity is quadratic for the typical case of a single-switch
tree.

This patch introduces some iteration helpers where the iterator is
already a struct dsa_port *dp, so that the other variant of the
filtering functions, dsa_port_is_{unused,user,cpu_dsa}, can be used
directly on the iterator. This eliminates the second lookup.

These functions can be used both by the core and by drivers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 120a56b01bee ("net: dsa: mt7530: fix network connectivity with multiple CPU ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dsa.h | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index d784e76113b8d..bec439c4a0859 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -472,6 +472,34 @@ static inline bool dsa_is_user_port(struct dsa_switch *ds, int p)
 	return dsa_to_port(ds, p)->type == DSA_PORT_TYPE_USER;
 }
 
+#define dsa_tree_for_each_user_port(_dp, _dst) \
+	list_for_each_entry((_dp), &(_dst)->ports, list) \
+		if (dsa_port_is_user((_dp)))
+
+#define dsa_switch_for_each_port(_dp, _ds) \
+	list_for_each_entry((_dp), &(_ds)->dst->ports, list) \
+		if ((_dp)->ds == (_ds))
+
+#define dsa_switch_for_each_port_safe(_dp, _next, _ds) \
+	list_for_each_entry_safe((_dp), (_next), &(_ds)->dst->ports, list) \
+		if ((_dp)->ds == (_ds))
+
+#define dsa_switch_for_each_port_continue_reverse(_dp, _ds) \
+	list_for_each_entry_continue_reverse((_dp), &(_ds)->dst->ports, list) \
+		if ((_dp)->ds == (_ds))
+
+#define dsa_switch_for_each_available_port(_dp, _ds) \
+	dsa_switch_for_each_port((_dp), (_ds)) \
+		if (!dsa_port_is_unused((_dp)))
+
+#define dsa_switch_for_each_user_port(_dp, _ds) \
+	dsa_switch_for_each_port((_dp), (_ds)) \
+		if (dsa_port_is_user((_dp)))
+
+#define dsa_switch_for_each_cpu_port(_dp, _ds) \
+	dsa_switch_for_each_port((_dp), (_ds)) \
+		if (dsa_port_is_cpu((_dp)))
+
 static inline u32 dsa_user_ports(struct dsa_switch *ds)
 {
 	u32 mask = 0;
-- 
2.39.2



