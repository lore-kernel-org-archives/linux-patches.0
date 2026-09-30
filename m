Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799D84E7802;
	Wed, 30 Sep 2026 17:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788788; cv=none; b=R/gKCGnggDGdjdCf4vm9FEeL19bKrFZxLTVEVlcPe/Mq9PxNKVZPX2giXnVOyZkHDSaDlK4nbmHuM6GJv5XXhq12qiiBAV9x/iknHLvynhvbOXaeXKMDIxtA/EZ7dieBy6SyuyhD4mRO/Z3Dr5isp1TjwXeZTBAxSbFcXFeAFR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788788; c=relaxed/simple;
	bh=MLglkbfXfYFhwl1DcQ7+j1EyeScVekGBOH2YzkVrukQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozAN/UVCYgqLuyRNOyd22cO9Atyd/sghNLN6zimMF/ZHICEts3HKOPg9n9OXHbsWaOT5UU0i0l2yJhIv8dG/Wyx0NIg64xZy/JBvK92XciHOuIC8YFGnfV3sNqkSbmqs+gw6Lsr3AlZPBDdVulsS1priMh8rlrYb28VZz8aN858=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6ukreri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6ukreri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D721F000FF;
	Wed, 30 Sep 2026 17:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788787;
	bh=Kc11FenEoYbVjcTzj7BEGp8GWjSjRBKh7D1cZ7NxJkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6ukreriiL6WRz2BUFWwBfG3PP3GeRZLze5WQ2S7kqCmwTQXR5IjFybLXJhmtC4ol
	 /+5xXu0zZBOYr/U6AZEagTrw+LFG4QNa+sZgheD52WJoEAYAlhIB3xVcb/IgfVkr+w
	 bMn9EYomKMQgA77yvMhn2K1ZYIS8OqUKe8q+RNy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	James Seo <james@equiv.tech>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 246/877] hwmon: (hp-wmi-sensors) Fix use-after-free in fungible_show()
Date: Wed, 30 Sep 2026 17:19:17 +0200
Message-ID: <20260930152420.032703102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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


