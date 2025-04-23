Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD63929CB4F;
	Wed, 23 Apr 2025 15:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422039; cv=none; b=DhK3J4xnJjBy6oL8HbQjN6pHL7SX1K/JDi+Im506f/4ldDewcsyty5kGeOct1hzlJPLfo6U8FALBnVo827ugNQuh4FA6nH4Aafdc2rwTEkOZhNuWd0mPc4FFjkRUlSQRjzUvwJO1WJK63TM629+4KDMac9g+AGLaqn3w4dL+2wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422039; c=relaxed/simple;
	bh=xA9ZkHq9KuXooIpJQ4D5RADMlJoGdFW15FjkkGGNTgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wko1mcc6WnAXcV+oxgwNxJJz0bdg4Uak2Ip8Qsu41cw3ohWkdkZHIHuSgZMmuRK001kSwWuwezMevl0OZSnQLytBMOstzFf+gfOtJ6rIctY9s6uXlruAqbC4JDXbfpnzRs1F4nWYKfpiVHTEzws0g9T9QhFkTzgRpkCBRArl0tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gBc76dnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBc76dnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405ABC4CEE3;
	Wed, 23 Apr 2025 15:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422039;
	bh=xA9ZkHq9KuXooIpJQ4D5RADMlJoGdFW15FjkkGGNTgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBc76dnS+ge3VaDScfQCUC1KflHiP9+vbIwvwERHnMYUrFzznCGZJorXgAH/lroIg
	 07fBJ2gwU9QxKQLMNhBqvFTEJdNo4cHN2Vtnz2oNCYM+zQAdPwZP/zSGwPlMMFpJby
	 HeXfCDFm9Ji6lD/Y/3zrmNRbyVibphD46KREtFGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 267/393] net: mctp: Set SOCK_RCU_FREE
Date: Wed, 23 Apr 2025 16:42:43 +0200
Message-ID: <20250423142654.392382208@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit 52024cd6ec71a6ca934d0cc12452bd8d49850679 ]

Bind lookup runs under RCU, so ensure that a socket doesn't go away in
the middle of a lookup.

Fixes: 833ef3b91de6 ("mctp: Populate socket implementation")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Link: https://patch.msgid.link/20250410-mctp-rcu-sock-v1-1-872de9fdc877@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/af_mctp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 28be85d055330..8032cfba22d1c 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -550,6 +550,9 @@ static int mctp_sk_hash(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
 
+	/* Bind lookup runs under RCU, remain live during that. */
+	sock_set_flag(sk, SOCK_RCU_FREE);
+
 	mutex_lock(&net->mctp.bind_lock);
 	sk_add_node_rcu(sk, &net->mctp.binds);
 	mutex_unlock(&net->mctp.bind_lock);
-- 
2.39.5



