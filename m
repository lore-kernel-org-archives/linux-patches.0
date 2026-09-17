Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FA63B634E;
	Thu, 17 Sep 2026 19:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671743; cv=none; b=cOHaVpJAK4c7umOqQEYm7NZWxhCp5+F8PsceT3oTwlRiyU7OF+65eK/+chWCAeUVAlWif4xjmBZBtTW4u4eIXOe9jKgzdHjhP9aOukBv+2fp9WtkcVw2Ux6H1SbdbR1Mtr2IudAzjjbHnWtPI2itOhRWpXYHXrACgkNWbvGkN2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671743; c=relaxed/simple;
	bh=2Oo33LYpKnabheWZo4eR+97x3v6a2Py07Od6Oo8Uhd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnZJNFp5s+L3J0wI7A33i+9+8E42TtL+CQ5gBeKADEaR0k1Td+khIXUh2VKRslzBhH6DiC7cs95+BydlSLkhPEozsK8z+xmc5f4xrdYjBb8qLnBuMt1//mZIDixN6aS/nbWLlBrgWsreMccIPDbjCEilQNo7Pu6byA8IA23z6B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHR97Yxn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHR97Yxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C50E1F000FF;
	Thu, 17 Sep 2026 19:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671742;
	bh=ln8z1Qdj6fav/UmLuQVPsTDBMMDuIF9+QB9hdDaBWGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tHR97YxnvE8PzVc0+BC1S8Uqa/GXdD3R27IUjIO55cXSZZkQLP5rp2jS8ihJ3MMYH
	 Y4GzrSaQV5bwnH+eoKixgU7u5vyBG6AjjsT3UqMdsBbVjY50mkdEW/bHS7njxe0z/0
	 oGhd6B0V8VjORUNRZKEbKGM8ji36kSkD95rOeHqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1074/1102] ACPI: TAD: Add locking around AML evaluations
Date: Thu, 17 Sep 2026 16:16:57 +0100
Message-ID: <20260917151607.797997163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit a3df8bbe0a704fa5c1609b9666b594f350558fe0 ]

In the ACPI TAD driver, there are hidden assumptions that the ACPI
control methods used by it will not be evaluated concurrently due
to ACPICA namespace and interpreter locking.

However, that may not be the case since ACPICA may drop and re-acquire
the namespace and interpreter locks during the evaluation of a given
object in a few cases, including the one in which the AML in question
sleeps causing acpi_ex_system_do_sleep() to be called.  In that case,
the evaluation of one control method may be started while the
evaluation of another one is still in progress.

For this reason, add a global lock to the ACPI TAD driver and
acquire it every time before evaluating an ACPI control method,
except for the initial evaluation of _GCP in acpi_tad_probe().

Fixes: 95c513ec84f7 ("ACPI: Add Time and Alarm Device (TAD) driver")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/12951141.O9o76ZdvQC@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_tad.c |   48 +++++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 19 deletions(-)

--- a/drivers/acpi/acpi_tad.c
+++ b/drivers/acpi/acpi_tad.c
@@ -23,6 +23,7 @@
 #include <linux/acpi.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/suspend.h>
@@ -80,6 +81,8 @@ static bool acpi_tad_rt_is_invalid(struc
 	    rt->daylight > 3;
 }
 
+static DEFINE_MUTEX(acpi_tad_aml_lock);
+
 static int acpi_tad_set_real_time(struct device *dev, struct acpi_tad_rt *rt)
 {
 	acpi_handle handle = ACPI_HANDLE(dev);
@@ -101,6 +104,8 @@ static int acpi_tad_set_real_time(struct
 
 	pm_runtime_get_sync(dev);
 
+	guard(mutex)(&acpi_tad_aml_lock);
+
 	status = acpi_evaluate_integer(handle, "_SRT", &arg_list, &retval);
 
 	pm_runtime_put_sync(dev);
@@ -115,30 +120,27 @@ static int acpi_tad_evaluate_grt(struct
 {
 	acpi_handle handle = ACPI_HANDLE(dev);
 	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER };
-	union acpi_object *out_obj;
-	struct acpi_tad_rt *data;
 	acpi_status status;
 	int ret = -EIO;
 
-	status = acpi_evaluate_object(handle, "_GRT", NULL, &output);
-	if (ACPI_FAILURE(status))
-		goto out_free;
-
-	out_obj = output.pointer;
-	if (out_obj->type != ACPI_TYPE_BUFFER)
-		goto out_free;
-
-	if (out_obj->buffer.length != sizeof(*rt))
-		goto out_free;
-
-	data = (struct acpi_tad_rt *)(out_obj->buffer.pointer);
-	if (!data->valid)
-		goto out_free;
+	guard(mutex)(&acpi_tad_aml_lock);
 
-	memcpy(rt, data, sizeof(*rt));
-	ret = 0;
+	status = acpi_evaluate_object(handle, "_GRT", NULL, &output);
+	if (ACPI_SUCCESS(status)) {
+		union acpi_object *out_obj;
 
-out_free:
+		out_obj = output.pointer;
+		if (out_obj->type == ACPI_TYPE_BUFFER &&
+		    out_obj->buffer.length == sizeof(*rt)) {
+			struct acpi_tad_rt *data;
+
+			data = (struct acpi_tad_rt *)(out_obj->buffer.pointer);
+			if (data->valid) {
+				memcpy(rt, data, sizeof(*rt));
+				ret = 0;
+			}
+		}
+	}
 	ACPI_FREE(output.pointer);
 	return ret;
 }
@@ -188,6 +190,8 @@ static int __acpi_tad_wake_set(struct de
 	args[0].integer.value = timer_id;
 	args[1].integer.value = value;
 
+	guard(mutex)(&acpi_tad_aml_lock);
+
 	status = acpi_evaluate_integer(handle, method, &arg_list, &retval);
 	if (ACPI_FAILURE(status) || retval)
 		return -EIO;
@@ -210,6 +214,8 @@ static int __acpi_tad_wake_read(struct d
 
 	args[0].integer.value = timer_id;
 
+	guard(mutex)(&acpi_tad_aml_lock);
+
 	status = acpi_evaluate_integer(handle, method, &arg_list, retval);
 	if (ACPI_FAILURE(status))
 		return -EIO;
@@ -426,6 +432,8 @@ static int acpi_tad_clear_status(struct
 
 	pm_runtime_get_sync(dev);
 
+	guard(mutex)(&acpi_tad_aml_lock);
+
 	status = acpi_evaluate_integer(handle, "_CWS", &arg_list, &retval);
 
 	pm_runtime_put_sync(dev);
@@ -467,6 +475,8 @@ static ssize_t acpi_tad_status_read(stru
 
 	pm_runtime_get_sync(dev);
 
+	guard(mutex)(&acpi_tad_aml_lock);
+
 	status = acpi_evaluate_integer(handle, "_GWS", &arg_list, &retval);
 
 	pm_runtime_put_sync(dev);


