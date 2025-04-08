Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE55B22257E;
	Tue,  8 Apr 2025 11:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112235; cv=none; b=LwSBxPvEu7YsjaOW0jkwPO1k1V4Bqe4IIiSYMyh5EJGNZZNJfE5Q0ecb3uh90w9n05Mfyz7PJX0x6ZpVGSmgzQhOr+ptLbb9IkM2Fr3uMivtkJx+Yx2estLZCkkKSyubHpWFpymwCKQcRWlhYRMijcvVhoLx+Q+LxO5XV5UzxWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112235; c=relaxed/simple;
	bh=3/f5IFbLsfAuru5awDjZW/Q43UfVSUJRstyFOOTvO1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fpfYlqa9hzSOHpVCJDgpyncRRzD+T6zato61hAt4izinQ3GnPoEfyNS5KoqjG9RoAClINjJiJhpUUeRIJsEpbjPHA+5pRxGMoTL0X88XZZseWiuO1GM6OrfZhdna+63MrBj//IGJ1r5CrVeFEMEJikxmBGAnQARe601iI1VuAuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQuWpDYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQuWpDYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E350C4CEE5;
	Tue,  8 Apr 2025 11:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112234;
	bh=3/f5IFbLsfAuru5awDjZW/Q43UfVSUJRstyFOOTvO1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQuWpDYhAsDYQUycj8gzNUmt/RZgM34YM+jnai1Hkx5K61kXnHAowWFRqBg9AwO1P
	 5ncRuGetR86D1NwphFiljgl83oDDXEpZQA6y33SxyMF+wLZ+jy58YOJ9gvF5obw8Yl
	 O/m/dNlEpM4kNaYn8RG+DrVdU6cvqU9H5905Iwiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Rowley <lkml@johnrowley.me>,
	Sami Tolvanen <samitolvanen@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.14 685/731] ACPI: platform-profile: Fix CFI violation when accessing sysfs files
Date: Tue,  8 Apr 2025 12:49:42 +0200
Message-ID: <20250408104930.200590453@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit dd4f730b557ce701a2cd4f604bf1e57667bd8b6e upstream.

When an attribute group is created with sysfs_create_group(), the
->sysfs_ops() callback is set to kobj_sysfs_ops, which sets the ->show()
and ->store() callbacks to kobj_attr_show() and kobj_attr_store()
respectively. These functions use container_of() to get the respective
callback from the passed attribute, meaning that these callbacks need to
be of the same type as the callbacks in 'struct kobj_attribute'.

However, ->show() and ->store() in the platform_profile driver are
defined for struct device_attribute with the help of DEVICE_ATTR_RO()
and DEVICE_ATTR_RW(), which results in a CFI violation when accessing
platform_profile or platform_profile_choices under /sys/firmware/acpi
because the types do not match:

  CFI failure at kobj_attr_show+0x19/0x30 (target: platform_profile_choices_show+0x0/0x140; expected type: 0x7a69590c)

There is no functional issue from the type mismatch because the layout
of 'struct kobj_attribute' and 'struct device_attribute' are the same,
so the container_of() cast does not break anything aside from CFI.

Change the type of platform_profile_choices_show() and
platform_profile_{show,store}() to match the callbacks in
'struct kobj_attribute' and update the attribute variables to
match, which resolves the CFI violation.

Cc: All applicable <stable@vger.kernel.org>
Fixes: a2ff95e018f1 ("ACPI: platform: Add platform profile support")
Reported-by: John Rowley <lkml@johnrowley.me>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2047
Tested-by: John Rowley <lkml@johnrowley.me>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Tested-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://patch.msgid.link/20250210-acpi-platform_profile-fix-cfi-violation-v3-1-ed9e9901c33a@kernel.org
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/platform_profile.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/acpi/platform_profile.c
+++ b/drivers/acpi/platform_profile.c
@@ -289,14 +289,14 @@ static int _remove_hidden_choices(struct
 
 /**
  * platform_profile_choices_show - Show the available profile choices for legacy sysfs interface
- * @dev: The device
+ * @kobj: The kobject
  * @attr: The attribute
  * @buf: The buffer to write to
  *
  * Return: The number of bytes written
  */
-static ssize_t platform_profile_choices_show(struct device *dev,
-					     struct device_attribute *attr,
+static ssize_t platform_profile_choices_show(struct kobject *kobj,
+					     struct kobj_attribute *attr,
 					     char *buf)
 {
 	struct aggregate_choices_data data = {
@@ -371,14 +371,14 @@ static int _store_and_notify(struct devi
 
 /**
  * platform_profile_show - Show the current profile for legacy sysfs interface
- * @dev: The device
+ * @kobj: The kobject
  * @attr: The attribute
  * @buf: The buffer to write to
  *
  * Return: The number of bytes written
  */
-static ssize_t platform_profile_show(struct device *dev,
-				     struct device_attribute *attr,
+static ssize_t platform_profile_show(struct kobject *kobj,
+				     struct kobj_attribute *attr,
 				     char *buf)
 {
 	enum platform_profile_option profile = PLATFORM_PROFILE_LAST;
@@ -400,15 +400,15 @@ static ssize_t platform_profile_show(str
 
 /**
  * platform_profile_store - Set the profile for legacy sysfs interface
- * @dev: The device
+ * @kobj: The kobject
  * @attr: The attribute
  * @buf: The buffer to read from
  * @count: The number of bytes to read
  *
  * Return: The number of bytes read
  */
-static ssize_t platform_profile_store(struct device *dev,
-				      struct device_attribute *attr,
+static ssize_t platform_profile_store(struct kobject *kobj,
+				      struct kobj_attribute *attr,
 				      const char *buf, size_t count)
 {
 	struct aggregate_choices_data data = {
@@ -442,12 +442,12 @@ static ssize_t platform_profile_store(st
 	return count;
 }
 
-static DEVICE_ATTR_RO(platform_profile_choices);
-static DEVICE_ATTR_RW(platform_profile);
+static struct kobj_attribute attr_platform_profile_choices = __ATTR_RO(platform_profile_choices);
+static struct kobj_attribute attr_platform_profile = __ATTR_RW(platform_profile);
 
 static struct attribute *platform_profile_attrs[] = {
-	&dev_attr_platform_profile_choices.attr,
-	&dev_attr_platform_profile.attr,
+	&attr_platform_profile_choices.attr,
+	&attr_platform_profile.attr,
 	NULL
 };
 


