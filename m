Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F544654F;
	Mon,  1 Apr 2024 16:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989873; cv=none; b=N3bGvXiesqTm43k9z2yWGaxrzrUz99zKyedAE8L4GcOBnJQ9sasRqRBblPryeERmkfAbVfnH1H7KGv2PwphKQAKZknd3MbWnT5+r6/ezlH5slEZ+KFc4/7kVlWETa/xaxcZOffNFEO4T1cowS9DgfOhzK0SI8wwkWbVUy5FOgcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989873; c=relaxed/simple;
	bh=soeq7qXeCXQ6aUjA4srX62hXoW2fCRex5HeZHbm5bIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5TB+RhNJIezLeX7Vneeu6i7RlvU7UpESamUOO8NuCM7/mZS+hKLD+kI6rz+wnKo/DcoI/kEFt5Lh+1t2XoyWFl5/f5OLPJ69/KRhmxP+hRVbtn6WHkZNRue6i3/KAMwLrC3LRoqfkMxOHPArQuWg+Trggwwsf0OmI0Pf2PF6mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmnLdWV3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmnLdWV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E630BC433F1;
	Mon,  1 Apr 2024 16:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989873;
	bh=soeq7qXeCXQ6aUjA4srX62hXoW2fCRex5HeZHbm5bIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmnLdWV3HjvNn9z2OSDtg7kqo+9uEmTyJ+sMnJBZnUyJpOzFc1WLXPz+kYrofn/9b
	 DIMBdaFqUieIx4Ie6uzOHUf1Qf9d+kM1zjjIxez4cPyzMQ9SF7K/4vbchTbNVZdd1U
	 2EEK+kFxBM9hdX458UGapbjhjktlJ+aZC3E0aenc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/396] wireguard: netlink: access device through ctx instead of peer
Date: Mon,  1 Apr 2024 17:43:46 +0200
Message-ID: <20240401152553.221135902@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 12d80306ff3bc..a6661c9500d40 100644
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



