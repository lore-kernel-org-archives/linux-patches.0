Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BA42F531B;
	Sat, 12 Sep 2026 12:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215503; cv=none; b=hxIOFJSyH7ZGUesHWiU405RU//3BpqY5wVfp9sHVjvuBStoKicGMXmakzoIudCWcELW3QXmOGXGO0yP1xqGnAdu4rQhdz21ipPuMBKHULFHa0Tx0dT/J8kG/rfT+pj7e0RdEd4m3noSUKy8KsK/glkq/QQZjARkogvvB7QHx7os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215503; c=relaxed/simple;
	bh=wxBMUxRunpnHjS5zgRXZDlE/s1izWqRy/4ueYtowS60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/tVAu7pnStLN2Ig2AuvqGeiQKm0lgGu8wrl1KqKDUXfBdtNQUE1jP8FY7goZaHXUoUZT9Zw4Afb56U7KWDp7qiVIbuAUHBqRbyMejtAbEBJ6RyZEqhX0WCrVo1eaKaZfPzcT/qssaUUibScnFLEHwx4Rm03UfZIoJw40ygu+JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uRLxU4Pb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uRLxU4Pb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4B11F000FF;
	Sat, 12 Sep 2026 12:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215502;
	bh=3hJTYtpuBNUkbWXkESkT0f8cFlUItpTsOksKEkNKM+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uRLxU4PbV3rpom4aZv/dKMSN9WOzTbEiidmXYHzFOs+9qX7C9upKj3HXYMouGY1vm
	 qnegroE2HqC7HLrIfOzW3wmh84kqEkx3mL9Pme3cm4XEvGMFKUVTHWwMMIDCpOfAFv
	 c1zjVlcQqmLSrV8vOaWiwWs3MKzNrmgnI1Kf8+zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0544/1376] firmware: arm_scmi: Unwind P2A receiver mailbox setup failure
Date: Sat, 12 Sep 2026 08:49:30 +0200
Message-ID: <20260912065619.664815508@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit f3e3773c4e5e96549d7540d8ddeb4fcd534f6f1d ]

mailbox_chan_setup() can request an additional P2A receiver channel after
successfully acquiring the primary P2A channel. If that later request
fails, the function returns immediately and leaves the primary channel
allocated.

Unwind the primary mailbox channel before returning the error so probe
deferral or other setup failures do not leave the channel busy for later
probe attempts.

Fixes: fa8b28ba22d9 ("firmware: arm_scmi: Add support for platform to agent channel completion")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-14-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/transports/mailbox.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_scmi/transports/mailbox.c b/drivers/firmware/arm_scmi/transports/mailbox.c
index 3e662ec063c3d..f43e00c46115e 100644
--- a/drivers/firmware/arm_scmi/transports/mailbox.c
+++ b/drivers/firmware/arm_scmi/transports/mailbox.c
@@ -238,9 +238,10 @@ static int mailbox_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 		smbox->chan_platform_receiver = mbox_request_channel(cl, p2a_rx_chan);
 		if (IS_ERR(smbox->chan_platform_receiver)) {
 			ret = PTR_ERR(smbox->chan_platform_receiver);
+			smbox->chan_platform_receiver = NULL;
 			if (ret != -EPROBE_DEFER)
 				dev_err(cdev, "failed to request SCMI P2A Receiver mailbox\n");
-			return ret;
+			goto err_free_chan;
 		}
 	}
 
-- 
2.53.0



