Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0FE277026;
	Sat, 17 Oct 2026 16:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255915; cv=none; b=jhL+BBBr5ozNbLXPDFW0dzhcjWZGE3WwO6ETHLGaDVDsq0Qth87F1mGbnVzq/xSQf2yofz5zdxewKst1rM4eKK0pv0wFb4juBOx33LZHckB1b7KpwVQR3dsbZ88tc3ccCYhYOTlwmxnPwaSb0j7zEUsSUt2m5NivgGU7GKPs+e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255915; c=relaxed/simple;
	bh=Z0wRB2igwFqYsRGRq2RnAB24oJTl4twqHBd+5emIuiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsKpIaoWW5W931oWzUfcAIUwOEePU4oVIK2zpxRANrlkN1kjtxmEc8sJ7ZTQCSfF/dmCOTvKy5Ky9qCX/Sz/L0eWDnUiV4jXNmXnfS9kuQns2g27qCPKNjSJymKn6tsJcQAm8z8zFqB4rsv6m3q5F1fwjSWs7m7khXYAQE748T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v54z9TAj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v54z9TAj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244A01F000C5;
	Sat, 17 Oct 2026 16:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255914;
	bh=D/U3bPkfoORqn/dMl2sx+vlij5M2fMvHQIa7ibDRIFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v54z9TAjximg0HTxyKzX2qdZNozgQela89TI1CMQ2vJYgnJu4+FHoZ6Rm7N/od4Ci
	 vrzMeRduhJJw0ibprNXzZ2WaI+q8BSGLWYINimapv/YqAdLc+Xw1iAhEC+lwDk9vl3
	 nsX7v5Rli4vUbm4gvcCra4O+HZuZpgw3MGoGJSGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0062/1674] ACPI: TAD: Split three functions to untangle runtime PM handling
Date: Sat, 17 Oct 2026 17:38:54 +0200
Message-ID: <20261017160432.728945478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

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
---
 drivers/acpi/acpi_tad.c | 128 ++++++++++++++++++++++++++--------------
 1 file changed, 84 insertions(+), 44 deletions(-)

diff --git a/drivers/acpi/acpi_tad.c b/drivers/acpi/acpi_tad.c
index 7af8e6b833533..8fb892424cfb2 100644
--- a/drivers/acpi/acpi_tad.c
+++ b/drivers/acpi/acpi_tad.c
@@ -110,7 +110,7 @@ static int acpi_tad_set_real_time(struct device *dev, struct acpi_tad_rt *rt)
 	return 0;
 }
 
-static int acpi_tad_get_real_time(struct device *dev, struct acpi_tad_rt *rt)
+static int acpi_tad_evaluate_grt(struct device *dev, struct acpi_tad_rt *rt)
 {
 	acpi_handle handle = ACPI_HANDLE(dev);
 	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER };
@@ -119,12 +119,7 @@ static int acpi_tad_get_real_time(struct device *dev, struct acpi_tad_rt *rt)
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
 
@@ -140,11 +135,6 @@ static int acpi_tad_get_real_time(struct device *dev, struct acpi_tad_rt *rt)
 		goto out_free;
 
 	memcpy(rt, data, sizeof(*rt));
-	if (acpi_tad_rt_is_invalid(rt)) {
-		ret = -ENODATA;
-		goto out_free;
-	}
-
 	ret = 0;
 
 out_free:
@@ -152,6 +142,82 @@ static int acpi_tad_get_real_time(struct device *dev, struct acpi_tad_rt *rt)
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
@@ -264,31 +330,15 @@ static const struct attribute_group acpi_tad_time_attr_group = {
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
@@ -314,27 +364,17 @@ static int acpi_tad_wake_write(struct device *dev, const char *buf, char *method
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
-- 
2.53.0



