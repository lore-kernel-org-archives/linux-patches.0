Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93BB347FDF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302478; cv=none; b=tYl3pCJtzj5HLGqspX0S3IQ1i+lKWA8XHfOHHgoW4/CU/+INsC3bEgjUJABZMFYHPDLWPB6mAIutkGocdLATX0xZ9klwoEuMQfQiIm0GmopdvpbSVfrExRLNNRUVdJ98+Z5xC6yZHtiJQrsiZHfJTMMZIanoku0HSULe0c/fGCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302478; c=relaxed/simple;
	bh=155nKOQ0dC7gn/DvlenXg00raW5HYmF2bQiFVsSTrSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9NDaeQfxMZEA0tN+z71+zuZxOaxSbdbqqUVcVVajgnsPpO5xBhWMhwuYF7maSHc29x19+i6moSfOG1u60PoofZUORSXRt17ffM4Qqo7pxJbWF9dOt1Gnof/BF+nZWUChRv4B6gSjgWMhVCN0IyiUZ0Fiiqn41oiL/VgCGASnv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IHCzEe/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IHCzEe/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DABC116D0;
	Sat, 28 Feb 2026 18:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302478;
	bh=155nKOQ0dC7gn/DvlenXg00raW5HYmF2bQiFVsSTrSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IHCzEe/TGxTVESvpxo2eTRWuhnEKckAx+yeigrDaizuYmwZDXHm9u2lkdtN0bHSe3
	 4ucWEDkOsKNZDELiP/Pijukny/VvX+oCOqUVlPNOr4kx1EJf7FtLmVd+l3t0yaKssQ
	 1++0M1YIXKLWEepLP2/xZV/EZazl7Z192s6kFZAMGHI8jVWHrm2MaZ1nTegvMutIKd
	 NZ0fuQuNOFsiVJNUnX4E9RXeI7kVR5ut2vnMgsy5EKn/JUY+R29i2PmQucAIuK6qw6
	 sRh+ouheOIs2ro1Ij7MKIUKl96n4TZjqx25uqNvWUJDvxRp43Ow5EUJu2zUF7QtoI/
	 MJ0YYpKlwll/w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 225/232] net: remove WARN_ON_ONCE when accessing forward path array
Date: Sat, 28 Feb 2026 13:11:18 -0500
Message-ID: <20260228181127.1592657-225-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 008e7a7c293b30bc43e4368dac6ea3808b75a572 ]

Although unlikely, recent support for IPIP tunnels increases chances of
reaching this WARN_ON_ONCE if userspace manages to build a sufficiently
long forward path.

Remove it.

Fixes: ddb94eafab8b ("net: resolve forwarding path from virtual netdevice and HW destination address")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 69bb7ac73d047..c2ca0b45bd37d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -695,7 +695,7 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 {
 	int k = stack->num_paths++;
 
-	if (WARN_ON_ONCE(k >= NET_DEVICE_PATH_STACK_MAX))
+	if (k >= NET_DEVICE_PATH_STACK_MAX)
 		return NULL;
 
 	return &stack->path[k];
-- 
2.51.0

