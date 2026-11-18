Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060540;
	b=vwVpOloWlRT3LmH1fx3RLcTUz8W++1qMRkc0usE0L8YmW/5HXtaGbuRrD0kS90fY9nc+
	 +zyNX4mRmJJC5OdrGhC2GofTp8X6i5KDrj/UnG8JgCn9WdmdRhQAx3q/IJ5e53/pCXVA7
	 7WaQ+VlV4X2D2MwIcz+gxwb10BfY+DywSkIZr5w4zOxpBvY5omZfwgJ/Q6sZRc8B/Y/hO
	 CsYOYc4Qmmt/rslG4kwQ2ZZwDb1zR/gjMOlZ4wex2+JuArEOBppq9IBkaMAPDT/cwVEtN
	 Oa3/R0irqa9RUKo8fsly7W0iQvw8WhWbHF2ijNPwtKfAaUaylTsJ66xA1a53QlhFJIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060540;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=el05cLeIHJJR3tSAutCW6sxC+DmpV/qeAzzYBg+XzhI=;
	b=TfxOrChw/wxZauxYCsOQF7uIehHmv4BWbO1WuxZk55pMgZ3gMHlewSkJ/6gP9yGfJPio
	 7LUeCmNwHIkibKvLZQ4sM4co46Z1XqM7HRFak1qmcKUBxZyh6WiBAVHo4lGllENCsNuVK
	 KUA1muRQP0fhoe+Hns7VlAjvDQF2b8aZKeaBEwVF7FQzq75YFBu0pKZA3qe1EWhZMsa9y
	 kFZ5DMOLR0DM6sw5C7MoHp88B6XGENk88ZvyXTvIfzECw6R+92fMQBiL9s+UXuNPBvbH+
	 0PN084dw6gcO1b4BxYgAFYCGNpWfQ6vh3E8P+BS06Obi3WWzHqtWa476awkZzJ7zXuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m8SNfgJB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FC6606A320;
	Thu, 19 Nov 2026 03:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m8SNfgJB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326141F000C4;
	Thu, 19 Nov 2026 03:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060539;
	bh=el05cLeIHJJR3tSAutCW6sxC+DmpV/qeAzzYBg+XzhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8SNfgJBtCABkzv6tV6tdAeIjSa6dzEyPhIIZSnmzdQcSMzjj4MnoyJNoaNgo1x0J
	 NA47hU1cYnZH3Mni/X2rXQRyXt+VqEBNdITr2Dkxi51UTnNcYLpSAU/9jKOwc8ew4H
	 ROpxfpV6soY77K10dcgz+5S88Qb/wsbz3b7QzA40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1198/1848] PM: wakeup: Unify device_init_wakeup() for PM_SLEEP and !PM_SLEEP
Date: Wed, 18 Nov 2026 15:53:56 +0100
Message-ID: <20261118150009.837892927@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit 09d3154a6f0f0bb5b604832095804780f3684b96 ]

Previously the CONFIG_PM_SLEEP and !CONFIG_PM_SLEEP device_init_wakeup()
implementations differed in confusing ways:

  - The PM_SLEEP version checked for a NULL device pointer and returned
    -EINVAL, while the !PM_SLEEP version did not and would simply
    dereference a NULL pointer.

  - When called with "false", the !PM_SLEEP version cleared "capable" and
    "enable" in the opposite order of the PM_SLEEP version.  That was
    harmless because for !PM_SLEEP they're simple assignments, but it's
    unnecessary confusion.

Use a simplified version of the PM_SLEEP implementation for both cases.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: ece9baab2a6e ("power: supply: bq24190_charger: use the wake irq API")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/wakeup.c | 30 ------------------------------
 include/linux/pm_wakeup.h   | 31 +++++++++++++++++++++++--------
 2 files changed, 23 insertions(+), 38 deletions(-)

diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index e3b0a2db32e9b..61b9150e9db77 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -498,36 +498,6 @@ void device_set_wakeup_capable(struct device *dev, bool capable)
 }
 EXPORT_SYMBOL_GPL(device_set_wakeup_capable);
 
-/**
- * device_init_wakeup - Device wakeup initialization.
- * @dev: Device to handle.
- * @enable: Whether or not to enable @dev as a wakeup device.
- *
- * By default, most devices should leave wakeup disabled.  The exceptions are
- * devices that everyone expects to be wakeup sources: keyboards, power buttons,
- * possibly network interfaces, etc.  Also, devices that don't generate their
- * own wakeup requests but merely forward requests from one bus to another
- * (like PCI bridges) should have wakeup enabled by default.
- */
-int device_init_wakeup(struct device *dev, bool enable)
-{
-	int ret = 0;
-
-	if (!dev)
-		return -EINVAL;
-
-	if (enable) {
-		device_set_wakeup_capable(dev, true);
-		ret = device_wakeup_enable(dev);
-	} else {
-		device_wakeup_disable(dev);
-		device_set_wakeup_capable(dev, false);
-	}
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(device_init_wakeup);
-
 /**
  * device_set_wakeup_enable - Enable or disable a device to wake up the system.
  * @dev: Device to handle.
diff --git a/include/linux/pm_wakeup.h b/include/linux/pm_wakeup.h
index aa3da66115335..6fb698ed6deb7 100644
--- a/include/linux/pm_wakeup.h
+++ b/include/linux/pm_wakeup.h
@@ -104,7 +104,6 @@ extern struct wakeup_source *wakeup_sources_walk_next(struct wakeup_source *ws);
 extern int device_wakeup_enable(struct device *dev);
 extern int device_wakeup_disable(struct device *dev);
 extern void device_set_wakeup_capable(struct device *dev, bool capable);
-extern int device_init_wakeup(struct device *dev, bool val);
 extern int device_set_wakeup_enable(struct device *dev, bool enable);
 extern void __pm_stay_awake(struct wakeup_source *ws);
 extern void pm_stay_awake(struct device *dev);
@@ -162,13 +161,6 @@ static inline int device_set_wakeup_enable(struct device *dev, bool enable)
 	return 0;
 }
 
-static inline int device_init_wakeup(struct device *dev, bool val)
-{
-	device_set_wakeup_capable(dev, val);
-	device_set_wakeup_enable(dev, val);
-	return 0;
-}
-
 static inline bool device_may_wakeup(struct device *dev)
 {
 	return dev->power.can_wakeup && dev->power.should_wakeup;
@@ -207,4 +199,27 @@ static inline void pm_wakeup_hard_event(struct device *dev)
 	return pm_wakeup_dev_event(dev, 0, true);
 }
 
+/**
+ * device_init_wakeup - Device wakeup initialization.
+ * @dev: Device to handle.
+ * @enable: Whether or not to enable @dev as a wakeup device.
+ *
+ * By default, most devices should leave wakeup disabled.  The exceptions are
+ * devices that everyone expects to be wakeup sources: keyboards, power buttons,
+ * possibly network interfaces, etc.  Also, devices that don't generate their
+ * own wakeup requests but merely forward requests from one bus to another
+ * (like PCI bridges) should have wakeup enabled by default.
+ */
+static inline int device_init_wakeup(struct device *dev, bool enable)
+{
+	if (enable) {
+		device_set_wakeup_capable(dev, true);
+		return device_wakeup_enable(dev);
+	} else {
+		device_wakeup_disable(dev);
+		device_set_wakeup_capable(dev, false);
+		return 0;
+	}
+}
+
 #endif /* _LINUX_PM_WAKEUP_H */
-- 
2.53.0



