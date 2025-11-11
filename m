Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B642737E3;
	Tue, 11 Nov 2025 01:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823343; cv=none; b=c1VkARrGyvqA847ioJNjjT7K8cpILvRPFrWx0R0/5GgA55R5sc7R/jL7tqXScR1NTiaXfGKi3ygNYUpOz2Zt+3m8O2oqFWCftnbOqjSWn7uSBUfII00W2MkQnxrJmHrBRTGDx7w7QdekaQTPxwOXoL8pB2Z5wZdhBqsJ1VOfqdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823343; c=relaxed/simple;
	bh=gaUf4ycDLWo3gn9PgEhPgr5mP8UxMHZevZyT2WEd0xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UROTdcHuSxBHo22kfLcYYtVOFRhz3YzyNcvFBdybyBlpc7OhAgMTjpGTag6WVfB1ANmC5aAomSmNGdfkibHpkuAal9XMzK1MUQpsYmzx0vErhrJUsro+1lNeWviz4UCklPLpm3+BFeNXu4j8mzk8/9UnQGxzzC+HbmqkovF8D9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYx9KMte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYx9KMte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A3EC16AAE;
	Tue, 11 Nov 2025 01:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823343;
	bh=gaUf4ycDLWo3gn9PgEhPgr5mP8UxMHZevZyT2WEd0xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hYx9KMte69kxPohgIFdfDkexHic4jOeZD23hv4m6FCx1g+kfyIOo5LPzemO3qswHE
	 aNKVwJ7ww1CbdWXmbuhIaVopSFdvrdcmVQKi54b8RJWSOwvsmuWwU6cJ+BufxuvTdM
	 tKV7TfJwCo+jDbByDc2cpdsVLnMH3uu2e6eCGjfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 223/565] HID: pidff: PERMISSIVE_CONTROL quirk autodetection
Date: Tue, 11 Nov 2025 09:41:19 +0900
Message-ID: <20251111004531.938096925@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit c2dc9f0b368c08c34674311cf78407718d5715a7 ]

Fixes force feedback for devices built with MMOS firmware and many more
not yet detected devices.

Update quirks mask debug message to always contain all 32 bits of data.

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index 0e60e4dc9e247..566eba0e045fa 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -1152,8 +1152,16 @@ static int pidff_find_special_fields(struct pidff_device *pidff)
 					 PID_DIRECTION, 0);
 	pidff->device_control =
 		pidff_find_special_field(pidff->reports[PID_DEVICE_CONTROL],
-			PID_DEVICE_CONTROL_ARRAY,
-			!(pidff->quirks & HID_PIDFF_QUIRK_PERMISSIVE_CONTROL));
+			PID_DEVICE_CONTROL_ARRAY, 1);
+
+	/* Detect and set permissive control quirk */
+	if (!pidff->device_control) {
+		pr_debug("Setting PERMISSIVE_CONTROL quirk\n");
+		pidff->quirks |= HID_PIDFF_QUIRK_PERMISSIVE_CONTROL;
+		pidff->device_control = pidff_find_special_field(
+			pidff->reports[PID_DEVICE_CONTROL],
+			PID_DEVICE_CONTROL_ARRAY, 0);
+	}
 
 	pidff->block_load_status =
 		pidff_find_special_field(pidff->reports[PID_BLOCK_LOAD],
@@ -1492,7 +1500,7 @@ int hid_pidff_init_with_quirks(struct hid_device *hid, u32 initial_quirks)
 	ff->playback = pidff_playback;
 
 	hid_info(dev, "Force feedback for USB HID PID devices by Anssi Hannula <anssi.hannula@gmail.com>\n");
-	hid_dbg(dev, "Active quirks mask: 0x%x\n", pidff->quirks);
+	hid_dbg(dev, "Active quirks mask: 0x%08x\n", pidff->quirks);
 
 	hid_device_io_stop(hid);
 
-- 
2.51.0



