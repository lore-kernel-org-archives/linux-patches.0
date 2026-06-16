Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B529D13777E;
	Tue, 16 Jun 2026 18:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635346; cv=none; b=Fxag28yw6MlP0B9704a/uEA6YdxdocsgbbUhivm8O0qqhXGNVfoJSUpUFFDJZNvszghx2/fGmULheFUE4If2NHr1tKRVhnuZMfDnDQpdGW1xWznFM3n30m6gFKaRBs20+Lk02WGjvPiwgvQDDJdyqSAZK4Ukzj4mrl/OyGGiGoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635346; c=relaxed/simple;
	bh=awaR0ov3phMbk4QzLaIMslgJLBiTwH27HIUu1W2GPaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7nyl+BU8/8+zLM2UH4Cv7CIU0wNOrnfSWwHwb0M9zLCLEgbRturlLRMZKS1tQiigA5bFsdYuAe4HdS+WLfRPVq/kPa7JQ8c20AwoDV9sB5JzKo3jyy1jRLHDUfXJvCFVaFV5oe1hFeo9BW6vwhrsPROa6qYVmd1f9m8USiD10g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlF8aKrf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlF8aKrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E2141F000E9;
	Tue, 16 Jun 2026 18:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635345;
	bh=rwR/HZ0kSTuIa6QnoGWjf/TXo0mCvDfNrFX4MMAb+Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlF8aKrf/4y93Z5EsrqLgm8NiNEP0WErNTD+DIrPJfE7xSEo/EyDV2MbSifs5RxHC
	 IY5IoA9TIvRdyQuFusVQ+Stq2WlXc67gi+7SB/4tEQbeDvAwyMm4Rmld6BAviBaohj
	 Sf4K87AczC4gNHtaVzFfTOZ+8cslcEseP30zmBrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Ido Schimmel <idosch@nvidia.com>,
	syzbot+9fdcc9f05a98a540b816@syzkaller.appspotmail.com,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/342] batman-adv: bla: avoid NULL-ptr deref for claim via dropped interface
Date: Tue, 16 Jun 2026 20:25:28 +0530
Message-ID: <20260616145049.747364807@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit f80d3d98d2ff78d9e2fe5d68b1f45948c4f7bd24 upstream.

Without rtnl_lock held, a hardif might be retrieved as primary interface of
a meshif, but then (while operating on this interface) getting decoupled
from the mesh interface. In this case, the meshif still exists but the
pointer from the primary hardif to the meshif is set to NULL.

The mesh_iface must be checked first to be non-NULL before continuing to
send an ARP request using meshif.

Cc: stable@kernel.org
Fixes: 23721387c409 ("batman-adv: add basic bridge loop avoidance code")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Reported-by: syzbot+9fdcc9f05a98a540b816@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9fdcc9f05a98a540b816
[ switch to old "mesh_iface" name "soft_iface" ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bridge_loop_avoidance.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index d8305961b59bd1..d01c636024ce15 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -357,12 +357,14 @@ static void batadv_bla_send_claim(struct batadv_priv *bat_priv, u8 *mac,
 	       sizeof(local_claim_dest));
 	local_claim_dest.type = claimtype;
 
-	soft_iface = primary_if->soft_iface;
+	soft_iface = READ_ONCE(primary_if->soft_iface);
+	if (!soft_iface)
+		goto out;
 
 	skb = arp_create(ARPOP_REPLY, ETH_P_ARP,
 			 /* IP DST: 0.0.0.0 */
 			 zeroip,
-			 primary_if->soft_iface,
+			 soft_iface,
 			 /* IP SRC: 0.0.0.0 */
 			 zeroip,
 			 /* Ethernet DST: Broadcast */
-- 
2.53.0



