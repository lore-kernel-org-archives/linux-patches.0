Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035077;
	b=ByHKVlwhw5NjoQpsNXbSpyDEsUYcMzsSCCV2BCAPekEinnMPM57hPORQy+HTiV7PWEhs
	 6p5NrzgB4et9Ijnq654RZITqeRVuLlwqvPaKb0MgIYhlPY4W31EV6MkdqhO8XSKikg0mt
	 vVvR7JJ8HP2lJCfzKdQ9ZyEu6cByx8ASSLpuAO8QdS957jUWW5A3l14iKnyoO6UbFG+kX
	 lggk0LmgqKh21WTZTdce5W0te7rYTuPpJuTXpoe6zq0HzQjwdUfhuqltouSp108Zyab+L
	 XpnIDU3Epe8oE/k3dxQO/hvR9yEmZyn1ovZqQZB2Cmvkv2j4a+VDcdsUeDTfbTewQdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vyrwcS2HAUXpkEHMIB91KWbrwwOfzh5jq+5PaYuQDNM=;
	b=VoG6kZcDSbbcg2NYRNNAmyxLGynqACja63TSMQ8iUzsvl0xywp1/3E46uD8pkpdJpeM0
	 X4Y/YQLGleSzfXIECv+ZgxJ7Dw2bgCWCE09ejrwiSOXcygsMDd0bxgHauJrcIsEZbs0gv
	 My4/qUi+18ZnZ2hAd5LCyuTYABJSkx8UHQ+E9in6jO5ZkZL0D4TKLEcu7+sklkZF2gqzc
	 t27MyHRrysVdJG1Ui/vGYbKXH//qNrGJgVI1bbi2qJDGhsXjt13/BV0QgLqCLw1xcKHr9
	 K+lGuVTvYxSwPQZFGVpRCSZv4ZSh6CXQoiLnAiD0/V3iKjEaVbgzJBz0ryDZbwWKmLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QtradCs+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE780606A31C;
	Wed, 18 Nov 2026 20:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QtradCs+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503221F000C4;
	Wed, 18 Nov 2026 20:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035076;
	bh=vyrwcS2HAUXpkEHMIB91KWbrwwOfzh5jq+5PaYuQDNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QtradCs+WGhoz/XRBG0/qNxkXRVrv1VjY+Ito9CvFa4W+6H85lLZiaEIW+9tlzowh
	 qTEoL8o14S31fPcQidY6KUuH+Oy/5ta2YuO32mKRUQJdWaNw9HiP13rYFuFi8oCzWS
	 UXaZ5IbwXQeSl6i4zCXD/GwOeBH36GKIcajCEn8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0590/3318] media: au0828: fix use-after-free in bulk_timeout timer on disconnect
Date: Wed, 18 Nov 2026 15:20:12 +0100
Message-ID: <20261118150335.286691286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 521030837bee352515d5ea57cc6a29581db3506e upstream.

start_urb_transfer() arms dev->bulk_timeout, whose callback
au0828_bulk_timeout() queues dev->restart_streaming; that work in turn
calls start_urb_transfer() and re-arms the timer.

au0828_dvb_unregister() cancels restart_streaming on disconnect but does
not sync bulk_timeout. au0828_usb_release() then frees dev with kfree(),
so a timer still armed or pending at that point can fire after the free
and dereference dev through timer_container_of().

Sync the timer with timer_shutdown_sync() before cancel_work_sync().  The
timer callback queues the work, so the timer must be stopped first; the
shutdown variant is needed because the work re-arms the timer through
start_urb_transfer().  The dvb->frontend == NULL early return guards the
register-failure path where the timer was never set up.

This bug was found by static analysis.

Fixes: 53460c53b761 ("[media] au0828: Add timer to restart TS stream if no data arrives on bulk endpoint")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/au0828/au0828-dvb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -537,6 +537,7 @@ void au0828_dvb_unregister(struct au0828
 	if (dvb->frontend == NULL)
 		return;
 
+	timer_shutdown_sync(&dev->bulk_timeout);
 	cancel_work_sync(&dev->restart_streaming);
 
 	dvb_net_release(&dvb->net);


