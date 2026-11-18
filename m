Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048171;
	b=BSopoTubDK+B4VxlK8xJ80Pl3lTapD3GazePt17HxGMkWPALDqZCOdEYHk7nR0v3asg2
	 3RVTP0yJd+hxr1aAi7bgAe0owSiYELMBOsP9JiAFVC1wJufD1mTn35lTzX57cCKSrsiSi
	 rjr+wJL7x3GfJs+pvff24V465Pao622D72tkYQAYhfTUCMSUv2E0Kd/8J4AO8z8nIiH9H
	 9uwWH4TCdIgset43GTzf5reqL6m0DB+4spbyvtNOBfencaoz51KWpzTCFrOi9itAtJ2k0
	 cY5bkxjPuE60zei8LmADvIJ7MN27x4I+dvdopfTKK/wGMHT7363P/TE4/BSEVm8o5+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sPqAiietO/9pqywjLeQcqW737pVOJR6rQieioRSS8ew=;
	b=mjxhofCsMAsdFroniiF6gGIupznJDyDyFmV+EMTm21tOQN6/ZD1rq3LCDlXSWvZekzA1
	 /DjTZ4rdLceRI18hMzLD2S7cN2txKU4fURkwuQIhheGnWczAP26GILXR8ZFvSH19FQwQR
	 4zepwz1ogfDmrsNyPKiaJ3728+rljTjeEflxoct5K4o/j4ncSJnEa5TYUu8m3TwIhCSRA
	 5N6lKBXG9MikASimOJHBrsQwqRCwf++sSExg1yYQboSxF/W5kM7eD7VxnypqUkz5ox1e1
	 fztX5Zwg7QzVwZDybLjvunBZjS+fmBuEm+pDmaZaEgeAXjpbvlLmiCxtiu6U4gqRFSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="odQsc/v2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52203606A320;
	Thu, 19 Nov 2026 00:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=odQsc/v2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35C01F000C4;
	Thu, 19 Nov 2026 00:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048171;
	bh=sPqAiietO/9pqywjLeQcqW737pVOJR6rQieioRSS8ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odQsc/v2eKWzRos+Rp1LJK28PV6vHdLBaqKsvfJLVjZijAhCouJlU9elg6bopRR1S
	 OUa0KY/s/IcTS0EGbxEQ0XqpsXhxXYFjRwY/ge8/PDqH4sjrAY1LubjKpCoAGFPTVj
	 prGHCmz23QfiK8fTebqNo6GiXCabDVOxWHHQw21I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1898/2857] ACPI: glue: Fix up and adjust acpi_unbind_one()
Date: Wed, 18 Nov 2026 15:48:52 +0100
Message-ID: <20261118150309.571502897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a194f30876c59..cc9ee8cb820fc 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -316,13 +316,13 @@ int acpi_bind_one(struct device *dev, struct acpi_device *acpi_dev)
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
 
@@ -337,15 +337,17 @@ int acpi_unbind_one(struct device *dev)
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
index 147b560947c66..9d2fb1cde25c5 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -594,7 +594,7 @@ struct acpi_bus_type {
 int register_acpi_bus_type(struct acpi_bus_type *);
 int unregister_acpi_bus_type(struct acpi_bus_type *);
 int acpi_bind_one(struct device *dev, struct acpi_device *adev);
-int acpi_unbind_one(struct device *dev);
+void acpi_unbind_one(struct device *dev);
 
 enum acpi_bridge_type {
 	ACPI_BRIDGE_TYPE_PCIE = 1,
-- 
2.53.0



