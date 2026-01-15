Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371512D73BE;
	Thu, 15 Jan 2026 17:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496463; cv=none; b=nakxhno4vy4mZt/YmX6ENBfLQ065s2LapXWolyK9VNVyMw4WnQwI8Jm9kcZySvtpJoiwt1zIR9ImS42Yo4Nm0RfZnipT9yOpcxb5jELhErz6UfQwxDd9hHft8bdklBBSJCUV7K30pwuX85xNACK80QOrqJ6WojNnWIbsIL+pwKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496463; c=relaxed/simple;
	bh=dEwORo43Ux+z3oFxKwrZOTrVdeasUwzL1H72tTPFUYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/n/3LFM9SXmHBK9HUhaplFQCE05km71jowjdKHSCQG8+umXHIY6kh9ZnRPBlt4/lUWkBeZU1qocp5MVZy4CIRnonFpUKv1yBL7F8dJYqH7x7kWCvbvekehW8SSyk+RBVZ45Gzx5fd9amf5Apo978XTxpHKxboJFg3R8eJXjMUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uasv9aZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uasv9aZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54DFC116D0;
	Thu, 15 Jan 2026 17:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496463;
	bh=dEwORo43Ux+z3oFxKwrZOTrVdeasUwzL1H72tTPFUYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uasv9aZWxdPEYqtT8zPRgjbqqOweWnB7aBq0atVmPYo1dfMzADP4BGaSGjVjpARwO
	 yKQouJPv2Xi0wBoe7x6MFR0PN2fYUzxiLHWezdrb824WXcs8KVFVlMphpI76HXXEEe
	 Er2yxfy4dh/m4At2XSFpBHwuo6x8bmEfcW5OvTZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Oscar Alfonso Diaz <oscar.alfonso.diaz@gmail.com>
Subject: [PATCH 6.12 021/119] wifi: mac80211: restore non-chanctx injection behaviour
Date: Thu, 15 Jan 2026 17:47:16 +0100
Message-ID: <20260115164152.726117811@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit d594cc6f2c588810888df70c83a9654b6bc7942d upstream.

During the transition to use channel contexts throughout, the
ability to do injection while in monitor mode concurrent with
another interface was lost, since the (virtual) monitor won't
have a chanctx assigned in this scenario.

It's harder to fix drivers that actually transitioned to using
channel contexts themselves, such as mt76, but it's easy to do
those that are (still) just using the emulation. Do that.

Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218763
Reported-and-tested-by: Oscar Alfonso Diaz <oscar.alfonso.diaz@gmail.com>
Fixes: 0a44dfc07074 ("wifi: mac80211: simplify non-chanctx drivers")
Link: https://patch.msgid.link/20251216105242.18366-2-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/tx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2395,6 +2395,8 @@ netdev_tx_t ieee80211_monitor_start_xmit
 
 	if (chanctx_conf)
 		chandef = &chanctx_conf->def;
+	else if (local->emulate_chanctx)
+		chandef = &local->hw.conf.chandef;
 	else
 		goto fail_rcu;
 


