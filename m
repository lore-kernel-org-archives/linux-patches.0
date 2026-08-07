Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9627E31327A;
	Fri,  7 Aug 2026 15:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116204; cv=none; b=AC75h2fnisjqBHGQkQkEmp/xpLwoepovjqn3/mAnOW1a3aXb+qq5Iw3UDVdtaYiCzV8oeQ4yL1KRLvfg7hpW9Twbp6J7mRng1jOk+4USlCS/808v6H+dtxWS7dEL9OMxBj6/9sWA20J8AUzyBi5kanPyaoup9W4J+neun25yFmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116204; c=relaxed/simple;
	bh=7kwFeG+mfQFKQWxdJFhYevUuPivc8YIQpeyDPAX4o3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7jlOdZZqbFeP2zf9/fwsfNcPk2xp2lG1UygeVCD/lRmbTdWWYjnoREnwsXr/BCk1b6h5ID6CvnADS4HyD5A42sL4HiO7jQciVKtw9SA+lTLBWaqsSmCbXYu0SvpMu/D3WxwhSgawL+y+/XSPQ3I2aq5pek28cLlm27cIW/ImlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFxB8VMJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFxB8VMJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F334A1F00A3A;
	Fri,  7 Aug 2026 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116203;
	bh=CNJ/Vq/UTwBwtWl8zrh2tRDFDaxhT8Gwh2wUoM6haBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFxB8VMJrqU3kTTjCK3uWYOpsBOHH6XrBYlvB142X8W6gaHaEPlIQRYRY2nuLHwF5
	 19ebBH9lNrK+cao1djgmmlj5+2vBLsICl/O9NGbQAfzTKZDvNeK7h54gs9FPvweDf4
	 EqW6VMEiau72vJT/kO2Hp7vN6mpVyphfqpkT/W9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Jardin <vjardin@free.fr>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 148/261] hwmon: (pmbus/core) notify on the hwmon device, not the i2c client
Date: Fri,  7 Aug 2026 16:38:25 +0200
Message-ID: <20260807143418.557044050@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Jardin <vjardin@free.fr>

commit a64a7e8a0b012ba81b0eadbd7afc84ab0dbfd70c upstream.

pmbus_notify() calls sysfs_notify() and kobject_uevent() on the i2c
client's kobject, but the alarm attributes live on the hwmon class
device registered by pmbus_do_probe(). Notifying the parent i2c device
is a no-op for both poll(POLLPRI) waiters and udev listeners: the named
attribute does not exist on that kobject.

Notify the hwmon device instead, so poll() wakes up and "change"
uevents fire on the inX_alarm/tempX_alarm attributes when SMBALERT#
reports a fault.

Fixes: f469bde9afd1 ("hwmon: (pmbus/core) Notify hwmon events")
Cc: stable@vger.kernel.org # v6.4+
Signed-off-by: Vincent Jardin <vjardin@free.fr>
Link: https://lore.kernel.org/r/20260723-fix_hwmon_notify_v1-v1-1-5a24c528686d@free.fr
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/pmbus_core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -2803,8 +2803,9 @@ static void pmbus_notify(struct pmbus_da
 
 		if (reg == sreg && page == spage && (smask & flags)) {
 			dev_dbg(data->dev, "sysfs notify: %s", da->attr.name);
-			sysfs_notify(&data->dev->kobj, NULL, da->attr.name);
-			kobject_uevent(&data->dev->kobj, KOBJ_CHANGE);
+			sysfs_notify(&data->hwmon_dev->kobj, NULL,
+				     da->attr.name);
+			kobject_uevent(&data->hwmon_dev->kobj, KOBJ_CHANGE);
 			flags &= ~smask;
 		}
 


