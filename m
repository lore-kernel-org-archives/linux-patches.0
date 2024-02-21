Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF5276905;
	Wed, 21 Feb 2024 13:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521657; cv=none; b=siv3Tf1KozSBG5yWSdTy1Kns9lLWPdcMvKU8UTBGuuvu+JdAox9NAwVVpQ3ate+4nwWf+3QzGcjxguwCgCoxdEoq0/sDRxjR2nMnBhGVlbSkKQYs3ICdgMCbx5rWYGFZUHP9KQjWxAXZn6300uG2mJK3mIgRV/eRvjc6xmLmhr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521657; c=relaxed/simple;
	bh=RJtOfqCo4UCaut2WRj1Yn+hTSZUm7+s96oc5CAGDZPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iou+rVZ+82YNZWgOWOH1PFFlugB2YHUO9AZdOtUrfRCMeOrfqeHQWZGI01zLBQXqhZsAhwyNIekpwwx2Fv6me/YtgZ+oAm/HlmLFYMhW8If26Qr+UB++CcPBRSL12DMkipziTAo3OhIPKYgnyLeCSjxXPObMvlqfHZyR15oeA0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hOT8cECJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hOT8cECJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7734C433F1;
	Wed, 21 Feb 2024 13:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521657;
	bh=RJtOfqCo4UCaut2WRj1Yn+hTSZUm7+s96oc5CAGDZPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOT8cECJHfQmkw39wzWPa4vrJlnC+tTBH79LeyC7mao0TakeziEuV1AOx7gZuvrIs
	 d4hMphLV+IHmwO16oNzaakH5Qf/lOgcdaCkICjEk9g+TNmS+QoBDA+LTgzEY11fUUR
	 3sGkg82mrdZV62kNAGkwXV7WmI7gH35+bYipEalc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zakhar Semenov <mail@free5lot.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Aseda Aboagye <aaboagye@chromium.org>
Subject: [PATCH 4.19 143/202] HID: apple: Swap the Fn and Left Control keys on Apple keyboards
Date: Wed, 21 Feb 2024 14:07:24 +0100
Message-ID: <20240221125936.334493871@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: free5lot <mail@free5lot.com>

commit 346338ef00d35bf8338ded171f9abeb9b10b43df upstream.

This patch allows users to swap the Fn and left Control keys on all Apple
keyboards: internal (e.g. Macbooks) and external (both wired and wireless).
The patch adds a new hid-apple module param: swap_fn_leftctrl (off by default).

Signed-off-by: Zakhar Semenov <mail@free5lot.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Aseda Aboagye <aaboagye@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-apple.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -54,6 +54,12 @@ MODULE_PARM_DESC(swap_opt_cmd, "Swap the
 		"(For people who want to keep Windows PC keyboard muscle memory. "
 		"[0] = as-is, Mac layout. 1 = swapped, Windows layout.)");
 
+static unsigned int swap_fn_leftctrl;
+module_param(swap_fn_leftctrl, uint, 0644);
+MODULE_PARM_DESC(swap_fn_leftctrl, "Swap the Fn and left Control keys. "
+		"(For people who want to keep PC keyboard muscle memory. "
+		"[0] = as-is, Mac layout, 1 = swapped, PC layout)");
+
 struct apple_sc {
 	unsigned long quirks;
 	unsigned int fn_on;
@@ -166,6 +172,11 @@ static const struct apple_key_translatio
 	{ }
 };
 
+static const struct apple_key_translation swapped_fn_leftctrl_keys[] = {
+	{ KEY_FN, KEY_LEFTCTRL },
+	{ }
+};
+
 static const struct apple_key_translation *apple_find_translation(
 		const struct apple_key_translation *table, u16 from)
 {
@@ -187,9 +198,11 @@ static int hidinput_apple_event(struct h
 	bool do_translate;
 	u16 code = 0;
 
-	if (usage->code == KEY_FN) {
+	u16 fn_keycode = (swap_fn_leftctrl) ? (KEY_LEFTCTRL) : (KEY_FN);
+
+	if (usage->code == fn_keycode) {
 		asc->fn_on = !!value;
-		input_event(input, usage->type, usage->code, value);
+		input_event(input, usage->type, KEY_FN, value);
 		return 1;
 	}
 
@@ -274,6 +287,14 @@ static int hidinput_apple_event(struct h
 		}
 	}
 
+	if (swap_fn_leftctrl) {
+		trans = apple_find_translation(swapped_fn_leftctrl_keys, usage->code);
+		if (trans) {
+			input_event(input, usage->type, trans->to, value);
+			return 1;
+		}
+	}
+
 	return 0;
 }
 
@@ -344,6 +365,11 @@ static void apple_setup_input(struct inp
 
 	for (trans = apple_iso_keyboard; trans->from; trans++)
 		set_bit(trans->to, input->keybit);
+
+	if (swap_fn_leftctrl) {
+		for (trans = swapped_fn_leftctrl_keys; trans->from; trans++)
+			set_bit(trans->to, input->keybit);
+	}
 }
 
 static int apple_input_mapping(struct hid_device *hdev, struct hid_input *hi,


