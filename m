Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1AD3D4133;
	Mon, 17 Aug 2026 13:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974802; cv=none; b=d2IXG4s6y+r9SNmzxnDo/s6eTToh2d6HbM2up6jxasMfdhduhX0QN5AypbNpgrNQCdtl66H1tFysIXpTFSQ3JRFV6CEAyMrRsA3Cyt6ov/GN7daR+/Uv9tNEFnjVIU7FJ7F8QR5gOYU635vy0jkSa+DJG3FETuPQyNG9rKZraCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974802; c=relaxed/simple;
	bh=Sr++SGxRaKJS4mxEKf/+9/O/0fd+OZx8LRjUCxLsn+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqWPdX+txsAKPeyElERxfowBAGRpRirHKZedI4eJkq1XOGftIf6ixCwfbUJglBbBRVIUIDrKrPF9uxAAtuMdqLrsKd44Nk6CCcQ5Ei3oej9FLAx3XbOlLknJeORTPfvzMjPmUTqMFtK5T6lW9wm4OCfWlDdRVU/i/auhjOhKje8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEcYv6tR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEcYv6tR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727801F00A3D;
	Mon, 17 Aug 2026 13:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974793;
	bh=ms+5Bd69Ow8iOJnmL8kkYp4SCx3O30wsR3jJFLeycTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UEcYv6tRh/ZDUHCPvpZn5qCvwrBdH95quFqHKDCr1v0Wu7hnVCrGTzwUso3HTN79E
	 aHY1G8QsCQKi53FU/K0OFWnXc+T414pLmYCDSPB1rwAovzQQBpNQYKdXHYS+l2EzdE
	 Qiz8ACeEkXHhzyeZcJO1rRkrNxsR+Inef8tH2Xng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 029/250] ovpn: fix incorrect use of rcu_access_pointer()
Date: Mon, 17 Aug 2026 15:29:50 +0200
Message-ID: <20260817132537.642894701@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit 26ba17d845193dac4921ae1ab280d28d1938052e ]

rcu_access_pointer() should only be used to test the value of a pointer,
not to dereference it. As it's in a spin_lock_bh() critical section, use
rcu_dereference_bh() instead, avoiding an extra rcu_read_lock().

Fixes: f6226ae7a0cd ("ovpn: introduce the ovpn_socket object")
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/peer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ovpn/peer.c b/drivers/net/ovpn/peer.c
index 9b647a327c468..412ef09abd5e7 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -1244,7 +1244,7 @@ static void ovpn_peer_release_p2p(struct ovpn_priv *ovpn, struct sock *sk,
 	}
 
 	if (sk) {
-		ovpn_sock = rcu_access_pointer(peer->sock);
+		ovpn_sock = rcu_dereference_bh(peer->sock);
 		if (!ovpn_sock || ovpn_sock->sk != sk) {
 			spin_unlock_bh(&ovpn->lock);
 			return;
-- 
2.53.0



