Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D632D3D3001;
	Thu, 17 Sep 2026 19:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671737; cv=none; b=VI78NHPleAbe2VOqNvOXpEraOJp+OC9Tn2OEg/kP7QEn1f+ecf7hqeiUal2HLgQjeyoO/t6zu1vohIkFC8Sdd8cX+5XQbwTYKBx7yNTtblAih2lSN7nR+vYXKa/faf9DW3/4tdUDCmAyXoYoZrX+uDRQ5WDM8TtAp59DvgBbR5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671737; c=relaxed/simple;
	bh=/GGXVzsAz25OfyBEQNUh3M2lQwmQTU2JAYICHXyF1Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJzURL4Qn8DXmgJnka1vCrp7vhArFK5mTaldUSy2DfWPyW0rhzH8Ys7Oag5m6AD3X1fiyNFcaJCQRQTYqfvRVLwCqi2J47ivwR3mhOqpMdGkUYjmpYW9l3+XYnXx35n5yoy6TPk0QzqR/jT8P7MWQHY3bmuO6Ng3lQvTTHkkDok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/GSgjcX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/GSgjcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236D01F000FF;
	Thu, 17 Sep 2026 19:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671735;
	bh=U2uWCDN7sgq7wCpVfofJ0Mig3uB6bCKTW6V9e3Fd43g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/GSgjcXRQOcFj5QVx5Zb+pFgQCBRb6XzLO5lWwP9KpwvaeFLLrfWn10NaDg2x3kk
	 AnN9YJcuPhf0CwRtPuLzX9i8WdEZ4ypkVIX758jjBglrUjVOzumBsnoflCBJXpBvnd
	 ACiQu3kFkvSXH8AUoCGo6YUnHC38yD8D4u+CSCik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1073/1102] ACPI: TAD: Split three functions to untangle runtime PM handling
Date: Thu, 17 Sep 2026 16:16:56 +0100
Message-ID: <20260917151607.771674681@linuxfoundation.org>
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

[ Upstream commit b14b77bbea0a82cb66f1538824783e63d4128510 ]

Move the core functionality of acpi_tad_get_real_time(),
acpi_tad_wake_set(), and acpi_tad_wake_read() into separate functions
called __acpi_tad_get_real_time(), __acpi_tad_wake_set(), and
__acpi_tad_wake_read(), respectively, which can be called from
code blocks following a single runtime resume of the device.

