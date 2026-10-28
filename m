Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212200;
	b=bbpDKMQB8iNgX85JztIWiE9n45S7l+RoV4pSEfhNZaEWl2UY4bZBK0neUO+LkxDnoJRm
	 g0dmXpBlx7feL5UoDVSx/BevNcs1eVFmY5omyEkNGPxZR/Jyt1YeV4zUY13afhXBUjejY
	 2jiHZu+F2loAVvMOGfkAM4psjIozpYOFXbn2eK7pgLjh7KVks5knHavvlBhCRCXgf4+kr
	 WuvG7ao80wpljXgrOct5upB98WzeL6KN/6q5yeGLEBaYeDvLm2hAPRIZv7YrHMGHPueku
	 K3PyhTkzMLabvw+fzA9McJvTAIWwcJtsCtBZLl9SaplT7Hs0G+K2E+1xTZ9RmRagbhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N9rcf15lMgs0TumfeNoWRhtYOmTN6O+DgelY5m11VAU=;
	b=SxPMeuLKlwq0GMxxl10yJp2mugM9vj6PaivvvdH3py218W6Uj8qsM025+Dxm+LNxO4OE
	 0Vb+HyGDg5tF4iUv6pQ1umd27lzoZM/4HaYVywmaXbBciOth34PL1S/M63J0+3vj28w36
	 GQEJ263S2dDz2lL09PKWbkw/ENfZwOaNyJ+wO/v+VLUU4tTzVeocfD4kKbd/IB6pL3exW
	 nxwdLC0pL5m1e99NGy+V15P57RMrZThj361WyFp5tvNvap8gpd9jMt3wVcjSNS5ncJVmH
	 Yv9tluJis+hzpTt2MWIWa46YtQIKRJQkS2d64QvgN022D8tJ8M4NxUtx7+gV8Rn6yaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGFrAOFR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A7F606A31A;
	Wed, 28 Oct 2026 18:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGFrAOFR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F7B1F01825;
	Wed, 28 Oct 2026 18:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212200;
	bh=N9rcf15lMgs0TumfeNoWRhtYOmTN6O+DgelY5m11VAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eGFrAOFR4+PAW2cVOitucvGPgROWBFi0CydmvWqpzuZwmLimeit3zrZ91fet6W4Kp
	 eEUdkDs6KPRKz89OXS/aMuTQTF1MLKMtkaqFpjuzUtMunA24kEDrKbl6mYzx0zLnuv
	 9/38vdNl+5K6Vu+6cgJEHpzdNGc6C2Q4PD+Czv0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0074/1887] ACPI: TAD: Split three functions to untangle runtime PM handling
Date: Wed, 28 Oct 2026 17:36:10 +0100
Message-ID: <20261028170500.920506890@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
index 664281d7f4259..5f8fc254fc4f3 100644
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



