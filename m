Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BA41C173F;
	Wed, 19 Feb 2025 09:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955777; cv=none; b=m7+go6/dZDwgkdN196DvofZWGqivhGGmYtIOSCnnkCqhuL5xkslC9MJ1lQSu3zITuvQJynNm8QXiA11CdW5xtzZcm71+1UDQ9fo55A9Ua/HL6XBcpyGSlXzkrjRur2MpregLlSQBceLETkZtx9IWjJ+5zSQ4X2KaamuXf2VNnDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955777; c=relaxed/simple;
	bh=SLYMbHpY2TXmmD8JFpbhQaGbs+A320Ow2yU+hrkkeqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRfodrnqRyS7C3F5aoO1ZDVkr5bCUjnJAyWcnzn6lzQlnSlcSMhI3fSyDB0RnRwHoUUI0dVvKgNRUP4YDYG5UPW2T/c8SelMMwZmQCUqXXL5JUb8dcd5j9fI5gtCn058Is5sJuR0F5koEjJkjgCb+zU8pQaOpOwaK7IisAz/kb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukpzhUKv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukpzhUKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9293C4CEE6;
	Wed, 19 Feb 2025 09:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955777;
	bh=SLYMbHpY2TXmmD8JFpbhQaGbs+A320Ow2yU+hrkkeqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukpzhUKvxBVZrg63JV/AsdGSWXLGPewGecKlpjonFHzlqgyVit1EEpNTVlJ6beRUS
	 2LIdc3xHOr+Kvio9kGSy4tMjv/iULGOowBj5hDE6v1zxBSgn9fuPBcwcLOBQhOg07q
	 TlfgfIa9sWxytD1Pg1RLwiYnACF7ImLVPUERDf94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/152] HID: hid-steam: Avoid overwriting smoothing parameter
Date: Wed, 19 Feb 2025 09:28:44 +0100
Message-ID: <20250219082554.449329321@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit 34281b4d916f167a6f77975380e1df07f06248b7 ]

The original implementation of this driver incorrectly guessed the function of
this register. It's not only unnecessary to write to this register for lizard
mode but actually counter-productive since it overwrites whatever previous
value was intentionally set, for example by Steam.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 79504249d7e2 ("HID: hid-steam: Move hidraw input (un)registering to work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index b110818fc9458..7aefd52e945a1 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -340,9 +340,6 @@ static void steam_set_lizard_mode(struct steam_device *steam, bool enable)
 		steam_send_report_byte(steam, STEAM_CMD_DEFAULT_MAPPINGS);
 		/* enable mouse */
 		steam_send_report_byte(steam, STEAM_CMD_DEFAULT_MOUSE);
-		steam_write_registers(steam,
-			STEAM_REG_RPAD_MARGIN, 0x01, /* enable margin */
-			0);
 
 		cancel_delayed_work_sync(&steam->heartbeat);
 	} else {
@@ -351,7 +348,6 @@ static void steam_set_lizard_mode(struct steam_device *steam, bool enable)
 
 		if (steam->quirks & STEAM_QUIRK_DECK) {
 			steam_write_registers(steam,
-				STEAM_REG_RPAD_MARGIN, 0x00, /* disable margin */
 				STEAM_REG_LPAD_MODE, 0x07, /* disable mouse */
 				STEAM_REG_RPAD_MODE, 0x07, /* disable mouse */
 				STEAM_REG_LPAD_CLICK_PRESSURE, 0xFFFF, /* disable clicky pad */
@@ -365,7 +361,6 @@ static void steam_set_lizard_mode(struct steam_device *steam, bool enable)
 				schedule_delayed_work(&steam->heartbeat, 5 * HZ);
 		} else {
 			steam_write_registers(steam,
-				STEAM_REG_RPAD_MARGIN, 0x00, /* disable margin */
 				STEAM_REG_LPAD_MODE, 0x07, /* disable mouse */
 				STEAM_REG_RPAD_MODE, 0x07, /* disable mouse */
 				0);
-- 
2.39.5



