Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAF82DEA6B;
	Fri,  9 Oct 2026 14:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557597; cv=none; b=nV8FU5fjXaCGWKAUyDLJSTv/aLWPhASmceaG/LcAXL861JTrh4j30YUn2rtMJJCeB+Hg4jpWPflv72FchkCItO7sslScEFlk2jWz7tyvdr/dHWoRSUcF7KPdv0FGBaLxBFPyGgPUgxN2P09W3kcgl1rgT+aHz5exAWaGy2a7oTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557597; c=relaxed/simple;
	bh=nh9uPWETEkJRK4dJ6YrpH2YT3zYbpE3gPxtLKmHm1cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sM02wxc5u9CBCV0DxzoRB/T9MO7wFjY8r/9iJIQmvF2Q1w8AJZQMw+xQHn5OYNw3ZU/j73OKEVt8EEX9BLlRHNQU9e1icWspkMmBCIT3Q1+bS4B0J8oIhZWKZdq9VtmHlmwpkNFiDCW2GVqYyErCgKZH4ewa5/1PeDUwM9+JCvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvN08mD+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvN08mD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82E21F000FF;
	Fri,  9 Oct 2026 14:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557596;
	bh=I/+ljrWv/c5YVVuGuTtkSVowDzULlg8aRHaSSjvNV7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FvN08mD+XgFZhwj2QAEZLxhohVvxsQsv310JhfpvElR+DcDh5fsBifm9Q9VWKAF91
	 XHZrBVK7vYTMieTcrqVLNPRuLXyKNeW/YF6eUtAns9bI5RlcIoEZpv3NBV2U9UXz1g
	 BBUWMSKPqzBeV1Xj6/uyeXi7mAuY1SjNX8pVkwsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 415/428] mptcp: fix msk->timer_ival reset
Date: Fri,  9 Oct 2026 16:12:32 +0200
Message-ID: <20261009140955.349049000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

In this kernel version, icsk->icsk_rto_min is not initialised, because
this version doesn't contain commit ea4eb2adb0d3 ("mptcp: honour
configured min/max RTO in retransmit paths").

Reset it to TCP_RTO_MIN, which is how msk->timer_ival is also reset in
__mptcp_init_sock() in this version.

Fixes: 69a7b2a91267 ("mptcp: prevent race between disconnect() and rtx")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index de6f289a6e14e..79ec52f64dc50 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3475,7 +3475,7 @@ static int mptcp_disconnect(struct sock *sk, int flags)
 	/* The later subflow close can not kick again the tout timer,
 	 * as the msk is already in closed status.
 	 */
-	msk->timer_ival = icsk->icsk_rto_min;
+	msk->timer_ival = TCP_RTO_MIN;
 	sk_stop_timer_sync(sk, &sk->mptcp_retransmit_timer);
 	icsk->icsk_mtup.probe_timestamp = 0;
 	sk_stop_timer_sync(sk, &icsk->mptcp_tout_timer);
-- 
2.53.0



