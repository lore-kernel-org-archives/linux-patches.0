Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9379B5304DB;
	Thu, 17 Sep 2026 17:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664482; cv=none; b=Q/WyGcAMvnsWgmijde+fv/RoCthx0p6fyHKmQ+4DGWF7z9ql8wrJnfgqOGmFdEgr/wFtY6R879+L52fxRtpx27Ot4cvaegLz264FL4tDdN+7wyyeGCTd/mKNWeQXaGade1hi2QkUjLa9Vcuuh5vpseyM0Xq5c6GhvwSxwcNDozc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664482; c=relaxed/simple;
	bh=2AwCSOMK+D1kYpjpQquSHcNgOKWYUSUea+XlRSaPBjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAqhdR3v5pjSDOrWEZiJvLdyrKVGi9ZhqOMLALqOLzkQrf7SgtriTmzhgKb1mdCO3aTg3SmNZbG1zUb1VM6J+bB3I6UeInhTfqqskvlvDOgzs/mkAWIDYTt5i2KswInZ8lsAaFR16OiqCs4hWit6RTOZhe3ncV7jmwh88HVm0Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KEchhma7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KEchhma7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8761F000FF;
	Thu, 17 Sep 2026 17:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664481;
	bh=dYMY304UEEN/GPhUj7Pp1YHFa066UXaH+GjFJ6JCwFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KEchhma7OkxGZfUvPCRNzptgR69GIVo2oI9nQ5aaKizspq9w7TpTLKmqQdNH605SC
	 TxIADKJdRHAyJMpZKGDgZyNpcCWiuDCJ2M10an0ldzoV9XKroB48XY9P4oYPI051Kw
	 ZDtUkr4qXjWUeFvtOF5TS3up1U7QgGc66gSHIh88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Carey <carvsdriver@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0385/1250] HID: multitouch: Honor ContactCount for Yoga Book 9 to suppress ghost contacts
Date: Thu, 17 Sep 2026 16:03:00 +0100
Message-ID: <20260917151602.478553588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Dave Carey <carvsdriver@gmail.com>

[ Upstream commit ef257b8be9776915ca468bae6c91e31757e69734 ]

The INGENIC 17EF:6161 firmware on the Lenovo Yoga Book 9 14IAH10
does not clear stale contact slots when fingers are lifted.  Each
HID report contains up to 10 finger slots, but only the first
ContactCount slots represent valid contacts; the remaining slots
retain TipSwitch=1 with positions from previous touches.

Raw HID capture confirms this: across a 60-second capture with
repeated multi-finger gestures, 90% of frames had more TipSwitch=1
slots than the reported ContactCount.  The ContactCount field itself
is always accurate.

Add MT_QUIRK_CONTACT_CNT_ACCURATE to the MT_CLS_YOGABOOK9I class so
the driver stops processing slots once ContactCount valid contacts
have been consumed, discarding the stale ghost entries per HID
specification section 17.  MT_QUIRK_NOT_SEEN_MEANS_UP (already in
the class) ensures that any slot skipped by this guard is released
via INPUT_MT_DROP_UNUSED at frame sync.

Signed-off-by: Dave Carey <carvsdriver@gmail.com>
Tested-by: Dave Carey <carvsdriver@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index fbf6f4b9e588f..35f9f4f76a550 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -442,6 +442,7 @@ static const struct mt_class mt_classes[] = {
 		{ .name = MT_CLS_YOGABOOK9I,
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
 			MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
 			MT_QUIRK_FORCE_MULTI_INPUT |
 			MT_QUIRK_SEPARATE_APP_REPORT |
 			MT_QUIRK_HOVERING |
-- 
2.53.0



