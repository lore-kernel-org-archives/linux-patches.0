Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396D131AAA8;
	Fri,  7 Aug 2026 14:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114267; cv=none; b=HCCojME00sfMnr1zI8W0l2frhDgS/b+QShbAFRqyAjMXX4lshM1zA3LJ5RwJaWP4ebd94vRptxkW4mEl+vdsiF+dc7hmWsmI1GRc/69TDuKFheogtw8ae7zN1zrQvoL6L9rHV7+RzArSCmlsRrUQTJ5T0fnVSyWvSs1KhJFpNis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114267; c=relaxed/simple;
	bh=91Lq7ql0DihmNwp03PFqDe3X7KgZwIldG5Hrm5DEueE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHeOZl36TYFOgps7T2U0wkDBdJ8zVVwsZvRpaQoD+151wjZnsupoEu1F58tIEuyI4/D2FqLus98PprLU88zjq/AY22PPxO6U1izbLu1UWMlBdBWBKnlytvdtk83NQSRCwZDGT78HLi0xSbkl1sCYK6wf9FbIzHQPKtLALfOUZYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GoBX7teD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GoBX7teD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB5F1F00A3A;
	Fri,  7 Aug 2026 14:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114263;
	bh=OVUHIF66PqHdVsCyOQb9fbGTBhnz54sihct7yYyoqSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GoBX7teDnc3LBJMH3DY+tXugkJSRJnGD0yPwtbyWBlGUjYrTxO3yC9/Fuj0QxjtWu
	 sGdihsp255niIFaGvDYLNHZlgBA8n9VqOKCtdvtjFMZR65cd8+8VDSikrYY/96fvat
	 tkzVRV7cEODy6CorfgDwK5dvxdWmqztsSbhjzWNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Jardin <vjardin@free.fr>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 201/337] hwmon: (pmbus/core) notify on the hwmon device, not the i2c client
Date: Fri,  7 Aug 2026 16:36:44 +0200
Message-ID: <20260807143422.909645791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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
@@ -2930,8 +2930,9 @@ static void pmbus_notify(struct pmbus_da
 
 		if (reg == sreg && page == spage && (smask & flags)) {
 			dev_dbg(data->dev, "sysfs notify: %s", da->attr.name);
-			sysfs_notify(&data->dev->kobj, NULL, da->attr.name);
-			kobject_uevent(&data->dev->kobj, KOBJ_CHANGE);
+			sysfs_notify(&data->hwmon_dev->kobj, NULL,
+				     da->attr.name);
+			kobject_uevent(&data->hwmon_dev->kobj, KOBJ_CHANGE);
 			flags &= ~smask;
 		}
 


