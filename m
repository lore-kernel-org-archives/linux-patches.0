Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558741E5201;
	Wed, 19 Feb 2025 08:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954712; cv=none; b=f1vKvksbWlGQ3rPP1hHwHnxWYgsL9WbfMsBBJ6hpNHVqnTsjRhYyOZ+bmHEO5nYUM/FbT7824o4489s9vzAi4d4tscv+cuslCCIfTmjTkZFLwSxXhGTdfHgwMIKjZQOkfbbBaLIA6vfdgmtnBHPytoEHi6P0smf6ZskvuJUev2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954712; c=relaxed/simple;
	bh=pSJDwh3iKa3ouj+ZmXYFvFRB4jS3T/qF+FQQa2/eqBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9CA+ntBRnF0X3wl6RPH2CGFm66wiP3L0BYKhOrJo5X0LK6NfSa/bfQiuAWlwY6XkIFYIlonizblSLIuBWrtFHCaM9yES/q7RYTCG3dHcuKFgYzOKyiT7We8lVUKvJgo3v9FD/DyJaPNFCXkhi6zMoNY6UF03FLHlCzcRgEh9mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wVpuK8b1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wVpuK8b1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65D3C4CED1;
	Wed, 19 Feb 2025 08:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954712;
	bh=pSJDwh3iKa3ouj+ZmXYFvFRB4jS3T/qF+FQQa2/eqBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wVpuK8b1uTUUNb2vv3fECN48x/wGMOHGPE9gxaroi/eYWLq4/+kn2etr272WozNW/
	 giACMq4X4d95Rlfwgbpd2EiVm3tSf3I8cJe/5tH7HvED/u6daRn1Jb1CR0t1xBWRdu
	 pzgzWyLi7u42OYWkzYihaSMxP6WEm9HAnNl10OE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/230] HID: hid-steam: Dont use cancel_delayed_work_sync in IRQ context
Date: Wed, 19 Feb 2025 09:25:31 +0100
Message-ID: <20250219082602.259307532@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bf8b633114be6..9b6aec0733ae6 100644
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



