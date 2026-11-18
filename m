Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060537;
	b=ZBA8nfoKOxFB/MsRk9SdlvHF0UNCuYMepR+HkOMDv3xUwNzbQcYd2/I3wDXg9V+0scMQ
	 aqgj3Dak4oLZr8m6c01Y7COyMPqMITdJJwq1chVDmOrbxbjWQDKscYG9bfR0gD6b50i7C
	 157kWxKhcviNtOrIcf1N4Qald3upilXZzJpFCRdai0OtPvilPD8PO3zcL2g9uucS3lVZ3
	 UYYsQoVKYA50mpCVkQlSlL94SAb1kqi+4RILVb48QjyfL/VOsP4xkKbJ7BtbnMk3+DRmU
	 UG0E3pTw3EK2hdSi0t9o8OxayCT9BeU7296m4BuXiyQXvaTOM3CYBhTcj+stQ4S5cXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pkJP8FJcOwoqIlM83bUYfzRoQLxLaMT2XilxLN6jKPA=;
	b=qLlA7Kkydd46QjZSLSyLcfxlfm44c1bYal952/tMblcMQ7/8McZvplypX+6pSbrmk9GO
	 bXFV0p0LIISZ9S3BIvFGt0/8cWor9k+AFTBK42ZBC/1d+UsAyHGLKkrlVwviPJSkE7AjM
	 g3CixLYwMW2TjX1riYUZEUseHFY+MRfKOh+Bt9uv5E8vPjHoSo4r17PF+k8zC/1kXlh8X
	 wlC/mEpgl12mgxPMaj0SMPPzzghy9F9CZdzVOJPKmTCKshwyfZjVy7k6T1AEjaQC8O/2r
	 QCCOhR2RYOkXRBYcHiU3f7q522YmZ+2zoBgSYxv9EjFNo0gl76bOEXDjJoTZO0sMj4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wyacwDiq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFC1606A325;
	Thu, 19 Nov 2026 03:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wyacwDiq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AB71F000C4;
	Thu, 19 Nov 2026 03:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060537;
	bh=pkJP8FJcOwoqIlM83bUYfzRoQLxLaMT2XilxLN6jKPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wyacwDiqyQ2KtO/1EvszaH8P2dkFI5YL+M2drZl2H+fbObXuDRNQYTkR9ySeRelcq
	 gDYzkp/pQgUhG0sNmAChSudoCKrI3slF6GkYHYpy36Nz+m1PsdZUJQaYQxuTMuFxvU
	 GtmrKtfyIlLIvetl6zgMq/vdyS4a/P34P3uinrAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1233/1848] ACPI: glue: Fix up and adjust acpi_unbind_one()
Date: Wed, 18 Nov 2026 15:54:31 +0100
Message-ID: <20261118150011.496335671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 36b24b0658cb7..0ed0de04e80f7 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -262,13 +262,13 @@ int acpi_bind_one(struct device *dev, struct acpi_device *acpi_dev)
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
 
@@ -283,15 +283,17 @@ int acpi_unbind_one(struct device *dev)
 			sysfs_remove_link(&acpi_dev->dev.kobj, physnode_name);
 			sysfs_remove_link(&dev->kobj, "firmware_node");
 			ACPI_COMPANION_SET(dev, NULL);
+
+			mutex_unlock(&acpi_dev->physical_node_lock);
+
 			/* Drop references taken by acpi_bind_one(). */
 			put_device(dev);
 			put_device(&acpi_dev->dev);
 			kfree(entry);
-			break;
+			return;
 		}
 
 	mutex_unlock(&acpi_dev->physical_node_lock);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(acpi_unbind_one);
 
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index a4c297387c77d..4170b54fe36d2 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -570,7 +570,7 @@ struct acpi_bus_type {
 int register_acpi_bus_type(struct acpi_bus_type *);
 int unregister_acpi_bus_type(struct acpi_bus_type *);
 int acpi_bind_one(struct device *dev, struct acpi_device *adev);
-int acpi_unbind_one(struct device *dev);
+void acpi_unbind_one(struct device *dev);
 
 struct acpi_pci_root {
 	struct acpi_device * device;
-- 
2.53.0



