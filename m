Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F423081DE;
	Mon, 13 Oct 2025 14:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760366961; cv=none; b=dvfFtHRSnZb/L0r9mfPNToJX15cO43JVD2BEn/kmG6yffbIQZDKvsfHp9uiEf7jL/l4ABvkzunLcPIKZL7GPSHGF9By/dAK4JbeXJ2yOpvXir0dpbY406R86uz3yaEXNuwxPRBb9gQ9WCiM00R0EYjUn+yo68E5ZwQCR2RvlysE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760366961; c=relaxed/simple;
	bh=yMsH2Hf6adJLu0wtBWpyRoOSa1zYJ+tGldR6Bl8UXqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIxt7SUsHlhuVEEQKFv+pYRNLYb5syzcmiYYL27Wc9hXZJP9okuRwJXQyCwAuBXfAkhNDtuH+Fzqnvn8dSxOuxeOfwqoRCxer2P0Na+WDlbyULWvmGxZ4GN+FefyCfnDm1h2XxoOnlefP/6ody6zrk23/33alaSMNQJG5Y7GOHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6Q58DXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6Q58DXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4710CC4CEE7;
	Mon, 13 Oct 2025 14:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760366960;
	bh=yMsH2Hf6adJLu0wtBWpyRoOSa1zYJ+tGldR6Bl8UXqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6Q58DXLHiom3MYcAFe5wL8rfZ4bGIzd4BQ7SJqxbwdIFk/vFMAhccqZOadZrW4mh
	 QbdPeiyUSkfiNoqoLiHMNLlqf8GZ0TBIcJ0uRKyWV2bsXfq8swMjhLckrO2eNdYJp3
	 JUhk7/GmiNoQKhuIrpgMJf196B4ocuYOYK6uYXp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	stable <stable@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.1 043/196] driver core/PM: Set power.no_callbacks along with power.no_pm
Date: Mon, 13 Oct 2025 16:43:36 +0200
Message-ID: <20251013144316.143260581@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -813,6 +813,9 @@ static inline bool device_pm_not_require
 static inline void device_set_pm_not_required(struct device *dev)
 {
 	dev->power.no_pm = true;
+#ifdef CONFIG_PM
+	dev->power.no_callbacks = true;
+#endif
 }
 
 static inline void dev_pm_syscore_device(struct device *dev, bool val)


