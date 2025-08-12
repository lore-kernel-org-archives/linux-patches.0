Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D894C29BDB7;
	Tue, 12 Aug 2025 19:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025847; cv=none; b=TxRNBHiJ/2WPWbvPeHJAVzESU+i2/lRjeFOnkrAFFQp0KOD5dgVj0qYOBIYxZuUmrusADHUoa+EKEAgbPJ2MRP+HdvaTGb66v1CSVOpY9IpVu0x2WkIAsWF5MAMckz1ofaDrgI59DOG4FYR326q42yZzUdkDdm62OwEBCbx7G08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025847; c=relaxed/simple;
	bh=xI0S+PlIy0LKyfWoSnYkLWxjuCS+IZE54e9GUysf8GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MW7YrhNeMWDSP2W76uq/leq81P924FPUR9uVrNVHsxRtsZjz6l62Rfww+k/cN0WwlNRQ1ALxYnPtQ1BmXBF2f0OfUskV3Dxz+0z3H96qaV5Apv1r0/ExPcGfbRPcF39lymh52i0CTxVLG8mKashygfkE+PrJGyIXv1aeFtbIv+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seg5kpBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seg5kpBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB8FC4CEF1;
	Tue, 12 Aug 2025 19:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025847;
	bh=xI0S+PlIy0LKyfWoSnYkLWxjuCS+IZE54e9GUysf8GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seg5kpBd9033eVc4pKHZNuIX/WNtiftM4Tv1AOUSMhBfntRbIf17DPolsjv6l1pVw
	 3Ae1BuxzPu2SKCjQvd8XIrD7f8RHNZE1jONUJMwt/+DlHPtKLLzwFS5k8GGekgfm8y
	 J6LYkVcPf+G0haZTwxbqcoJQzKm9VcuUBmBKXfVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 162/480] tcp: call tcp_measure_rcv_mss() for ooo packets
Date: Tue, 12 Aug 2025 19:46:10 +0200
Message-ID: <20250812174404.206902638@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 38d7e444336567bae1c7b21fc18b7ceaaa5643a0 ]

tcp_measure_rcv_mss() is used to update icsk->icsk_ack.rcv_mss
(tcpi_rcv_mss in tcp_info) and tp->scaling_ratio.

Calling it from tcp_data_queue_ofo() makes sure these
fields are updated, and permits a better tuning
of sk->sk_rcvbuf, in the case a new flow receives many ooo
packets.

Fixes: dfa2f0483360 ("tcp: get rid of sysctl_tcp_adv_win_scale")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250711114006.480026-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index e75ee9023674..ca24c2ea359b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5056,6 +5056,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		return;
 	}
 
+	tcp_measure_rcv_mss(sk, skb);
 	/* Disable header prediction. */
 	tp->pred_flags = 0;
 	inet_csk_schedule_ack(sk);
-- 
2.39.5



