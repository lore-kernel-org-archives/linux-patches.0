Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955B31CAA82;
	Wed, 19 Feb 2025 09:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955805; cv=none; b=qndgCcBIWCTBu011hJIxAyTi1ZSA2w2zqz9Kf63Jmsp8NP7uZGUku8Lqp+nrURy8gpHIoq5Z8xXwZH0gNJ/uTVr7ySFkP9IItvjHofS2NEfBpyRwNWC70VeL+9tL0H0bC71AzPcMAC/FHyuQFbqscwzV9ac/vVYIGhBbeihqPbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955805; c=relaxed/simple;
	bh=svYiF0TfHUZFQTUiq7XWMo3+dOgR3NJNeGDNyfNFQbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIFyh/OF8y1RYn59SSCdPwLF781bPa2iE7bqGcj/ZxodeXTp2DHFFj+EY2jyUucx2yOdGB3cbbHWv77Vq0RiGpRS6ctLkreyv5NLfVYTCgypaBiPYlVlXLlCpUl2JupFp8LU+0XdqZqFOqHrP4xPkQ0jRAnW0RaczjnkUHNjcQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1v3DE7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1v3DE7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7CFC4CED1;
	Wed, 19 Feb 2025 09:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955805;
	bh=svYiF0TfHUZFQTUiq7XWMo3+dOgR3NJNeGDNyfNFQbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1v3DE7qSQHsq+neiMkqFoZmxqE6RGWnVSOvCyLejqG0O2iiR1gB3hO3S3iUAX6Lq
	 efW5nyRPHSmLHWOofypnLih5omZYU+Gh4kX2GtgwZBY+ERvwyI5Mdp1dnWfnORojrC
	 0HrFcSoEczcu8o2h9PNa2vjOVuOtnsFWtxh8WEJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/152] HID: hid-steam: Make sure rumble work is canceled on removal
Date: Wed, 19 Feb 2025 09:28:52 +0100
Message-ID: <20250219082554.761079103@linuxfoundation.org>
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
index 29a0e1f395339..a25d0034dc1ea 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -1304,6 +1304,7 @@ static void steam_remove(struct hid_device *hdev)
 
 	cancel_delayed_work_sync(&steam->mode_switch);
 	cancel_work_sync(&steam->work_connect);
+	cancel_work_sync(&steam->rumble_work);
 	hid_destroy_device(steam->client_hdev);
 	steam->client_hdev = NULL;
 	steam->client_opened = false;
-- 
2.39.5



