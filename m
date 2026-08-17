Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6793C8C74;
	Mon, 17 Aug 2026 13:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974710; cv=none; b=T3gAkKdg3uUy8OKGYqkZcG/9AuonqSJW8IJ/KhhOO3mGdup9Ff5gSUyN2xjuQsyNZeiEYLB0SShQQtziM3oHfbNwSEuJTGtN2J0s+Je9H2SFScArYellSrPj9piIfDnduRJI2bK0Kh64uboEi2Yn42tx7V1q2m+3t3xxL3nYYpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974710; c=relaxed/simple;
	bh=AE7KwpwvOzgvOeIZrfCWgAdt6BVCVOo4pun0jRkx65M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWin44Idc6L5KyK4NSNajmVpHvicsNOUGlBYsgalMtPgl/P4YVeL5YqnTjxB/bcYxlvjEwI38Feli9440+VUmYyJTJmOBzb7U5npb0PGFgxVK6gEISemZJrjQ3DPYv2qslnaWSLeIo08js90klenQn3ainIsI2Mwd9QC2UcqDVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Bq8IQmT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Bq8IQmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8D11F00A3E;
	Mon, 17 Aug 2026 13:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974701;
	bh=oAj8mbNMFapd0cCBiVNTGt+4Tk9wpKV02keF42OekGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Bq8IQmTLs2oS/Cm4lkzPEo1p9IlR6tne5e/UjUgpRgq7EquZuLH76qTw3+ZShcmr
	 1T1JdKH/5yW9DfeDoiDeLT37zIm7yIa4KP+K6HNw5d7cdjiGgPCHPiS1D8jcvivW+Y
	 X8RwLbD+DUb1BwJRtjSZK57pCkm2N11iD/VD4EUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@openvpn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 024/250] ovpn: ensure socket is owned by ovpn before deref sk_user_data
Date: Mon, 17 Aug 2026 15:29:45 +0200
Message-ID: <20260817132537.443289014@linuxfoundation.org>
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
index 448cee3b3f9fa..e40e320a6abf5 100644
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



