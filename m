Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334053998AF;
	Tue, 21 Jul 2026 18:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659429; cv=none; b=LkAheToxcE487kgzTr4FRfVo6m6I/e75JYKk3u0lhJIZbpzX3lDhK/OWx04GMzMV8eARuXaQ5Fs1t47SxJx2ywhwoQ6NkOx5VBXVgk6VSsBuv5GLNq0YGE0qJwsMZlzVEgxcK/QsichCe/d/TMyyrnpbQDOChII/daXEQMLMohA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659429; c=relaxed/simple;
	bh=H2HhVzURkZ85sTTZ4OKhx7k+7L+u5WTrEHO9n46fpXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VU/dCENgO9df8mJZLggKIPA+5bjFp8ND64sT7IW2n920dab+j8xa8epUIfiRtJzNNa+muPzCN3WyR46nZM1577JUX8uX+a5wTw5dBAY0TA6lcutjnidkxK9A7WuZhHiCixUtQ+w3sNIX2+gijMGlzWSMM2EnIKP/Yekh1uevyiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lW77u/kS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lW77u/kS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99BC41F000E9;
	Tue, 21 Jul 2026 18:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659428;
	bh=03+cgtjecfDtjSEwgz1ZJfB16b5Ev0RUby52TUXnPsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lW77u/kSfkLJssuwtrvb0Cme/P7opAAXaag7vmfcVmEPDIAsvfEnAVu8D+OOQjAIH
	 9wnyBMo6oSFzuhRF0TMVgF8pPE2qu8aO643e5BQWbSQQaU0qLkD38qokp0Jl4w8pxQ
	 +4ZLOshXbIZGQCaXElU//0aG7LaUtLJxX71j2NcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1516/1611] ACPI: NFIT: core: Fix acpi_nfit_init() error cleanup
Date: Tue, 21 Jul 2026 17:27:12 +0200
Message-ID: <20260721152549.542288598@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 38bf27511ef41bffebd157ec3eba41fc89ba59cd ]

If acpi_nfit_init() fails after adding the acpi_desc object to the
acpi_descs list, that object is never removed from that list because
the acpi_nfit_shutdown() devm action is not added for the NFIT device
in that case.  Next, the acpi_nfit_init() failure causes
acpi_nfit_probe() to fail, the acpi_desc object is freed, and a
dangling pointer is left behind in the acpi_descs.  Any subsequent
ACPI Machine Check Exception will trigger nfit_handle_mce() which
iterates over acpi_descs and so a use-after-free will occur.

Moreover, if acpi_nfit_probe() returns 0 after installing a notify
handler for the NFIT device and without allocating the acpi_desc
object and setting the NFIT device's driver data pointer, the
acpi_desc object will be allocated by acpi_nfit_update_notify()
and acpi_nfit_init() will be called to initialize it.  Regardless
of whether or not acpi_nfit_init() fails in that case, the
acpi_nfit_shutdown() devm action is not added for the NFIT device
and acpi_desc is never removed from the acpi_descs list.  If the
acpi_desc object is freed subsequently on driver removal, any
subsequent ACPI MCE will lead to a use-after-free like in the
previous case.

To address the first issue mentioned above, make acpi_nfit_probe()
call acpi_nfit_shutdown() directly on acpi_nfit_init() failures and
to address the other one, add a remove callback to the driver and
make it call acpi_nfit_shutdown().  Also, since it is now possible to
pass NULL to acpi_nfit_shutdown() or the acpi_desc object passed to it
may not have been initialized, add checks against NULL for acpi_desc and
its nvdimm_bus field to that function and make acpi_nfit_unregister()
clear the latter after unregistering the NVDIMM bus.

Fixes: a61fe6f7902e ("nfit, tools/testing/nvdimm: unify common init for acpi_nfit_desc")
Fixes: fbabd829fe76 ("acpi, nfit: fix module unload vs workqueue shutdown race")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: All applicable <stable@vger.kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/1963615.tdWV9SEqCh@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/nfit/core.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3061,6 +3061,8 @@ static void acpi_nfit_unregister(void *d
 	struct acpi_nfit_desc *acpi_desc = data;
 
 	nvdimm_bus_unregister(acpi_desc->nvdimm_bus);
+	/* The nvdimm_bus object may have been freed, so clear the pointer. */
+	acpi_desc->nvdimm_bus = NULL;
 }
 
 int acpi_nfit_init(struct acpi_nfit_desc *acpi_desc, void *data, acpi_size sz)
@@ -3301,7 +3303,10 @@ static void acpi_nfit_remove_notify_hand
 void acpi_nfit_shutdown(void *data)
 {
 	struct acpi_nfit_desc *acpi_desc = data;
-	struct device *bus_dev = to_nvdimm_bus_dev(acpi_desc->nvdimm_bus);
+	struct device *bus_dev;
+
+	if (!acpi_desc || !acpi_desc->nvdimm_bus)
+		return;
 
 	/*
 	 * Destruct under acpi_desc_lock so that nfit_handle_mce does not
@@ -3316,6 +3321,7 @@ void acpi_nfit_shutdown(void *data)
 	mutex_unlock(&acpi_desc->init_mutex);
 	cancel_delayed_work_sync(&acpi_desc->dwork);
 
+	bus_dev = to_nvdimm_bus_dev(acpi_desc->nvdimm_bus);
 	/*
 	 * Bounce the nvdimm bus lock to make sure any in-flight
 	 * acpi_nfit_ars_rescan() submissions have had a chance to
@@ -3393,9 +3399,14 @@ static int acpi_nfit_add(struct acpi_dev
 				sz - sizeof(struct acpi_table_nfit));
 
 	if (rc)
-		return rc;
+		acpi_nfit_shutdown(acpi_desc);
 
-	return devm_add_action_or_reset(dev, acpi_nfit_shutdown, acpi_desc);
+	return rc;
+}
+
+static void acpi_nfit_remove(struct acpi_device *adev)
+{
+	acpi_nfit_shutdown(dev_get_drvdata(&adev->dev));
 }
 
 static void acpi_nfit_update_notify(struct device *dev, acpi_handle handle)
@@ -3482,6 +3493,7 @@ static struct acpi_driver acpi_nfit_driv
 	.ids = acpi_nfit_ids,
 	.ops = {
 		.add = acpi_nfit_add,
+		.remove = acpi_nfit_remove,
 	},
 };
 


