Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31FB346AFB;
	Fri,  7 Aug 2026 15:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116624; cv=none; b=a9RaguFd+NWkRfiEae634TNTTshLZbFpamET4tjuJpteVlRbSkiJgSVg0sDbAlPDmqrH3SyKHo03uDVlTIxu9JPhXPGncbkaR2mPuCTCsnGDv0AqteeJ5ViFoE/OgDerw+vjbtzJZ+sOUMW5Yg4xIrffKUpKypP4cWV+k1kV1X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116624; c=relaxed/simple;
	bh=y0IKEqWcAqlJ9BW6SUDKCkxk+tgS12wx1sL2G0W6+6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W45TtM6e0mBFe15EW59z1V9564zBciF8jMJAhCvHxM27PalKeOWGpv/3tKKLS+LfqszRvNvB/3tDuuBqEHXeydwbiZQaZbQtFyMuMpnkcCObfYJYgv1xoQvPgWQ1yH+caSFV7OZX1jg09OOuThApeEGZbiet7XbYQpLqtlYUSrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3xa8XRJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3xa8XRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4021F000E9;
	Fri,  7 Aug 2026 15:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116623;
	bh=rjP68OSh6D7SyHnjebgct+RafRwsW8MGgwcj6QjwHoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a3xa8XRJMeOXX6e/EQGD3khXO7yYrPaXOHt2s/4bO/0WUg7QfZ5DYBIEPl1KqtTcf
	 P4jy46JfmN/YeWsALPNNAE7p/e1TR8xrMVN2rLSe8jTkLBVpAILA4T+Sb921rOle+/
	 5kk8TgWkBoMzt3PYoG07Bm5Id48wKivJ4N1YdVEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Attila Fazekas <afazekas@redhat.com>,
	Wander Lairson Costa <wander@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 034/438] rtla/timerlat_top: Fix on-threshold actions firing on signal
Date: Fri,  7 Aug 2026 16:33:50 +0200
Message-ID: <20260807143428.735231401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

[ Upstream commit fafb66e5903c2bcfc7b7e259042a8282f18a6faa ]

A bug was reported when rtla-timerlat-top tool performs on-threshold
actions, even though no threshold was hit. This is reproduced even if no
threshold is set at all:

$ rtla timerlat top -q -c 0 --on-threshold shell,command='echo BAD'
BAD
                                     Timer Latency
...

The bug is due to incorrect logic in timerlat_top_bpf_main_loop().
The loop uses timerlat_bpf_wait(), the return values of which are:

- > 0 (number of ringbuffer entries): at least 1 CPU hit threshold
- = 0: time out
- < 0: wait was interrupted by a signal

Commit 3138df6f0cd0 ("rtla/timerlat: Exit top main loop on any non-zero
wait_retval") changed the condition for "threshold hit" from
"wait_reval == 1" (exactly 1 CPU hit threshold) to "wait_retval != 0",
to fix a race where multiple CPUs hit the threshold at the same time.

That also made it incorrectly include a signal (< 0), coming from either
duration expired (SIGALRM) or user interrupt (SIGINT).

Check for wait_retval greater than zero in the if condition to cover all
return values correctly.

Fixes: 3138df6f0cd0 ("rtla/timerlat: Exit top main loop on any non-zero wait_retval")
Reported-by: Attila Fazekas <afazekas@redhat.com>
Reviewed-by: Wander Lairson Costa <wander@redhat.com>
Link: https://lore.kernel.org/r/20260713141047.687877-1-tglozar@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/timerlat_top.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/src/timerlat_top.c b/tools/tracing/rtla/src/timerlat_top.c
index 035abf01dbe63..d625b76a31679 100644
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -821,7 +821,7 @@ timerlat_top_bpf_main_loop(struct osnoise_tool *tool)
 		if (!params->quiet)
 			timerlat_print_stats(tool);
 
-		if (wait_retval != 0) {
+		if (wait_retval > 0) {
 			/* Stopping requested by tracer */
 			retval = common_threshold_handler(tool);
 			if (retval)
-- 
2.53.0



