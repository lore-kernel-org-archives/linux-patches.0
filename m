Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3546502D5A;
	Wed, 30 Sep 2026 18:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792195; cv=none; b=hJtrz+iK+i3cMPef4V+mR4VHPukOrIRYjykGK8oxExhvX9IXLpJlt2Dp3vrofD9f2N56eWn99eSMGnmuWNCWq0AEATYs2EiQSEErzoQCpWY1SdPnuYn7T33Nhi4+IoTlVSopWONOA/KBdsw+PREIwcjD4bKaSXt9hoPdEp/qg08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792195; c=relaxed/simple;
	bh=2gQjPXC6QQSZ66qA3AYNqoqaW7m3/SUbGq8tb+c2W1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VNq7nuNCeaze8ffnJ2bpTXdZFJ0y5mx2FWScjc8vIeJyOuyIbKP6pA2sEUWkbH56Bw0B9Up46Zz+0ltVXXFv1OZFcFb4M85PPE3YnLM8nrbMVhS0GpHVU0lG2y8/bMjkCKEEp27ukcf9Yv8HXdGPvOckqkkRPt7u8YHeec2X55E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQPVh56X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQPVh56X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105FB1F000FF;
	Wed, 30 Sep 2026 18:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792194;
	bh=g9R7LLaCIPfGibyLjEod7B6CMD/MWBOoSfTx+E373mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vQPVh56XCFs+ayC/POX969ko0HKuEPleP7Sxy0Gi7dfsma4YF0Rm4HiuOwm0NEF9t
	 Iv90m+GUsFn64FBXpk4GKTtrPW6elXk7X8ujOfpQ8o3jbC6IXhOx9KeZFBfeCjtTZc
	 Q+SwL2qZ4cEC8h9UNodyAdFLWWNuZ+Zqv420050Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 570/752] wifi: brcmsmac: fix UAF in brcms_free_timer()
Date: Wed, 30 Sep 2026 17:27:20 +0200
Message-ID: <20260930152410.568590475@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1567,6 +1567,10 @@ void brcms_free_timer(struct brcms_timer
 
 	/* delete the timer in case it is active */
 	brcms_del_timer(t);
+	/* Ensure the callback has finished before freeing the timer
+	 * structure, since brcms_del_timer() uses non-synchronous cancel.
+	 */
+	cancel_delayed_work_sync(&t->dly_wrk);
 
 	if (wl->timers == t) {
 		wl->timers = wl->timers->next;


