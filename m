Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8CB36607D;
	Thu, 30 Jul 2026 15:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426739; cv=none; b=MHsXEJQiA1Xdt9fUG/pjOgN2Z6C2ZC2jlG+cTRa5WdiKKhz2BJtzyWFj5nn8ezGUTnzdZgdymLE6Q8zG4Xc3GjEa9AsNKzTm5933EovlC4BZUpgkPuqBVejadCg97womgtWhDtkCfg431y6peWOXp5bjSEuuAaNMFVJEnt6Z1QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426739; c=relaxed/simple;
	bh=qaua/qfNW8YK4QaSVTGdkpORWFkMeDdScpSbYCD0U4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tmd2Fos3sUzcpr0I8R1f/AhYWXhpYmQpwT1CQzr8jgWBc4qG0HJ3eAjipJOEiggnhxXL6RlMJqsUqOmzTL4MeQNqUo7P6YYH9oS+J/eZ7A85dgXx73Pow43yejr8CfnBg89XNyW453SM14kNOfjKR0gFXZ1mxUX29164BPzgbTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xx3j/oGY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xx3j/oGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D1A1F000E9;
	Thu, 30 Jul 2026 15:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426738;
	bh=ENvbiJwLzMWBwX/Ml/Lv22ixx1CdDFPZiCODxquhB5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xx3j/oGYWoPHfCQSMJJ9R49V7adv4RounjWlMzchv11IcZdd3wXUWJt4gulF62Qi6
	 c/zhsZhv16lXH8CUcQmgxbZ54zGLKrPT5+rZ+veiqfEdv5u87pbnrTjHDMUYQDu2m0
	 /EVt5+GuiOlq54F8cJRwEWN7pbQePrOKhFaO3A+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 526/602] thunderbolt: Remove service debugfs entries during unregister
Date: Thu, 30 Jul 2026 16:15:18 +0200
Message-ID: <20260730141447.064948240@linuxfoundation.org>
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
@@ -1019,6 +1018,14 @@ const struct device_type tb_service_type
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
@@ -2053,7 +2061,7 @@ void tb_xdomain_add(struct tb_xdomain *x
 
 static int unregister_service(struct device *dev, void *data)
 {
-	device_unregister(dev);
+	__unregister_service(dev);
 	return 0;
 }
 


