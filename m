Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3183B9943;
	Fri,  7 Aug 2026 15:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115395; cv=none; b=kbjqmAlIsuthpkiefxYMxTDZNW5EeSbk1QHBj8RAY11FxItsUFN1fRtGaRGi2I65FA7naTvFrsca7bmG5WsK6Pbb47AAuMqFeeHEpDbbsc4RmcHtSRtY9SJlyt+XN3yFSNdgUbMqhP6TTqj8TPyJCwFmYVSpHR6+CkeV8ihts+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115395; c=relaxed/simple;
	bh=Rqi9rXJDTdxCyinQyKzcVljzV0djeo9D+7s9ouyE3sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKYaP8eK77Awmk9DPbWyDtdQK2eNHJGicNhD0YIlLozQzXx2BBKHT449HACmJostkGlbQej7ho/3h7dvIMbAikcbLTlNRl96hXuYgXsn1R5OxRxA32xkorNfIDVnO2LC+sCf8iQqotFZccScoHMV5tGwdMYMfj+IetWddykGx/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/Jks6p9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/Jks6p9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D5F1F000E9;
	Fri,  7 Aug 2026 15:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115393;
	bh=NthtVqNsBo2TzaC0r+KMmXefiml5OO0RezmNLhPbXFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/Jks6p97CSYg2pl2pFLmzB5o4CIbVTIN9Z0MnbI+lOuqjBLtxZgD2WcDyFY6z9be
	 fsiUcYLCYNtNpDa+sUsDeyc05TahR0psy62GNRFMVECCpQKtw2VNjKReC3YhY2xfHC
	 PesQ26AGHyn6/a0lrES+uuOrUtge/E2D11UqkYq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Jardin <vjardin@free.fr>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 261/396] hwmon: (pmbus/core) notify on the hwmon device, not the i2c client
Date: Fri,  7 Aug 2026 16:37:01 +0200
Message-ID: <20260807143429.881926555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2977,8 +2977,9 @@ static void pmbus_notify(struct pmbus_da
 
 		if (reg == sreg && page == spage && (smask & flags)) {
 			dev_dbg(data->dev, "sysfs notify: %s", da->attr.name);
-			sysfs_notify(&data->dev->kobj, NULL, da->attr.name);
-			kobject_uevent(&data->dev->kobj, KOBJ_CHANGE);
+			sysfs_notify(&data->hwmon_dev->kobj, NULL,
+				     da->attr.name);
+			kobject_uevent(&data->hwmon_dev->kobj, KOBJ_CHANGE);
 			flags &= ~smask;
 		}
 


