Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4D9157E8F;
	Mon, 29 Jan 2024 17:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548376; cv=none; b=JJWn5jhLHk9+l0o8brEx5O/YGQv0Ax/MbE49u0tLTVVz9OqAtK94sFgkew6SlLtunfNwnnFBAwn79YJpwQGOLImltgYY1BzcyDYNb2fy1wn3mIUAa5p15InV4kM7fYpt/TTFRk+6K3GH7QWLPc/uYzB5kHk3VYQs2KQb7sCYtB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548376; c=relaxed/simple;
	bh=efWN6upCMLx+hFMVWeZERx98/Ha4/RfmRQjnXbWVaJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AFxGbLspwCwfvnXe0WxvtyH9dF3GfMaZDiZAZAVHgX5gfbMjCS76cUzBEcpJbIES3nSzF68WPDipCtAH34dYwuf9OaKiKmQNwDyD0hTh7EUidLKzDebyRZmWbeXuaDJQIsHTOfrGCcJmduD/CmqrRKD+W/G9SSSWVTmF5TdcCME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORjsK6y8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORjsK6y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99FFC43390;
	Mon, 29 Jan 2024 17:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548375;
	bh=efWN6upCMLx+hFMVWeZERx98/Ha4/RfmRQjnXbWVaJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORjsK6y8WnKPVPdHuKEnLREa5Vfry+uoTYTZxIGVQnwBaOpFnliSYCaQESWsyK1V+
	 TEpgBHJvj3O6WINNCiLm+HVvu6e88/nyFdoo/darx8R0fnFiPxFr0HW+TRQqv0AfVC
	 iZuoXRQAtuIQ9uQqovtCSOruiIhBcGkN66VsDSKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 137/185] platform/x86: intel-uncore-freq: Fix types in sysfs callbacks
Date: Mon, 29 Jan 2024 09:05:37 -0800
Message-ID: <20240129170002.995711350@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 416de0246f35f43d871a57939671fe814f4455ee upstream.

