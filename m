Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63E8511E8A;
	Wed, 23 Sep 2026 14:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173859; cv=none; b=CWg1v+xucnGOS8akY+OWkFkQwJDS9XR2JoBYAPGRzc8Z9NxemQmJwpm82nH1ERPscBT/joTzOWh7fkhQej1CS9VH2G2vY3ijKUH6zl8zhuYMXsgFkhuRYhvNCUzwdX3cRn+C0fjcDIf83Yd1fS/vTz0pBjt2NMSezsM3NR5sIM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173859; c=relaxed/simple;
	bh=JhQpjA8IdMjfu2iZh8u1au5mYnNgDyWV0Q0nd42bTBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/YfJQ8XCLnz3+Tv9ov6MGalyPpOMAhvTAjsolNNQU1ZCUsyT0WUWnq/OV2BgJLVK6ggGtxJdJ9N0HkYY8XVIljadsk3SXV+WjyA/gkjJGUZgrGYvrb4UU4rudqQdl9POxbyAxXHuWqJwsSfyJ3b7ngH6GucpcNDaPhTjrbJJdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L92T3KI4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L92T3KI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DA31F00893;
	Wed, 23 Sep 2026 14:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173857;
	bh=Fp3h1fx6ctUoHu3UrOptfzTf6H+iru655rkK9h53V/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L92T3KI4khwqIQ/xIVxbBNxrMNvfhhYzDzqmgX7oaGXL8AHpjfHuW/xu3tAI8WQLJ
	 y5KOqG5OvmiyYEm74SwrePS8FkMzNae9tIv6SCOR3LDVzXvWoCuL9QS6P4COZxFphV
	 K3p/RJFWfTaZdQzoNEBEvulr33cnvFilaTLcC20Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	James Seo <james@equiv.tech>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 365/438] hwmon: (hp-wmi-sensors) Fix use-after-free in fungible_show()
Date: Wed, 23 Sep 2026 16:06:26 +0200
Message-ID: <20260923140654.316970950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1261,7 +1261,9 @@ static int fungible_show(struct seq_file
 		break;
 
 	case HP_WMI_PROPERTY_CURRENT_STATE:
+		mutex_lock(&state->lock);
 		seq_printf(seqf, "%s\n", nsensor->current_state);
+		mutex_unlock(&state->lock);
 		break;
 
 	case HP_WMI_PROPERTY_UNIT_MODIFIER:


