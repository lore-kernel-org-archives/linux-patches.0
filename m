Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD11F3EC807;
	Mon, 17 Aug 2026 13:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973927; cv=none; b=Qj4w1/bp+Z7vl622g6EQr3q/io/2KT7N0sJ6H9xs/Tf2K/yHatHoQtWUDsr5kqzMd/A5YDT119/AzzXUjVB2dk+AIvmqsu5W+2hw4bcTaoB8EK0/fEiLYxvSzAOB09C7uQ+oj50epY1o449qaQ0uAYVGktKuQM9arO7tqXRzKJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973927; c=relaxed/simple;
	bh=lgskpGptr34PgaXXo2i+wOMiI7YdDLfSWBFZn+iPKFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZqNkGTlIV9G+8KQ7d794sbJRFQOrAMeWWDqsqOiWmhNg5xRvO4scb1rgpq/SY8Ggu7a0b0u6ggoBR+0s2QbcgxFX6NT8P+6HYaGHCj98lXMiQOtDyFJ6Z1F2okLp+izkooZp1MxS5gUKlVdF0j4rsDlfdkpEGRvLaGSskQ1ewJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DI6xnWuv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DI6xnWuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F641F00A3F;
	Mon, 17 Aug 2026 13:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973926;
	bh=BE7B1dlWitUSD8aPFDEmlKw61j1hOPyJ27m51hfNRms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DI6xnWuvYs17/T6N648XrIFjZwH3XexigjHEDBFzALLKJtpDZB7fYpxarwLKixPay
	 L3+fwHQxUoGSebLwGSpU2JTipgxDsEZ/GK9P32exBKoEBCYXiExpR1oO42CoEFhvr9
	 n9eniv5l5l8LT3xd1p2rMxLmXvpttoxhGaBmUReM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 029/271] ovpn: ensure socket is owned by ovpn before deref sk_user_data
Date: Mon, 17 Aug 2026 15:29:14 +0200
Message-ID: <20260817132537.948518540@linuxfoundation.org>
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

From: Antonio Quartulli <antonio@openvpn.net>

[ Upstream commit 59aed1eb60d70678a53acccb0cb337a26ce6680e ]

Some subsystems, like BPF SOCKMAP, set sk_user_data without
actually setting the encap_type.

For this reason, we must make sure that the type is the
one ovpn expects before dereferencing sk_user_data.

Failing to do so may lead to out-of-bounds reads.

Fixes: f6226ae7a0cd ("ovpn: introduce the ovpn_socket object")
Signed-off-by: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ovpn/socket.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ovpn/socket.c b/drivers/net/ovpn/socket.c
index 517caa64a4fef..6cbeb2caaeeca 100644
--- a/drivers/net/ovpn/socket.c
+++ b/drivers/net/ovpn/socket.c
@@ -162,6 +162,15 @@ struct ovpn_socket *ovpn_socket_new(struct socket *sock, struct ovpn_peer *peer)
 		rcu_read_lock();
 		ovpn_sock = rcu_dereference_sk_user_data(sk);
 		if (ovpn_sock) {
+			/* something else filled the sk_user_data without
+			 * setting the encap_type. Reject the socket.
+			 */
+			if (!type) {
+				ovpn_sock = ERR_PTR(-EBUSY);
+				rcu_read_unlock();
+				goto sock_release;
+			}
+
 			/* socket owned by another ovpn instance, we can't use it */
 			if (ovpn_sock->ovpn != peer->ovpn) {
 				ovpn_sock = ERR_PTR(-EBUSY);
-- 
2.53.0



