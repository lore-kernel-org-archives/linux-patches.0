Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1577A175A6D;
	Thu, 30 Jul 2026 14:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423300; cv=none; b=G3arhUDucSAxYOwqEidaB11aIK1yp5RkxI+D2wBh+FGull7UUVP/6Vuv1avH7zMP1rCQ7DaUl11diJ+TDdEomBHK/b+YdbOcWi1NbWithlIjDxgryAANtt7poKtgxMU9A0F/zztFCOgFeOnmR8VVQ9pukWHgyBvWiLZCDS1v1fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423300; c=relaxed/simple;
	bh=brDae8dC17ngVUkwkBvl38/AoTNxa8HbDyAUm4WTxu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rle/GcyIK78DJeFZNKwm+j0Q/OuHorU1yC5Ite/qBWY43aXlDl/eCKlK2r4nMHKnxa3eC/AatfdYQNp4FG5Oplv0liHGyT4+5eE570iWfJXX18J+/Wv1iQqq8RIVeZOuTOSDzgQVzxdBOSD4GIhcLz+PQWz2CyYJhHgKkI8QGtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RuQNrxNV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RuQNrxNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C671F000E9;
	Thu, 30 Jul 2026 14:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423298;
	bh=e1wbj78Z0DOhaUfiVlkZnnGFNpAD71WwYL7sf4O7MXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RuQNrxNV521Lvka/iRlGv+R9MglllCy6qWF+F8Pf11unA49P4xepnhGmd4qiQ0Uzt
	 vgiZ95p4Mk5XNBZ4WQQJ3UphNI6b/zQG4xota8QFKxUOYn6sO5x47sUSMPEmu9JRgF
	 GF7+ZjlZKFG+WH3iamLfdw/mXO24FkEkMyeaxMds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 734/744] thunderbolt: Remove service debugfs entries during unregister
Date: Thu, 30 Jul 2026 16:16:47 +0200
Message-ID: <20260730141459.908822373@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


