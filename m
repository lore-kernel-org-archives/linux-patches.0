Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081FD482CA;
	Mon,  1 Apr 2024 17:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991008; cv=none; b=BC4yzqzil3Pf46QV9sKoA2PXAx8iZAJV7AiyssCJY1LQA6Ci2T2kQ16DZfG4zttavZlNTXkoUjZ2mvzep6WTJ+oPDha4CwixYTfqHIWu8P++Jjr02IEq79xsB5Sgqexx5jGx3fGShCmYMu6foCSmzGm0c/4OG20PBj2XhbMNPrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991008; c=relaxed/simple;
	bh=5XnQD3SVtH/iJ5VIGVhHSrK/gQJ5BM8CIjDnTyV8Ksw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FgB8/HdZsUnhtYdsNxMKc5IfsvERJKpXPnTGCM4P/YAEm7C+MnbvQ5WiwKH1G2kObhUzL69kkpaXwTPeBsXu4BRXibsb6ZIj/eb0lHEdQA/xjqibw3jT69OeBE7bhMQ0SWdsAaKRkz6vJ86RVgwcsu4yLPTDF63kAdiU+l+0t7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxcGF5X7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxcGF5X7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E0FC43390;
	Mon,  1 Apr 2024 17:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991007;
	bh=5XnQD3SVtH/iJ5VIGVhHSrK/gQJ5BM8CIjDnTyV8Ksw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxcGF5X7ttBDbbCvLIeziOpEPMBQ/8cSvg/vFz+jhp4cRTFHgx3rSm1DJ5zBVIxKA
	 w1SOgmtRUwG63IoIthO3gIWCu3dwq9LCDjcgA6dWvREXSmRsGOBG2Pcd5t3chfckOH
	 4my73XWsFJhda8+Hny7us/Bioon5mpMpUlnfak/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/272] wireguard: netlink: access device through ctx instead of peer
Date: Mon,  1 Apr 2024 17:45:24 +0200
Message-ID: <20240401152534.867404151@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
index 81eef56773a23..81b716e6612e2 100644
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



