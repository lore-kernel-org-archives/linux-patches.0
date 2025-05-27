Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CAB3C01;
	Tue, 27 May 2025 17:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367265; cv=none; b=S8MkQs/6KDhrhJ5eLfo1c2x7PYSrgBK82c4dsnsMOBQSinWfAMhis5wY1441vIoa+BGQglYAHWt4Xh2S+6lJk2UDW3KwJRpvQsV4k39rnqgVxWyv82NggZuSTGAyvtkjrVpv/m7X9pMVX+5bPn2o9VulxuYgLmENLQmJoRWcg0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367265; c=relaxed/simple;
	bh=40dR7tJz35nZ1r5th11eMljlZJNfNNHZgdzKqofJTg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Shgu49fdhk3FmcyfaX6QrF+rtm7pLfc2Z2VgFEaycTEIIp0u3/TWNAaG5I22l/tYlsnHU1j8kBu2ciUFoS1VxwYNMICF75gIwlqd4Q8UOR8+HKOUJPgS1j8/jZY+cHDHB/Vq+hinHhi+kTuW0Fp+JC1uSiZj7DeXG3tiyIA9zko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0PF0Q1Ze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0PF0Q1Ze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6747C4CEE9;
	Tue, 27 May 2025 17:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367265;
	bh=40dR7tJz35nZ1r5th11eMljlZJNfNNHZgdzKqofJTg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0PF0Q1Zee6ysKt7KKJBM8PQu1ZfdMeQOhtMfjqZ47nq6pA2UdxaXqzSXGjFv3z1f8
	 21/pV/vb7lFZKQ1VEsf4gtPcXw420K0tGZM8pAiC1RFyLQLuNDA8Rs4zbkuNEKgcRh
	 mOg3cUG2w1PdIr2XyBbOiny01nRKplgxQfDGhPqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 314/783] PM: sleep: Suppress sleeping parent warning in special case
Date: Tue, 27 May 2025 18:21:51 +0200
Message-ID: <20250527162525.856920959@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit e8195f0630f1c4c2465074fe81b5fda19efd3148 ]

Currently, if power.no_callbacks is set, device_prepare() will also set
power.direct_complete for the device.  If power.direct_complete is set
in device_resume(), the clearing of power.is_prepared will be skipped
and if new children appear under the device at that point, a warning
will be printed.

After commit (f76b168b6f11 PM: Rename dev_pm_info.in_suspend to
is_prepared), power.is_prepared is generally cleared in device_resume()
before invoking the resume callback for the device which allows that
callback to add new children without triggering the warning, but this
does not happen for devices with power.direct_complete set.

This problem is visible in USB where usb_set_interface() can be called
before device_complete() clears power.is_prepared for interface devices
and since ep devices are added then, the warning is printed:

 usb 1-1: reset high-speed USB device number 3 using ci_hdrc
  ep_81: PM: parent 1-1:1.1 should not be sleeping
 PM: resume devices took 0.936 seconds

Since it is legitimate to add the ep devices at that point, the
warning above is not particularly useful, so get rid of it by
clearing power.is_prepared in device_resume() for devices with
power.direct_complete set if they have no PM callbacks, in which
case they need not actually resume for the new children to work.

Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://patch.msgid.link/20250224070049.3338646-1-xu.yang_2@nxp.com
[ rjw: New subject, changelog edits, rephrased new code comment ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 23be2d1b04079..37fe251b4c591 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -933,6 +933,13 @@ static void device_resume(struct device *dev, pm_message_t state, bool async)
 		goto Complete;
 
 	if (dev->power.direct_complete) {
+		/*
+		 * Allow new children to be added under the device after this
+		 * point if it has no PM callbacks.
+		 */
+		if (dev->power.no_pm_callbacks)
+			dev->power.is_prepared = false;
+
 		/* Match the pm_runtime_disable() in device_suspend(). */
 		pm_runtime_enable(dev);
 		goto Complete;
-- 
2.39.5



