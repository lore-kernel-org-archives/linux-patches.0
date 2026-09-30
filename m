Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F144E324C;
	Wed, 30 Sep 2026 16:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786147; cv=none; b=YhQbQE8+5xkyqHtCrdwGOoEcsI7OYb4YhqbDHA/R/Q0exQTr7B5tZmdFzFYtsBfxfpbMBrhfAVVxrdWztcoigx6oPoXTYHH8pJU7gW1VcIU0OGlyzvz5k3u0daHn6erAH+STZ4EsUS5Scq49IOEcq5HcNLdE6wk7DJP4HfXTQRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786147; c=relaxed/simple;
	bh=9GNBrXgvnj4kkBUJ2tHNVBnw/rCISrJOmogECo3EAbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEVav66kk1UO5LupU0lKeAjRw6LZgztD+iq0mJONcSOn2zaRqhF8W3bd1Hjr+b86Nei6HNMQQYAZANQA1rWnTReeoDEo7bBcZPv2wyoF6WZnMIMiz+hdvYgRdU75v+uqCtomt8Py5CDGh/uzklp6tGhZYANcqcerTChAT8VCnzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRcr3x6h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRcr3x6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09691F000FF;
	Wed, 30 Sep 2026 16:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786146;
	bh=tdFjCo2pLB0bD8BUlU7OqcDlBzClpFXlRM1NF7vMzO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kRcr3x6hxxB7MS5dRKDhW+izvtXKKlxD8tMvB9fkWKtncusDzxHQ31J+8K7/b4rlK
	 O5UTOvgvOqvbqhei+EudiJ4Py/Y6DMQvZYTpWBxrglMwGjCYIrZNRTVP6jaTP+qxjB
	 X4MGEax4WPFeAG5CQnPigUaSzYHyGIwSil15j4BU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 759/982] wifi: brcmsmac: fix UAF in brcms_free_timer()
Date: Wed, 30 Sep 2026 17:24:55 +0200
Message-ID: <20260930152433.056794557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit 1eeca1d5e0920fbdad6449768fd2d4364e714180 upstream.

brcms_free_timer() calls brcms_del_timer() which uses the non-synchronous
cancel_delayed_work() to cancel the timer's underlying delayed work.  If
the work callback (_brcms_timer) is already running, cancel_delayed_work()
returns false without waiting, and brcms_free_timer() proceeds to kfree(t)
while the callback still accesses t through container_of().

Add an explicit cancel_delayed_work_sync() after brcms_del_timer() to
guarantee that any in-flight callback has completed before the timer
structure is freed.

Fixes: 5b435de0d786 ("net: wireless: add brcm80211 drivers")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260815121043.938414-1-yijiangshan@kylinos.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -1568,6 +1568,10 @@ void brcms_free_timer(struct brcms_timer
 
 	/* delete the timer in case it is active */
 	brcms_del_timer(t);
+	/* Ensure the callback has finished before freeing the timer
+	 * structure, since brcms_del_timer() uses non-synchronous cancel.
+	 */
+	cancel_delayed_work_sync(&t->dly_wrk);
 
 	if (wl->timers == t) {
 		wl->timers = wl->timers->next;


