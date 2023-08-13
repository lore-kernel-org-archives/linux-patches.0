Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FFC9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297D8C433C9;
	Sun, 13 Aug 2023 21:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962448;
	bh=O+GO/qEWAHM/XGB1olFgTqNxm8sw1gsg2srCzxkJEFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RwAhelgPTSR21MdvuwkxRPvQor14/qOzG8X8/tXf68AVenreQV1FsIq7YAvZdYyot
	 oxTegxeSXp3XXmBpu00aM3iOspI+n4uHb/16+BUdnNci2On4gm9Eg9tzk9lamUrLT9
	 uW+euN0KzzID4xd0hYiiQGeUQNGrYXLRDvb1qWSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hanssson <ulf.hansson@linaro.org>,
	Maulik Shah <quic_mkshah@quicinc.com>
Subject: [PATCH 6.1 033/149] cpuidle: dt_idle_genpd: Add helper function to remove genpd topology
Date: Sun, 13 Aug 2023 23:17:58 +0200
Message-ID: <20230813211719.796706635@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maulik Shah <quic_mkshah@quicinc.com>

commit 9a8fa00dad3c7b260071f2f220cfb00505372c40 upstream.

Genpd parent and child domain topology created using dt_idle_pd_init_topology()
needs to be removed during error cases.

Add new helper function dt_idle_pd_remove_topology() for same.

Cc: stable@vger.kernel.org
Reviewed-by: Ulf Hanssson <ulf.hansson@linaro.org>
Signed-off-by: Maulik Shah <quic_mkshah@quicinc.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpuidle/dt_idle_genpd.c |   24 ++++++++++++++++++++++++
 drivers/cpuidle/dt_idle_genpd.h |    7 +++++++
 2 files changed, 31 insertions(+)

--- a/drivers/cpuidle/dt_idle_genpd.c
+++ b/drivers/cpuidle/dt_idle_genpd.c
@@ -152,6 +152,30 @@ int dt_idle_pd_init_topology(struct devi
 	return 0;
 }
 
+int dt_idle_pd_remove_topology(struct device_node *np)
+{
+	struct device_node *node;
+	struct of_phandle_args child, parent;
+	int ret;
+
+	for_each_child_of_node(np, node) {
+		if (of_parse_phandle_with_args(node, "power-domains",
+					"#power-domain-cells", 0, &parent))
+			continue;
+
+		child.np = node;
+		child.args_count = 0;
+		ret = of_genpd_remove_subdomain(&parent, &child);
+		of_node_put(parent.np);
+		if (ret) {
+			of_node_put(node);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 struct device *dt_idle_attach_cpu(int cpu, const char *name)
 {
 	struct device *dev;
--- a/drivers/cpuidle/dt_idle_genpd.h
+++ b/drivers/cpuidle/dt_idle_genpd.h
@@ -14,6 +14,8 @@ struct generic_pm_domain *dt_idle_pd_all
 
 int dt_idle_pd_init_topology(struct device_node *np);
 
+int dt_idle_pd_remove_topology(struct device_node *np);
+
 struct device *dt_idle_attach_cpu(int cpu, const char *name);
 
 void dt_idle_detach_cpu(struct device *dev);
@@ -35,6 +37,11 @@ static inline int dt_idle_pd_init_topolo
 {
 	return 0;
 }
+
+static inline int dt_idle_pd_remove_topology(struct device_node *np)
+{
+	return 0;
+}
 
 static inline struct device *dt_idle_attach_cpu(int cpu, const char *name)
 {


