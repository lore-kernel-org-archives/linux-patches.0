Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE99A3F9287;
	Mon, 17 Aug 2026 13:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973944; cv=none; b=j8o99eW40kHhzpXUcRCXqTHpcrel2O79I0HTFSeWAR5Drd9ryn2Jr1YFZAVOe85OZ8sjZ1aKfgCYhxgTKh8UxgR3p990uA3AABqam9wMEteo0HCholfkzOGyYn6Cf6Fs4Fk07yL4Z6mmjBkZpbJ5lw4EpUzd1DGni4lBZxTkdHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973944; c=relaxed/simple;
	bh=9YjgTl2lxYOgfo+79NVe/aOtnr7zLJnkmvI/BIfL6Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijwOID3rgKCbPa5tCqXfQhy4fDGCjUa4anSCetljRyPcc9Ne7IKjyN3fH154ag6KWgpU9d+pKAEpsxkjTYRtVtvZqGiTqf8aRICY1pQA2u1YhtimEB5kn67HC468YPIkUcCYLhKELM6WkzkSj4t1kshKAoJezSCmLr4R8fcIr/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeEqTi0M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeEqTi0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBD01F00A3F;
	Mon, 17 Aug 2026 13:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973943;
	bh=ZaJ4MI14cr6PRa/AybDpieQpNAtPLE55GYVCz7rcQHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IeEqTi0MUcM1OCl22X6GUbtu1MJCrd3wCpEZNb7prO1Lw9BHzD3fIEzeceiyHm6ra
	 kuAx+9DmT0tytNF8yd4DtkG0BARtwlt/dut4N7QVfdy48izXiJmOPkUKCCCchKCq2H
	 pbtWZHkF9ihgvSiKFrvIy83gZdsgxJ/s1/AM/qGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 034/271] ovpn: fix incorrect use of rcu_access_pointer()
Date: Mon, 17 Aug 2026 15:29:19 +0200
Message-ID: <20260817132538.147765093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index eada414a9d922..b0519f9840d83 100644
--- a/drivers/net/ovpn/peer.c
+++ b/drivers/net/ovpn/peer.c
@@ -1249,7 +1249,7 @@ static void ovpn_peer_release_p2p(struct ovpn_priv *ovpn, struct sock *sk,
 	}
 
 	if (sk) {
-		ovpn_sock = rcu_access_pointer(peer->sock);
+		ovpn_sock = rcu_dereference_bh(peer->sock);
 		if (!ovpn_sock || ovpn_sock->sk != sk) {
 			spin_unlock_bh(&ovpn->lock);
 			return;
-- 
2.53.0



