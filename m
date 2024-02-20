Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D40612D7;
	Tue, 20 Feb 2024 21:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463962; cv=none; b=RRfa3VuKvLp47GqRg4SdCGW/9UPj2Ej429HX4NXdPwEnMiSknllUUeRegbbR81fmLYHnDvxLlgdbybV5WkS55gmggYHanhnpQLbXOQVP6r+FMf2MmlcYNEc26bom20xKYKJAr7mszm3BpEU73GLVwsHjcs2LcsI4Hpl4FrjcvN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463962; c=relaxed/simple;
	bh=tgPTSnh/qb/hRJcRO9UPhGiAT0Gh0uMXBy43QX1aESw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBF/TTXeoxO+QidhnX3yyBDeU/4ICdc2Zk6zf/o11Mjw4EilVCy1ieCTULL/YSl66/Oi48430GOHwYpSy1vAU3UphXq9Gl58J9MZNpYja2uhDvO2560lPErEm/RabZIcTH08KaIDThcHze1dsYRF3+/Hj0g29GQLQXsJgCv9wYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chk5SqJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chk5SqJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0547EC433F1;
	Tue, 20 Feb 2024 21:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463962;
	bh=tgPTSnh/qb/hRJcRO9UPhGiAT0Gh0uMXBy43QX1aESw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chk5SqJ9ZlkZnWB3z0r1OrbFo9OkFt1qe6aLqtLueN72FqgQ6kBd/IbBmsR3Bp0E6
	 n34UX8pkz2C32QHfca7nd1Q2F4QzbOt0b4JP8kKbI2LeB8hkjujCY7stZo9XJJQhfo
	 Kt53PC9Nv7bKgeLLZGaf5Lvblxq/7bBSzQp6pNGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 207/331] wifi: cfg80211: fix wiphy delayed work queueing
Date: Tue, 20 Feb 2024 21:55:23 +0100
Message-ID: <20240220205644.203750556@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 net/wireless/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1675,6 +1675,7 @@ void wiphy_delayed_work_queue(struct wip
 			      unsigned long delay)
 {
 	if (!delay) {
+		del_timer(&dwork->timer);
 		wiphy_work_queue(wiphy, &dwork->work);
 		return;
 	}


