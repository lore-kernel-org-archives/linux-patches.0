Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3E436E467;
	Wed, 30 Sep 2026 19:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796447; cv=none; b=H9LgWr1a/KOm1J0gBOt0K7MIR+vFIm30y1OU+NI8fflf8eLqWhKNKiGkeM/b/wbOxwNhuFKsXLe0eGggHFMdSeiCVarUV9nrW+qMpx56FVK7RTCjWFVCe/bljHV5ZwXP7V+/fpXlnYGhbSLyOTdJi7dnh6R2hGXyyJ6yD8q4oXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796447; c=relaxed/simple;
	bh=9Wuyv259v9Ps6E3/TLKPBYu1qzZ0jlBLzDfQeDWbiww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=te89TpNYrfyJPY+aD6TRPUKsiCLUJ1GUbJj0Sfxf+O/tjo44VMnTN4YodfqXbuUN61g2vMjneMQj5u6qgKf2jX+JXzQxm/KBoSH+DhhC/1oppvbHaxrZDcYmeBr6rxWhzVfsJmhWVvQt0C8+8ZrRlUJsTTNSskAWa6ENh9mNuKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZnzEYTn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZnzEYTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9771F000FF;
	Wed, 30 Sep 2026 19:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796445;
	bh=7CNMCbvuHa4kURvjHpYiEm3I++RAt3LRxuZd9a9tMoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZnzEYTn6j99YSu1x+bxoP6239pG+lNYwl9vqQjZlTIu19H890gvU9UkkkEJbYOTl
	 PJfDo3s71yTR0l+jE8ceQUSKixtKrNRpH1j8k4MBq7VMlu46qalahyJNPxdCpgAa9B
	 qCpepHMM20OaMOWTh+uIlhLaVsA0QsSUsaKG/g48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 0917/1193] wifi: brcmsmac: fix UAF in brcms_free_timer()
Date: Wed, 30 Sep 2026 17:26:41 +0200
Message-ID: <20260930152454.613369967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1565,6 +1565,10 @@ void brcms_free_timer(struct brcms_timer
 
 	/* delete the timer in case it is active */
 	brcms_del_timer(t);
+	/* Ensure the callback has finished before freeing the timer
+	 * structure, since brcms_del_timer() uses non-synchronous cancel.
+	 */
+	cancel_delayed_work_sync(&t->dly_wrk);
 
 	if (wl->timers == t) {
 		wl->timers = wl->timers->next;


