Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A929E7461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB27C433C7;
	Sun, 17 Sep 2023 20:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981229;
	bh=KCnLHpdhl/bnzhYeyFM+6nEh5KzTgdIkG17FjZ9zyhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5sc97o3KmM9G1P8pOdcr7+m15ogXBhmo4Qk24OC06EAPX3yiRaqT5L7AIsq+4Udt
	 e7KHZQyXJrCJkvaSJ+FQ8ceAp/eJCqOuoKiw2xAShOsYkuIKD4ohCtoptPGR6l4gZt
	 mpiZewip4quSyykGO2i1qsjQb1qveenLyogmAoa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+822d1359297e2694f873@syzkaller.appspotmail.com,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/219] xsk: Fix xsk_diag use-after-free error during socket cleanup
Date: Sun, 17 Sep 2023 21:13:39 +0200
Message-ID: <20230917191044.305597788@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 3e019d8a05a38abb5c85d4f1e85fda964610aa14 ]

Fix a use-after-free error that is possible if the xsk_diag interface
is used after the socket has been unbound from the device. This can
happen either due to the socket being closed or the device
disappearing. In the early days of AF_XDP, the way we tested that a
socket was not bound to a device was to simply check if the netdevice
pointer in the xsk socket structure was NULL. Later, a better system
was introduced by having an explicit state variable in the xsk socket
struct. For example, the state of a socket that is on the way to being
closed and has been unbound from the device is XSK_UNBOUND.

The commit in the Fixes tag below deleted the old way of signalling
that a socket is unbound, setting dev to NULL. This in the belief that
all code using the old way had been exterminated. That was
unfortunately not true as the xsk diagnostics code was still using the
old way and thus does not work as intended when a socket is going
down. Fix this by introducing a test against the state variable. If
the socket is in the state XSK_UNBOUND, simply abort the diagnostic's
netlink operation.

Fixes: 18b1ab7aa76b ("xsk: Fix race at socket teardown")
Reported-by: syzbot+822d1359297e2694f873@syzkaller.appspotmail.com
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: syzbot+822d1359297e2694f873@syzkaller.appspotmail.com
Tested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/bpf/20230831100119.17408-1-magnus.karlsson@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk_diag.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xdp/xsk_diag.c b/net/xdp/xsk_diag.c
index c014217f5fa7d..22b36c8143cfd 100644
--- a/net/xdp/xsk_diag.c
+++ b/net/xdp/xsk_diag.c
@@ -111,6 +111,9 @@ static int xsk_diag_fill(struct sock *sk, struct sk_buff *nlskb,
 	sock_diag_save_cookie(sk, msg->xdiag_cookie);
 
 	mutex_lock(&xs->mutex);
+	if (READ_ONCE(xs->state) == XSK_UNBOUND)
+		goto out_nlmsg_trim;
+
 	if ((req->xdiag_show & XDP_SHOW_INFO) && xsk_diag_put_info(xs, nlskb))
 		goto out_nlmsg_trim;
 
-- 
2.40.1



