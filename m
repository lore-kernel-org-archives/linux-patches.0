Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A99374CC;
	Wed,  7 Aug 2024 15:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043567; cv=none; b=Y83RODi17FKzrcTqJ8EOA+x/WleKsKNxqSABS6P+rFOvbDHD+NWHKGDAqtArQohBbITgAHkje+59TcjTq8zpcsP2KGeWfBTxDw+CDWdCTnAQEYl0Hd8P1QIEetwPoPCBFsdBokRUp45TKFl6gKPI3LWD7+MgX4A7ohTA5ikczSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043567; c=relaxed/simple;
	bh=ATSeaxzCHMqFkkgmSODWd7N0QQNqWVN30ISgRJ1JtyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpkyuQDKIw0jeWzdHMCVg+9EsHqi43ayu0blWlHrsnZTKqwwxiNCsAt4ns2I9l8qapckXQebH8OAVTCBu2S0h3V/pfblFGYkmR0W9k9fYzoaVxoBQ6Nsxa4V4GW4I/lx1lAUFAh+w6LjagSsP+e804XYtVMxpyl6emoq2QqFK5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CyEl2WDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CyEl2WDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8D5C32781;
	Wed,  7 Aug 2024 15:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043567;
	bh=ATSeaxzCHMqFkkgmSODWd7N0QQNqWVN30ISgRJ1JtyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyEl2WDN7dslTfJsVWY2xLGsJrKyHR6rGFc1rHqDYnobpeI5aIBSh5R0TzH392hwG
	 KuPnqPK7wi+zb4US9cth9PrzZE8SJerrOLmA+Nszl+05n0Jr0bFwhkLE83U+zzVqmc
	 Tzx8iTdRGlCjkXKHlv3xHBqpRsW9n/vvLobTgMuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 18/86] leds: trigger: Call synchronize_rcu() before calling trig->activate()
Date: Wed,  7 Aug 2024 16:59:57 +0200
Message-ID: <20240807150039.844218607@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit b1bbd20f35e19774ea01989320495e09ac44fba3 ]

Some triggers call led_trigger_event() from their activate() callback
to initialize the brightness of the LED for which the trigger is being
activated.

In order for the LED's initial state to be set correctly this requires that
the led_trigger_event() call uses the new version of trigger->led_cdevs,
which has the new LED.

AFAICT led_trigger_event() will always use the new version when it is
running on the same CPU as where the list_add_tail_rcu() call was made,
which is why the missing synchronize_rcu() has not lead to bug reports.
But if activate() is pre-empted, sleeps or uses a worker then
the led_trigger_event() call may run on another CPU which may still use
the old trigger->led_cdevs list.

Add a synchronize_rcu() call to ensure that any led_trigger_event() calls
done from activate() always use the new list.

Triggers using led_trigger_event() from their activate() callback are:
net/bluetooth/leds.c, net/rfkill/core.c and drivers/tty/vt/keyboard.c.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240531120124.75662-1-hdegoede@redhat.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: ab477b766edd ("leds: triggers: Flush pending brightness before activating trigger")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-triggers.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index cdb446cb84af2..fe7fb2e7149c5 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -193,6 +193,13 @@ int led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trig)
 		spin_unlock(&trig->leddev_list_lock);
 		led_cdev->trigger = trig;
 
+		/*
+		 * Some activate() calls use led_trigger_event() to initialize
+		 * the brightness of the LED for which the trigger is being set.
+		 * Ensure the led_cdev is visible on trig->led_cdevs for this.
+		 */
+		synchronize_rcu();
+
 		ret = 0;
 		if (trig->activate)
 			ret = trig->activate(led_cdev);
-- 
2.43.0



