Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C54243376;
	Mon, 20 Apr 2026 16:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701307; cv=none; b=V4bE1kcPEDxfs8DMnQBZeOmmv05pyT1/eGR9hZI+J8hjgGrT5iKqzGDsGm4LCigv2ZzBFUukRVfQzMnDuGj4Kxqhn0epqUpTU5MjuMmmuLctMkk+NDuiUpTsMHiXpDy0Ih4jAAq6UFuljzJxACYM6LylP7FE2xiT718IQrYuzAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701307; c=relaxed/simple;
	bh=8b+A6vGa5JuTm15pyxvHh5b/eK4TwkpwuQm+BnOfN9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WojYTOGOP3RNnccBSXNbvxYI0uXD3QL3j9MibshVW6PbITEiXZiYfqa46yS/n+wQPPjpPsgBxwyvwFpmRqjEFXX3839nG7XGLuTXBUiginKN7tjOLv2LPzeFs7c2/fKGoShX4pjiPmppWDt5e/9CI4eI3nOKFqsdhwWzZeUVMuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C2PWuBbR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C2PWuBbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6778C19425;
	Mon, 20 Apr 2026 16:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701307;
	bh=8b+A6vGa5JuTm15pyxvHh5b/eK4TwkpwuQm+BnOfN9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2PWuBbR1wjnoWvWx/GS3CgeZYQdNb5vWksj9RGcWtMcKUJ86zbtdcwozJhjHkrLS
	 pt60yd+RSDmEzjT+HXjiCo4zuFVyes6d7on0NCpb0o2NT0KMBn8jt+3SBiNyQEmZP5
	 yYak9rK3F8E1+fIcjAvqqRUbNfl/vsoQtMpt9ZgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/162] xsk: fix XDP_UMEM_SG_FLAG issues
Date: Mon, 20 Apr 2026 17:41:35 +0200
Message-ID: <20260420153929.319957849@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 include/net/xdp_sock.h  | 2 +-
 net/xdp/xsk_buff_pool.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index df3f5f07bc7c2..98491d774d826 100644
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
index 9db08365fcb00..a9d8aa83f8000 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -255,6 +255,10 @@ int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_sock *umem_xs,
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



