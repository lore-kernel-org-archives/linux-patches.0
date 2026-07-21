Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A383E3B6C17;
	Tue, 21 Jul 2026 22:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673466; cv=none; b=LcoakqgQXYdk9REOyeKQmxLCYWFytL7kOwDfXApZH+Lb6ykfrXBNtN3e8yhrGJHyIcXuk8Ke1QWAXXdiUQU7d67xF53K4nK0J7fcXaKvxx5d+IbJZ4p19ZvaGNBNIc3XBmBXTuRMWNHOA4PXpx/cDt2KtbheCQVuS7qE4UCZoIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673466; c=relaxed/simple;
	bh=ad5R6vphNYaJQq8uNNccj213yU7ZwNBVWZFQkn4O67Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+zGsSblqj7GKzGTQ8hJ2IJs9+UHQXRL2WaEbhZ5IN0NS1dkdeCFbgZsIFaMYQB2VWQGk4yX/YDG1YOlStHtKMh/n9C3TrDre/sRX6eGBefpveY4aaNOewETdSq5W36/6UICm7QB180PwhBg7kaOvB2D+hSF+p1H2KbylKq3lpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T8UcDiXS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T8UcDiXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146A31F000E9;
	Tue, 21 Jul 2026 22:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673465;
	bh=vTh+c4c+n/2lzROIfb9/MCzLotHLUdzFxwuhxV11/n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T8UcDiXSfTQyf3xwLoWUc8Xf1JvN3PTBo6G5FPdm4UElHMNwlGTr9GJ4AYgbdzzX+
	 NNJwt9e8pGkpjMNIGw7nsqn1UI3DDhizWnOTbMCIM2EZlY0+z88eSulbKttePuxaUg
	 4r3kZ1mMrxxzpubfe5GkH9LW1pp5GUHGN6cvojFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/699] driver core: use READ_ONCE() for dev->driver in dev_has_sync_state()
Date: Tue, 21 Jul 2026 17:18:50 +0200
Message-ID: <20260721152359.559024729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 77d6493c26a484..3575a28fee7f3c 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -842,9 +842,12 @@ static inline struct device_node *dev_of_node(struct device *dev)
 
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



