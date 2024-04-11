Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB33014532F;
	Thu, 11 Apr 2024 10:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829814; cv=none; b=FoMhoBupifEANF/xetZ8qy064/nQ6k1f3g7zLzXscVxfo1mVo17yfMUvnPNK4A2zPDY6H8dSJXI0Fclovs6Ez8Y+AT0aYLZkqe8TZ2AiPdTdkiE7ga4S18jRCX9D97AK2t3XQgn3lpSDtSQ6aZjrYSF2Hkr5mIGcGMlZ4A0YiAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829814; c=relaxed/simple;
	bh=+TnLpotENgedPlxOBJNOkTTBicJz1QEOr3L/NNxAfxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UX/0EunD6CdlzIZfCKYjYqu66lC31apt/TuXCl9QXtC/EX2P4y7oJOOKis3EojxQ22g8N3aVofSe9OTjTA1XgbUsLtOinoF/nOnYX2+h1ZBArdnYfMmp+bS2Ilu6PTYlG+NpT0MqJjW+82zhXAv5tNr+j53xUoLskHSj0ep2oTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjLH3z2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjLH3z2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F407C433F1;
	Thu, 11 Apr 2024 10:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829814;
	bh=+TnLpotENgedPlxOBJNOkTTBicJz1QEOr3L/NNxAfxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjLH3z2DJvO+OJHnvYxZ4IB747DJRBHNh3FKmVQ/Hb7mhRF4VIcIc3HBG1jcAUFW1
	 GdszisnJ4fdF0A7C2wS/SvkovBcwbK9Vt9N98ONZ8TavcYLzxAII0tHN0V/6YpSj1F
	 +rQtr+cYaglJS+kQOz1zZIyWG4YOfOpZfQwT8+zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Geliang Tang <geliangtang@gmail.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 113/175] mptcp: add sk_stop_timer_sync helper
Date: Thu, 11 Apr 2024 11:55:36 +0200
Message-ID: <20240411095422.969807312@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <geliangtang@gmail.com>

[ Upstream commit 08b81d873126b413cda511b1ea1cbb0e99938bbd ]

This patch added a new helper sk_stop_timer_sync, it deactivates a timer
like sk_stop_timer, but waits for the handler to finish.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 151c9c724d05 ("tcp: properly terminate timers for kernel sockets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 2 ++
 net/core/sock.c    | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 81888513b3b93..8eea17a41c1ca 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2194,6 +2194,8 @@ void sk_reset_timer(struct sock *sk, struct timer_list *timer,
 
 void sk_stop_timer(struct sock *sk, struct timer_list *timer);
 
+void sk_stop_timer_sync(struct sock *sk, struct timer_list *timer);
+
 int __sk_queue_drop_skb(struct sock *sk, struct sk_buff_head *sk_queue,
 			struct sk_buff *skb, unsigned int flags,
 			void (*destructor)(struct sock *sk,
diff --git a/net/core/sock.c b/net/core/sock.c
index 62d169bcfcfa1..eaa6f1ca414d0 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2804,6 +2804,13 @@ void sk_stop_timer(struct sock *sk, struct timer_list* timer)
 }
 EXPORT_SYMBOL(sk_stop_timer);
 
+void sk_stop_timer_sync(struct sock *sk, struct timer_list *timer)
+{
+	if (del_timer_sync(timer))
+		__sock_put(sk);
+}
+EXPORT_SYMBOL(sk_stop_timer_sync);
+
 void sock_init_data(struct socket *sock, struct sock *sk)
 {
 	sk_init_common(sk);
-- 
2.43.0



