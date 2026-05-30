Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB502F5A06;
	Sat, 30 May 2026 16:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158355; cv=none; b=dAJiETHF2KvuDs5JKmXZ5FDQTnOstRcDbijbblPoa+PgeaI952VzakuijfNzRcELQsB1kv5fQlSlTtFzm4VrXCl8SbwVeaOuwxiQHjGadJlPKL6wcqO5fFqrHdN0vzAVYqT64y36UDpU8k3xg1kpoEsPwwFjANMsFqsTEAgq4EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158355; c=relaxed/simple;
	bh=zhWB9VGmXf7miHeLfgm07PNaiGZauhifIlC30spRMIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7/ArCE6lrGn29ri0PgMftYVdR3/mD59I6vS3gAfIXbmc/vB+GJtgrcleIgItbLG3Bki9MGQKm1B9XA/n1WToWIdBA/kPoJcwGCJ+I5u1AcNmrVjxNErXsL3gDYFwlOA/PYoEcL0E+L8YO1/37r43y2TQ4NWXnN7joJE3Z6/sh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEsnjQ9P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEsnjQ9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D24A1F00893;
	Sat, 30 May 2026 16:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158354;
	bh=Ckr/glicyINM+C29HHsi2G8/HKnaoqKIR2YYcsq/who=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jEsnjQ9Pw4E28CDhcB5M7x0TywzcjWyGoHuuv8nfibJuaMmdd5ZYxVtu3SZ8mATrF
	 210fdU2Y1+Fjaovk1ySjNHEE9Gwx4MPs9nirT1GUbwBDv1Qg8jHxN/Ufbl6rh4db76
	 phhCHPEr34UDxbZ8udsUsZgdYmdDG0heG0okN4D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/969] xfrm_user: fix info leak in build_mapping()
Date: Sat, 30 May 2026 17:52:47 +0200
Message-ID: <20260530160301.605762686@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 1beb76b2053b68c491b78370794b8ff63c8f8c02 ]

struct xfrm_usersa_id has a one-byte padding hole after the proto
field, which ends up never getting set to zero before copying out to
userspace.  Fix that up by zeroing out the whole structure before
setting individual variables.

Fixes: 3a2dfbe8acb1 ("xfrm: Notify changes in UDP encapsulation via netlink")
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 64137facd128e..9d22a7753f080 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3729,6 +3729,7 @@ static int build_mapping(struct sk_buff *skb, struct xfrm_state *x,
 
 	um = nlmsg_data(nlh);
 
+	memset(&um->id, 0, sizeof(um->id));
 	memcpy(&um->id.daddr, &x->id.daddr, sizeof(um->id.daddr));
 	um->id.spi = x->id.spi;
 	um->id.family = x->props.family;
-- 
2.53.0



