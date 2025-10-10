Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2852F8BFA;
	Fri, 10 Oct 2025 13:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102285; cv=none; b=H0dZ/OluLVoNCW/4XrO93U/RxArlxC0ebKkXLA3MdEe5emo7vkYMjETS38Pub5k9SNZamA2TxspqDQbgwE5GSY0NaIGcmrJBWbeunX4INLFyYz1lv0R9jdoObKt/YPAB+wDejapqCOEXytdb8Gez5D5sujapsVojz7l8ZYNAJ9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102285; c=relaxed/simple;
	bh=ztRPJo/WTAPb+6zLcob4w7qV8sg+daiygRlFEIL6iLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEGpQUbt2hCf5MWTcElS3Lj9dDoAM6lZGCkmXi+HePhcyActevS+Ef8zPuek9ghZaIRFnxjI+ldOWUGBwq3j7Q79qFxZ2cD5DGVIVLOChwZ8xzdVVq+U/kK6iVNQmTp3UZbfG0I84g0U9fVfevI2odqdgTMUY86UUdj3eFNpNZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ziASLCV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziASLCV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E07C4CEF1;
	Fri, 10 Oct 2025 13:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102284;
	bh=ztRPJo/WTAPb+6zLcob4w7qV8sg+daiygRlFEIL6iLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ziASLCV2dzYj1Br5wxlDZY4t4/fXcDMjmbegTeyq48XE4s4+XeASZIpkB05vkKqu+
	 wUCk9MybsDxUGygYg9+XIvOt13QP/y78skihQO7lwoSS3v49gVU0FQHAp+hrDc0/5R
	 vCLT7pmAF0SWZNV+W0iY+GP5vZrTDN4+eimh5TLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	stable <stable@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.17 19/26] driver core/PM: Set power.no_callbacks along with power.no_pm
Date: Fri, 10 Oct 2025 15:16:14 +0200
Message-ID: <20251010131331.906612184@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
References: <20251010131331.204964167@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit c2ce2453413d429e302659abc5ace634e873f6f5 upstream.

Devices with power.no_pm set are not expected to need any power
management at all, so modify device_set_pm_not_required() to set
power.no_callbacks for them too in case runtime PM will be enabled
for any of them (which in principle may be done for convenience if
such a device participates in a dependency chain).

Since device_set_pm_not_required() must be called before device_add()
or it would not have any effect, it can update power.no_callbacks
without locking, unlike pm_runtime_no_callbacks() that can be called
after registering the target device.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: stable <stable@kernel.org>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Link: https://lore.kernel.org/r/1950054.tdWV9SEqCh@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/device.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -851,6 +851,9 @@ static inline bool device_pm_not_require
 static inline void device_set_pm_not_required(struct device *dev)
 {
 	dev->power.no_pm = true;
+#ifdef CONFIG_PM
+	dev->power.no_callbacks = true;
+#endif
 }
 
 static inline void dev_pm_syscore_device(struct device *dev, bool val)


