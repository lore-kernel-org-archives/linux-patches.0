Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3D31F5435;
	Wed, 23 Apr 2025 15:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421639; cv=none; b=sQI4HQorf+KIAtfw405ZEJnddES/+rIaRR88W/ej6PfBrNH1+SFh4+TXa0xHzELqIzDnfAwkb7Awm4g4XTi3PVEdXvPavYzhgVzr+74RucraVfL7m4RRk9bVLtlc3L4s7V01CzwBwHsZU2uzOd1ZetQYqyjuKL0AwLXVxGpLtos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421639; c=relaxed/simple;
	bh=eeQB8ShbPOPHdnjmcCTXp/UsP+014LC+bMDv+ZwsrxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R33V21EZS8KUyb3mvkeM13uj4Kzbuyd8eZ4CECduGqz1Ox8SLdoR5nqJlav4r9TVtlGQs0e4HwRREHo2Wmc4O0e/54u0dV/P7dQIGs20r6ZbWefBtdw5lpXUcTjkGdD0RBGbdADFKuc7XExlmDRyo2c/2DQt3JA2VtPtKHUqzXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzUB6xZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzUB6xZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DE2C4CEE2;
	Wed, 23 Apr 2025 15:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421639;
	bh=eeQB8ShbPOPHdnjmcCTXp/UsP+014LC+bMDv+ZwsrxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzUB6xZDiQ0dHfyA5T6s0RF90McKf7KYClk9Sje0v9FlgqznvaxFVXItk6kSEdAGM
	 M/IpVE792Y68rT2zgPpRqPlvQVrgD6ev1nT5/XA3ae6w58N2EyAhJGKDqfglDDdj82
	 os9jMgiNgkZPubl24Kjf/fq77qMgWId/TBMirpb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Rowley <lkml@johnrowley.me>,
	Sami Tolvanen <samitolvanen@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 161/291] ACPI: platform-profile: Fix CFI violation when accessing sysfs files
Date: Wed, 23 Apr 2025 16:42:30 +0200
Message-ID: <20250423142630.975295948@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[nathan: Fix conflicts in older stable branches]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/platform_profile.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/acpi/platform_profile.c
+++ b/drivers/acpi/platform_profile.c
@@ -22,8 +22,8 @@ static const char * const profile_names[
 };
 static_assert(ARRAY_SIZE(profile_names) == PLATFORM_PROFILE_LAST);
 
-static ssize_t platform_profile_choices_show(struct device *dev,
-					struct device_attribute *attr,
+static ssize_t platform_profile_choices_show(struct kobject *kobj,
+					struct kobj_attribute *attr,
 					char *buf)
 {
 	int len = 0;
@@ -49,8 +49,8 @@ static ssize_t platform_profile_choices_
 	return len;
 }
 
-static ssize_t platform_profile_show(struct device *dev,
-					struct device_attribute *attr,
+static ssize_t platform_profile_show(struct kobject *kobj,
+					struct kobj_attribute *attr,
 					char *buf)
 {
 	enum platform_profile_option profile = PLATFORM_PROFILE_BALANCED;
@@ -77,8 +77,8 @@ static ssize_t platform_profile_show(str
 	return sysfs_emit(buf, "%s\n", profile_names[profile]);
 }
 
-static ssize_t platform_profile_store(struct device *dev,
-			    struct device_attribute *attr,
+static ssize_t platform_profile_store(struct kobject *kobj,
+			    struct kobj_attribute *attr,
 			    const char *buf, size_t count)
 {
 	int err, i;
@@ -115,12 +115,12 @@ static ssize_t platform_profile_store(st
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
 


