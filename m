Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB932F28;
	Mon, 10 Mar 2025 17:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627689; cv=none; b=skYYZmw6pwQE8XMHAH/3lnHs/7eUYJnDbUWBxKqeFIsh02bJQi9pt1mv4rManfUCMo0dHs6Cs30dY/K0zMe64Y/AlABuuah85v4dfaSYv5SJuvX01rAnoC/9teFU9dPMg8i7jGhVxuvQgsS3jjtu/iu+T0O6mSFtzaua95GRzWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627689; c=relaxed/simple;
	bh=yQtIqnj5fwGkfxPLG7PvdOltm8eN3whRD8k2VP0cneE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcAQFcgN6axp1Rh6wE4g+kYO6CqjWUzwztHxoYhWXQ97m14u1FHPPtGNLvaXUUimfsup65kSlVRMQjJ8i8GahhsKwGuTN0ENXPIy/uO2TPalwTBo4bsg9gFsXCVZc7hWRemG3CmLQ28XaHg5VFV5mmP/PGWEDDN2SxbpiSyq9yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKEGaJDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKEGaJDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51412C4CEE5;
	Mon, 10 Mar 2025 17:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627688;
	bh=yQtIqnj5fwGkfxPLG7PvdOltm8eN3whRD8k2VP0cneE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKEGaJDr0Y+/cJX2FVvIOAcPkw0eEWgKxLRUJx7r6X9vucnzOpBu53VBkYXLq67yh
	 o7Ry482yHFD5ah0hek8m8cjK+mhUUWIex3mUUew9kohkPLDzTgSc2kNAitWZHbri3o
	 tJX2hbjYZxucI38holcR4DC1+g2Sz3SZ39NG1AIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0154da2d403396b2bd59@syzkaller.appspotmail.com,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/269] HID: hid-steam: Fix use-after-free when detaching device
Date: Mon, 10 Mar 2025 18:05:37 +0100
Message-ID: <20250310170505.042220051@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

[ Upstream commit e53fc232a65f7488ab75d03a5b95f06aaada7262 ]

When a hid-steam device is removed it must clean up the client_hdev used for
intercepting hidraw access. This can lead to scheduling deferred work to
reattach the input device. Though the cleanup cancels the deferred work, this
was done before the client_hdev itself is cleaned up, so it gets rescheduled.
This patch fixes the ordering to make sure the deferred work is properly
canceled.

Reported-by: syzbot+0154da2d403396b2bd59@syzkaller.appspotmail.com
Fixes: 79504249d7e2 ("HID: hid-steam: Move hidraw input (un)registering to work")
Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 7b35966898785..19b7bb0c3d7f9 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -1327,11 +1327,11 @@ static void steam_remove(struct hid_device *hdev)
 		return;
 	}
 
+	hid_destroy_device(steam->client_hdev);
 	cancel_delayed_work_sync(&steam->mode_switch);
 	cancel_work_sync(&steam->work_connect);
 	cancel_work_sync(&steam->rumble_work);
 	cancel_work_sync(&steam->unregister_work);
-	hid_destroy_device(steam->client_hdev);
 	steam->client_hdev = NULL;
 	steam->client_opened = 0;
 	if (steam->quirks & STEAM_QUIRK_WIRELESS) {
-- 
2.39.5



