Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B62E4D1789;
	Thu, 17 Sep 2026 18:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668002; cv=none; b=lAI+HORj2tDppiC2EaKbw+n1b2Mq4wy4anTlNHjmL2R1UhIRxtEX8+gkJhuVxkHIxkfSgKWkalM57dzF0uxzqKdyn7O6OWtSYJBxdQ/eQv0gXvJy1K3HC94x9pOWYlihj7IPrY5VWDJNlLCnMmXEF//kJnhswSX34ZeJTc8NEVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668002; c=relaxed/simple;
	bh=vhUi0Z51HqyXdJE65xOQ0sqSdaW6yU82dE5QCB25qZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgU8U18ThHyXiz+HTFKD3uxUNrtLeATCpAJgDYecYGAWt9p9fJr8PuHusbgSmlNi96BFHz0Lnxr9lxIPKDcdzA/eqg0l6FmPNCSY+mWb0jlrrAR72QX6HlPiqX1KKPwkKDo1YMwfdeZEmbEz40x+6g8q1aDE7TiwN1wV3s9UroI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZD+nUXS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZD+nUXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2371F000FF;
	Thu, 17 Sep 2026 17:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668001;
	bh=39Ejdc7X163Q+FMlyBpC7KRCmQkKu60Muo8Z9dZxJe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZD+nUXSmr5l8A9RhBPCnnyiPDLo8IlJdGfHu/L9H2Kv6yGZZuwH6dMi6U5V+8l9z
	 sC/RarmZobyodf8jOI6U4x8U7EnLjR2AHTjns4RztC3UF9IK8DDS07jHR7CU+E2l1N
	 lIWjzTtKDJ8arq10cSBmphseB6MkkkhbMT5axK4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Carey <carvsdriver@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0279/1102] HID: multitouch: Honor ContactCount for Yoga Book 9 to suppress ghost contacts
Date: Thu, 17 Sep 2026 16:03:42 +0100
Message-ID: <20260917151546.615515710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 9547c1909efbe..454bb8b9b732f 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -411,6 +411,7 @@ static const struct mt_class mt_classes[] = {
 		{ .name = MT_CLS_YOGABOOK9I,
 		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
 			MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
 			MT_QUIRK_FORCE_MULTI_INPUT |
 			MT_QUIRK_SEPARATE_APP_REPORT |
 			MT_QUIRK_HOVERING |
-- 
2.53.0



