Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0EB14C585;
	Tue, 20 Feb 2024 21:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463204; cv=none; b=oQMZxoT8i8c7eyQDMN/PzeVPVLvscoXymfayiSbZtLBtTnE+du6zrw5qFf+Tv3qoHq4nXtTP6gxUmuJpFkM2rVOZpdeKYQk8ilVQHgyGJ9CH4/pXQf5641/67qF6DvZZGaQwETSjPJUo4pmE0Q6fld4kULTJmxD6KhVJTkuIFaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463204; c=relaxed/simple;
	bh=q9HEL2+61KAw3apAthjOIkh+dSihVo3WyibisEfU+lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImkOqxM1WwZU0Hzp/rYH6HoPEN8jvaQlR2Du0i8GhkGfKlrRInEdeAltFftwZaezqoajnU1nZJh6UTwtrnjT/rOYhyzxQHlu8RD612lMapZQ1BW6zuuCnYdE+D1H4mgmZGWlMAyZ85dEwDi/tjwv9z9bMo+ApxNBqjdgaWye37c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XzzGldQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XzzGldQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45477C433F1;
	Tue, 20 Feb 2024 21:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463204;
	bh=q9HEL2+61KAw3apAthjOIkh+dSihVo3WyibisEfU+lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XzzGldQ+hpzH2tZfdzlIwUy92sExzzd0N2uoe6oOtKX8n0EHHpFk/cn2KZzVG+boC
	 KcE/iru2ge+WWNSajtqxMuXN//tAf0BDDCF1++fHm3CEP7doDpAhHSnl8jSXC47sTS
	 oL/SOlY59CbXvdROuMffY/Xyk7NFExlF+pX9Qir0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 140/197] wifi: cfg80211: fix wiphy delayed work queueing
Date: Tue, 20 Feb 2024 21:51:39 +0100
Message-ID: <20240220204845.259511585@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1671,6 +1671,7 @@ void wiphy_delayed_work_queue(struct wip
 			      unsigned long delay)
 {
 	if (!delay) {
+		del_timer(&dwork->timer);
 		wiphy_work_queue(wiphy, &dwork->work);
 		return;
 	}


