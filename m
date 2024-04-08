Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EBD76413;
	Mon,  8 Apr 2024 13:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582063; cv=none; b=DQd6XO8Wnohta+3glIiDNvPa1WxYmP4ec6bVUOzMm26wxvrBLI9Ikm4XgJ/4ZttSb3gABSaYpp1y9MrZD908wJvFy3WAEwUBNxzjj931rglCKvucbgilocIdRXen7Y1dkC6jNtzhyuNvPp0njrv85xKoIoSkN6sicxCOQZScL4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582063; c=relaxed/simple;
	bh=D49xngul/x87GpeA8HlXS8Y+JUOa8zmz20j+mq6CkOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pC5IsKjzoVWkzLYMLby8v87cZpWrtVtbPfAVuE7RcfPxRFYmvgg81sZZcbOGzXSLlHtNZGmvY4idksHHXsJKa8Gd0A/ylIsi7d2AyYmVeryKOrFMzkuaL0JIiQvka4/Z2ncwwrLlXGsC0tzUlSgYLpLZThuXcmqMRqxU1JNwtq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYPAElkR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYPAElkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFADC433F1;
	Mon,  8 Apr 2024 13:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582063;
	bh=D49xngul/x87GpeA8HlXS8Y+JUOa8zmz20j+mq6CkOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYPAElkR7CNpd+F8wlTbGzYA0CTG+cr+3a9pnG8XkeDoFbZ2+58ZnEQj5P3jOd5RT
	 rtq42R6ruYHSnUmjyCrMZsp4Y/bo+PcoCLAlXZ2KTOCfn7LxCfptYr9oXUb+0MpNJu
	 xFi7NeLFT8fgz8v2v5B/XzIsvMQ7I3dSG7/6uAIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/690] wireguard: netlink: access device through ctx instead of peer
Date: Mon,  8 Apr 2024 14:49:34 +0200
Message-ID: <20240408125403.431591726@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6523f9d5a1527..9dc02fa51ed09 100644
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



