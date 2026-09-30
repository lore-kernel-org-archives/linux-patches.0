Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FA53E1681;
	Wed, 30 Sep 2026 19:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796517; cv=none; b=SZ7EdfxvjsTIFW1bpnLdMMM6H+BAHCISavlWaVeLoeiikbuLOxvwGw3gpfOSARvLtYyxKivupCDzR/og0y5qFVRFStOSR3gchGe0FCwX6fSoinAstwQqyyWvGd7Qvx8i0TcR0YBlMvrMC2yhZzvLq9Qjy8vWPG8w8Ov4s5wtDKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796517; c=relaxed/simple;
	bh=1+SM/v6FlackVNZHgKmETpTDkxvO2Cv97px0mrVFQ3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrhbMUckS0KBqP68dKC8VvR4ztWqPFpzIAdAgR2bRXPhV/JwoQF3hhp+Q0MrrkbRk53arR7HUhid3du99nlOcChMLhaKUZsT1uTNplWpHfTGQboMyjUzkHXArYJ+vCxlqKIJkktVMawBIZ3ekmSgiGwDFRT4dBZ7LTN9gIJut44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yV22lup2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yV22lup2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2B41F000FF;
	Wed, 30 Sep 2026 19:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796516;
	bh=smf1HV8MS7sY4BHlv4NQvBZkUJRKvYYet4a5M+k828g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yV22lup2dj+GSakZ2k5JJsTKVEn+SxaM4pJMjrJwO3MTFuUUVD79oHJSbSYUq7q+m
	 +SSZv2Ui/fg6MGSrogGI76LBbe/bGMvZHc8G8bNj/SeZiEQUQU8LvcP3CFfHkSXe1S
	 ZeLlrfpZFMMsvkEWWtvXlsvR03W4AQVP9a8At8QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	James Seo <james@equiv.tech>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 0904/1193] hwmon: (hp-wmi-sensors) Fix use-after-free in fungible_show()
Date: Wed, 30 Sep 2026 17:26:28 +0200
Message-ID: <20260930152454.327957934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Muhammad Bilal <meatuni001@gmail.com>

commit e6cb0b4d4ecb8e71fd2200d907ab2e9663356f69 upstream.

nsensor->current_state is dynamically replaced as the sensor's state
changes. update_numeric_sensor_from_wobj() does this by freeing the
old string and installing a new one:

	if (strcmp(trimmed, nsensor->current_state)) {
		new_string = hp_wmi_strdup(dev, trimmed);
		if (new_string) {
			devm_kfree(dev, nsensor->current_state);
			nsensor->current_state = new_string;
		}
	}

This function is only ever called from hp_wmi_update_info() while
state->lock is held, so the free-and-replace itself is properly
serialized against concurrent updates.

fungible_show(), however, reads the same pointer after the lock has
already been dropped:

	err = hp_wmi_update_info(state, info);
	if (err)
		return err;

	switch (prop) {
	...
	case HP_WMI_PROPERTY_CURRENT_STATE:
		seq_printf(seqf, "%s\n", nsensor->current_state);
		break;

hp_wmi_update_info() takes state->lock internally and releases it
before returning, so by the time fungible_show() dereferences
nsensor->current_state in seq_printf(), no lock is held. Two
processes reading a sensor's current_state debugfs entry at
overlapping times (or one reading it while another read of the same
sensor triggers a refresh) can race: one thread's seq_printf() can
be part-way through printing the string at the moment another
thread's call into update_numeric_sensor_from_wobj() frees it with
devm_kfree() and installs a new pointer, causing a use-after-free
read.

Take state->lock around the read in fungible_show() as well, so it
can never run concurrently with the free-and-replace in
update_numeric_sensor_from_wobj().

Fixes: 23902f98f8d4 ("hwmon: add HP WMI Sensors driver")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
Acked-by: James Seo <james@equiv.tech>
Link: https://patch.msgid.link/20260916002926.161595-1-meatuni001@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/hp-wmi-sensors.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hwmon/hp-wmi-sensors.c
+++ b/drivers/hwmon/hp-wmi-sensors.c
@@ -1247,7 +1247,9 @@ static int fungible_show(struct seq_file
 		break;
 
 	case HP_WMI_PROPERTY_CURRENT_STATE:
+		mutex_lock(&state->lock);
 		seq_printf(seqf, "%s\n", nsensor->current_state);
+		mutex_unlock(&state->lock);
 		break;
 
 	case HP_WMI_PROPERTY_UNIT_MODIFIER:


