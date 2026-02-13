Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A3C1D432D;
	Fri, 13 Feb 2026 13:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990999; cv=none; b=o7GCuh+M+mFBPb9U6GFpCdRf1XDKgRnLEyEHOTfwfOTo95TaMSjSh49Re/MxfuhdpWYaIdxFwbiE+HkoYhAezrOdv8qYTu3xksCcC6zRnLsjKmYbKrOBXUj4knu2snDEnTuRjdicGglMdsQAHsajVwrh9IpEaRhoFmgM1ocqB7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990999; c=relaxed/simple;
	bh=4ssSL+JoNOrJvmsasxqzVN0Rkspktc3g3ZthUi+W1ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeNIqOWaFeQVzbE0eRATMRrMQFNdd/diRS4ryiUFtaPyTUYCGpI3EXaE2CDX3BUVJv0NfFI2jkeJ5ADdhDf5mv9tX7CGSSAA1f63utOOYwowQFpUKfzHDTm0eORy5bYjhkacD7T2RCM+am2XEnRphVOde5EOlsrfk022x42QXBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqCyjAUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqCyjAUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28233C116C6;
	Fri, 13 Feb 2026 13:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990999;
	bh=4ssSL+JoNOrJvmsasxqzVN0Rkspktc3g3ZthUi+W1ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqCyjAUk50CTjsDCibAEEIAVcnyx5RCvv2rh1FtEnM+nd3TduK9nYklUwmutXyS6U
	 b3GBwZ08cid8bSnbb+tjgRK2jlLZCWwcpsjxiwHRivZ041VVSTBW9rp9wAtGC3pM8E
	 1gJnk7ntXIUsUxb6pIkkgmdfMaWqtfsX+7hVyH/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Subject: [PATCH 6.6 04/25] driver core: enforce device_lock for driver_match_device()
Date: Fri, 13 Feb 2026 14:48:30 +0100
Message-ID: <20260213134704.047053139@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134703.882698935@linuxfoundation.org>
References: <20260213134703.882698935@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <hanguidong02@gmail.com>

commit dc23806a7c47ec5f1293aba407fb69519f976ee0 upstream.

Currently, driver_match_device() is called from three sites. One site
(__device_attach_driver) holds device_lock(dev), but the other two
(bind_store and __driver_attach) do not. This inconsistency means that
bus match() callbacks are not guaranteed to be called with the lock
held.

Fix this by introducing driver_match_device_locked(), which guarantees
holding the device lock using a scoped guard. Replace the unlocked calls
in bind_store() and __driver_attach() with this new helper. Also add a
lock assertion to driver_match_device() to enforce this guarantee.

This consistency also fixes a known race condition. The driver_override
implementation relies on the device_lock, so the missing lock led to the
use-after-free (UAF) reported in Bugzilla for buses using this field.

Stress testing the two newly locked paths for 24 hours with
CONFIG_PROVE_LOCKING and CONFIG_LOCKDEP enabled showed no UAF recurrence
and no lockdep warnings.

Cc: stable@vger.kernel.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220789
Suggested-by: Qiu-ji Chen <chenqiuji666@gmail.com>
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Fixes: 49b420a13ff9 ("driver core: check bus->match without holding device lock")
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Link: https://patch.msgid.link/20260113162843.12712-1-hanguidong02@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/base.h |    9 +++++++++
 drivers/base/bus.c  |    2 +-
 drivers/base/dd.c   |    2 +-
 3 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -165,9 +165,18 @@ void device_set_deferred_probe_reason(co
 static inline int driver_match_device(struct device_driver *drv,
 				      struct device *dev)
 {
+	device_lock_assert(dev);
+
 	return drv->bus->match ? drv->bus->match(dev, drv) : 1;
 }
 
+static inline int driver_match_device_locked(struct device_driver *drv,
+					     struct device *dev)
+{
+	guard(device)(dev);
+	return driver_match_device(drv, dev);
+}
+
 static inline void dev_sync_state(struct device *dev)
 {
 	if (dev->bus->sync_state)
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -263,7 +263,7 @@ static ssize_t bind_store(struct device_
 	int err = -ENODEV;
 
 	dev = bus_find_device_by_name(bus, NULL, buf);
-	if (dev && driver_match_device(drv, dev)) {
+	if (dev && driver_match_device_locked(drv, dev)) {
 		err = device_driver_attach(drv, dev);
 		if (!err) {
 			/* success */
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1169,7 +1169,7 @@ static int __driver_attach(struct device
 	 * is an error.
 	 */
 
-	ret = driver_match_device(drv, dev);
+	ret = driver_match_device_locked(drv, dev);
 	if (ret == 0) {
 		/* no match */
 		return 0;


