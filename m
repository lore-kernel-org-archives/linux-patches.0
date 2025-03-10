Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD92226D0B;
	Mon, 10 Mar 2025 17:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626833; cv=none; b=Qgtl63uNa6x8XbtOS/UWOF5CZSxe+Jsbhc5ddr2OQdZszDmgzTjAB1T92S72dCczyLtZldDBf0BqNF58OAkD9L7bi3gajfsBqelLAUH0nc3dHG1xTxOK7C78j8wTdqs5wJLUctAkMT2ppgV/HaLfWU8kUjCxEeiyySpVXM+1q8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626833; c=relaxed/simple;
	bh=sBKEfCExQUnHw7or5Jbu3i6Ioz4eTrsZSa1QB6tfb4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riF1OxzybX75Zl+/uuRxc/B+vydLLBmuACwURx7yZwqXyyrp53P2Dfqg0hjwkF8CWIqm9pXct/GDQdPxkCfPCvJve3QqyP8GDMIwu+gaRM8LvfCA+X18xADjXDYPwyN5to9cR240yzJu/4SwVy8xbiziwmiCTyURnXFiHP3G5dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TodMhCTn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TodMhCTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14721C4CEE5;
	Mon, 10 Mar 2025 17:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626833;
	bh=sBKEfCExQUnHw7or5Jbu3i6Ioz4eTrsZSa1QB6tfb4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TodMhCTnm+V8B7BawvVa5yEIIAHBauUy8aolIn9I5VReVpq6/1QghOFLA4NtqPXBi
	 I3KSsDjRjtzzTqw1E5YCTua+pauMzWE/duZxhkS/T5tn98A+0m9ZUpF0EBZlR5IJJa
	 Jp7lu5lLdQIlH+Qn9/4Ge/TTmHLrOD84UlV9271M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0154da2d403396b2bd59@syzkaller.appspotmail.com,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 128/207] HID: hid-steam: Fix use-after-free when detaching device
Date: Mon, 10 Mar 2025 18:05:21 +0100
Message-ID: <20250310170452.892699640@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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
index 5f8518f6f5ac7..03e57d8acdadf 100644
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



