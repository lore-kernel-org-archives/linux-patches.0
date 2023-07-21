Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB2720F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D97DC433C7;
	Fri, 21 Jul 2023 19:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967517;
	bh=zm1+k2QD7Z6ahsCWfXueQiPnEDROfnqi3KDPu5vlm9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MaxvGv4D2d4hHP4P/6CiYJlUg4dPpy340SucEXVf8ZPHPM4UTU8k/aAnzIEF3xGr5
	 /o7lgqrJ1YpJFGl5lv2oglJAw2VP5O30+eGtmJ/19sTe4dQbdjfi8qiuAQAwbx1Cw/
	 Y3Eex0FJzAy6i5iI3WwX/6R7BeTv/SuwiMqqwbUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chungkai Yang <Chung-kai.Yang@mediatek.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 190/223] PM: QoS: Restore support for default value on frequency QoS
Date: Fri, 21 Jul 2023 18:07:23 +0200
Message-ID: <20230721160528.986419565@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chungkai Yang <Chung-kai.Yang@mediatek.com>

commit 3a8395b565b5b4f019b3dc182be4c4541eb35ac8 upstream.

Commit 8d36694245f2 ("PM: QoS: Add check to make sure CPU freq is
non-negative") makes sure CPU freq is non-negative to avoid negative
value converting to unsigned data type. However, when the value is
PM_QOS_DEFAULT_VALUE, pm_qos_update_target specifically uses
c->default_value which is set to FREQ_QOS_MIN/MAX_DEFAULT_VALUE when
cpufreq_policy_alloc is executed, for this case handling.

Adding check for PM_QOS_DEFAULT_VALUE to let default setting work will
fix this problem.

Fixes: 8d36694245f2 ("PM: QoS: Add check to make sure CPU freq is non-negative")
Link: https://lore.kernel.org/lkml/20230626035144.19717-1-Chung-kai.Yang@mediatek.com/
Link: https://lore.kernel.org/lkml/20230627071727.16646-1-Chung-kai.Yang@mediatek.com/
Link: https://lore.kernel.org/lkml/CAJZ5v0gxNOWhC58PHeUhW_tgf6d1fGJVZ1x91zkDdht11yUv-A@mail.gmail.com/
Signed-off-by: Chungkai Yang <Chung-kai.Yang@mediatek.com>
Cc: 6.0+ <stable@vger.kernel.org> # 6.0+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/qos.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index af51ed6d45ef..782d3b41c1f3 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -426,6 +426,11 @@ late_initcall(cpu_latency_qos_init);
 
 /* Definitions related to the frequency QoS below. */
 
+static inline bool freq_qos_value_invalid(s32 value)
+{
+	return value < 0 && value != PM_QOS_DEFAULT_VALUE;
+}
+
 /**
  * freq_constraints_init - Initialize frequency QoS constraints.
  * @qos: Frequency QoS constraints to initialize.
@@ -531,7 +536,7 @@ int freq_qos_add_request(struct freq_constraints *qos,
 {
 	int ret;
 
-	if (IS_ERR_OR_NULL(qos) || !req || value < 0)
+	if (IS_ERR_OR_NULL(qos) || !req || freq_qos_value_invalid(value))
 		return -EINVAL;
 
 	if (WARN(freq_qos_request_active(req),
@@ -563,7 +568,7 @@ EXPORT_SYMBOL_GPL(freq_qos_add_request);
  */
 int freq_qos_update_request(struct freq_qos_request *req, s32 new_value)
 {
-	if (!req || new_value < 0)
+	if (!req || freq_qos_value_invalid(new_value))
 		return -EINVAL;
 
 	if (WARN(!freq_qos_request_active(req),
-- 
2.41.0



