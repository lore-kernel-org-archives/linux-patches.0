Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635E72F5472;
	Fri, 10 Oct 2025 13:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102488; cv=none; b=YD2HcNiEUFaBvftU8BuAKjch+XI+CxiHuFx8Gi3wj0gfEIM+dwHsSFMDAvMwODHP84BC07GZNnL9vdndOg0L3LKeiclLjPCxLFVJyOKMPEzajd6p95VIbmHKOGfp1ux40PxeP8ke6keIUYt/IbtA9pTaMrhL88cYrFJZEO+Jjt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102488; c=relaxed/simple;
	bh=vMzIkO5190eqEjqcHpAwu/Ti4xLtSpU0igvlf/nOoJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3qNZrH/zMes6qpxvqAtIh8Rb3HgKEFoSoUS7372PD5jsAQQY3Kd8n5KFnlMppRnslww/EQ9Al+ia/NvRAK5cSbKEVTgrsb5NF1P9bwLzlEMLvikB45z3ftRYpooSuA59f7PSwQBjwBBc5P5QEdNJSClaDs1HiulJYSr4jytBJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/FJ4KHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/FJ4KHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87101C4CEF1;
	Fri, 10 Oct 2025 13:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102487;
	bh=vMzIkO5190eqEjqcHpAwu/Ti4xLtSpU0igvlf/nOoJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/FJ4KHHiA0eWea4ocDrGxWBvjHdGWaMruUxPMpU3eJssEV2gNMoTHhbr/NOCZsru
	 2cK59nChm9NwubNEUVXycobJ8JB9RfY9/J6eM03ZdmrAy6alUOV1Q+3F0dCZWrR3/q
	 GMmM09xCuK4d4XgPOIZLsj88iPwxfadKHANBL40Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	stable <stable@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.12 32/35] driver core/PM: Set power.no_callbacks along with power.no_pm
Date: Fri, 10 Oct 2025 15:16:34 +0200
Message-ID: <20251010131332.947920239@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -873,6 +873,9 @@ static inline bool device_pm_not_require
 static inline void device_set_pm_not_required(struct device *dev)
 {
 	dev->power.no_pm = true;
+#ifdef CONFIG_PM
+	dev->power.no_callbacks = true;
+#endif
 }
 
 static inline void dev_pm_syscore_device(struct device *dev, bool val)


