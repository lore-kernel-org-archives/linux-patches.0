Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99103446AC;
	Mon,  1 Apr 2024 16:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988499; cv=none; b=IZ65lxw0+ZxyPhG2ONcmzTgncMrRsJmY77MFBhvcdF5pQ97EBJiKnllnOd1wDorcoBPE72x3Z/1VSpONPQqjots5A4hdus4mOY2uBvAizw+FAUIVgZAFntw64JtdEWj1YqeCFQaBORuZemXitF7Pr47h44eQinE/1vKrOGYbqNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988499; c=relaxed/simple;
	bh=JZE+YGGC8NqBxUtJNCU6Iuk03sQp3O1bzpu0uV6EMV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dgxk9CloXJp8tcA8Mg6lDkvHbvgOlr1OHCQEZylFfuoRrGTGK52zk/it+zetadXTThEjEfCh7ZkZQb7kvbaCqko0dCyBY1CG1wmiK4Wi0X87id7PjPi25+C/I++/KJvinOaOM5Gz1zoILLRAUSO5yc0RAsDMvN094d1coS7rc8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j1cHE5So; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j1cHE5So"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE43C433C7;
	Mon,  1 Apr 2024 16:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988499;
	bh=JZE+YGGC8NqBxUtJNCU6Iuk03sQp3O1bzpu0uV6EMV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j1cHE5SouMinclp+KYGXHby+zgJyZ0JOk7e9Xq8jDaQ/aZsqxEtpAr0aH1Ymn2bz8
	 nReBZPHsm9rFxACDqud63+z41Ajab5gfE2E4elaMUemLf0vM1z00AlxhEbdZ8n2r30
	 HLEGikNo/utwRftC+n6xfrQevaMTbChxRnrN/Uzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 203/432] wireguard: netlink: access device through ctx instead of peer
Date: Mon,  1 Apr 2024 17:43:10 +0200
Message-ID: <20240401152559.191115650@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason A. Donenfeld <Jason@zx2c4.com>

[ Upstream commit 71cbd32e3db82ea4a74e3ef9aeeaa6971969c86f ]

The previous commit fixed a bug that led to a NULL peer->device being
dereferenced. It's actually easier and faster performance-wise to
instead get the device from ctx->wg. This semantically makes more sense
too, since ctx->wg->peer_allowedips.seq is compared with
ctx->allowedips_seq, basing them both in ctx. This also acts as a
defence in depth provision against freed peers.

Cc: stable@vger.kernel.org
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireguard/netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netlink.c
index c17aee454fa3b..f7055180ba4aa 100644
--- a/drivers/net/wireguard/netlink.c
+++ b/drivers/net/wireguard/netlink.c
@@ -164,8 +164,8 @@ get_peer(struct wg_peer *peer, struct sk_buff *skb, struct dump_ctx *ctx)
 	if (!allowedips_node)
 		goto no_allowedips;
 	if (!ctx->allowedips_seq)
-		ctx->allowedips_seq = peer->device->peer_allowedips.seq;
-	else if (ctx->allowedips_seq != peer->device->peer_allowedips.seq)
+		ctx->allowedips_seq = ctx->wg->peer_allowedips.seq;
+	else if (ctx->allowedips_seq != ctx->wg->peer_allowedips.seq)
 		goto no_allowedips;
 
 	allowedips_nest = nla_nest_start(skb, WGPEER_A_ALLOWEDIPS);
-- 
2.43.0



