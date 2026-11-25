Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623054;
	b=ANq91XvKyFTpFE3pokJ9rP3uSohT6YBwS/RbEfPkdhjAD1Bl9bzcYyfSvN5v1dCc9ClP
	 +PI8LJ0GKKyvP8FUGK70YJvtSbUvgofoVfeCoPrRDeIrthSfIYzOTQUY0x9ODad259KUR
	 Bb3QbMOw3Wb04SL+Hr+sx0IKPjKYyYBf7jku7yBuZSOSZ9vg+a0SrSlrJu2HQquykqbLh
	 U92tgo/tggEoaSRiGDO4oS5tL6rFJHY1an1R/kvzh2d7qCaRzD8rOLDe8QorAf1B+GzL7
	 Qf7s2/9gnaWz2XttIOxW1yX7qIT9yJ4UUUrffgy27QDt90A3rHt8TUv/sC+yFlQ2tSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UuRCskjsDApie3OEUBzNmjTEARf5CVCASNMZ1x/UEcY=;
	b=nT6Vet/SqpOByNYw+7VT+rM8ai3QOYkJQqgC9eH/tVtgBWt+lFR8zhcD81sTj5IYcgFJ
	 tfHougBVdIUmGxFC4zgmweUWwhTY8f9b2Hd9dll//P5EYUii8KwmHRY+U9UEPpK0sfem8
	 xlPG6yFKz4+LJQL4VIDPIPNbYy1FgjmZUre9Xcp2tz4fBIJAltBnJhZcolu5p0m7vYNjo
	 pwITtdG7aX0LyUcUAdjGHUrR1BAm+tT9l0kP6qkqD5iEklMY3za2aOn97/L7v+Vdf6yQx
	 Dr309y89ZoJQ9v8Lj1RH8mCHrCIzF/ClSDDWoVWbgw2a3HUKj5I0xO6bnQZ1oa65vAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mlvb2lpC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837CC606A31E;
	Wed, 25 Nov 2026 16:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mlvb2lpC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41AB1F000C0;
	Wed, 25 Nov 2026 16:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623054;
	bh=UuRCskjsDApie3OEUBzNmjTEARf5CVCASNMZ1x/UEcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlvb2lpCCWj0EnAJCgAgF3DncfZoqGBM6frVkk51ha9Hc076+5KjbgumY31R7lAmw
	 HK/D05uOX8d2TVDuNCg+21owi5pNpE7nntCPNB/u8bBGVfrN3sCQgQKzeHcenqytVN
	 zQibVIs+KxodtugQhEm/2GFIzzd3VcqBipya0sWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Menninger <tmenninger@everpuredata.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.18 733/990] NFSv4: Prevent indefinite waits for out-of-order OPEN stateids
Date: Wed, 25 Nov 2026 15:35:00 +0100
Message-ID: <20261125143839.237068303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Menninger <tmenninger@everpuredata.com>

commit 151d95a1e696979a7d54b23c96338754be2fcc1f upstream.

When processing an out-of-order OPEN stateid on an NFSv4.1 or later
mount, nfs_set_open_stateid_locked() waits for stateid updates to be
processed in order. A five-second timeout is intended to prevent
indefinite waits when preceding updates never arrive.

However, each iteration calls schedule_timeout() with a fresh
five-second timeout. An update to the shared open state can wake the
caller without satisfying its ordering check. The remaining timeout
is then discarded, and the next iteration starts another full wait.

Under sustained concurrent OPEN/CLOSE activity on the same open state,
repeated wakeups can prevent the timeout from ever expiring. Some
tasks can remain stuck in update_open_stateid() while others continue
making progress.

Compute a single deadline on entry and pass only the remaining time
to schedule_timeout(). Once the deadline expires, take the existing
timeout path rather than starting another wait. This prevents
wakeups from extending the wait indefinitely.

Observed on Linux 6.8.0 and reproduced on 7.3.0 with 96 concurrent
O_RDWR|O_TRUNC open/close loops on one NFSv4.1/TCP file (nconnect=16).
Ten workers made no progress for over 300 seconds while others ran.
With the fix, all workers resumed after transient stalls.

Fixes: c9399f21c215 ("NFSv4: Fix OPEN / CLOSE race")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Menninger <tmenninger@everpuredata.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1775,6 +1775,8 @@ static void nfs_set_open_stateid_locked(
 {
 	DEFINE_WAIT(wait);
 	int status = 0;
+	unsigned long deadline = jiffies + 5 * HZ;
+	signed long remaining;
 	for (;;) {
 
 		if (nfs_stateid_is_sequential(state, stateid))
@@ -1809,7 +1811,8 @@ static void nfs_set_open_stateid_locked(
 
 		if (!fatal_signal_pending(current) &&
 		    !nfs_current_task_exiting()) {
-			if (schedule_timeout(5*HZ) == 0)
+			remaining = (long)(deadline - jiffies);
+			if (remaining <= 0 || schedule_timeout(remaining) == 0)
 				status = -EAGAIN;
 			else
 				status = 0;


