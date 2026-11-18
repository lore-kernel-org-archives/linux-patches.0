Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055006;
	b=brPNiyMzj8xNs8llW14FkBSsvwdP+ZXG1C1u+SJNNF3lFRHEk6jow+XtXHb9WlXA/ExL
	 rHHabjsngCbbP7ad2T/gZeOfjab9z/DeuSiUD9/fhhEy8mGlo6orBuGQiYr9TXUqLZzRw
	 xBqQqnr6J6aOXZh2F9HztrzwSfAOrVQG1DuuFsXxiyuaHIuEChKFLTboJNdfCl1X1tkAr
	 iBYg69iBZU4qua8wm4iS0is66SnICfYvAFd8UNLgJ5WvH0JoLt1HY7MjmZ4IgUUgYLwsW
	 lD7oFxTul9zUibgzfNEoPLcwKpEbf1fC331603NNrjz5xOs7T3KX1hWSakBwOWDmNhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nAteSKuI0eP74PZhL/NyQaxCuUINlAnZDmnHYXU7cqE=;
	b=zfb16vm9hC2S9Q4im34c07FZAdb5WQ4KQrXBNu5YnHpg4ir4Uhbscxmcr/pq60TvDNGX
	 ZfhpO+7Pri7QvWVW5KsMOYm761bSt2G2zdXXmrc+j1GSE/iQU0bTvY5+mKwTwUmfPfU2v
	 v/cWNFcgH2LS/G17cQnkVU7q+3was6QkCMOqFBZ/jjO4uy2mDT1rH2y1Lc/ki0RgLFj1a
	 GHpJIj8WwmaNRjrnQ+IT62nQlSYk58/wGMJoIycN0sGlQs7CGsKcWo6sJbC22TcJ6DW5Y
	 slCOYk2ImzFIzWFfpU1YNk6OCj707Amxr9+PAzBrgwNlPa8EZ4gml7O1nNRWihZIs6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nqIjqbjA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BFDA606A31C;
	Thu, 19 Nov 2026 02:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nqIjqbjA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98C11F000C4;
	Thu, 19 Nov 2026 02:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055006;
	bh=nAteSKuI0eP74PZhL/NyQaxCuUINlAnZDmnHYXU7cqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqIjqbjA1M/WhiqSrk7FHKR5lUWItxl9Jb+/fcuCRJvMH0Mj4xicpDBZiXTywpt0z
	 HZrGUI1s01L+GxDZ6ELboTrC9LsxwITvHpikNlJIfV6RergWi3Eo4LNNuClGI4MNdF
	 3Glu2HgSMJEhgwHgu71D2RhN0upOkffMGKJ50EL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1478/2214] ACPI: glue: Fix up and adjust acpi_unbind_one()
Date: Wed, 18 Nov 2026 15:52:34 +0100
Message-ID: <20261118150110.286429276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 693546852656075e0247ac637b05625ead134eff ]

Since none of the acpi_unbind_one() callers check its return value and
it always returns 0 anyway, make it void.

Also notice that unlocking physical_node_lock for the given ACPI device
should be carried out before dropping the reference to it in case that
reference is the last one (highly unlikely), so rearrange the code to
make that happen.

Fixes: 3e3327837c18 ("ACPI: Use list_for_each_entry() in acpi_unbind_one()")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/10940500.nUPlyArG6x@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/glue.c     | 10 ++++++----
 include/acpi/acpi_bus.h |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 7a33a6d985f89..f696f0da49318 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -252,13 +252,13 @@ int acpi_bind_one(struct device *dev, struct acpi_device *acpi_dev)
 }
 EXPORT_SYMBOL_GPL(acpi_bind_one);
 
-int acpi_unbind_one(struct device *dev)
+void acpi_unbind_one(struct device *dev)
 {
 	struct acpi_device *acpi_dev = ACPI_COMPANION(dev);
 	struct acpi_device_physical_node *entry;
 
 	if (!acpi_dev)
-		return 0;
+		return;
 
 	mutex_lock(&acpi_dev->physical_node_lock);
 
@@ -273,15 +273,17 @@ int acpi_unbind_one(struct device *dev)
 			sysfs_remove_link(&acpi_dev->dev.kobj, physnode_name);
 			sysfs_remove_link(&dev->kobj, "firmware_node");
 			ACPI_COMPANION_SET(dev, NULL);
+
+			mutex_unlock(&acpi_dev->physical_node_lock);
+
 			/* Drop references taken by acpi_bind_one(). */
 			put_device(dev);
 			acpi_dev_put(acpi_dev);
 			kfree(entry);
-			break;
+			return;
 		}
 
 	mutex_unlock(&acpi_dev->physical_node_lock);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(acpi_unbind_one);
 
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 7a85ae6b7b005..7ce4e01b2406e 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -576,7 +576,7 @@ struct acpi_bus_type {
 int register_acpi_bus_type(struct acpi_bus_type *);
 int unregister_acpi_bus_type(struct acpi_bus_type *);
 int acpi_bind_one(struct device *dev, struct acpi_device *adev);
-int acpi_unbind_one(struct device *dev);
+void acpi_unbind_one(struct device *dev);
 
 struct acpi_pci_root {
 	struct acpi_device * device;
-- 
2.53.0



