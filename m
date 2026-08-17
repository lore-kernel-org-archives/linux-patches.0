Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9676E3CBE84;
	Mon, 17 Aug 2026 13:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974346; cv=none; b=qQINqwtRWSRsnEXmryWVwZI+3Yaibd2/NddMB9O2UxwHEDUJ+hM7PoxrVL3YtGcKjFCYkGjwpeCipl0+UNXjCqVkY5VoMOCym5KmtEpnh5/sAAOwYxN8i0KJi6LY12Wvm+mwVRR4KJA45Qo4FuDHCLLyz8MRQBdXEYemj0VhufY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974346; c=relaxed/simple;
	bh=DPr5oIo7kTCJ+zEMVWPMuBMXUeLz+SWfZWdS7RTBv80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VezD3Fw9/Bxx7f7e97frM+MLrfJ3jrTp2wWzzySvUXwJWvhMgZpJU4RCF0wg/GET2XAxxPI2cqxyBo1o/orzLQM732CeYiL/BIwxqT7v1kGkkEu0ymjWddvKXHoNlI8LKJsBM0j2GzHLrMNcSgLoS1OFiAX3oUTrxrVsrqQOypQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQG6CBJd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQG6CBJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87E71F00A3A;
	Mon, 17 Aug 2026 13:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974338;
	bh=jyd16mePd0tDd2eJDdK33HRmVXERZcmu8DRCHkDT3bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQG6CBJdov6V54mSMEG2trDFoVZU35rNxrvfhkZlxv0jydty3a1FJAyfWrD4mAELk
	 XeTykRFEw7ZW+4N+a5+h0XBdTDMTRXkh2x/anRGdM6y0cauOI3Cua2mXapoHno8ztv
	 mahYAKkBPTj2r2YabE8QaEjtTN+basdbK9whRMmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 121/271] hwmon: Support guard() and scoped_guard for subsystem locks
Date: Mon, 17 Aug 2026 15:30:46 +0200
Message-ID: <20260817132541.847388954@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit d1e720c7328e046049b792d03fae093d4d3a72e4 ]

Add support for guard() and scoped_guard() for the hwmon subsystem lock
to simplify its use.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 2da6050809d4 ("hwmon: (corsair-psu) serialize debugfs access against hwmon")
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



