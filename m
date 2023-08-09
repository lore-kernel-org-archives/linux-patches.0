Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6782717756
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAED8C433C8;
	Wed,  9 Aug 2023 11:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580058;
	bh=Bep+K8XuISJoshbNZRdiMFLSSK8fBqtCThsq5emjGgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s9N5hsgvIcIDdHqTIVzRN2pAxpwzbYcPt3IOiuhUJR9MOXQ0PdQ/WVkdqqaBbImCP
	 R/grZ8vpKR+EYeqrjG8RU/agyfPXGRqIRCR9jgRPUBox8Od2D32vGz+SbKExvpXHQY
	 K4sBFFXcV7W2nQfTIX8BxKabQIEkwxmOBYS2vW5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 213/323] tcp: annotate data-races around rskq_defer_accept
Date: Wed,  9 Aug 2023 12:40:51 +0200
Message-ID: <20230809103707.868005356@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ae488c74422fb1dcd807c0201804b3b5e8a322a3 ]

do_tcp_getsockopt() reads rskq_defer_accept while another cpu
might change its value.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230719212857.3943972-9-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4711963413a49..853a33bf8863e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3009,9 +3009,9 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 
 	case TCP_DEFER_ACCEPT:
 		/* Translate value in seconds to number of retransmits */
-		icsk->icsk_accept_queue.rskq_defer_accept =
-			secs_to_retrans(val, TCP_TIMEOUT_INIT / HZ,
-					TCP_RTO_MAX / HZ);
+		WRITE_ONCE(icsk->icsk_accept_queue.rskq_defer_accept,
+			   secs_to_retrans(val, TCP_TIMEOUT_INIT / HZ,
+					   TCP_RTO_MAX / HZ));
 		break;
 
 	case TCP_WINDOW_CLAMP:
@@ -3406,8 +3406,9 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 			val = (val ? : READ_ONCE(net->ipv4.sysctl_tcp_fin_timeout)) / HZ;
 		break;
 	case TCP_DEFER_ACCEPT:
-		val = retrans_to_secs(icsk->icsk_accept_queue.rskq_defer_accept,
-				      TCP_TIMEOUT_INIT / HZ, TCP_RTO_MAX / HZ);
+		val = READ_ONCE(icsk->icsk_accept_queue.rskq_defer_accept);
+		val = retrans_to_secs(val, TCP_TIMEOUT_INIT / HZ,
+				      TCP_RTO_MAX / HZ);
 		break;
 	case TCP_WINDOW_CLAMP:
 		val = tp->window_clamp;
-- 
2.39.2



