Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79123330B11;
	Fri, 17 Oct 2025 15:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715939; cv=none; b=RtgBhUKtSMlofT8senq0oW3sHAksqT/l+Zoa1tiBMqZGUTbT3EnwRhcRygaMcXyko7i0Vwpa2r+9Iug2v4LN6/frhZO1i+F7J65oOb9hwKXeYUDjZ0SaYKho9u6i2V32Y0M+boMzy/Tdd/1A3ejM66H9KqqzmdKwvvblM5TefLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715939; c=relaxed/simple;
	bh=gEkPhJ+zGQStONqNHTA2bbb7p2pFPOvispZnkyj2cHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOuPnKEqw3BpjxMDucBGcpTzImmu7HaOqr1zV7H1ZoGeOkBivwWkoEK4W46Y5MZkUDJ7M8w1mPq8K/VCs+RuRnZpR/Ifrgv9QUaFpxlXYWvlomqWF8fGY1T+C33KsS7PfUGhbtl0OXy/aaxl/5ciGNQzPEXrfbqr6JHJsgpNmdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRo/5qMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRo/5qMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EF7C4CEE7;
	Fri, 17 Oct 2025 15:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715939;
	bh=gEkPhJ+zGQStONqNHTA2bbb7p2pFPOvispZnkyj2cHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRo/5qMB6Akl2er9d1Y0M4kbKqUxms2m6VLbBngnryik8pHnBNIoJ8qcGf/1ZFcKK
	 xnURpcn0Ee5qYw47nLEAf/MQdmoE0WgwN/ctVUGEZ8Y2x+V1/PGIaldqkebwobekE1
	 kdLyiEa3SkuzZq7UgXmU5TXeezwcJE9CGM3cFRYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	stable <stable@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.15 018/276] driver core/PM: Set power.no_callbacks along with power.no_pm
Date: Fri, 17 Oct 2025 16:51:51 +0200
Message-ID: <20251017145143.067011846@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -736,6 +736,9 @@ static inline bool device_pm_not_require
 static inline void device_set_pm_not_required(struct device *dev)
 {
 	dev->power.no_pm = true;
+#ifdef CONFIG_PM
+	dev->power.no_callbacks = true;
+#endif
 }
 
 static inline void dev_pm_syscore_device(struct device *dev, bool val)


