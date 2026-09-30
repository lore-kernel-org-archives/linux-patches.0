Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F646372680;
	Wed, 30 Sep 2026 15:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783615; cv=none; b=q+caSwqnB7X+Dq9wYj9cw9JRe3gmE3lqLImcqKp+zWeGIhsQ5vos3VQBfPFHOE3hIp3Jeom3R0xymoFoGrEn0u2PJyNyh3TQ5kV8HsBk4tRmjX4Oj1KZzo0/pGDQkyzp7K4tbQEy1xrxzMV1GF/P56v6YfYWMEdK1kgm+toysGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783615; c=relaxed/simple;
	bh=8fCOrWASNZ7of48xRO17g/dLBkiiTFFtsIlao605m5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUHi094YLsA8r7Gp7jvcTBYkNwciO2+rPn39iOj1UXvJ46jJmtzUXrlKhWZG19oDFWMhFHug3BZJzLeHTe2VDuHmlHGH/wcLzXCCiN2/i6g2bunjETOEGhl/KBAJdHr83sLvAAS8tpwP6rjGDl+ciQbdhsT4tFP0hgqrM7Mzxaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ba0ya2y4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ba0ya2y4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAAE1F00898;
	Wed, 30 Sep 2026 15:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783611;
	bh=j4rpHMEIQYKo4NFwAw/ojMgeuo+g9bRFax5IeQSlO/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ba0ya2y4DFaX05QWQApneoDja4CZmvzbY72twVauL2g09aZ8wDciq5xcGHKOQfqef
	 fB3RXfazAuVfmK31PJ/nPmU6DcrsgcOkLv3Fkv53R+Y2h4JcN53qvYu9eQS2NJ1JUs
	 5xuCt7gRrZ0qZFW4K2G+WbHS9i9Ww32PBYfuRdG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 461/595] wifi: brcmsmac: fix UAF in brcms_free_timer()
Date: Wed, 30 Sep 2026 17:25:54 +0200
Message-ID: <20260930152357.598942795@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


