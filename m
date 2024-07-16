Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01514B641;
	Tue, 16 Jul 2024 15:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144447; cv=none; b=rkzL1yyCt1h2nlH7g2nPf1Snn9n/hykYkUlb5lMZ1haGWSB+nI6gHMMHkPRAzDGq4RmPvt4wCGDs1EvSrJG1mV61qwTalpiJTtRrV7Bgkss3/weyU+0n8VJfSNYSac5D/ab3QUBKMwOIGsNboj3xTRB7NtFIlPP9nlDeqtMH2E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144447; c=relaxed/simple;
	bh=vHNFAvV9yiz9yYLeTdKYKcCxAngw9b5sgD8bnuzrGcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FS4vCmDw9A8iq5ZiBn7kNAN51qvFRD5fKOZkSoMxk0lH9lz5pIPBSbx0KVBhk1ETPyJhDRSFUuhpxh/1c+feFdLrbG711ZmrRstwrONYWX53Od9fwz1YjIkhk4L8Bi+ZAK05wpmdhYqaHf3RJ9iquaeswXpifSmVMD2N3EVktvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dvv7Ea2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dvv7Ea2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6B5C116B1;
	Tue, 16 Jul 2024 15:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144446;
	bh=vHNFAvV9yiz9yYLeTdKYKcCxAngw9b5sgD8bnuzrGcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dvv7Ea2/+m+CZjQ39vuQxr8PRFWXZGR9JDaVSKRTegGJPa8pkdJRx0McqbudKnRhY
	 Kr6Nyo6nDpSTelkAHfu/oXD5TOWZkffj0uPvaeuk7k9aF63Bo47vGvmlGQYbdna3zg
	 uGqHUpOx3gp13ZjWYigP3kqGZwPd0HEGJ4Wt0FRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Menglong Dong <imagedong@tencent.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 75/78] tcp: use signed arithmetic in tcp_rtx_probe0_timed_out()
Date: Tue, 16 Jul 2024 17:31:47 +0200
Message-ID: <20240716152743.540850005@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 36534d3c54537bf098224a32dc31397793d4594d upstream.

Due to timer wheel implementation, a timer will usually fire
after its schedule.

For instance, for HZ=1000, a timeout between 512ms and 4s
has a granularity of 64ms.
For this range of values, the extra delay could be up to 63ms.

For TCP, this means that tp->rcv_tstamp may be after
inet_csk(sk)->icsk_timeout whenever the timer interrupt
finally triggers, if one packet came during the extra delay.

We need to make sure tcp_rtx_probe0_timed_out() handles this case.

Fixes: e89688e3e978 ("net: tcp: fix unexcepted socket die when snd_wnd is 0")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Menglong Dong <imagedong@tencent.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://lore.kernel.org/r/20240607125652.1472540-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_timer.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -439,8 +439,13 @@ static bool tcp_rtx_probe0_timed_out(con
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	const int timeout = TCP_RTO_MAX * 2;
-	u32 rcv_delta, rtx_delta;
+	u32 rtx_delta;
+	s32 rcv_delta;
 
+	/* Note: timer interrupt might have been delayed by at least one jiffy,
+	 * and tp->rcv_tstamp might very well have been written recently.
+	 * rcv_delta can thus be negative.
+	 */
 	rcv_delta = inet_csk(sk)->icsk_timeout - tp->rcv_tstamp;
 	if (rcv_delta <= timeout)
 		return false;


