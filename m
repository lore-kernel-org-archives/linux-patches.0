Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F48B236424;
	Mon, 10 Mar 2025 17:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627414; cv=none; b=QXRYiyxohrCwBQmgJY+at5JyEVZqNXs+5Ip4tqBjWk890wgeK/wscyS+7yTUElBL08p+p9r8h+isbHuY+/2tx+3Jiv394BVREOCYAunJQD8WnE7gEYdcDI1Gpri7jdmwxj/YersbWWvfswWlNwlQ5rxqQ6I6ecnFEeOrAjq9YIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627414; c=relaxed/simple;
	bh=o//9dZDBBdQoDbSLIhTVYQPRTq7noHn4sb8rZPg5H7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5t4X7XewxsRkjzGQbIvTuDATOOl5PCyFU/wMeiOnhcqxPXKxRS9WTH0pSo0yHM7AeBi3SQO8jotZxk3v4e+b5yEtlAEoFHOXdTkc/pS+mKGN1jIqbtZwLSOISb1LJ8UAYh1TdXGqVfS/IeZZkuCDZihqDH4ED92LcAcanF6rYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQSt4HTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQSt4HTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87623C4CEED;
	Mon, 10 Mar 2025 17:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627413;
	bh=o//9dZDBBdQoDbSLIhTVYQPRTq7noHn4sb8rZPg5H7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQSt4HTUQVP2npH9UhuRfZjoPd7NTaf2jhr4bRWK182O+692LtzppF8gFKqQMfJP6
	 gcPDsjBHHsRD8XBbR1WLDMTfg8nPK6Ryp3sDXbSwyCFljqBFTVXv6uXG7mOJsLuYF6
	 nMxtkvnyvFVM+u4D1u9THGcfnMLN66/GrVrttFhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2e5c1e55b9e5c28a3da7@syzkaller.appspotmail.com,
	Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 122/269] wifi: nl80211: reject cooked mode if it is set along with other flags
Date: Mon, 10 Mar 2025 18:04:35 +0100
Message-ID: <20250310170502.584519402@linuxfoundation.org>
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

From: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>

commit 49f27f29446a5bfe633dd2cc0cfebd48a1a5e77f upstream.

It is possible to set both MONITOR_FLAG_COOK_FRAMES and MONITOR_FLAG_ACTIVE
flags simultaneously on the same monitor interface from the userspace. This
causes a sub-interface to be created with no IEEE80211_SDATA_IN_DRIVER bit
set because the monitor interface is in the cooked state and it takes
precedence over all other states. When the interface is then being deleted
the kernel calls WARN_ONCE() from check_sdata_in_driver() because of missing
that bit.

Fix this by rejecting MONITOR_FLAG_COOK_FRAMES if it is set along with
other flags.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 66f7ac50ed7c ("nl80211: Add monitor interface configuration flags")
Cc: stable@vger.kernel.org
Reported-by: syzbot+2e5c1e55b9e5c28a3da7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2e5c1e55b9e5c28a3da7
Signed-off-by: Vitaliy Shevtsov <v.shevtsov@mt-integration.ru>
Link: https://patch.msgid.link/20250131152657.5606-1-v.shevtsov@mt-integration.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4218,6 +4218,11 @@ static int parse_monitor_flags(struct nl
 		if (flags[flag])
 			*mntrflags |= (1<<flag);
 
+	/* cooked monitor mode is incompatible with other modes */
+	if (*mntrflags & MONITOR_FLAG_COOK_FRAMES &&
+	    *mntrflags != MONITOR_FLAG_COOK_FRAMES)
+		return -EOPNOTSUPP;
+
 	*mntrflags |= MONITOR_FLAG_CHANGED;
 
 	return 0;


