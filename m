Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCD1305687;
	Wed, 23 Sep 2026 14:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175051; cv=none; b=Dv4SU5CxvCoLiZVSpi1YSYer/kbdEgusD/EGllDP6IG+2EDkH7Rcop4H26hb1DG+53gR76wwXyHTlJzSFyfWyQuWD0G9HmFywK/Cql/BLcvH+n3NfD/43Vq9Xy6UIDim+d12StskU2DhkdgKk2tq2jkYd6fMaknQ4A36GNNUa+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175051; c=relaxed/simple;
	bh=jAK6Q1u0s3tSuDIOePrC3ESskgagl4+7MK3fu58LlNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBoyctRBr5zhsR9+/qqzeE3ym2awGYUkhGXqzfHXjShQvt/9VV/gcuGM+h/CE7GRZu6jw2rJODsnRfABH58s6WIRqIVH9BTBo4fRrsGkVMHwIMpSJKNSxBSkQs6jdtL0ZVpoXASVkZQEmJo/DAoExrgyJSVDhWJjpwkRzry9mc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfYZiNMj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfYZiNMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423FD1F000FF;
	Wed, 23 Sep 2026 14:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175049;
	bh=ym7nLcUBjM2/bO6W15PO4oDfJON0I3xdEG72cWlhg70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NfYZiNMjI5ag1IK4B5Knw/SNnCBrGg1bepsNsIptvlrXg0t21PlprdnAFeXLHsjAz
	 2+6GGqjOzsFJH+LmR9vsHduxnonpQXeDvyY1JSWwovJ9eTCT04LenhvqeO8/5FxEYO
	 shP+QvOfEXIIKk2Md4uidqMyjrVufCuDsOAi+9Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Bilal <meatuni001@gmail.com>,
	James Seo <james@equiv.tech>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 306/398] hwmon: (hp-wmi-sensors) Fix use-after-free in fungible_show()
Date: Wed, 23 Sep 2026 16:06:20 +0200
Message-ID: <20260923140651.351392106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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


