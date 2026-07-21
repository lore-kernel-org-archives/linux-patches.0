Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CB9368D40;
	Tue, 21 Jul 2026 22:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673397; cv=none; b=C92pTVh2woQL5idCMw5BjMJvwqgGfhJGScS4R5+Zv09CRwtrvcCij3/nGu3KSqHPHcFMrEILK5M0Yc5jq8ghkVXgcmc2UPYk0nYGpAMA/SyHCzIUGmaui75dK3BLwL7E4sSYIEVIuKxWD5kPe6vZTRgGnUrWKzQxVaH298omqx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673397; c=relaxed/simple;
	bh=wShom6yF+eL8zt5FDgwFes12a9QInoc8exunT1iYMTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKLt4+hku5pPnFedlHkEnvX/COxJvKn116cX/GGodz5+F9Qnn+GwNHkO0KuApO/W5qiAb02PU9oczvIXik1G6yCbHnPwiQy8Ndqm0QPNLjeO00Bu/UPUKULsqoe+hHy+dRTXGJDPPBbMDVtYeMGRoNsPnVfZtPrkQiSsVtAnM28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrjeiz32; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrjeiz32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396AC1F000E9;
	Tue, 21 Jul 2026 22:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673396;
	bh=1y0PIrzbM5nV8ZyJB7Na3AFWCTIfwXBKDGOkKhgadRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vrjeiz32iI9TK6Nt95WUCkgk0XKoBeNbFeH6dAXyHunZWZsESnEC2N1VXQCnZMw1O
	 QVWIOt9uidW9n3Zppnn+66/nvMQ3AYyA+EmJJDL6ARz9Fi4dBw52Kj1UVDGSrHWfzW
	 O6ukwSdlhzBFuw21j5I3NNTiambLdNJXX8MY7qes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 147/699] Input: goodix - clamp the device-reported contact count
Date: Tue, 21 Jul 2026 17:18:26 +0200
Message-ID: <20260721152359.023493386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 5ed62a96e06be4e94b8296b7932afee550a70e04 upstream.

goodix_ts_read_input_report() copies the number of touch points reported
by the device into an on-stack buffer

	u8 point_data[2 + GOODIX_MAX_CONTACT_SIZE * GOODIX_MAX_CONTACTS];

which is sized for at most GOODIX_MAX_CONTACTS (10) contacts. The only
runtime check bounds the per-interrupt count against ts->max_touch_num,
but that value is taken verbatim from a 4-bit field of the device
configuration block and is never clamped:

	ts->max_touch_num = ts->config[MAX_CONTACTS_LOC] & 0x0f;

The nibble can be 0..15, so a malfunctioning, malicious or counterfeit
controller (or an attacker tampering with the I2C bus) can advertise up
to 15 contacts. goodix_ts_read_input_report() then accepts a touch_num
of up to 15 and the second goodix_i2c_read() writes
ts->contact_size * (touch_num - 1) bytes past the one-contact header into
point_data - up to 30 bytes (45 with the 9-byte report format) beyond the
92-byte buffer: a stack out-of-bounds write.

Clamp max_touch_num to GOODIX_MAX_CONTACTS, the number of contacts
point_data[] is sized for, when reading it from the configuration.

Fixes: a7ac7c95d468 ("Input: goodix - use max touch number from device config")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260612-b4-disp-6844625d-v1-1-df0aed080c9d@proton.me
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/goodix.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -955,7 +955,8 @@ static void goodix_read_config(struct go
 	}
 
 	ts->int_trigger_type = ts->config[TRIGGER_LOC] & 0x03;
-	ts->max_touch_num = ts->config[MAX_CONTACTS_LOC] & 0x0f;
+	ts->max_touch_num = min(ts->config[MAX_CONTACTS_LOC] & 0x0f,
+				GOODIX_MAX_CONTACTS);
 
 	x_max = get_unaligned_le16(&ts->config[RESOLUTION_LOC]);
 	y_max = get_unaligned_le16(&ts->config[RESOLUTION_LOC + 2]);


