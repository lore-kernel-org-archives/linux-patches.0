Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE88411A09;
	Thu, 30 Jul 2026 15:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423912; cv=none; b=kPVHW+sdwymqHjUVzUM39Me835P85VqRyefWx3LpvNg1v6KyopHpUwoMtb7uze1nWkPQrVKYaoKepyd4o+byER5WVAOpLGzoalkuilP3b9tiN+eb6548WSWQPguo+cS2axmyjXmHI4Qvr7Qyj40EqjxeWpJKrIR0rcdp/4CytMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423912; c=relaxed/simple;
	bh=rmpoW2kPZeZzeR1jRAnw/FTWuQqgKGkzIfvwU4szeQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibfTO5/ZvhMolbCeduZy87F6qdlSMVVr7VyBd+D5Tnj2qr3u+xta4kACd/y5Wu/UcdysNHPRg/NKTAqrG3S98MRLM3QbdREWLqLaBTylyxsiR83lv2nfwSOLzC3Dla6iNXX6Dd1OpfPu4ZWbOILGJBFbEHpTvt1Xry8lpP1IZHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FUBDk5FS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FUBDk5FS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032C01F000E9;
	Thu, 30 Jul 2026 15:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423910;
	bh=j4KQ7e91NUdfNuNBhHpD+HRIkDzducwk4li85OcLBzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FUBDk5FSAwG/2VdHDKu+/T07oV0O6hjuZ+EjYvbZwmuIdnKSQF24tlkvsVUCwzDiS
	 nrwuzih/Cmu4eq+ek/h5dj8gb8XfEdU3kb1gMJMK+gJMC/4ngGqE3Qm+4oWyj/H+7m
	 mps68b0rCfLBmHvokoU79j+Nhexj7vzDWl+NDZ7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Baffo <marco@mandelbit.com>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 208/675] ovpn: use monotonic clock for peer keepalive timeouts
Date: Thu, 30 Jul 2026 16:08:58 +0200
Message-ID: <20260730141449.564391741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Baffo <marco@mandelbit.com>

[ Upstream commit f7e6287ccd3abeed9e638b581dc3fdf742106ba3 ]

Replace ktime_get_real_seconds() with the monotonic
ktime_get_boottime_seconds() to ensure the keepalive mechanism is robust
against system clock modifications.

Right now, the driver uses ktime_get_real_seconds() to track peer
timeouts, relying on the system wall-clock.

An administrative time adjustment or an NTP sync that steps the clock
forward can cause `now' to instantly exceed `last_recv + timeout'.

When this occurs, the driver artificially expires healthy peers.
Depending on the OpenVPN user-space configuration, this triggers a
premature tunnel restart (if --keepalive or --ping-restart is used) or
a complete disconnection of the client (if --ping-exit is used).

Fixes: 3ecfd9349f40 ("ovpn: implement keepalive mechanism")
Signed-off-by: Marco Baffo <marco@mandelbit.com>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/io.c   | 4 ++--
 drivers/net/ovpn/peer.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ovpn/io.c b/drivers/net/ovpn/io.c
index c03e58e28a860d..0008a3d30c198b 100644
--- a/drivers/net/ovpn/io.c
+++ b/drivers/net/ovpn/io.c
@@ -137,7 +137,7 @@ void ovpn_decrypt_post(void *data, int ret)
 	}
 
 	/* keep track of last received authenticated packet for keepalive */
-	WRITE_ONCE(peer->last_recv, ktime_get_real_seconds());
+	WRITE_ONCE(peer->last_recv, ktime_get_boottime_seconds());
 
 	rcu_read_lock();
 	sock = rcu_dereference(peer->sock);
@@ -291,7 +291,7 @@ void ovpn_encrypt_post(void *data, int ret)
 
 	ovpn_peer_stats_increment_tx(&peer->link_stats, orig_len);
 	/* keep track of last sent packet for keepalive */
-	WRITE_ONCE(peer->last_sent, ktime_get_real_seconds());
+	WRITE_ONCE(peer->last_sent, ktime_get_boottime_seconds());
 	/* skb passed down the stack - don't free it */
 	skb = NULL;
 err_unlock:
diff --git a/drivers/net/ovpn/peer.c b/drivers/net/ovpn/peer.c
index 7e7ccae1325179..b7c103fda2ae68 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -45,7 +45,7 @@ static void unlock_ovpn(struct ovpn_priv *ovpn,
  */
 void ovpn_peer_keepalive_set(struct ovpn_peer *peer, u32 interval, u32 timeout)
 {
-	time64_t now = ktime_get_real_seconds();
+	time64_t now = ktime_get_boottime_seconds();
 
 	netdev_dbg(peer->ovpn->dev,
 		   "scheduling keepalive for peer %u: interval=%u timeout=%u\n",
@@ -1352,7 +1352,7 @@ void ovpn_peer_keepalive_work(struct work_struct *work)
 {
 	struct ovpn_priv *ovpn = container_of(work, struct ovpn_priv,
 					      keepalive_work.work);
-	time64_t next_run = 0, now = ktime_get_real_seconds();
+	time64_t next_run = 0, now = ktime_get_boottime_seconds();
 	LLIST_HEAD(release_list);
 
 	spin_lock_bh(&ovpn->lock);
-- 
2.53.0



