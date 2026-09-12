Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A4C34752E;
	Sat, 12 Sep 2026 10:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210692; cv=none; b=hDl6kFLzy7p4KLq7ansEtocdbK4l1UuZJwX4nBLDP116fuxXqOShLuuQ38SssbCLFPxDVbWcc54Y1MmyqyxrzHruvD/gIg6THR5d7/KPrl7B4pyEhjAg5tDNuDb5AqpMzuF07Kc9KEgrOTwWgTOLAe6oGUXPnH6kOFNr5rHlLn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210692; c=relaxed/simple;
	bh=7RIjbty6nFeGwJ9hg9jFUvhzlvclrG2JZBRxrjPBCY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJwsD6zZA4cVPlh9iG8nXw+hpoDKzcWFHVA99GaMsikmQHHucm60VSYSlpWhjm4sQeIZL2kaLwitlOC0Y0JJq10aqYkOfiBblfUCMWnxv7LkwwKq51+YZ2K5UsdCM2CAq3+4/2mquPA5ZyhZwFoJ4jn0RQsX/4l4BLr8apDarI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJ+mH+pk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJ+mH+pk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8BBA1F000FF;
	Sat, 12 Sep 2026 10:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210690;
	bh=xCvXvQ0dOviHQeIRO4EKk71BRWhQzrp6zjMZ8S8qFRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QJ+mH+pkYEYSncnxGSgDpV2IrTK5VHxNAFT0ehBekr6oh/kojQSsegB2ULljEg75a
	 TA8qi91isfxVYdBzJQg9NSAow2G9AcDuaOsxB1UnZ47bNRiyjTb6D+UZd6gHpsJ9BT
	 XMdO8hKY947KTf9DT+LKp5xD9EFstI8OxMMY/P8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1078/1518] hwmon: Support guard() and scoped_guard for subsystem locks
Date: Sat, 12 Sep 2026 08:54:07 +0200
Message-ID: <20260912065647.834960998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit d1e720c7328e046049b792d03fae093d4d3a72e4 ]

Add support for guard() and scoped_guard() for the hwmon subsystem lock
to simplify its use.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 26db27364088 ("hwmon: (cros_ec) Synchronize EC access from the thermal device callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/hwmon-kernel-api.rst | 7 ++++---
 include/linux/hwmon.h                    | 3 +++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/hwmon/hwmon-kernel-api.rst b/Documentation/hwmon/hwmon-kernel-api.rst
index 1d7f1397a8274..9fcde32a140df 100644
--- a/Documentation/hwmon/hwmon-kernel-api.rst
+++ b/Documentation/hwmon/hwmon-kernel-api.rst
@@ -85,9 +85,10 @@ removal.
 When using ``[devm_]hwmon_device_register_with_info()`` to register the
 hardware monitoring device, accesses using the associated access functions
 are serialised by the hardware monitoring core. If a driver needs locking
-for other functions such as interrupt handlers or for attributes which are
-fully implemented in the driver, hwmon_lock() and hwmon_unlock() can be used
-to ensure that calls to those functions are serialized.
+for other functions such as interrupt handlers, attributes which are fully
+implemented in the driver, or debugfs functions, hwmon_lock() and hwmon_unlock()
+can be used to ensure that calls to those functions are serialized. Those
+functions also support guard() and scoped_guard() variants.
 
 Using devm_hwmon_device_register_with_info()
 --------------------------------------------
diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
index 301a83afbd663..f5330e7ae247c 100644
--- a/include/linux/hwmon.h
+++ b/include/linux/hwmon.h
@@ -13,6 +13,7 @@
 #define _HWMON_H_
 
 #include <linux/bitops.h>
+#include <linux/cleanup.h>
 
 struct device;
 struct attribute_group;
@@ -495,6 +496,8 @@ char *devm_hwmon_sanitize_name(struct device *dev, const char *name);
 void hwmon_lock(struct device *dev);
 void hwmon_unlock(struct device *dev);
 
+DEFINE_GUARD(hwmon_lock, struct device *, hwmon_lock(_T), hwmon_unlock(_T))
+
 /**
  * hwmon_is_bad_char - Is the char invalid in a hwmon name
  * @ch: the char to be considered
-- 
2.53.0



