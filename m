Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5046931E85C;
	Thu, 16 Jul 2026 13:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210228; cv=none; b=Vf0Rn+wkLaBGkhpN7TK56lAIsMNc/7NvvTv28Tglh9an+RiU8q8qzGLA/dRCBzyMo01QTI19URSp4faxNfETEcWsim6bhR10afOl2GywpOVaPKUhzDAl2txNEsEFjtrrvopKsAmpbJ89EDQRBMMJlaryjRmfrcbejwgI1WVGk8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210228; c=relaxed/simple;
	bh=QKqRWuKfk8ccQ/vtBwIHoefRGeWOhfWf/qmT1i8QF2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cfvo1saF7b/Ck/9pYyz6EryhxZCaTYCgdJu+Q9E160MotWwrJKap/E6MouNIA9kag7EHuK0pnrzmAixwBRx+iIKw/g4vePLFfV9S6IxVqhAsjR6jwyiiYaMXkXl1Kr0vZT7OaSTjQm97yq5kdBicQuCwfPhIBEKY/roDE9y2fpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atZUsiZ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atZUsiZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56481F000E9;
	Thu, 16 Jul 2026 13:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210227;
	bh=Y9fFfsGdPiNfIZ22VMmNvmkbpDzukelj4KOZ9pqjol8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=atZUsiZ/GWeAwL/QDeYBeimiISXlR4jSaLlZoEikyTDeIzUsuBkF9JwEYLXaryXaO
	 Gp/DUo0N2CnPK6uzYyb91EdS1CxCUsHAqzg5YJvPXKFZqVdAms1+lNaeu/XGo+Ibaw
	 luElpWbMDnR7dEcMyqEPhi2uq87i5DrJOeNxmJa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 484/518] Input: goodix - clamp the device-reported contact count
Date: Thu, 16 Jul 2026 15:32:32 +0200
Message-ID: <20260716133058.438955188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1057,7 +1057,8 @@ static void goodix_read_config(struct go
 	}
 
 	ts->int_trigger_type = ts->config[TRIGGER_LOC] & 0x03;
-	ts->max_touch_num = ts->config[MAX_CONTACTS_LOC] & 0x0f;
+	ts->max_touch_num = min(ts->config[MAX_CONTACTS_LOC] & 0x0f,
+				GOODIX_MAX_CONTACTS);
 
 	x_max = get_unaligned_le16(&ts->config[RESOLUTION_LOC]);
 	y_max = get_unaligned_le16(&ts->config[RESOLUTION_LOC + 2]);


