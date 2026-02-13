Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC0B3563C3;
	Fri, 13 Feb 2026 13:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990654; cv=none; b=E4+dYCmw7EEE78urc5z/SriYnCvHA9pzPDPJYYDkNEeFZOAvvnUNre7HHrCVu+tVnNyVzD1uj2jROtBZMt9S3JjtnL3/Whd0XMsH+MQP/9A/5b6ZacSpOGr8c1lgBumgOhTybjAnbUZetNJsUg3foaaDydgcAn2MVLGb6VejNIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990654; c=relaxed/simple;
	bh=g6TBDFgZjXq1hxhx4dfx2wGEqOiub8zZfrOfyB0vKpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WjmPEmekHLh9fez3/G5/ZkaHrvhzjiZ8eezeZRRJtZ7UJC0RYnFNE8LDxuJ0zagtwWsvTaDNp1wQxK52ksf3Ger45RWDdhgsjRb6nfhV8VFUahegQrUheI5POzjV7bBgwngXsKNAHqi3LGaE3yPQbcNYvAtS2iRlNaJFkusGzyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdr7n212; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdr7n212"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9538EC116C6;
	Fri, 13 Feb 2026 13:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990654;
	bh=g6TBDFgZjXq1hxhx4dfx2wGEqOiub8zZfrOfyB0vKpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdr7n212jAgYhs8CQ/Zr13UsLbM4C59yXBg4aozBzQM6sRN0zACB8n79IDI7PdnXQ
	 u/l/ADhK7OQBQwetrgIC/al06kMhPKb5zDIVqy7CIn3Nc+Nk7tFl0mzQczFvbSct3U
	 rdYTME100RcV0OnIck7N5xCF2tYVB7/UrTr6a3ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiu-ji Chen <chenqiuji666@gmail.com>,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Subject: [PATCH 6.19 27/49] driver core: enforce device_lock for driver_match_device()
Date: Fri, 13 Feb 2026 14:47:46 +0100
Message-ID: <20260213134709.727418807@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -182,9 +182,18 @@ void device_set_deferred_probe_reason(co
 static inline int driver_match_device(const struct device_driver *drv,
 				      struct device *dev)
 {
+	device_lock_assert(dev);
+
 	return drv->bus->match ? drv->bus->match(dev, drv) : 1;
 }
 
+static inline int driver_match_device_locked(const struct device_driver *drv,
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
@@ -1180,7 +1180,7 @@ static int __driver_attach(struct device
 	 * is an error.
 	 */
 
-	ret = driver_match_device(drv, dev);
+	ret = driver_match_device_locked(drv, dev);
 	if (ret == 0) {
 		/* no match */
 		return 0;


