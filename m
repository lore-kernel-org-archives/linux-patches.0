Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2F21CAA85;
	Wed, 19 Feb 2025 08:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954518; cv=none; b=Q2Bu0A/aLeqo08+iK1Q6myDO454h8wNmp9tf/lrr80rmzMoytf98+smIEedOCrzRCnCtthZFwIuVf4fxf4J6jP0EhhMaqO6IIj1WWgGW+i0+GfiZnLTjvn4Ldb789GlYrMw4oQgroYE9SICIQdra8FpLozNg/SQuRtJJU6xXon0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954518; c=relaxed/simple;
	bh=vALNSSbQYXuXux6dLwapUBaX30c2IRe2F1tYl/vCj18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1sPGcGgA64Ry7SUJliqU8y/xhmqIID5nLCNANDaiimIq5U47PZSqhBOBXbWRW1HrAk6u56g+lpefZSGKfhXgkbZkNMGfDWnAjOC9IzhOT9qEI5tU32pgNvnZt2kL8Lav7Sjugmsa4P4qtXBoIYqHyhdwlJYkFh4YKin9hnK5UE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcFQDDkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcFQDDkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BE4C4CEE7;
	Wed, 19 Feb 2025 08:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954518;
	bh=vALNSSbQYXuXux6dLwapUBaX30c2IRe2F1tYl/vCj18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcFQDDknb4kd9y3RORkPCEHhKAz6EzuVvQ5iOCm72Q/2DndE0PB11OV+who1hvLlw
	 mxbFbOnve1rst5BzvpEOIhrO7FLQQZinUBSCuhuLg7V4kJ8KU1xf/t+oKshrPdyLW0
	 M/4xJZzNhuFVZ4RaZiRjoAWGtmSQca+CqDhrGMOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 227/274] HID: hid-steam: Make sure rumble work is canceled on removal
Date: Wed, 19 Feb 2025 09:28:01 +0100
Message-ID: <20250219082618.461665569@linuxfoundation.org>
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

[ Upstream commit cc4f952427aaa44ecfd92542e10a65cce67bd6f4 ]

When a force feedback command is sent from userspace, work is scheduled to pass
this data to the controller without blocking userspace itself. However, in
theory, this work might not be properly canceled if the controller is removed
at the exact right time. This patch ensures the work is properly canceled when
the device is removed.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 79504249d7e2 ("HID: hid-steam: Move hidraw input (un)registering to work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 12a6887cd12c9..48139ef80dc11 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -1306,6 +1306,7 @@ static void steam_remove(struct hid_device *hdev)
 
 	cancel_delayed_work_sync(&steam->mode_switch);
 	cancel_work_sync(&steam->work_connect);
+	cancel_work_sync(&steam->rumble_work);
 	hid_destroy_device(steam->client_hdev);
 	steam->client_hdev = NULL;
 	steam->client_opened = 0;
-- 
2.39.5



