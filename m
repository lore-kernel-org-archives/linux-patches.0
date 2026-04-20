Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD6C3D75D7;
	Mon, 20 Apr 2026 13:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691426; cv=none; b=iUU2n9vDo/LFOuejuRHL4uFCZ+Se72iwIoBF3v5goqNVR9ZXw99E8maxQODIrvt1j+VveElPybgG8zajtYGttepogSDAPDfTF1uPAIongMqpOxvD7t3BH0xTUu8ufnltp+tOxVngvjv9gGchGiJuL/n+aN6uSKt/pUYFCjzoOHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691426; c=relaxed/simple;
	bh=7esXPXSJ/ZP/jTJgN0exkzf/P3sXEoopdpAcZN5UGic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D3Yae0/H/UoF82v6COsIER3bo5GmnUOin3/fUjUbJHAHr+yxA39cVtooevdE40nLqE5ELHKP1xUW2KdaZnq0B9SAvRj1QGKnOov8ye6437lFeE6edgvb2rkw1dMq0a6+OC3JuRcGH234+NCUH71zVji1oIYwasVPXvPiBL39XJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O48FwW0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O48FwW0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBD7C19425;
	Mon, 20 Apr 2026 13:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691426;
	bh=7esXPXSJ/ZP/jTJgN0exkzf/P3sXEoopdpAcZN5UGic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O48FwW0b+8ml9Rp5oCUOhR0VUqG6i78Mm8g20SvfhgUqHNZw4E9CW2B1iDsNcaVsD
	 1FwgNTHPEurDvAwCrH2JzW/6Av1kgnm9hqVYOLOgROrMsuTn3Yzfxo2rH8Hqo+Y8pn
	 KslEv4yNgnzJR7i7DKc6xTW5TmtGSxT4PfPSkjZ1IcjjbAcTY1rQTK9CcW/34cGwhy
	 C8fB7m6Q0lqUwYMOxYHTJ8vVrm6tdEC5RiGBsYFk1aHA/QvyRih2/FblenhwoGEX3i
	 hLU1cSQFa7xT4jYNpArfaavktyTNK2ns2SdA4i7WvVsKqHRlPzA6pSB++vurTlQCvg
	 na7pcjClsJDNg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	magnus.karlsson@intel.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	ast@kernel.org,
	tirthendu.sarkar@intel.com,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] xsk: fix XDP_UMEM_SG_FLAG issues
Date: Mon, 20 Apr 2026 09:16:54 -0400
Message-ID: <20260420132314.1023554-20-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 93e84fe45b752d17a5a46b306ed78f0133bbc719 ]

Currently xp_assign_dev_shared() is missing XDP_USE_SG being propagated
to flags so set it in order to preserve mtu check that is supposed to be
done only when no multi-buffer setup is in picture.

Also, this flag has the same value as XDP_UMEM_TX_SW_CSUM so we could
get unexpected SG setups for software Tx checksums. Since csum flag is
UAPI, modify value of XDP_UMEM_SG_FLAG.

Fixes: d609f3d228a8 ("xsk: add multi-buffer support for sockets sharing umem")
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://patch.msgid.link/20260402154958.562179-4-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 include/net/xdp_sock.h  | 2 +-
 net/xdp/xsk_buff_pool.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index ce587a2256618..7c2bc46c67050 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -14,7 +14,7 @@
 #include <linux/mm.h>
 #include <net/sock.h>
 
-#define XDP_UMEM_SG_FLAG (1 << 1)
+#define XDP_UMEM_SG_FLAG BIT(3)
 
 struct net_device;
 struct xsk_queue;
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index aa9788f20d0db..677c7d00f8c32 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -259,6 +259,10 @@ int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *umem_xs,
 		return -EINVAL;
 
 	flags = umem->zc ? XDP_ZEROCOPY : XDP_COPY;
+
+	if (umem->flags & XDP_UMEM_SG_FLAG)
+		flags |= XDP_USE_SG;
+
 	if (umem_xs->pool->uses_need_wakeup)
 		flags |= XDP_USE_NEED_WAKEUP;
 
-- 
2.53.0

