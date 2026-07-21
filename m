Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18D9435A96;
	Tue, 21 Jul 2026 20:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665455; cv=none; b=pEXtx9m4y8EN2UWsQylZRvnN+bzjoai5IQ0YtesNpJEBAi04k3CzA2F+iLST3JPnmYLQdgtPtZpRl8fjt6Hvsk2Ij/ZS0/jUu3ckXHeekDmWSzTyPVv0sHLYAXkWQKauptXeijXsaiaorK2LEdEopkGngV54l2jWkapeT6fw4Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665455; c=relaxed/simple;
	bh=YFFVQiP+tD4dD7wFrfkT23pR6YC1uKi3jXyu47OMPBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BI1ausDsrhu0WDpOuGKZ31/ux6LX+m6TCRzCzIn3M2h6eLa9Td2/WN5cHLEyq5Pvr2hdcklTQ+/DJZ4kLfPeDQi9sxXdHBNNdC2aCd+s0DVxE4EJuMgKuuoxAhJWS6e0jFG913iqoeQsygd2fC2ivXyvnjcjuhUfoOKQfrmN/qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElKhs0sJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElKhs0sJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634F11F00A3A;
	Tue, 21 Jul 2026 20:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665453;
	bh=M37iC/zPQ8VvBbcMUUal6ts+YzJvMg00KnlscWq5Ebw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ElKhs0sJh1Dv4jSJHP6gBj1KoColcQEx6M1HvHCwV22+hS1zkRWDQcyeU/kidTO/a
	 evis9DRotAWSqc/TAyAk5sh3UCRkTFj5ZLGjyrSwjBq0wH+2Lpq70Awn4J/0pcKqgj
	 9/QYoCVI6Nlr4XiYQTNFFxCgaIhTBRIj03taidyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0309/1266] Input: goodix - clamp the device-reported contact count
Date: Tue, 21 Jul 2026 17:12:26 +0200
Message-ID: <20260721152448.746985445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -1056,7 +1056,8 @@ static void goodix_read_config(struct go
 	}
 
 	ts->int_trigger_type = ts->config[TRIGGER_LOC] & 0x03;
-	ts->max_touch_num = ts->config[MAX_CONTACTS_LOC] & 0x0f;
+	ts->max_touch_num = min(ts->config[MAX_CONTACTS_LOC] & 0x0f,
+				GOODIX_MAX_CONTACTS);
 
 	x_max = get_unaligned_le16(&ts->config[RESOLUTION_LOC]);
 	y_max = get_unaligned_le16(&ts->config[RESOLUTION_LOC + 2]);


