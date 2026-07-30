Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BF2449B01;
	Thu, 30 Jul 2026 16:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428205; cv=none; b=XY2zYP40ff/763yjGEEgp/PNSDpAsO7hsVlNW18l5uPwyYKHsoV3JNKgPQFgBQ5cvHnR2GoSNHmbz5P81gHcareT9I+D9o+w3aFQ71VKX4lpGm0SHhsJfp1siGlcUE/Gb/T7lDHXeKhT8FhigzTKlpCZ9gCYpHYf3ZvIvtDJV7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428205; c=relaxed/simple;
	bh=TqnlX2vFYvsBemfFy1COj9OLKfm4Rrs0NEKOjEGfUJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AVvE1lJuB0X/Un0bqmd5QmKqh0j8H9ZrnusZwjjfLrM3GE1N2wxE+Y62GmQe29ihQPgXVGyi32nVaEqUpNM/RuniKkNnBLO/KeVappvqtniQ5kbVOD6qCTf76x3XtQzTMUJSXCvo5/58OS8rDtsyZDaBHIfFsmm8YabLLhtMkiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWxisxSB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWxisxSB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C9E1F000E9;
	Thu, 30 Jul 2026 16:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428199;
	bh=ADzOESyl2J66jWLvfSQtcC9OdsaiBKOXYMBRvKbHTR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sWxisxSBLdHaiWtgoUfMImSOTleEMXE+UUdSi9478w8b05XFvZNBtrK8NCExVi8XV
	 V8WU5Y1ZmSL+WwYF7sf0xPSppczJNhbUQr9GNHDV3Y2NbLukow7A3Xja/RRaITPcPa
	 0VJXFhzaN+warOPGL/ggO/ZR/dm21sD96OXYZE58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 438/484] thunderbolt: Remove service debugfs entries during unregister
Date: Thu, 30 Jul 2026 16:15:35 +0200
Message-ID: <20260730141432.995668449@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
@@ -1004,7 +1004,6 @@ static void tb_service_release(struct de
 	struct tb_service *svc = container_of(dev, struct tb_service, dev);
 	struct tb_xdomain *xd = tb_service_parent(svc);
 
-	tb_service_debugfs_remove(svc);
 	ida_free(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
@@ -1019,6 +1018,14 @@ struct device_type tb_service_type = {
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
@@ -1030,7 +1037,7 @@ static int remove_missing_service(struct
 
 	if (!tb_property_find(xd->remote_properties, svc->key,
 			      TB_PROPERTY_TYPE_DIRECTORY))
-		device_unregister(dev);
+		__unregister_service(dev);
 
 	return 0;
 }
@@ -1123,6 +1130,7 @@ static void enumerate_services(struct tb
 		tb_service_debugfs_init(svc);
 
 		if (device_register(&svc->dev)) {
+			tb_service_debugfs_remove(svc);
 			put_device(&svc->dev);
 			break;
 		}
@@ -2048,7 +2056,7 @@ void tb_xdomain_add(struct tb_xdomain *x
 
 static int unregister_service(struct device *dev, void *data)
 {
-	device_unregister(dev);
+	__unregister_service(dev);
 	return 0;
 }
 