When booting a kernel with CONFIG_CFI_CLANG, there is a CFI failure when
accessing any of the values under
/sys/devices/system/cpu/intel_uncore_frequency/package_00_die_00:

  $ cat /sys/devices/system/cpu/intel_uncore_frequency/package_00_die_00/max_freq_khz
  fish: Job 1, 'cat /sys/devices/system/cpu/int…' terminated by signal SIGSEGV (Address boundary error)

  $ sudo dmesg &| grep 'CFI failure'
  [  170.953925] CFI failure at kobj_attr_show+0x19/0x30 (target: show_max_freq_khz+0x0/0xc0 [intel_uncore_frequency_common]; expected type: 0xd34078c5

The sysfs callback functions such as show_domain_id() are written as if
they are going to be called by dev_attr_show() but as the above message
shows, they are instead called by kobj_attr_show(). kCFI checks that the
destination of an indirect jump has the exact same type as the prototype
of the function pointer it is called through and fails when they do not.

These callbacks are called through kobj_attr_show() because
uncore_root_kobj was initialized with kobject_create_and_add(), which
means uncore_root_kobj has a ->sysfs_ops of kobj_sysfs_ops from
kobject_create(), which uses kobj_attr_show() as its ->show() value.

The only reason there has not been a more noticeable problem until this
point is that 'struct kobj_attribute' and 'struct device_attribute' have
the same layout, so getting the callback from container_of() works the
same with either value.

Change all the callbacks and their uses to be compatible with
kobj_attr_show() and kobj_attr_store(), which resolves the kCFI failure
and allows the sysfs files to work properly.

Closes: https://github.com/ClangBuiltLinux/linux/issues/1974
Fixes: ae7b2ce57851 ("platform/x86/intel/uncore-freq: Use sysfs API to create attributes")
Cc: stable@vger.kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20240104-intel-uncore-freq-kcfi-fix-v1-1-bf1e8939af40@kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
[nathan: Fix conflicts due to lack of 9b8dea80e3cb in 6.1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c |   64 +++++-----
 drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.h |   20 +--
 2 files changed, 42 insertions(+), 42 deletions(-)

--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c
@@ -74,30 +74,30 @@ static ssize_t show_perf_status_freq_khz
 }
 
 #define store_uncore_min_max(name, min_max)				\
-	static ssize_t store_##name(struct device *dev,		\
-				     struct device_attribute *attr,	\
+	static ssize_t store_##name(struct kobject *kobj,		\
+				     struct kobj_attribute *attr,	\
 				     const char *buf, size_t count)	\
 	{								\
-		struct uncore_data *data = container_of(attr, struct uncore_data, name##_dev_attr);\
+		struct uncore_data *data = container_of(attr, struct uncore_data, name##_kobj_attr);\
 									\
 		return store_min_max_freq_khz(data, buf, count,	\
 					      min_max);		\
 	}
 
 #define show_uncore_min_max(name, min_max)				\
-	static ssize_t show_##name(struct device *dev,		\
-				    struct device_attribute *attr, char *buf)\
+	static ssize_t show_##name(struct kobject *kobj,		\
+				    struct kobj_attribute *attr, char *buf)\
 	{                                                               \
-		struct uncore_data *data = container_of(attr, struct uncore_data, name##_dev_attr);\
+		struct uncore_data *data = container_of(attr, struct uncore_data, name##_kobj_attr);\
 									\
 		return show_min_max_freq_khz(data, buf, min_max);	\
 	}
 
 #define show_uncore_perf_status(name)					\
-	static ssize_t show_##name(struct device *dev,		\
-				   struct device_attribute *attr, char *buf)\
+	static ssize_t show_##name(struct kobject *kobj,		\
+				   struct kobj_attribute *attr, char *buf)\
 	{                                                               \
-		struct uncore_data *data = container_of(attr, struct uncore_data, name##_dev_attr);\
+		struct uncore_data *data = container_of(attr, struct uncore_data, name##_kobj_attr);\
 									\
 		return show_perf_status_freq_khz(data, buf); \
 	}
@@ -111,11 +111,11 @@ show_uncore_min_max(max_freq_khz, 1);
 show_uncore_perf_status(current_freq_khz);
 
 #define show_uncore_data(member_name)					\
-	static ssize_t show_##member_name(struct device *dev,	\
-					   struct device_attribute *attr, char *buf)\
+	static ssize_t show_##member_name(struct kobject *kobj,	\
+					   struct kobj_attribute *attr, char *buf)\
 	{                                                               \
 		struct uncore_data *data = container_of(attr, struct uncore_data,\
-							  member_name##_dev_attr);\
+							  member_name##_kobj_attr);\
 									\
 		return sysfs_emit(buf, "%u\n",				\
 				 data->member_name);			\
@@ -126,29 +126,29 @@ show_uncore_data(initial_max_freq_khz);
 
 #define init_attribute_rw(_name)					\
 	do {								\
-		sysfs_attr_init(&data->_name##_dev_attr.attr);	\
-		data->_name##_dev_attr.show = show_##_name;		\
-		data->_name##_dev_attr.store = store_##_name;		\
-		data->_name##_dev_attr.attr.name = #_name;		\
-		data->_name##_dev_attr.attr.mode = 0644;		\
+		sysfs_attr_init(&data->_name##_kobj_attr.attr);	\
+		data->_name##_kobj_attr.show = show_##_name;		\
+		data->_name##_kobj_attr.store = store_##_name;		\
+		data->_name##_kobj_attr.attr.name = #_name;		\
+		data->_name##_kobj_attr.attr.mode = 0644;		\
 	} while (0)
 
 #define init_attribute_ro(_name)					\
 	do {								\
-		sysfs_attr_init(&data->_name##_dev_attr.attr);	\
-		data->_name##_dev_attr.show = show_##_name;		\
-		data->_name##_dev_attr.store = NULL;			\
-		data->_name##_dev_attr.attr.name = #_name;		\
-		data->_name##_dev_attr.attr.mode = 0444;		\
+		sysfs_attr_init(&data->_name##_kobj_attr.attr);	\
+		data->_name##_kobj_attr.show = show_##_name;		\
+		data->_name##_kobj_attr.store = NULL;			\
+		data->_name##_kobj_attr.attr.name = #_name;		\
+		data->_name##_kobj_attr.attr.mode = 0444;		\
 	} while (0)
 
 #define init_attribute_root_ro(_name)					\
 	do {								\
-		sysfs_attr_init(&data->_name##_dev_attr.attr);	\
-		data->_name##_dev_attr.show = show_##_name;		\
-		data->_name##_dev_attr.store = NULL;			\
-		data->_name##_dev_attr.attr.name = #_name;		\
-		data->_name##_dev_attr.attr.mode = 0400;		\
+		sysfs_attr_init(&data->_name##_kobj_attr.attr);	\
+		data->_name##_kobj_attr.show = show_##_name;		\
+		data->_name##_kobj_attr.store = NULL;			\
+		data->_name##_kobj_attr.attr.name = #_name;		\
+		data->_name##_kobj_attr.attr.mode = 0400;		\
 	} while (0)
 
 static int create_attr_group(struct uncore_data *data, char *name)
@@ -161,14 +161,14 @@ static int create_attr_group(struct unco
 	init_attribute_ro(initial_max_freq_khz);
 	init_attribute_root_ro(current_freq_khz);
 
-	data->uncore_attrs[index++] = &data->max_freq_khz_dev_attr.attr;
-	data->uncore_attrs[index++] = &data->min_freq_khz_dev_attr.attr;
-	data->uncore_attrs[index++] = &data->initial_min_freq_khz_dev_attr.attr;
-	data->uncore_attrs[index++] = &data->initial_max_freq_khz_dev_attr.attr;
+	data->uncore_attrs[index++] = &data->max_freq_khz_kobj_attr.attr;
+	data->uncore_attrs[index++] = &data->min_freq_khz_kobj_attr.attr;
+	data->uncore_attrs[index++] = &data->initial_min_freq_khz_kobj_attr.attr;
+	data->uncore_attrs[index++] = &data->initial_max_freq_khz_kobj_attr.attr;
 
 	ret = uncore_read_freq(data, &freq);
 	if (!ret)
-		data->uncore_attrs[index++] = &data->current_freq_khz_dev_attr.attr;
+		data->uncore_attrs[index++] = &data->current_freq_khz_kobj_attr.attr;
 
 	data->uncore_attrs[index] = NULL;
 
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.h
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.h
@@ -23,11 +23,11 @@
  * @die_id:		Die id for this instance
  * @name:		Sysfs entry name for this instance
  * @uncore_attr_group:	Attribute group storage
- * @max_freq_khz_dev_attr: Storage for device attribute max_freq_khz
- * @mix_freq_khz_dev_attr: Storage for device attribute min_freq_khz
- * @initial_max_freq_khz_dev_attr: Storage for device attribute initial_max_freq_khz
- * @initial_min_freq_khz_dev_attr: Storage for device attribute initial_min_freq_khz
- * @current_freq_khz_dev_attr: Storage for device attribute current_freq_khz
+ * @max_freq_khz_dev_attr: Storage for kobject attribute max_freq_khz
+ * @mix_freq_khz_dev_attr: Storage for kobject attribute min_freq_khz
+ * @initial_max_freq_khz_dev_attr: Storage for kobject attribute initial_max_freq_khz
+ * @initial_min_freq_khz_dev_attr: Storage for kobject attribute initial_min_freq_khz
+ * @current_freq_khz_dev_attr: Storage for kobject attribute current_freq_khz
  * @uncore_attrs:	Attribute storage for group creation
  *
  * This structure is used to encapsulate all data related to uncore sysfs
@@ -44,11 +44,11 @@ struct uncore_data {
 	char name[32];
 
 	struct attribute_group uncore_attr_group;
-	struct device_attribute max_freq_khz_dev_attr;
-	struct device_attribute min_freq_khz_dev_attr;
-	struct device_attribute initial_max_freq_khz_dev_attr;
-	struct device_attribute initial_min_freq_khz_dev_attr;
-	struct device_attribute current_freq_khz_dev_attr;
+	struct kobj_attribute max_freq_khz_kobj_attr;
+	struct kobj_attribute min_freq_khz_kobj_attr;
+	struct kobj_attribute initial_max_freq_khz_kobj_attr;
+	struct kobj_attribute initial_min_freq_khz_kobj_attr;
+	struct kobj_attribute current_freq_khz_kobj_attr;
 	struct attribute *uncore_attrs[6];
 };
 


