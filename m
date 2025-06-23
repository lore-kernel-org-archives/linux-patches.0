Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF187482;
	Mon, 23 Jun 2025 21:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713660; cv=none; b=dD+MyzjkwitUCnWkFLkE1+vF7Fn3ROsBujboVaagLx/oss7+XxSR1NLQ5/B46qICL9fjCH/+CCv40kbaeQf84FqKw+groMGQnPQOMHeaikNrgHvWOCWLsU/0ugLP/qPP3fsgtd2TQxkiJcveLcnNwek8GCvNrJpIaYCwThEVch0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713660; c=relaxed/simple;
	bh=vT16eT+vnTG8T51Bq7862a8ly9EWdLHzGvxOXkBzq04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=El/bxe9ddpPwuUXZ5ZyOwF/T3I3FBK5SAeVlgQc7DWTLPRMrwPX+wH1IsbtXHFxjaHFgu6AtbpSMTnp6GEqC35R/XfPTuarUMDmTjQgXFeUs6gvQLeShsYRGHNOKyxyRaLQDbSVL2eUi3JOOHuEE1btkhQbCPxpCXfpqbEO3oyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6vBYzwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6vBYzwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56623C4CEEA;
	Mon, 23 Jun 2025 21:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713660;
	bh=vT16eT+vnTG8T51Bq7862a8ly9EWdLHzGvxOXkBzq04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6vBYzwBw8eB6staF/SE9wxX7m0M+AHpkkPm1jq8R+LBkgMiZ6vw6z/UJyNYmZGsj
	 +SyUZFeYhKAvFCTnaYMdd6qf/Glcnh44m4iLH/h5rj4Pvfh/Bm/WrIGlZIGXfLGQpF
	 rxWV3Eix3iERGYAOMFbegjyVIFGcXtZwdaEi8ekU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Wei Wang <weiwan@google.com>,
	Arjun Roy <arjunroy@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 158/355] tcp: tcp_data_ready() must look at SOCK_DONE
Date: Mon, 23 Jun 2025 15:05:59 +0200
Message-ID: <20250623130631.453370482@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 39354eb29f597aa01b3d51ccc8169cf183c4367f upstream.

My prior cleanup missed that tcp_data_ready() has to look at SOCK_DONE.
Otherwise, an application using SO_RCVLOWAT will not get EPOLLIN event
if a FIN is received in the middle of expected payload.

The reason SOCK_DONE is not examined in tcp_epollin_ready()
is that tcp_poll() catches the FIN because tcp_fin()
is also setting RCV_SHUTDOWN into sk->sk_shutdown

Fixes: 05dc72aba364 ("tcp: factorize logic into tcp_epollin_ready()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Wei Wang <weiwan@google.com>
Cc: Arjun Roy <arjunroy@google.com>
Reviewed-by: Wei Wang <weiwan@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5028,7 +5028,7 @@ err:
 
 void tcp_data_ready(struct sock *sk)
 {
-	if (tcp_epollin_ready(sk, sk->sk_rcvlowat))
+	if (tcp_epollin_ready(sk, sk->sk_rcvlowat) || sock_flag(sk, SOCK_DONE))
 		sk->sk_data_ready(sk);
 }
 


