Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E1614F9DA;
	Tue, 20 Feb 2024 21:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465148; cv=none; b=fY/Gf/Ipkz3LJNCuewz+4VTtzQ9KTkgy/fBZOM1EGsR+UqsFz0vVzqOxLoY999Lng9whR2JfIYLWxe4AF1U95myM/DKZ96CJjNgjVVkzQekWNeHGdLexIK0Wojj10dIlz659ASVQnqkTFKJZNoXWN0I/9wY3FG3ghU5bNA088oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465148; c=relaxed/simple;
	bh=VG05iOsIOttXd8xEwkSUcamU8bjfepln6wFRzkpqdiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpgyugO8N0Lp2zwnFDGPDXl+81xe+AkZjOqPl+q0Z4TbBBZSirew0fT8K0YUo+mqgkYLevamqHEEEEPiBsM5ZBkLeh7NvwptKTEXWu6LlJM2xiohYjuIFW5XSssNjJjJG1mlZtxeLg7ymv0RyrV42N+DU82gBh8xJqoQjGo4720=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvCWAUrO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvCWAUrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213A0C433F1;
	Tue, 20 Feb 2024 21:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465148;
	bh=VG05iOsIOttXd8xEwkSUcamU8bjfepln6wFRzkpqdiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvCWAUrOgd6oZ3PN6dDYAU7dGLSyhlt/WrXBQ8Sx/G+KED+LWZjAioVb2eBPe5yhI
	 WAWCtgYyZSKM16Pwyp2rvfWcpGa0b/MxS6sJbKis3sFJjDfw6s3BwO3epBw29rR72J
	 ZrtsXdUtgNM4iRm9cKYncQe6mK9hHsj1Djim6S4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.7 251/309] wifi: cfg80211: fix wiphy delayed work queueing
Date: Tue, 20 Feb 2024 21:56:50 +0100
Message-ID: <20240220205641.022971418@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit b743287d7a0007493f5cada34ed2085d475050b4 upstream.

When a wiphy work is queued with timer, and then again
without a delay, it's started immediately but *also*
started again after the timer expires. This can lead,
for example, to warnings in mac80211's offchannel code
as reported by Jouni. Running the same work twice isn't
expected, of course. Fix this by deleting the timer at
this point, when queuing immediately due to delay=0.

Cc: stable@vger.kernel.org
Reported-by: Jouni Malinen <j@w1.fi>
Fixes: a3ee4dc84c4e ("wifi: cfg80211: add a work abstraction with special semantics")
Link: https://msgid.link/20240125095108.2feb0eaaa446.I4617f3210ed0e7f252290d5970dac6a876aa595b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -5,7 +5,7 @@
  * Copyright 2006-2010		Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright 2015-2017	Intel Deutschland GmbH
- * Copyright (C) 2018-2023 Intel Corporation
+ * Copyright (C) 2018-2024 Intel Corporation
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -1661,6 +1661,7 @@ void wiphy_delayed_work_queue(struct wip
 			      unsigned long delay)
 {
 	if (!delay) {
+		del_timer(&dwork->timer);
 		wiphy_work_queue(wiphy, &dwork->work);
 		return;
 	}


