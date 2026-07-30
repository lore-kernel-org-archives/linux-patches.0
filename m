Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C93A37B012;
	Thu, 30 Jul 2026 15:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426042; cv=none; b=BXI2ScPlpE1d3PVcQvBO7gw2LQ5W+8GOV+hOvffRjXxHVl+oXsoXrl3hL6gW+G4i/I7VWkkds3falzoIPpyHWrbvsBZ+1car76BViiHQTBi74oIxFNqWcRvbmVLlIEVvQGE0vZYE4uyF6ffsZOQLU4QZ7j2tilPKss0wfzylBcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426042; c=relaxed/simple;
	bh=8zg+lhe5S2HITCHiwW7NcLFcJStVHlbW4Et6SM9aX7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ascpZYgJfMR4ZqAg5jqjVGv5UL/7c0o1KBJNqtUbITDOwpa6vpTF2DAXKjc5ZVecoMDb48mv7hvhoacwBm+yVwBwmvGN1tBk3Kr75Ek+Ee3TJiGWSNGOurcn9iyuoAa/t8UF5QNZ6gQ/mVU6oOfbsCEzixfRsKXxJ0g+2MfNJRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPzxJmCC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPzxJmCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5AD1F00A3A;
	Thu, 30 Jul 2026 15:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426041;
	bh=dDmebe7phBy2wRKCX9+uxPy/YLYlgJ0ta+E0XXuVZOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gPzxJmCCwvsTfrcwK88fbedLF8Z/ZLwF7K7jY1JBZORiPKkkY1dSPWhjTawHS9uZH
	 KKn1kvqsxvRS1FM5or5ZuTNVIyw6f04cPQ6DxRmnOohQZM4TXPCnn+nc7HnOsH6c6u
	 OFJ2NjhO7sk81nDhgsz5qXZF3uV28TlP/3OvJd24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/602] dpll: add clock quality level attribute and op
Date: Thu, 30 Jul 2026 16:10:28 +0200
Message-ID: <20260730141440.931144311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit a1afb959add1fad43cb337448c244ed70bac3109 ]

