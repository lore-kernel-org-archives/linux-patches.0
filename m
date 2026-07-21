Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E4C415F23;
	Tue, 21 Jul 2026 22:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671412; cv=none; b=lieYFtOsaEjAZn4tkuTuWgyqJvxOXd6cGY5fqi6s1GgcRsYbrvk7mcNiqpN62I7KZBtndHXbqXtuCzLW4zwTD56VpeHUWQOw5wrlrciFyeZAajQVcNezdV9cdkO0iuUeQyAEOZkgMX0UdvWPhPVZQkREUfYIrZXcWW0FZVDqWmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671412; c=relaxed/simple;
	bh=e0+kMW5Z2JbUvCEfMPbxaNJOGvsy/hzhK765/UPQ3LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDvHz1hdkamPX5sk8z24323SSLY1aRQts3PyvoEgUMHCawBEngYyPaEMF8dDSEbbVNUTld+uJs7KCv2i15Fib4XNSn+TA6PwxlqvIV97J1oUxWSqUy7JD74muc9XlMfzKZtA1C+P1PXGntjSTav6P4RRykb3kcc8eAVJKq0f9oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUR1wx3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUR1wx3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA26F1F000E9;
	Tue, 21 Jul 2026 22:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671411;
	bh=p3L+FJ2i9H/rZMVmAaCj6bptJ/ug0zpMD4jIOsmaGdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZUR1wx3poH7fIOTFrVn4apXd9Rj1JxlYg9UzWYuQwxAwXeA+2BNcwjmXaTdYIewZ0
	 IFX0xI3fxw2Mi8mR4UVLEq5VRi9Xwbf2FwDElwEjJlNlocyeZU4Z3TSBmJRRgpuhR1
	 pgaBQGiB+O8jhdwhEYBuZM0UtFFak+K73MzVhr2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 219/843] driver core: use READ_ONCE() for dev->driver in dev_has_sync_state()
Date: Tue, 21 Jul 2026 17:17:34 +0200
Message-ID: <20260721152410.943690367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit e9506871a8ea304cde48ff4a57226df2aadddae3 ]

dev_has_sync_state() reads dev->driver twice without holding
device_lock() -- once for the NULL check and once to dereference
->sync_state. Some callers only hold device_links_write_lock, which
doesn't prevent a concurrent unbind from clearing dev->driver via
device_unbind_cleanup().

Fix it by reading dev->driver exactly once with READ_ONCE(), pairing
with the WRITE_ONCE() in device_set_driver().

Link: https://lore.kernel.org/driver-core/DHW8QPU1VU1F.3P6PH69HLFBYC@kernel.org/
Fixes: ac338acf514e ("driver core: Add dev_has_sync_state()")
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Saravana Kannan <saravanak@kernel.org>
Link: https://patch.msgid.link/20260418162221.1121873-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/device.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 2c16bc2149c20d..8da560db916331 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -838,9 +838,12 @@ static inline struct device_node *dev_of_node(struct device *dev)
 
 static inline bool dev_has_sync_state(struct device *dev)
 {
+	struct device_driver *drv;
+
 	if (!dev)
 		return false;
-	if (dev->driver && dev->driver->sync_state)
+	drv = READ_ONCE(dev->driver);
+	if (drv && drv->sync_state)
 		return true;
 	if (dev->bus && dev->bus->sync_state)
 		return true;
-- 
2.53.0



