Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827184;
	b=G1QXeGzcVMfsI39vRjgFl6HIHT8FKU4JPZplcEMFrDAEJLK9nqW3UtD2qsfAF8YDkErm
	 L6n6VusXFeEiVTbga+nqhIMxWpVBayScVnjScWUMoAEniKUZsbr1iRSM9AFUEB7vJ/bho
	 I+e7D1STWMYqdGRC5B/0D0DMvXKf0wUYh/7gMJ6n0erAH3d6yathW347gyB20HJNamkbW
	 6UccmxLopBZeqrmXfjznOJ7cemhnwDHHInSW+y1js1+UcvzEd3PvYUnZUqVobezdVXoOs
	 dbPAlqgw6LwOhSNiJDV6/DUx55156SALg79QM1mkbPw/YBQOsV7yiYPq8iEKcJiOXnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eLCyAtOiIcLdqqyZrIxCgmlkP6MsygJmS03yOzOrQcM=;
	b=y88azAubOYdu1BnwaYKjSbyl6inoibhsAVbatWFiuyQ7At/oWIyneZg8j/sbMLZEvhS/
	 NmlS/0BTJNZJTnfOGRF1j0rQ+RMIoHJo35OSxdQpgZB4mB8lQkoKlgm6vPZADm+M04PGu
	 l5ptqMn3uu4D21KmbZ2Aim4/56E91ijkpxr1wo0iEIMebl3N1LbHL5dNxiUA2FhjAIPQg
	 7x/SHAgmM+CelsyImwaWRBqi+CNANvltnFnMNTSmV+DeNOSa8vWdZm5zv2Q6DNkyJ2JjR
	 +XlHyz+g5c5fnKeIeVK/f3ivOPi7mvVVENaZEJtwPub3LnP4vPNc59DLFGjPod7c58w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j50YztWL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CFE606A846;
	Wed,  4 Nov 2026 21:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j50YztWL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF641F00919;
	Wed,  4 Nov 2026 21:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827183;
	bh=eLCyAtOiIcLdqqyZrIxCgmlkP6MsygJmS03yOzOrQcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j50YztWLHNLEAUcI3tKDUrk568MglEqCzr8IkDXARESX+KoyBozN4kytXwFKRxx7J
	 BRKWmSUn9x4Zstz66U1Oq09hR94374VfcoeMPv61lOsuwSxN39Pq6BUcbEH1wkqsC1
	 HYk7UBq3nmzLxuDMKCbBMjQPzUCrbbr0z15ejDlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamie Lenehan <lenehan@twibble.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.3 244/547] scsi: dc395x: sync the waiting_timer before freeing the host
Date: Wed,  4 Nov 2026 16:07:08 -0500
Message-ID: <20261104211045.103501662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 0b1a79f2791a06f139dce5450e487307cf0e241f upstream.

The waiting_timer callback re-arms itself and takes the host lock.
adapter_uninit() currently stops it with timer_delete(), which does not
wait for a callback already running on another CPU. The final
scsi_host_put() that frees the host (and the host lock the callback
dereferences) runs right after adapter_uninit(), so a concurrent or just
re-armed callback can fire after the free, leaving a potential
use-after-free window.

Replace timer_delete() with timer_shutdown_sync() at the top of
adapter_uninit(), before the host-lock section: the timer is dequeued,
a running callback is waited for and rearming is blocked before the chip
is halted, so it cannot fire at all once the adapter has ceased to
function. Waiting outside the lock avoids the self-deadlock that would
result from syncing a callback blocked on the lock we still hold.

No shutdown is needed for selto_timer because it has no reachable armer
or callback.

This issue was found by an in-house static analysis tool.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Cc: Jamie Lenehan <lenehan@twibble.org>
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260911020544.42966-1-fanwu01@zju.edu.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/dc395x.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3808,13 +3808,11 @@ static void adapter_uninit_chip(struct A
 static void adapter_uninit(struct AdapterCtlBlk *acb)
 {
 	unsigned long flags;
-	DC395x_LOCK_IO(acb->scsi_host, flags);
 
-	/* remove timers */
-	if (timer_pending(&acb->waiting_timer))
-		timer_delete(&acb->waiting_timer);
-	if (timer_pending(&acb->selto_timer))
-		timer_delete(&acb->selto_timer);
+	/* Drain the self-rearming timer; must not run under host_lock. */
+	timer_shutdown_sync(&acb->waiting_timer);
+
+	DC395x_LOCK_IO(acb->scsi_host, flags);
 
 	adapter_uninit_chip(acb);
 	adapter_remove_and_free_all_devices(acb);


