Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F28A1C7019;
	Wed, 19 Feb 2025 08:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953847; cv=none; b=baG6zufiPfqZlhTR30KJTrw3WO7ZH0LFlPDLmYeYyuSrPYxIn2cF/KArp5FMXciWQt9wC4Wor0vN/uQofe6L/426/5lExQG0dgIW3/n8CFhQhJwVNh45vOcoMJQevRISGlobBwR1XECSPuU8gtPzBrpg99armuhM0PFnHAZ9NrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953847; c=relaxed/simple;
	bh=V95AsXMy4TLXD0wb5Qn93tdDX+Xp7OTkZqu9TtY1bVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkHLMLlutE+7xFgJvUNlrrTpFAWGCwvFCmVlXaUBHhc0GxsXVI4eV6ni54JhlcVtgZIUqktGesDKjSI9ZAaYdQdmWHzwAEH1lxYavckCWtqYEghjyCTBehzcPKu4dHeP+OO8xN6AJfXIb/qDotn8dleZ6aH0Y7nY24cVVJnxnck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUger2Dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUger2Dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F30CC4CED1;
	Wed, 19 Feb 2025 08:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953846;
	bh=V95AsXMy4TLXD0wb5Qn93tdDX+Xp7OTkZqu9TtY1bVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUger2DnD929lPh/0WWUFmSYybfJi4hr9lb0DGcMVoJCwI2phzsbYUqBeMljzwB9/
	 wWDgiYRLNtmHXugyf2vnS9skPNbaiEQdEfgtT2P3/9kIm9Rk9cCqLI8bjErxikdDmS
	 neVoD0+VVtI53T/rTG9/CJrjuolAw7Fm8Q7lY1+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 017/274] HID: hid-steam: Dont use cancel_delayed_work_sync in IRQ context
Date: Wed, 19 Feb 2025 09:24:31 +0100
Message-ID: <20250219082610.213719369@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit b051ffa2aeb2a60e092387b6fb2af1ad42f51a3c ]

Lockdep reported that, as steam_do_deck_input_event is called from
steam_raw_event inside of an IRQ context, it can lead to issues if that IRQ
occurs while the work to be cancelled is running. By using cancel_delayed_work,
this issue can be avoided. The exact ordering of the work and the event
processing is not super important, so this is safe.

Fixes: cd438e57dd05 ("HID: hid-steam: Add gamepad-only mode switched to by holding options")
Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 6439913372a8a..12a6887cd12c9 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -1592,7 +1592,7 @@ static void steam_do_deck_input_event(struct steam_device *steam,
 
 	if (!(b9 & BIT(6)) && steam->did_mode_switch) {
 		steam->did_mode_switch = false;
-		cancel_delayed_work_sync(&steam->mode_switch);
+		cancel_delayed_work(&steam->mode_switch);
 	} else if (!steam->client_opened && (b9 & BIT(6)) && !steam->did_mode_switch) {
 		steam->did_mode_switch = true;
 		schedule_delayed_work(&steam->mode_switch, 45 * HZ / 100);
-- 
2.39.5



