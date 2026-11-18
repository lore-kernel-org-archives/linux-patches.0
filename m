Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054965;
	b=Sk2QUVvOd6lN7MRQQ9iSb3ANDWOPOPImaFqW6g7MZ1Yu9tcybtbrzGf931R5ZVVbh9Uw
	 Hijrli12mMzerJkwtj4xpUtKcvjYQinkwGGMrZqYJ3gBYKeCneENdxWMZyozT4rtkS4f3
	 h0JmK+FugYS3URUiL9rEYE6Wn3ZKzS0u0wFlmlMaOvwlNfMaVwKEoQMUd1Videm56WmEo
	 P5UQecod/LXTaBD+Dv5b7C7hJp5Z25lUlOOUJvoX95PWYj0cQobv68GvXIAAPimUDD3OB
	 WgHzFMQ93NPitKEjaCKPXEfsBJ2KyK4yXDNy1JUl1TGmihYX0hmhg+jIVnmTqse0ddA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yridi9mj8qweP3oFCwMqwKyLUmRaHAfrafSZhkk9ees=;
	b=A4EiZV5CCP7HNzt/P+7aWRxLkXrCTCGP/S0BdW8iR3gvMNQxqASppg0CaCfiea+41U+B
	 Su++y9S3C20hROb8+5BhWvElidvsVJlhj2vzTLhJqkHhO+N31A8QHFDOzO+XSf0au/NUp
	 0qCEdNCaK8Tqa4kuUtdQCqafqBsrYNlaZzHggwVsVcR/IhmyjIS2wRsKhvcFl2r81tCg1
	 A3KbSdEwS52zpmS0OH3RJSi7W9FajY4Z1oGVeVfrRrk2QZKDkXfhxrinIziC4cOGFErQM
	 Hn8pX51zPS8mfN9QITseMKTMu2if8bbLkmw4WfE2U7iG0EeNqdX2ZuHsfLqBNw7UEyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iUstRV85;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D11606A31C;
	Thu, 19 Nov 2026 02:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iUstRV85
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D071F000C4;
	Thu, 19 Nov 2026 02:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054965;
	bh=Yridi9mj8qweP3oFCwMqwKyLUmRaHAfrafSZhkk9ees=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iUstRV85UEX8H/DAToslekG2o60Io/0SPJr98yNnRn8zbHoxcGAWBtHKPrJBsdzBv
	 OP0boxWzGnjnYQEhw5dJYUrlIaI8n7NbEgLlHMe7EhQIV/opNbX5UNJsHTUKKX/zxR
	 d0dVvkdpPLPNgwO2nWBg9JPPG6F6olmzkobmxa7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1423/2214] PM: wakeup: Unify device_init_wakeup() for PM_SLEEP and !PM_SLEEP
Date: Wed, 18 Nov 2026 15:51:39 +0100
Message-ID: <20261118150108.130526088@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4ef4c8dfd2bc7..37acb6e2e75b2 100644
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
index 196a157456aa8..77f4849e34189 100644
--- a/include/linux/pm_wakeup.h
+++ b/include/linux/pm_wakeup.h
@@ -109,7 +109,6 @@ extern struct wakeup_source *wakeup_sources_walk_next(struct wakeup_source *ws);
 extern int device_wakeup_enable(struct device *dev);
 extern int device_wakeup_disable(struct device *dev);
 extern void device_set_wakeup_capable(struct device *dev, bool capable);
-extern int device_init_wakeup(struct device *dev, bool val);
 extern int device_set_wakeup_enable(struct device *dev, bool enable);
 extern void __pm_stay_awake(struct wakeup_source *ws);
 extern void pm_stay_awake(struct device *dev);
@@ -167,13 +166,6 @@ static inline int device_set_wakeup_enable(struct device *dev, bool enable)
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
@@ -217,4 +209,27 @@ static inline void pm_wakeup_hard_event(struct device *dev)
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



