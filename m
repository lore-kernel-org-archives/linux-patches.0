Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7133BED30;
	Sat, 17 Oct 2026 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257457; cv=none; b=JZFaxMgTRNbovF7Mmn/ADiwbTH5aiTWe2572mYMJvlWpB94s4x4EmNpM/nS593jrtHyP7KpyVSE8jIBoBHS6wOxGRxqYqJJSDm7ankjrA/KGPDEmn/Bv4iHQAxGLLUc04TvhpyKy5wg2/tJ2kD9271605eqknkgHegkst9aJXvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257457; c=relaxed/simple;
	bh=URerZM68h8ESlAPn8e/oqDIaSn3pZsNbWMRlQA99vSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEe/WB1Uapfa+BxfyZxC0IV1foWR+cmJMLgdVd8u88gLnLLUt94JQt8LEXMoiwa/nwE1+3FTdOOtz9jIHsk8O6RWp7GfUJAZwUwoXv0uNaTV+EhluHcugXZgqGVAbOBZAOkUWvZz6Ffu8dWLJaN0R8bu6fufiYj2BZDu6yGz+xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xh+iHFno; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xh+iHFno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E519D1F000C4;
	Sat, 17 Oct 2026 17:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257456;
	bh=7fvs+U5spgcUjCmnpa/63ggAAggPlpJzo2vgnCwBP6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xh+iHFnoF4VzMFDALk8CbUPzQcBbZVDfUqehmqe7mU+N4eBSU9M47/G8LE1vubJoE
	 RrPPsH70aWSlGge/zLDoewJQMR/m++8/Ylhu6qcyFRbbfuuKc0RemQQj80e2FSP1ZX
	 Qk11cSp3dqJ/5kJWd1w7rk27M1IPa3ZQ8NBUhB9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0563/1674] HID: hid-steam: Make client_opened a counter
Date: Sat, 17 Oct 2026 17:47:15 +0200
Message-ID: <20261017160445.545823472@linuxfoundation.org>
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

[ Upstream commit 555b818adb97eca70210a49ba3f1d27882dde092 ]

The client_opened variable was used to track if the hidraw was opened by any
clients to silence keyboard/mouse events while opened. However, there was no
counting of how many clients were opened, so opening two at the same time and
then closing one would fool the driver into thinking it had no remaining opened
clients.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 29ff4eb5194b7..d390ac5aee0da 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -294,7 +294,7 @@ struct steam_device {
 	spinlock_t lock;
 	struct hid_device *hdev, *client_hdev;
 	struct mutex report_mutex;
-	bool client_opened;
+	unsigned long client_opened;
 	struct input_dev __rcu *input;
 	struct input_dev __rcu *sensors;
 	unsigned long quirks;
@@ -952,7 +952,7 @@ static void steam_battery_unregister(struct steam_device *steam)
 static int steam_register(struct steam_device *steam)
 {
 	int ret;
-	bool client_opened;
+	unsigned long client_opened;
 	unsigned long flags;
 
 	/*
@@ -1138,7 +1138,7 @@ static int steam_client_ll_open(struct hid_device *hdev)
 	unsigned long flags;
 
 	spin_lock_irqsave(&steam->lock, flags);
-	steam->client_opened = true;
+	steam->client_opened++;
 	spin_unlock_irqrestore(&steam->lock, flags);
 
 	schedule_work(&steam->unregister_work);
@@ -1154,7 +1154,7 @@ static void steam_client_ll_close(struct hid_device *hdev)
 	bool connected;
 
 	spin_lock_irqsave(&steam->lock, flags);
-	steam->client_opened = false;
+	steam->client_opened--;
 	connected = steam->connected && !steam->client_opened;
 	spin_unlock_irqrestore(&steam->lock, flags);
 
@@ -1331,7 +1331,7 @@ static void steam_remove(struct hid_device *hdev)
 	cancel_work_sync(&steam->rumble_work);
 	cancel_work_sync(&steam->unregister_work);
 	steam->client_hdev = NULL;
-	steam->client_opened = false;
+	steam->client_opened = 0;
 	if (steam->quirks & STEAM_QUIRK_WIRELESS) {
 		hid_info(hdev, "Steam wireless receiver disconnected");
 	}
-- 
2.53.0