In order to allow driver expose quality level of the clock it is
running, introduce a new netlink attr with enum to carry it to the
userspace. Also, introduce an op the dpll netlink code calls into the
driver to obtain the value.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20241030081157.966604-2-jiri@resnulli.us
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 11c057d23465 ("net/mlx5: Fix MCIA register buffer overflow on 32 dword reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/dpll.yaml | 41 +++++++++++++++++++++++++++
 drivers/dpll/dpll_netlink.c           | 24 ++++++++++++++++
 include/linux/dpll.h                  |  4 +++
 include/uapi/linux/dpll.h             | 24 ++++++++++++++++
 4 files changed, 93 insertions(+)

diff --git a/Documentation/netlink/specs/dpll.yaml b/Documentation/netlink/specs/dpll.yaml
index cb5763f79ac2ae..c799d43b8833d1 100644
--- a/Documentation/netlink/specs/dpll.yaml
+++ b/Documentation/netlink/specs/dpll.yaml
@@ -85,6 +85,36 @@ definitions:
           This may happen for example if dpll device was previously
           locked on an input pin of type PIN_TYPE_SYNCE_ETH_PORT.
     render-max: true
+  -
+    type: enum
+    name: clock-quality-level
+    doc: |
+      level of quality of a clock device. This mainly applies when
+      the dpll lock-status is DPLL_LOCK_STATUS_HOLDOVER.
+      The current list is defined according to the table 11-7 contained
+      in ITU-T G.8264/Y.1364 document. One may extend this list freely
+      by other ITU-T defined clock qualities, or different ones defined
+      by another standardization body (for those, please use
+      different prefix).
+    entries:
+      -
+        name: itu-opt1-prc
+        value: 1
+      -
+        name: itu-opt1-ssu-a
+      -
+        name: itu-opt1-ssu-b
+      -
+        name: itu-opt1-eec1
+      -
+        name: itu-opt1-prtc
+      -
+        name: itu-opt1-eprtc
+      -
+        name: itu-opt1-eeec
+      -
+        name: itu-opt1-eprc
+    render-max: true
   -
     type: const
     name: temp-divider
@@ -252,6 +282,17 @@ attribute-sets:
         name: lock-status-error
         type: u32
         enum: lock-status-error
+      -
+        name: clock-quality-level
+        type: u32
+        enum: clock-quality-level
+        multi-attr: true
+        doc: |
+          Level of quality of a clock device. This mainly applies when
+          the dpll lock-status is DPLL_LOCK_STATUS_HOLDOVER. This could
+          be put to message multiple times to indicate possible parallel
+          quality levels (e.g. one specified by ITU option 1 and another
+          one specified by option 2).
   -
     name: pin
     enum-name: dpll_a_pin
diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index e3fb08e1578d85..c66f57a5814c8c 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -187,6 +187,27 @@ dpll_msg_add_temp(struct sk_buff *msg, struct dpll_device *dpll,
 	return 0;
 }
 
+static int
+dpll_msg_add_clock_quality_level(struct sk_buff *msg, struct dpll_device *dpll,
+				 struct netlink_ext_ack *extack)
+{
+	const struct dpll_device_ops *ops = dpll_device_ops(dpll);
+	DECLARE_BITMAP(qls, DPLL_CLOCK_QUALITY_LEVEL_MAX) = { 0 };
+	enum dpll_clock_quality_level ql;
+	int ret;
+
+	if (!ops->clock_quality_level_get)
+		return 0;
+	ret = ops->clock_quality_level_get(dpll, dpll_priv(dpll), qls, extack);
+	if (ret)
+		return ret;
+	for_each_set_bit(ql, qls, DPLL_CLOCK_QUALITY_LEVEL_MAX)
+		if (nla_put_u32(msg, DPLL_A_CLOCK_QUALITY_LEVEL, ql))
+			return -EMSGSIZE;
+
+	return 0;
+}
+
 static int
 dpll_msg_add_pin_prio(struct sk_buff *msg, struct dpll_pin *pin,
 		      struct dpll_pin_ref *ref,
@@ -623,6 +644,9 @@ dpll_device_get_one(struct dpll_device *dpll, struct sk_buff *msg,
 	if (ret)
 		return ret;
 	ret = dpll_msg_add_lock_status(msg, dpll, extack);
+	if (ret)
+		return ret;
+	ret = dpll_msg_add_clock_quality_level(msg, dpll, extack);
 	if (ret)
 		return ret;
 	ret = dpll_msg_add_mode(msg, dpll, extack);
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
index 3c03b19d939070..5d62e9a0b8243c 100644
--- a/include/linux/dpll.h
+++ b/include/linux/dpll.h
@@ -28,6 +28,10 @@ struct dpll_device_ops {
 			       struct netlink_ext_ack *extack);
 	int (*temp_get)(const struct dpll_device *dpll, void *dpll_priv,
 			s32 *temp, struct netlink_ext_ack *extack);
+	int (*clock_quality_level_get)(const struct dpll_device *dpll,
+				       void *dpll_priv,
+				       unsigned long *qls,
+				       struct netlink_ext_ack *extack);
 };
 
 struct dpll_pin_ops {
diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
index 7fa641b3a20adb..12a43bf9a863bc 100644
--- a/include/uapi/linux/dpll.h
+++ b/include/uapi/linux/dpll.h
@@ -79,6 +79,29 @@ enum dpll_lock_status_error {
 	DPLL_LOCK_STATUS_ERROR_MAX = (__DPLL_LOCK_STATUS_ERROR_MAX - 1)
 };
 
+/**
+ * enum dpll_clock_quality_level - level of quality of a clock device. This
+ *   mainly applies when the dpll lock-status is DPLL_LOCK_STATUS_HOLDOVER. The
+ *   current list is defined according to the table 11-7 contained in ITU-T
+ *   G.8264/Y.1364 document. One may extend this list freely by other ITU-T
+ *   defined clock qualities, or different ones defined by another
+ *   standardization body (for those, please use different prefix).
+ */
+enum dpll_clock_quality_level {
+	DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_PRC = 1,
+	DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_SSU_A,
+	DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_SSU_B,
+	DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_EEC1,
+	DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_PRTC,
+	DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_EPRTC,
+	DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_EEEC,
+	DPLL_CLOCK_QUALITY_LEVEL_ITU_OPT1_EPRC,
+
+	/* private: */
+	__DPLL_CLOCK_QUALITY_LEVEL_MAX,
+	DPLL_CLOCK_QUALITY_LEVEL_MAX = (__DPLL_CLOCK_QUALITY_LEVEL_MAX - 1)
+};
+
 #define DPLL_TEMP_DIVIDER	1000
 
 /**
@@ -180,6 +203,7 @@ enum dpll_a {
 	DPLL_A_TEMP,
 	DPLL_A_TYPE,
 	DPLL_A_LOCK_STATUS_ERROR,
+	DPLL_A_CLOCK_QUALITY_LEVEL,
 
 	__DPLL_A_MAX,
 	DPLL_A_MAX = (__DPLL_A_MAX - 1)
-- 
2.53.0



