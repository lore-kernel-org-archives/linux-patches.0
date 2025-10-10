Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D178E2EF664;
	Fri, 10 Oct 2025 13:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102416; cv=none; b=jTtcT/lqg1rHgpXAZooOD1zJuW947l0C0+aUUTTeKJH2hvSKJzErDSZufezP+oP06SO/6g0UP/945K6DyvhftlZVZ92KUUd9TfSwfUdYYXpNbJSApZAmk+RiDOes41grR3k0LRYPMpkM/h5NRpoa7K3+3eXNuU4IcPnHmedyico=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102416; c=relaxed/simple;
	bh=4mSDTwAB2J/wIykZ0mUaOXG6Pjakmgw70q4adPCMbUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WECVtT2sRQ2thJbMoBWg8vt3eXAd9Zz/JMZLnLJKFsUx2f8GrVQLQG26jZXEjUzgpTjW95nEdyly3BWQK/VirGpcU9K/pgsjGucCwK4r6FV7va8jL1dD2NtgSBC7lfut4moBV2dvuc0huYQTyqsbJ9nkozvVnMi4jjp3UW2gJXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ycd1Mv7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ycd1Mv7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9E1C4CEF1;
	Fri, 10 Oct 2025 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102416;
	bh=4mSDTwAB2J/wIykZ0mUaOXG6Pjakmgw70q4adPCMbUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ycd1Mv7o3T2Z4HnyxSZOoD8e/plFvVvO4nOlpI2JSjk4S4Y0tJFvV9WGnFW8rKNXO
	 QC98OTHpznDR349rIoAIljPzhDGFjpbHv1gh76h7IvF1RaqkAgAtTvLSHbf8cq1Ota
	 duDOMw3kFrVEaOBRLg/gNz3efIu1RlnPXvwNfEUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	stable <stable@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.16 37/41] driver core/PM: Set power.no_callbacks along with power.no_pm
Date: Fri, 10 Oct 2025 15:16:25 +0200
Message-ID: <20251010131334.750995295@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


