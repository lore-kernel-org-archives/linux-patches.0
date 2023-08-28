Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726FA11C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4093C433C8;
	Mon, 28 Aug 2023 10:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219071;
	bh=7NqRESLnxkuGaFvPjeDCR2RjF6kNPmaomvDYpkDOooc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7bvujZ5kJ56o48cJnLLGv2fHiCte8WdWjmxEx/zyGKiMZoo0i9UAKiiiRz+kGkXs
	 9FhoFZv9eFFMJ4RCE5/D318Th8KEc+VMfgELRMvj6/aXdZ2VRiDL7Vy5IQ0QjATb3e
	 rDUDcJeFfRiCHrBXNTf1Inh9H6aPptI/4WIpvgZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/158] PM-runtime: add tracepoints for usage_count changes
Date: Mon, 28 Aug 2023 12:12:12 +0200
Message-ID: <20230828101158.531401699@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

[ Upstream commit d229290689ae0f6eae068ef142de4fd61ab4ba50 ]

Add tracepoints to remaining places where device's power.usage_count
is changed.

This helps debugging where and why autosuspend is prevented.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 81302b1c7c99 ("ALSA: hda: Fix unhandled register update during auto-suspend period")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/runtime.c | 13 +++++++++++--
 include/trace/events/rpm.h   |  6 ++++++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index d5c2d86fbecd4..6e110c80079d7 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1048,8 +1048,10 @@ int __pm_runtime_idle(struct device *dev, int rpmflags)
 	int retval;
 
 	if (rpmflags & RPM_GET_PUT) {
-		if (!atomic_dec_and_test(&dev->power.usage_count))
+		if (!atomic_dec_and_test(&dev->power.usage_count)) {
+			trace_rpm_usage_rcuidle(dev, rpmflags);
 			return 0;
+		}
 	}
 
 	might_sleep_if(!(rpmflags & RPM_ASYNC) && !dev->power.irq_safe);
@@ -1080,8 +1082,10 @@ int __pm_runtime_suspend(struct device *dev, int rpmflags)
 	int retval;
 
 	if (rpmflags & RPM_GET_PUT) {
-		if (!atomic_dec_and_test(&dev->power.usage_count))
+		if (!atomic_dec_and_test(&dev->power.usage_count)) {
+			trace_rpm_usage_rcuidle(dev, rpmflags);
 			return 0;
+		}
 	}
 
 	might_sleep_if(!(rpmflags & RPM_ASYNC) && !dev->power.irq_safe);
@@ -1143,6 +1147,7 @@ int pm_runtime_get_if_in_use(struct device *dev)
 	retval = dev->power.disable_depth > 0 ? -EINVAL :
 		dev->power.runtime_status == RPM_ACTIVE
 			&& atomic_inc_not_zero(&dev->power.usage_count);
+	trace_rpm_usage_rcuidle(dev, 0);
 	spin_unlock_irqrestore(&dev->power.lock, flags);
 	return retval;
 }
@@ -1476,6 +1481,8 @@ void pm_runtime_allow(struct device *dev)
 	dev->power.runtime_auto = true;
 	if (atomic_dec_and_test(&dev->power.usage_count))
 		rpm_idle(dev, RPM_AUTO | RPM_ASYNC);
+	else
+		trace_rpm_usage_rcuidle(dev, RPM_AUTO | RPM_ASYNC);
 
  out:
 	spin_unlock_irq(&dev->power.lock);
@@ -1543,6 +1550,8 @@ static void update_autosuspend(struct device *dev, int old_delay, int old_use)
 		if (!old_use || old_delay >= 0) {
 			atomic_inc(&dev->power.usage_count);
 			rpm_resume(dev, 0);
+		} else {
+			trace_rpm_usage_rcuidle(dev, 0);
 		}
 	}
 
diff --git a/include/trace/events/rpm.h b/include/trace/events/rpm.h
index 26927a560eabc..3c716214dab1a 100644
--- a/include/trace/events/rpm.h
+++ b/include/trace/events/rpm.h
@@ -74,6 +74,12 @@ DEFINE_EVENT(rpm_internal, rpm_idle,
 
 	TP_ARGS(dev, flags)
 );
+DEFINE_EVENT(rpm_internal, rpm_usage,
+
+	TP_PROTO(struct device *dev, int flags),
+
+	TP_ARGS(dev, flags)
+);
 
 TRACE_EVENT(rpm_return_int,
 	TP_PROTO(struct device *dev, unsigned long ip, int ret),
-- 
2.40.1



