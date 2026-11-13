Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590950;
	b=zTCl6x3roJhCT+G4p/7jEHo1Ltu3C/nxA9FKR4R+cuULYTpXoHYR0fffA6ShJE7WYPe3
	 mwK8WInL0tzabQXth+1mvWkY/l6byS0HHoUgzdouYLR2WLqTPCJ7JH3o9D3JhMCXZCX8c
	 Oks7nq1Ky64ICDnk7djJDtUjHGHCRq34QxSI0GIolBTGOPY4poZ/9RtRzRzE4Y/kH4poN
	 tdX+4uAvMvW17GlnUACpl8IHHLZxxyZ4IcJurBRfj5/3zGYGEZncJVO8sxIUcXF5CrO1a
	 YCqFZxMcsQhQSH2CDC6H/aicvUuciilHta126kYc9/BPHSkOFU1yHjgv/Dl5yRro56A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A23KN6U4YXREQySkMUY4Z5d+9Nc+U0e0D4Ft8dxF22g=;
	b=SYcZttYsegKCKUJU2z4fJk1AcnjsRarMNSF5g/IrRpxZhJLQvQCRdodBydIr57LiRQqv
	 A748eDASNVVlDJ0BR7qrejzvcFgnj+YXUKpU34d3gIDkMRfGwyGoHpmGB+d0BaMSEqUO/
	 RakA23eb0NhqzlOHzJkIPDOxa/4+dyAcunl89uxTVCWR6hp2lEkYjoBMGRsdu+VCEdMKZ
	 OnEatV+EMfokvOeNmWXvZizWi3i6o9sKwuF5PWfz0s1Af1orfU/P7GqPB+oLL7IdPo4UI
	 0XxrPX+ks9iQr/4lkeCiQA3SimYSO4wKEAKnhoeBBbyFcA3QmbOP4eWzgv9/k/cHgvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2aTjgpB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86150606F707;
	Fri, 13 Nov 2026 17:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2aTjgpB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EA11F000C4;
	Fri, 13 Nov 2026 17:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590950;
	bh=A23KN6U4YXREQySkMUY4Z5d+9Nc+U0e0D4Ft8dxF22g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2aTjgpBgUIvxCsGayXjB/wNWyYxSBPToKHUH/EUi1fbuJF+YcJIrUBifxgNq2bxg
	 pW9OqtQmOAhTqeSyzrGXqDFMnF4mRyh7IBOvKeM6yuQGsIDkkL2O2FDndZBZl4y1Q7
	 eTvXJDjrgIw9mbs2fmbSxfjy1VelW5F84ccXk3yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 131/670] netrom: drop a frame received with a TTL of 0
Date: Fri, 13 Nov 2026 10:44:55 -0500
Message-ID: <20261113153816.261977603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

nr_route_frame() drops a frame to forward when its time to live is 1,
then decrements the TTL of the copy it sends on. A frame that arrives
with a TTL of 0 passes the test and leaves with a TTL of 255: in a
routing loop it can then go round up to 255 more times instead of
dying.

Drop frames with a TTL of 0 as well.

Tested on two QEMU guests (6.12.94, KASAN, lockdep) linked by KISS: A
sends B three NET/ROM frames for nodes that B routes through neighbour
TESTC, with TTL 0, 1 and 2, and listens as TESTC to see what B sends
on.

  before: TTL 0 sent on with TTL 255, TTL 1 dropped, TTL 2 sent on with 1
  after:  TTL 0 dropped,              TTL 1 dropped, TTL 2 sent on with 1

No kernel report in either run.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 303f110f8f2adc6f8b313fbfd4d53a1fc56c29e6)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_route.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 8397a319932c1..7fbacc5fee84f 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -785,10 +785,12 @@ int nr_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 	if (!READ_ONCE(sysctl_netrom_routing_control) && ax25 != NULL)
 		return 0;
 
-	/* Its Time-To-Live has expired */
-	if (skb->data[14] == 1) {
+	/*
+	 * Its Time-To-Live has expired. A frame received with a TTL of 0
+	 * has expired too: decremented below, it would leave with 255.
+	 */
+	if (skb->data[14] <= 1)
 		return 0;
-	}
 
 	nr_node = nr_node_get(nr_dest);
 	if (nr_node == NULL)
-- 
2.53.0



