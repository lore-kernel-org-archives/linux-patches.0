Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D52145FEF;
	Wed, 19 Jun 2024 13:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803131; cv=none; b=Fl3fhlBsDIGHjNEHjgIT9gbjuw3wBg85eKHESi8kuRc0TWK5gZLssyz26ITnG6VatPKkbFmDZ44JjP9R1UCL8VNPGRa25iSbJKU5+S7zvpuGQr8BTdG4W0QUjirkcU/N01J/ELDbII0OiBkZV9OnkCJnLDW2kL2UPwmSX5vTjU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803131; c=relaxed/simple;
	bh=fn0wxMUeRjkKx2mR7U1eR2Te+pxZ1S6KCwMN7wlUVkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eV5NZA08WtHlQqWdzcJm2ffY0ri9DDkjG+lgmc/CyOxTcJZ/LkBeeJ2pyFXCR7cCm++8hatdIHvuQM64oJaZEYlEQSQ5ZUlDpo5cUXGFUbqejj2oGxFrJoljckJi9rBOYr04lQrzQCYHKj4jLvKwcIJXfjy/0fzICbmwd/tseL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hk9S31n9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hk9S31n9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47034C2BBFC;
	Wed, 19 Jun 2024 13:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803131;
	bh=fn0wxMUeRjkKx2mR7U1eR2Te+pxZ1S6KCwMN7wlUVkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hk9S31n9cn6u6iQLPpuwpHTprFogJlS0p2GEJwENaHCjRkxBn/Kg/N21FwJOHlGlj
	 Wm+3HrnN0YKmOUkuLOvi1kwlqXjLWT3Cmdsg9An5W3RQD4QguVYUrxaWT+taMfDaxc
	 OgIyhT2anxCA+JlgJ3tLvWEPlxJ+Vk7fvJPdEwDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Menglong Dong <imagedong@tencent.com>,
	Neal Cardwell <ncardwell@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 163/281] tcp: use signed arithmetic in tcp_rtx_probe0_timed_out()
Date: Wed, 19 Jun 2024 14:55:22 +0200
Message-ID: <20240619125616.110543780@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 36534d3c54537bf098224a32dc31397793d4594d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_timer.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index d1ad20ce1c8c7..f96f68cf7961c 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -483,8 +483,12 @@ static bool tcp_rtx_probe0_timed_out(const struct sock *sk,
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	const int timeout = TCP_RTO_MAX * 2;
-	u32 rcv_delta;
+	s32 rcv_delta;
 
+	/* Note: timer interrupt might have been delayed by at least one jiffy,
+	 * and tp->rcv_tstamp might very well have been written recently.
+	 * rcv_delta can thus be negative.
+	 */
 	rcv_delta = inet_csk(sk)->icsk_timeout - tp->rcv_tstamp;
 	if (rcv_delta <= timeout)
 		return false;
-- 
2.43.0



