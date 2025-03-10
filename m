Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ED223371E;
	Mon, 10 Mar 2025 17:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628069; cv=none; b=Qlv318AuDh/4az/U7udlB9SaTa9B1VuQBBXWb4P4FAZxKHDSb1Gk845FUO5QNhoJq7/SewwRifEl2zWmWS92TI4cEIE3n4wGwMQmBi7jLVdmxj6nxBkxQ6RtLOpnVG4l4Vv2OCgwxrRvyCyPDsL/86/kPq24Y92SVSFaX82JEds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628069; c=relaxed/simple;
	bh=AnEMON0aJ+eiS0qb//hfmpo01J1g/XZMEVGamDkCBfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q07Tm/DFUXedbv1sCnkTIYC2QQDkBRcw/XOMQoWsrCMeAdf2sXkyuu7IUPvRtPDLZEn5QRJYqDHFUyHzN58VzKB1zloqt9jcu3S4ypwRmAOiBVpIutLDOVJw/gBEUpRLnKijDvIXgEoWQ7KuwfqW5Fn5U9p49zuPMXBQNcz32TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ed0LYzbh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ed0LYzbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7880DC4CEED;
	Mon, 10 Mar 2025 17:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628069;
	bh=AnEMON0aJ+eiS0qb//hfmpo01J1g/XZMEVGamDkCBfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ed0LYzbhTSooJ5yjNucH1UK9SqWG7+vksY6/+UL+C+4qa4u7DDfVRaZisnkxI4xAW
	 Rb1zzDfkHSbv2jwSJcMm604XUaR70CTtPrSTzYJ5v4K3CkNVwRdgoAHGH10C37ayhr
	 Cdqvg2Bof3UO6NY5GxUZOD9cW74pPL26VCji5+8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0154da2d403396b2bd59@syzkaller.appspotmail.com,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/145] HID: hid-steam: Fix use-after-free when detaching device
Date: Mon, 10 Mar 2025 18:06:11 +0100
Message-ID: <20250310170437.860874994@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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
index 49c067133975f..29ff4eb5194b7 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -1325,11 +1325,11 @@ static void steam_remove(struct hid_device *hdev)
 		return;
 	}
 
+	hid_destroy_device(steam->client_hdev);
 	cancel_delayed_work_sync(&steam->mode_switch);
 	cancel_work_sync(&steam->work_connect);
 	cancel_work_sync(&steam->rumble_work);
 	cancel_work_sync(&steam->unregister_work);
-	hid_destroy_device(steam->client_hdev);
 	steam->client_hdev = NULL;
 	steam->client_opened = false;
 	if (steam->quirks & STEAM_QUIRK_WIRELESS) {
-- 
2.39.5



