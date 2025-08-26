Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD121A8F84;
	Tue, 26 Aug 2025 13:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213399; cv=none; b=b5n1MhXme32lWOfoTDXTqHsZycOzROeAO/2MzUJdZanqXCeA0Ct46vzTuQ7XSBFKkv2uaUaiFJTdoUXCtsAHLhx/VUY8LYwY/Uwr2frQpcrceFvld1/x368AQN9T2JLqVMi1nhtAEIIStn8QoXBQJl+pFpE13m7deDZ0SUbQbPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213399; c=relaxed/simple;
	bh=oDC5CNYj+ffOx7tTfGFNm6co/7t4hqQs0AXpuJE7juM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ub/97wQJEGTzAJqknjhLZVwarSRg3aHh+HpuAh90trA+UjzHXE0jdH34s5ixBu4KkzFAd6Pgr3wZoAl8Isux6cdaFfJumITn0fmzkQdJKKuL1wkgTx3QjIuP99TpWFiib0RmkEgkWx96NK0SZ2phuZ88hZJx9U8xBazm9yqN5gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZLNoDAX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZLNoDAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C148C4CEF1;
	Tue, 26 Aug 2025 13:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213399;
	bh=oDC5CNYj+ffOx7tTfGFNm6co/7t4hqQs0AXpuJE7juM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZLNoDAXTz33Tned36PTguB9hgpklg+65p7MqKpJSYhXfO4G52/yQxiFZxp4ctrm/
	 SAZNN+WCL6+dy/xBduT1yzMNHzE+JwQcOVWQAUITOtY29h7nCfYNECLeQuzQOE0uab
	 CJroJb7EepMuOOhtwDf5O0MNXFvu0CJfGOGUfzZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>
Subject: [PATCH 6.6 331/587] platform/chrome: cros_ec: Unregister notifier in cros_ec_unregister()
Date: Tue, 26 Aug 2025 13:08:00 +0200
Message-ID: <20250826111001.336423104@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit e2374953461947eee49f69b3e3204ff080ef31b1 upstream.

The blocking notifier is registered in cros_ec_register(); however, it
isn't unregistered in cros_ec_unregister().

Fix it.

Fixes: 42cd0ab476e2 ("platform/chrome: cros_ec: Query EC protocol version if EC transitions between RO/RW")
Cc: stable@vger.kernel.org
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://lore.kernel.org/r/20250722120513.234031-1-tzungbi@kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/cros_ec.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/platform/chrome/cros_ec.c
+++ b/drivers/platform/chrome/cros_ec.c
@@ -313,6 +313,9 @@ EXPORT_SYMBOL(cros_ec_register);
  */
 void cros_ec_unregister(struct cros_ec_device *ec_dev)
 {
+	if (ec_dev->mkbp_event_supported)
+		blocking_notifier_chain_unregister(&ec_dev->event_notifier,
+						   &ec_dev->notifier_ready);
 	platform_device_unregister(ec_dev->pd);
 	platform_device_unregister(ec_dev->ec);
 	mutex_destroy(&ec_dev->lock);


