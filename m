Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D79C15F315;
	Mon, 29 Jan 2024 17:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548588; cv=none; b=Z7duOBH6RwXcOXeI+89GZoru7kjVELYve2yOjdl8oELmLu7MlUs5PPkddklMlEqMKYzO3973pEGQ0akBiziWt4yNWR6FwMP3sB4nikEsk8CsiaIytNkrLJYuEx646cmlaTFB8WPST0Ob8xJHfInqIGyxE99dyeiCsN+48f4vCoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548588; c=relaxed/simple;
	bh=6cSPyDmQw+7QFNqTy2Q55NwGt3yIR/bfT0YW5tXuLJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pW4MXO5akxmdWpa9xwKMUa0eWdan6jQRkhzBWfRc4nVhs3CbLyGdbf8uvLurw8bbAAoKgmmdVXwM3Yf0TAMMTepXeN7BRVyzUoH+29fXbKn2w8esbRJPKa1dZaielI260lNqclJjeDsli8/WONt/637VXgMiXLWN74Nlvzy9ZiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dit9WEIk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dit9WEIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6660CC43390;
	Mon, 29 Jan 2024 17:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548588;
	bh=6cSPyDmQw+7QFNqTy2Q55NwGt3yIR/bfT0YW5tXuLJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dit9WEIkta4cfYQunlI5CkQMKsKLixXKgw4gRpdL34SwyHQMx+nJgO9cgx5+O1nMC
	 USVeKp+u/gOpK4FhAPyvIQb+0X/+ea0Ykbb8O2f3ZeE3KGTFJD6YmkOlRrcWn2ImAa
	 RDkEfdMyySCsadxi5TgdtbPlMFUlhb9gEBLcqfLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.6 245/331] platform/x86: intel-uncore-freq: Fix types in sysfs callbacks
Date: Mon, 29 Jan 2024 09:05:09 -0800
Message-ID: <20240129170022.049367558@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c |   82 +++++-----
 drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.h |   32 +--
 2 files changed, 57 insertions(+), 57 deletions(-)

--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency-common.c
@@ -23,23 +23,23 @@ static int (*uncore_read)(struct uncore_
 static int (*uncore_write)(struct uncore_data *data, unsigned int input, unsigned int min_max);
 static int (*uncore_read_freq)(struct uncore_data *data, unsigned int *freq);
 
-static ssize_t show_domain_id(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t show_domain_id(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
-	struct uncore_data *data = container_of(attr, struct uncore_data, domain_id_dev_attr);
+	struct uncore_data *data = container_of(attr, struct uncore_data, domain_id_kobj_attr);
 
 	return sprintf(buf, "%u\n", data->domain_id);
 }
 
-static ssize_t show_fabric_cluster_id(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t show_fabric_cluster_id(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
-	struct uncore_data *data = container_of(attr, struct uncore_data, fabric_cluster_id_dev_attr);
+	struct uncore_data *data = container_of(attr, struct uncore_data, fabric_cluster_id_kobj_attr);
 
 	return sprintf(buf, "%u\n", data->cluster_id);
 }
 
-static ssize_t show_package_id(struct device *dev, struct device_attribute *attr, char *buf)
+static ssize_t show_package_id(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
 {
-	struct uncore_data *data = container_of(attr, struct uncore_data, package_id_dev_attr);
+	struct uncore_data *data = container_of(attr, struct uncore_data, package_id_kobj_attr);
 
 	return sprintf(buf, "%u\n", data->package_id);
 }
@@ -97,30 +97,30 @@ static ssize_t show_perf_status_freq_khz
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
@@ -134,11 +134,11 @@ show_uncore_min_max(max_freq_khz, 1);
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
@@ -149,29 +149,29 @@ show_uncore_data(initial_max_freq_khz);
 
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
@@ -186,21 +186,21 @@ static int create_attr_group(struct unco
 
 	if (data->domain_id != UNCORE_DOMAIN_ID_INVALID) {
 		init_attribute_root_ro(domain_id);
-		data->uncore_attrs[index++] = &data->domain_id_dev_attr.attr;
+		data->uncore_attrs[index++] = &data->domain_id_kobj_attr.attr;
 		init_attribute_root_ro(fabric_cluster_id);
-		data->uncore_attrs[index++] = &data->fabric_cluster_id_dev_attr.attr;
+		data->uncore_attrs[index++] = &data->fabric_cluster_id_kobj_attr.attr;
 		init_attribute_root_ro(package_id);
-		data->uncore_attrs[index++] = &data->package_id_dev_attr.attr;
+		data->uncore_attrs[index++] = &data->package_id_kobj_attr.attr;
 	}
 
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
@@ -26,14 +26,14 @@
  * @instance_id:	Unique instance id to append to directory name
  * @name:		Sysfs entry name for this instance
  * @uncore_attr_group:	Attribute group storage
- * @max_freq_khz_dev_attr: Storage for device attribute max_freq_khz
- * @mix_freq_khz_dev_attr: Storage for device attribute min_freq_khz
- * @initial_max_freq_khz_dev_attr: Storage for device attribute initial_max_freq_khz
- * @initial_min_freq_khz_dev_attr: Storage for device attribute initial_min_freq_khz
- * @current_freq_khz_dev_attr: Storage for device attribute current_freq_khz
- * @domain_id_dev_attr: Storage for device attribute domain_id
- * @fabric_cluster_id_dev_attr: Storage for device attribute fabric_cluster_id
- * @package_id_dev_attr: Storage for device attribute package_id
+ * @max_freq_khz_kobj_attr: Storage for kobject attribute max_freq_khz
+ * @mix_freq_khz_kobj_attr: Storage for kobject attribute min_freq_khz
+ * @initial_max_freq_khz_kobj_attr: Storage for kobject attribute initial_max_freq_khz
+ * @initial_min_freq_khz_kobj_attr: Storage for kobject attribute initial_min_freq_khz
+ * @current_freq_khz_kobj_attr: Storage for kobject attribute current_freq_khz
+ * @domain_id_kobj_attr: Storage for kobject attribute domain_id
+ * @fabric_cluster_id_kobj_attr: Storage for kobject attribute fabric_cluster_id
+ * @package_id_kobj_attr: Storage for kobject attribute package_id
  * @uncore_attrs:	Attribute storage for group creation
  *
  * This structure is used to encapsulate all data related to uncore sysfs
@@ -53,14 +53,14 @@ struct uncore_data {
 	char name[32];
 
 	struct attribute_group uncore_attr_group;
-	struct device_attribute max_freq_khz_dev_attr;
-	struct device_attribute min_freq_khz_dev_attr;
-	struct device_attribute initial_max_freq_khz_dev_attr;
-	struct device_attribute initial_min_freq_khz_dev_attr;
-	struct device_attribute current_freq_khz_dev_attr;
-	struct device_attribute domain_id_dev_attr;
-	struct device_attribute fabric_cluster_id_dev_attr;
-	struct device_attribute package_id_dev_attr;
+	struct kobj_attribute max_freq_khz_kobj_attr;
+	struct kobj_attribute min_freq_khz_kobj_attr;
+	struct kobj_attribute initial_max_freq_khz_kobj_attr;
+	struct kobj_attribute initial_min_freq_khz_kobj_attr;
+	struct kobj_attribute current_freq_khz_kobj_attr;
+	struct kobj_attribute domain_id_kobj_attr;
+	struct kobj_attribute fabric_cluster_id_kobj_attr;
+	struct kobj_attribute package_id_kobj_attr;
 	struct attribute *uncore_attrs[9];
 };
 


