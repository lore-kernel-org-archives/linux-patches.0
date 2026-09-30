Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7623F502554;
	Wed, 30 Sep 2026 17:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788924; cv=none; b=dH69pxQoE6xFit7cXFwRSlYsiBf3AD+n9+N4QTvq2aYsJRl8Q4R/CphgQMen0NiGzo9DLk+t2HvaSEUfPUIpAjbieIiNo2eYZtZaZpPrxVFrVICsQCQfwPV+YAed0eVbVNmdRKtLyRmHI2cw9yc/VdIT4WQdh4VD7kqSUy8jXJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788924; c=relaxed/simple;
	bh=BAk+lHDuuoAvrGGNpLsxTSmQ0Tml37cF0LpbNksj9oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYiNSO98DzTE+r0GLNk+hVYA0ycIEYdlAF6NFmzjzP7p7LHH59PCRmsly0sawuHcZzoTAgYaAn9VrC1XNP7vjcQyIO6G3mqs1w9Hh7OdiinO/Sd8cslp7KK/h/pkoSica0p+jgsr+PFiLCfmyBtlC9W1iOEptwEF9WSPkcpEzbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPXwtBkA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPXwtBkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C788B1F000FF;
	Wed, 30 Sep 2026 17:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788923;
	bh=s86aXEO7dHCK+n36LmDbna9DBMWIs1XZt7EjTa528Go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yPXwtBkA1MWiKwxtr/t9OQMxoUFEzCl+RkvjFHOsWbV1zb0XeD89Fd/d3/GvEIcjF
	 yQYqZKHcNG+LCgk/j2T4OGV1aqVi2Y+4VZtRGhRB+QURTLB/2UdHkExzq14c1RlLMn
	 zJmVcVFldPc/P8DVFgryehjQM+9a+lhPPtE3gjlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 259/877] wifi: brcmsmac: fix UAF in brcms_free_timer()
Date: Wed, 30 Sep 2026 17:19:30 +0200
Message-ID: <20260930152420.311043153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
@@ -1569,6 +1569,10 @@ void brcms_free_timer(struct brcms_timer
 
 	/* delete the timer in case it is active */
 	brcms_del_timer(t);
+	/* Ensure the callback has finished before freeing the timer
+	 * structure, since brcms_del_timer() uses non-synchronous cancel.
+	 */
+	cancel_delayed_work_sync(&t->dly_wrk);
 
 	if (wl->timers == t) {
 		wl->timers = wl->timers->next;


