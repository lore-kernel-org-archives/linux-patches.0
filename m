Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13311DDCE;
	Tue, 16 Jul 2024 16:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146244; cv=none; b=BoabzXzaN7bCSdv4mRcTfAz2RCFSyoE75yH/BWAUohiAhxUJYtGNXZkp0FvrRsZ0TCLWKZ7kHAsxW3GU8E+J/lmIWk9q0eTfKhoxT304GGdbW7u5FUlPBmUD+RA5sjANEO4oixwaEK/H5Urgh3Wc1FdPouunZBOydkN3RmECxBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146244; c=relaxed/simple;
	bh=ezdZfYe5wHO7cGViZushqArqT8KkbCGR7piU9PEDt38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDEeKYKt0M7Qvljy22E55CfF1ty6O6xzlUQL6xqRUl05/qC9oPtq19nf/JQISh0x/xSvoNT7S9upR2ShOJd7f1aEkNpKMWbJpdyUPKhnZSnEWFjqXCLTpH3fobqO2sVf93ArpeDKCONER9ciKibPVwAETG2zCCcy5MDa/vL8MZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1UgmmLp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1UgmmLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC25C116B1;
	Tue, 16 Jul 2024 16:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146244;
	bh=ezdZfYe5wHO7cGViZushqArqT8KkbCGR7piU9PEDt38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1UgmmLpgymvUVPEK47vFzekq+HqHWJs2O1nxHdpa7qx/+cEVix01E22SwBIALB8y
	 lS/0mfTRtrx+yKZOgT8jVo/4gRcbvoOqD8ISQaj3axsZYNT5e/RNNPedfU53Fd5u+K
	 WalePUA++b4rpaxbH34ZwazirfawU0YfiU8wvnD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Menglong Dong <imagedong@tencent.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 104/144] tcp: use signed arithmetic in tcp_rtx_probe0_timed_out()
Date: Tue, 16 Jul 2024 17:32:53 +0200
Message-ID: <20240716152756.531193782@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -442,8 +442,13 @@ static bool tcp_rtx_probe0_timed_out(con
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


