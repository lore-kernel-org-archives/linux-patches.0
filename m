Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625711;
	b=TKrV3MZlOpcxXSw0FCJd/HfC+wLlNwIQOkz9fvTOdbBHtWdgchyqu4eB/e712oH5OJWr
	 T61UAXlMREAo3aqyu7+9IKeNTL4tAevfX/pKdown5vVLZprq8fzkxb/JCumUm4d/oXs9R
	 xmG1+BUya868DkQ66pSl1iEDfqkSwTWsw0Kodj69jmf3L+zT33a1btjDmRZ3ywszfK8hz
	 BcUDujBlXFBoPnx7J77H9zyP8OFt2wQupxHTgnUlh/F0GUUsdp7+2+SYA8UqOMpg3dWe7
	 XJPza5w1FTCYDqA6HDFcAAVtvueRzTRcdWGRKVjlE2zexN8+N+9JDOhTs1nerepNoNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=luv+gGocyvdGNe9x2k3nXgKHGljblIx4fBjPZ0KSTRM=;
	b=4Ncavbk1FvyfsSMwhVLv2Pt8oqb4eqqr4uqgrglOfWs3cASn9N7boieiyOCUtrcTt1Kf
	 DFf+9hzUrzU/WZ0kuWt+lJIfpIB4EO8BXsPbImKXROBwt65JyeX/MV5vX8PNSiQH3FJ0U
	 OkpKhqR1o66c960sG5BGd7FM6mbWvmTzSv96tzKjZFNU0PMCd9+dqYyCNKwtZllXNsFz/
	 2WzvBOSraERbADi4TYEbbrAyIoiMIFGq7aY1xVcUGwlHPtL810xET7TZihFnjtFkLNN+8
	 0Y2rJ2xA6ME0ybVs7URR4rkryDc6mHFafAzb4Ja0Y2sSF1BB9NTUCpAdFvZ286eqiqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lePgTT27;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE86606A336;
	Wed, 25 Nov 2026 16:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lePgTT27
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69ECA1F000C4;
	Wed, 25 Nov 2026 16:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625711;
	bh=luv+gGocyvdGNe9x2k3nXgKHGljblIx4fBjPZ0KSTRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lePgTT273LTnoM9iXNpY2u3YF5qd4xihgQZwmY7yRtuVh9Ra1uuE2j/3MEuv8hRaa
	 sfbGgBcwJT4oCpkfFD7GZMRarky0ZrWE5e3/WQRTDFnslyEpAvcADtyh+u773Mcayg
	 YL/vTwjz11NUUgdeRg51gfPzDAMXFP7z5bgxDANE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Menninger <tmenninger@everpuredata.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>
Subject: [PATCH 6.12 605/816] NFSv4: Prevent indefinite waits for out-of-order OPEN stateids
Date: Wed, 25 Nov 2026 15:35:53 +0100
Message-ID: <20261125143903.183314982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1748,6 +1748,8 @@ static void nfs_set_open_stateid_locked(
 {
 	DEFINE_WAIT(wait);
 	int status = 0;
+	unsigned long deadline = jiffies + 5 * HZ;
+	signed long remaining;
 	for (;;) {
 
 		if (nfs_stateid_is_sequential(state, stateid))
@@ -1782,7 +1784,8 @@ static void nfs_set_open_stateid_locked(
 
 		if (!fatal_signal_pending(current) &&
 		    !nfs_current_task_exiting()) {
-			if (schedule_timeout(5*HZ) == 0)
+			remaining = (long)(deadline - jiffies);
+			if (remaining <= 0 || schedule_timeout(remaining) == 0)
 				status = -EAGAIN;
 			else
 				status = 0;


