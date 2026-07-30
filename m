Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8FF442FA6;
	Thu, 30 Jul 2026 15:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427164; cv=none; b=IL444yjxwrE8LrsShBC9KCdvDsD/EKildqDiPEd/hjyVrB8Pi9xDZ/uMyHc8Bov6dMYTR9mHe5echrHDGPpqI7EjzSkbGPdai8SKx1F3rkMZgIcPNLdGPpEajZhnAnbljONPy4Gb0FLicDtepmqBHwt+urWmYtEcVUpMslQ3KdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427164; c=relaxed/simple;
	bh=pNzMH85imxvSMGg6FExlG0dhvxce/1bFMx0tdrkt/D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUEuy9DhKgNdRl3o/dtorPQ4rVD4YPwgAmmQaw3YVU1i84cy/ACU0sbMZBEF2c7t7us1JDjx1mY9oyZOXX/M06ue0DFHcXnVm4ucnWpFdRWObXEoLre3IIMzTlfbvdsKbZNaOxAD1OHR28yHIh0MslEqK2+zWKPR1+jFqp0YLIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yi9vemZB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yi9vemZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3739A1F000E9;
	Thu, 30 Jul 2026 15:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427163;
	bh=VgNngA2/jpH8N/L7Rf5QcfBtnYfnFh8mwO+O9BCn/7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yi9vemZB7rl3898Mo6K8DYPl5jjgGUpr5sI7e9HEwS81nw4Hf7KWBtHOt5jbvPoxk
	 poR/rFoL5+qHMhleluCJVUii3lO4RK/+T3K7wrJJ8VdPjdUkjF51gli1G1uNoE3tCb
	 hZj1QgPZPia6l0vg/QFZyQYwUZVB1Yph0334DebU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/484] net/iucv: take a reference on the socket found in afiucv_hs_rcv()
Date: Thu, 30 Jul 2026 16:09:30 +0200
Message-ID: <20260730141425.021217867@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 4fa349156043dc119721d067329714179f501749 ]

afiucv_hs_rcv() looks up the destination socket under iucv_sk_list.lock,
drops the lock, and then passes the socket to the afiucv_hs_callback_*()
handlers without holding a reference. AF_IUCV sockets are not
RCU-protected and are freed synchronously by iucv_sock_kill() ->
sock_put(), so a concurrent close can free the socket in the window
between read_unlock() and the handler, which then dereferences freed
memory (for example sk->sk_data_ready() in afiucv_hs_callback_syn()).

Take a reference with sock_hold() while the socket is still on the list
and release it with sock_put() once the handler has run.

Fixes: 3881ac441f64 ("af_iucv: add HiperSockets transport")
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Hidayath Khan <hidayath@linux.ibm.com>
Link: https://patch.msgid.link/20260705-b4-disp-fc79c0dc-v1-1-d2cdcb57afa9@proton.me
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/af_iucv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index e9a9bb0dee065a..a7b95590f6c96c 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2090,6 +2090,8 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 			}
 		}
 	}
+	if (sk)
+		sock_hold(sk);
 	read_unlock(&iucv_sk_list.lock);
 	if (!iucv)
 		sk = NULL;
@@ -2139,6 +2141,8 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 		kfree_skb(skb);
 	}
 
+	if (sk)
+		sock_put(sk);
 	return err;
 }
 
-- 
2.53.0



