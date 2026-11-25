Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625089;
	b=IT4Reg8VDozFI8Kg09QdooQL2MLz7tiM6Z0Q9JFXTO7GHiYHF3E2+1WbtV+8uP8vaLVE
	 GNCWUpqHzD63u67WjRpAVSflippOuBiZ18mFgUA6YqNT38Tw5QFOc4P9PCs15+5lx/T8M
	 Q8YCH7UdFoBOD8BvXaobxlewXu/YHJFYllfFhrcFZLf/Ba/ehUDvSBIEzPJsZlyDjWsCt
	 s6/ClEoBMS+kag9pb77zNLSsbuhT007gM6eSeWxV5LjbCHOThM55yhSMhdr+4ECEGsEx3
	 B4wEg3iQkpX9zMYTDc36Q5yfImD4z02S+cqB9+tbc04C+mEbdyXRXh+IohU5X24Wd5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PT0n67v2eTqn1RXyvRqsuIE0yfGjQli5JEbdsgC/aTQ=;
	b=dLCbVbXIyM74/LKnAtQpGsHnXb6j6LE2NFp59AlworeVwQI5xmJ5nUmX6i0bOUbOKxyM
	 VpCNlcMSnj5aLD1uoCRMEoPngPIsf2TnRGnhVrjp64oGTmbUjPACjqbZO45z+1Z1jAApV
	 IY43/VfoM2U7JjhK470EZ3s99lfQW630YJv3G/FpKyoT3LkyMiKOYb3LF+8Mc9CW2cCkf
	 Zk+9kQrzwgHGFMLQp8hiUflhznnP/qnm6yMGum2XdtQDVQdP3jdQzD12a+qY5f3HfXXYD
	 Tpo1JrTQy6sQM+D+ph3O3RCYiDIpdp6Gz0bZueQ3iqu6n1/QZ2pvkoL4RX2V/S9q+eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILcjJWCM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD95606A329;
	Wed, 25 Nov 2026 16:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILcjJWCM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805401F000D8;
	Wed, 25 Nov 2026 16:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625089;
	bh=PT0n67v2eTqn1RXyvRqsuIE0yfGjQli5JEbdsgC/aTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILcjJWCMJI3DRlB6aojOBUs2I8/FRbADqeHLUzZf7lG1titVEOvOe8hgmzISOWpK2
	 mJFI6q5nhf3izK5NrCRicLAa22/ksoYKbE8Ny61FQEhHvmnHzZ9xjmzU2AvjsgGIga
	 FyOACcB3nwgPfPM3eZp0nuiaIfBdJs2lj06bu+os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 402/816] ACPI: glue: Carry out companion lookup under bus_type_sem
Date: Wed, 25 Nov 2026 15:32:30 +0100
Message-ID: <20261125143858.503712618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit c94619c8a5b5d3b980433d247ac87a2d1c827cb6 ]

When acpi_device_notify() looks up an ACPI companion for the given
device, it invokes callbacks from struct acpi_bus_type() without
synchronization which may lead to a use-after-free if the driver
module containing those callbacks is unloaded at the same time.

Address this by holding bus_type_sem throughout the entire ACPI
companion lookup and the execution of the .setup() callback in
struct acpi_bus_type (if present) instead of dropping the semaphore
(prematurely) after finding a matching struct acpi_bus_type.

For this purpose, rename acpi_get_bus_type() to acpi_companion_lookup(),
make it return a struct acpi_device pointer, and move the relevant code
from acpi_device_notify() to it.

Also notice that the only case in which the .bind() callback from an
ACPI scan handler may need to be invoked is when the given device is
a platform one, so adjust acpi_device_notify() accordingly and drop
the "done" label that is not used any more from it.

Fixes: 2ef5236660b6 ("ACPI: glue: Look for ACPI bus type only if ACPI companion is not known")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/3089807.e9J7NaK4W3@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/glue.c | 61 +++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 32 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index c01ebf20a9318..e2a40847d24b6 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -59,19 +59,34 @@ int unregister_acpi_bus_type(struct acpi_bus_type *type)
 }
 EXPORT_SYMBOL_GPL(unregister_acpi_bus_type);
 
-static struct acpi_bus_type *acpi_get_bus_type(struct device *dev)
+static struct acpi_device *acpi_companion_lookup(struct device *dev)
 {
-	struct acpi_bus_type *tmp, *ret = NULL;
+	struct acpi_bus_type *type;
 
-	down_read(&bus_type_sem);
-	list_for_each_entry(tmp, &bus_type_list, list) {
-		if (tmp->match(dev)) {
-			ret = tmp;
-			break;
+	guard(rwsem_read)(&bus_type_sem);
+
+	list_for_each_entry(type, &bus_type_list, list) {
+		struct acpi_device *adev;
+
+		if (!type->match(dev))
+			continue;
+
+		adev = type->find_companion(dev);
+		if (!adev) {
+			dev_dbg(dev, "ACPI companion not found\n");
+			return NULL;
 		}
+		if (acpi_bind_one(dev, adev)) {
+			dev_dbg(dev, "Binding to ACPI companion failed\n");
+			return NULL;
+		}
+		if (type->setup)
+			type->setup(dev);
+
+		return adev;
 	}
-	up_read(&bus_type_sem);
-	return ret;
+
+	return NULL;
 }
 
 #define FIND_CHILD_MIN_SCORE	1
@@ -362,40 +377,22 @@ void acpi_device_notify(struct device *dev)
 
 	ret = acpi_bind_one(dev, NULL);
 	if (ret) {
-		struct acpi_bus_type *type = acpi_get_bus_type(dev);
-
-		if (!type)
+		adev = acpi_companion_lookup(dev);
+		if (!adev)
 			return;
-
-		adev = type->find_companion(dev);
-		if (!adev) {
-			dev_dbg(dev, "ACPI companion not found\n");
-			return;
-		}
-		ret = acpi_bind_one(dev, adev);
-		if (ret) {
-			dev_dbg(dev, "Binding to ACPI companion failed\n");
-			return;
-		}
-		if (type->setup) {
-			type->setup(dev);
-			goto done;
-		}
 	} else {
 		adev = ACPI_COMPANION(dev);
 
 		if (dev_is_pci(dev)) {
 			pci_acpi_setup(dev, adev);
-			goto done;
 		} else if (dev_is_platform(dev)) {
 			acpi_configure_pmsi_domain(dev);
+
+			if (adev->handler && adev->handler->bind)
+				adev->handler->bind(dev);
 		}
 	}
 
-	if (adev->handler && adev->handler->bind)
-		adev->handler->bind(dev);
-
-done:
 	dev_dbg(dev, "Bound to ACPI device %s\n", acpi_dev_name(adev));
 }
 
-- 
2.53.0