This will facilitate adding alarm support to the RTC class device
interface of the driver going forward.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://patch.msgid.link/23076728.EfDdHjke4D@rafael.j.wysocki
Stable-dep-of: a3df8bbe0a70 ("ACPI: TAD: Add locking around AML evaluations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_tad.c |  128 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 84 insertions(+), 44 deletions(-)

--- a/drivers/acpi/acpi_tad.c
+++ b/drivers/acpi/acpi_tad.c
@@ -111,7 +111,7 @@ static int acpi_tad_set_real_time(struct
 	return 0;
 }
 
-static int acpi_tad_get_real_time(struct device *dev, struct acpi_tad_rt *rt)
+static int acpi_tad_evaluate_grt(struct device *dev, struct acpi_tad_rt *rt)
 {
 	acpi_handle handle = ACPI_HANDLE(dev);
 	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER };
@@ -120,12 +120,7 @@ static int acpi_tad_get_real_time(struct
 	acpi_status status;
 	int ret = -EIO;
 
-	pm_runtime_get_sync(dev);
-
 	status = acpi_evaluate_object(handle, "_GRT", NULL, &output);
-
-	pm_runtime_put_sync(dev);
-
 	if (ACPI_FAILURE(status))
 		goto out_free;
 
@@ -141,11 +136,6 @@ static int acpi_tad_get_real_time(struct
 		goto out_free;
 
 	memcpy(rt, data, sizeof(*rt));
-	if (acpi_tad_rt_is_invalid(rt)) {
-		ret = -ENODATA;
-		goto out_free;
-	}
-
 	ret = 0;
 
 out_free:
@@ -153,6 +143,82 @@ out_free:
 	return ret;
 }
 
+static int __acpi_tad_get_real_time(struct device *dev, struct acpi_tad_rt *rt)
+{
+	int ret;
+
+	ret = acpi_tad_evaluate_grt(dev, rt);
+	if (ret)
+		return ret;
+
+	if (acpi_tad_rt_is_invalid(rt))
+		return -ENODATA;
+
+	return 0;
+}
+
+static int acpi_tad_get_real_time(struct device *dev, struct acpi_tad_rt *rt)
+{
+	int ret;
+
+	pm_runtime_get_sync(dev);
+
+	ret = __acpi_tad_get_real_time(dev, rt);
+
+	pm_runtime_put_sync(dev);
+
+	return ret;
+}
+
+static int __acpi_tad_wake_set(struct device *dev, char *method, u32 timer_id,
+			       u32 value)
+{
+	acpi_handle handle = ACPI_HANDLE(dev);
+	union acpi_object args[] = {
+		{ .type = ACPI_TYPE_INTEGER, },
+		{ .type = ACPI_TYPE_INTEGER, },
+	};
+	struct acpi_object_list arg_list = {
+		.pointer = args,
+		.count = ARRAY_SIZE(args),
+	};
+	unsigned long long retval;
+	acpi_status status;
+
+	args[0].integer.value = timer_id;
+	args[1].integer.value = value;
+
+	status = acpi_evaluate_integer(handle, method, &arg_list, &retval);
+	if (ACPI_FAILURE(status) || retval)
+		return -EIO;
+
+	return 0;
+}
+
+static int __acpi_tad_wake_read(struct device *dev, char *method, u32 timer_id,
+				unsigned long long *retval)
+{
+	acpi_handle handle = ACPI_HANDLE(dev);
+	union acpi_object args[] = {
+		{ .type = ACPI_TYPE_INTEGER, },
+	};
+	struct acpi_object_list arg_list = {
+		.pointer = args,
+		.count = ARRAY_SIZE(args),
+	};
+	acpi_status status;
+
+	args[0].integer.value = timer_id;
+
+	status = acpi_evaluate_integer(handle, method, &arg_list, retval);
+	if (ACPI_FAILURE(status))
+		return -EIO;
+
+	return 0;
+}
+
+/* sysfs interface */
+
 static char *acpi_tad_rt_next_field(char *s, int *val)
 {
 	char *p;
@@ -265,31 +331,15 @@ static const struct attribute_group acpi
 static int acpi_tad_wake_set(struct device *dev, char *method, u32 timer_id,
 			     u32 value)
 {
-	acpi_handle handle = ACPI_HANDLE(dev);
-	union acpi_object args[] = {
-		{ .type = ACPI_TYPE_INTEGER, },
-		{ .type = ACPI_TYPE_INTEGER, },
-	};
-	struct acpi_object_list arg_list = {
-		.pointer = args,
-		.count = ARRAY_SIZE(args),
-	};
-	unsigned long long retval;
-	acpi_status status;
-
-	args[0].integer.value = timer_id;
-	args[1].integer.value = value;
+	int ret;
 
 	pm_runtime_get_sync(dev);
 
-	status = acpi_evaluate_integer(handle, method, &arg_list, &retval);
+	ret = __acpi_tad_wake_set(dev, method, timer_id, value);
 
 	pm_runtime_put_sync(dev);
 
-	if (ACPI_FAILURE(status) || retval)
-		return -EIO;
-
-	return 0;
+	return ret;
 }
 
 static int acpi_tad_wake_write(struct device *dev, const char *buf, char *method,
@@ -315,27 +365,17 @@ static int acpi_tad_wake_write(struct de
 static ssize_t acpi_tad_wake_read(struct device *dev, char *buf, char *method,
 				  u32 timer_id, const char *specval)
 {
-	acpi_handle handle = ACPI_HANDLE(dev);
-	union acpi_object args[] = {
-		{ .type = ACPI_TYPE_INTEGER, },
-	};
-	struct acpi_object_list arg_list = {
-		.pointer = args,
-		.count = ARRAY_SIZE(args),
-	};
 	unsigned long long retval;
-	acpi_status status;
-
-	args[0].integer.value = timer_id;
+	int ret;
 
 	pm_runtime_get_sync(dev);
 
-	status = acpi_evaluate_integer(handle, method, &arg_list, &retval);
+	ret = __acpi_tad_wake_read(dev, method, timer_id, &retval);
 
 	pm_runtime_put_sync(dev);
 
-	if (ACPI_FAILURE(status))
-		return -EIO;
+	if (ret)
+		return ret;
 
 	if ((u32)retval == ACPI_TAD_WAKE_DISABLED)
 		return sprintf(buf, "%s\n", specval);


