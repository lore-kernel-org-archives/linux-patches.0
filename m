Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A323BE623;
	Sat, 12 Sep 2026 20:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243580; cv=none; b=JcRW1LnZBzU/vgv80GW44JmYl2gX7zSqJTOsBLBJitLcUVhxWTih0QjnrsbnLMXJNVl2XNWo7lUNHlS5P/h2TSXEvdKSv19hxSXKwn0emug7kpqyR3oP2+tYvu3sO1cdygGsAvDYnkbP1hqek6pFUD1OHzxT2IbSpZSDAk4eNlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243580; c=relaxed/simple;
	bh=uoYvn3bOqNPTjj3LFqCRuic5uHu0ZtVj8+/Q8kNgMTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEQJDjQCxHFt9NW59ctHKHrxUMjaTBUEVFYNItSVI1bjplrhH4RZd3yTJmqN88PtST0VsRNrN7G6N3Www6/aQpGKkaDgStiSInel9x8WJXRVxE358fXzfGB8cL0kvfgvKIKQ0CDHtd3ZrLsgNJyqwWsZ2sYw2pDvQpKlPjw/P0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omRAZw8P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omRAZw8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358A11F000FF;
	Sat, 12 Sep 2026 20:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243577;
	bh=AXt28KOsjuQ9sa3UkMPim30vmuFrORtZpf77UB11S54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=omRAZw8PPo2c18TBG+Dn67VE69LWiOe2aSBgl2VrUDZIdffb4vdNH590TOL6LiS4a
	 KYZKOD14xPk1to5iPgErdz3BKFWAHuZw61dcp0pChrO2XhEfC/AVNwbLRxlhMLCKSC
	 OvIYkeFCRqOtzTTixnak/9RFAEE6xxLvWK6wcpMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 794/798] HID: fix an error code in hid_check_device_match()
Date: Sat, 12 Sep 2026 09:07:02 +0200
Message-ID: <20260912065535.259275859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 89e756e3cc8d9c1ebc0f2b2f6912227073d93118 ]

The hid_check_device_match() returns true if we find a match and false
if we don't.  But here it returns -ENODEV which becomes true instead
of false.

Fixes: 207733f92661 ("HID: split apart hid_device_probe to make logic more apparent")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 4b704d98b019f..9d1a3b05ca8d9 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2322,7 +2322,7 @@ static bool hid_check_device_match(struct hid_device *hdev,
 {
 	*id = hid_match_device(hdev, hdrv);
 	if (!*id)
-		return -ENODEV;
+		return false;
 
 	if (hdrv->match)
 		return hdrv->match(hdev, hid_ignore_special_drivers);
-- 
2.53.0



