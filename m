Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD62442FC4;
	Thu, 30 Jul 2026 15:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425145; cv=none; b=ccPVSF77n/F7aej7EQhgX8UoJU99VjEfCPEtugx0JRHJF4XRHbG4Zb8og5BnZ1jbU0Rm5Ku+0Dkhbz3KJEXoW0Nacqqy/A+BTzjfDJnS6+lXIwJd5Tm1iMX1Z4sOfKPt6/YfC+TnBvmZzIH9qOWXuUxvCfOLxz0JlEo86eh4dTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425145; c=relaxed/simple;
	bh=+jUuwdeH4yF3NH3yv+qIc343NR1NYF5tlZ2EOnWuCGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNaxSiSXu7AdpJ+Jfm13RYwhb3N4rJrj27FBvkavGIojzH7vDQyzOKPQGQuHG+ykwqRc3iOuBvBTZ51YRVjyRXWJHMSLdnYsx1llW5PfiLL24uM18EiZXb0ShWCuX9JX6DEg/MvT4kF545ySrrznUaX5MqodDqqnDC7SwO1x8t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDli/oxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDli/oxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D6E1F000E9;
	Thu, 30 Jul 2026 15:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425144;
	bh=QDYqoU4MQBahg1ZfWKtE2v266S9EFhY/jEB6AixUvBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDli/oxgpeOeX8vCcBHTr6oYGb5r8BRN/bCemG+H+fkYkFniAyMPJ3YrxmPNT+chx
	 qIaiMvUytbGtsiqGFBRlfsuqklHTSTJh/ODacI9Qqa76ZaQts+EE+CrnUgA96ZUWpv
	 yJHPvnwleUvkoJppukmn9y+GAXHjS+bvKr8ue0yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 638/675] thunderbolt: Remove service debugfs entries during unregister
Date: Thu, 30 Jul 2026 16:16:08 +0200
Message-ID: <20260730141458.690480431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 4d5fc3f4068568dfcb8cbe2852b4adc56394aa26 ]

We add them as part of the register path so to keep it symmetric remove
them as part of the unregister path. This also removes them even if the
service itself is not yet released (but is unregistered), thus allowing
new register with the same service name to happen.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Stable-dep-of: 2c5d2d3c3f70 ("thunderbolt: Prevent XDomain delayed work use-after-free on disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/xdomain.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1008,7 +1008,6 @@ static void tb_service_release(struct de
 	struct tb_service *svc = container_of(dev, struct tb_service, dev);
 	struct tb_xdomain *xd = tb_service_parent(svc);
 
-	tb_service_debugfs_remove(svc);
 	ida_free(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
@@ -1023,6 +1022,14 @@ const struct device_type tb_service_type
 };
 EXPORT_SYMBOL_GPL(tb_service_type);
 
+static void __unregister_service(struct device *dev)
+{
+	struct tb_service *svc = tb_to_service(dev);
+
+	tb_service_debugfs_remove(svc);
+	device_unregister(&svc->dev);
+}
+
 static int remove_missing_service(struct device *dev, void *data)
 {
 	struct tb_xdomain *xd = data;
@@ -1034,7 +1041,7 @@ static int remove_missing_service(struct
 
 	if (!tb_property_find(xd->remote_properties, svc->key,
 			      TB_PROPERTY_TYPE_DIRECTORY))
-		device_unregister(dev);
+		__unregister_service(dev);
 
 	return 0;
 }
@@ -1127,6 +1134,7 @@ static void enumerate_services(struct tb
 		tb_service_debugfs_init(svc);
 
 		if (device_register(&svc->dev)) {
+			tb_service_debugfs_remove(svc);
 			put_device(&svc->dev);
 			break;
 		}
@@ -2059,7 +2067,7 @@ void tb_xdomain_add(struct tb_xdomain *x
 
 static int unregister_service(struct device *dev, void *data)
 {
-	device_unregister(dev);
+	__unregister_service(dev);
 	return 0;
 }
 


