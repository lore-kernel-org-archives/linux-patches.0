Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0595747AF75;
	Thu, 20 Aug 2026 16:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243540; cv=none; b=VHYBnj9BYkGRWtju6NVrkErZuwkADWES/nDiKs3gHK6s2RwyYb3AM62IbIeMZgcUzQucAnk+SUh4j2xhtnk48QfA6PEezEjLloAQjFfXFOaxeKffPOpZtUzpZcKTpfBfPgUoeVlALSBLAL6CubZzW2QxUXO9CH9lnEUoc4MoKuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243540; c=relaxed/simple;
	bh=yNZE383Vw51enyvB5QTrGuvFgwjg8ZZkQwR07aOnLzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFCiQdDWKhCrpt/4AD0Cpz7y/TdxUPVxHIv0FcphVpqUx2tP/BT7BnkFPkea2xium1wTd0E6/K5jTkykIXiCuIvPeuyse9VIm+i03Zezhw5AxrT7XDG9yfY1wkFrTAtvoTRvBtX1OErBO0vOzaUUdD9zB/dHnAjXZVivRAfCRxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfd+O60/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfd+O60/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606C31F000E9;
	Thu, 20 Aug 2026 16:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243538;
	bh=w5RhtxwSbLiXscOjzISHNUuVV9YmGuAgXbrZvGMgqe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfd+O60/1PNrLUeJmj4O6QvL4BWEjeKN0zV8dimLBF5bAS7AMjvGl9pDZ0qodzVdv
	 CqktuSczREo6OEzOeqpL+f0D05CPR0fAA5T/4NofN0AOwPNhyQeQLLWjI0Popl6IJt
	 ccJTyDSYHQv39qdsKOtugS89KP+84TtADZfUAtNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/272] thunderbolt: Remove service debugfs entries during unregister
Date: Thu, 20 Aug 2026 16:55:14 +0200
Message-ID: <20260820145235.159983340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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
@@ -807,7 +807,6 @@ static void tb_service_release(struct de
 	struct tb_service *svc = container_of(dev, struct tb_service, dev);
 	struct tb_xdomain *xd = tb_service_parent(svc);
 
-	tb_service_debugfs_remove(svc);
 	ida_free(&xd->service_ids, svc->id);
 	kfree(svc->key);
 	kfree(svc);
@@ -822,6 +821,14 @@ struct device_type tb_service_type = {
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
@@ -833,7 +840,7 @@ static int remove_missing_service(struct
 
 	if (!tb_property_find(xd->remote_properties, svc->key,
 			      TB_PROPERTY_TYPE_DIRECTORY))
-		device_unregister(dev);
+		__unregister_service(dev);
 
 	return 0;
 }
@@ -926,6 +933,7 @@ static void enumerate_services(struct tb
 		tb_service_debugfs_init(svc);
 
 		if (device_register(&svc->dev)) {
+			tb_service_debugfs_remove(svc);
 			put_device(&svc->dev);
 			break;
 		}
@@ -1462,7 +1470,7 @@ void tb_xdomain_add(struct tb_xdomain *x
 
 static int unregister_service(struct device *dev, void *data)
 {
-	device_unregister(dev);
+	__unregister_service(dev);
 	return 0;
 }
 


