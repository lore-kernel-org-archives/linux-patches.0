Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC89B3B9616;
	Sat, 17 Oct 2026 17:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257463; cv=none; b=JoQlT4IIG0+T78CwNWIvfIOzHGLLk4Vo3at5GqvCF+h6ExVi4ClE75QIng2TyE0T1tb+rpyLyJRE8qrzFsIIxPJnXaSzh7GPn4qWS8e7rUDoSPQZkPKGPmXoPVc6RlE0FORNTqq/ZLwUtQoI8WNPgU0XqgOCWx2M6Mpa9efIUO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257463; c=relaxed/simple;
	bh=Ga2+fxHODe0FO/1kkr88FmNvSrAuFLsTpse/B82FU9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYDarbMMlVUro0QhJhgYELexwTozNk6Mqf/I9L0ea9yaGv5pMf7Ffvt1g8UJ+aBIglRpkDRiCIjkAyQEu/vhrhJXCTz7kMoE/hGDCrE0MMoZo5iIrKXWMVfEPXSEMBcW4+sI0+xS1frz7hmg0EtQB0GAiw3FuXdqd24Sbe+hXzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymckvzc3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymckvzc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CE51F000C4;
	Sat, 17 Oct 2026 17:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257462;
	bh=S46srv6r/+Vdr2EP7sIxk/nNCHpo/pjbjp7paxsO574=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ymckvzc3LfkC62K1Fld/YdMdbOTyyXKrkU+d2e+p/DPnwjq/kD19/3noEqXoQMvlv
	 5SVexdV1xUl/k7GZVPnnnMca7nyFUqRm92LWroL42A0Rp20vjenhVYdrYXBQIDQu4C
	 TgplRwNkg2B5YDLKuI+5H/cTLzucKTn+GXWefMyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0565/1674] HID: steam: Rearrange teardown sequence
Date: Sat, 17 Oct 2026 17:47:17 +0200
Message-ID: <20261017160445.596527638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit ddce9641ce924ed91ec8304577e463823a29ffaf ]

This fixes a narrow window during the teardown sequence where callbacks
could still be scheduled during cleanup that would then have a dangling
pointer to the now-freed steam struct.

This also puts work canceling for rumble and mode switch in
steam_unregister, as that shouldn't persist while the client hdev is open.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[Lee: Omit coalesce_rumble_work cancellation as 1d4549fd1115 ("HID:
      steam: Coalesce rumble packets") is not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 59e39bdf34ed9..df176a722061b 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -1020,6 +1020,8 @@ static void steam_unregister(struct steam_device *steam)
 	steam_battery_unregister(steam);
 	steam_sensors_unregister(steam);
 	steam_input_unregister(steam);
+	cancel_work_sync(&steam->rumble_work);
+	cancel_delayed_work_sync(&steam->mode_switch);
 	mutex_lock(&steam_devices_lock);
 	list_del_init(&steam->list);
 	mutex_unlock(&steam_devices_lock);
@@ -1301,24 +1303,24 @@ static int steam_probe(struct hid_device *hdev,
 static void steam_remove(struct hid_device *hdev)
 {
 	struct steam_device *steam = hid_get_drvdata(hdev);
+	unsigned long flags;
 
 	if (!steam || hdev->group == HID_GROUP_STEAM) {
 		hid_hw_stop(hdev);
 		return;
 	}
 
+	hid_hw_close(hdev);
 	hid_destroy_device(steam->client_hdev);
-	cancel_delayed_work_sync(&steam->mode_switch);
-	cancel_work_sync(&steam->work_connect);
-	cancel_work_sync(&steam->rumble_work);
-	steam->client_hdev = NULL;
+	spin_lock_irqsave(&steam->lock, flags);
 	steam->client_opened = 0;
+	spin_unlock_irqrestore(&steam->lock, flags);
+	cancel_work_sync(&steam->work_connect);
 	if (steam->quirks & STEAM_QUIRK_WIRELESS) {
 		hid_info(hdev, "Steam wireless receiver disconnected");
 	}
-	hid_hw_close(hdev);
-	hid_hw_stop(hdev);
 	steam_unregister(steam);
+	hid_hw_stop(hdev);
 }
 
 static void steam_do_connect_event(struct steam_device *steam, bool connected)
-- 
2.53.0



