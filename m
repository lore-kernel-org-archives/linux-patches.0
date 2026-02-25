Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565232D3EEE;
	Wed, 25 Feb 2026 06:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002730; cv=none; b=cjTFi/AotXV+WM9ZQbMDVa3StNHt46zZEMenDVxApoEalLOa1JV6Cub8QdynjMH8HS1NHOjHWotYXUrKlGYm16ynlhlAqlkhJP3Qxgriz66RsUd26IcRF2vFmkn+uq4f0+wp42FeQbERCUA1zjHLHLVgvGlPEI0bRvEpmeYIhrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002730; c=relaxed/simple;
	bh=8eIvQBDzGAYabG3K+Ytjt7XNFtUNgo6aUAbf+NPyGXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paS/3I07Pkb6ktRyoZ78QCMx97faimm4Xo4rGNk1j75EmXRPXdWI+yFLFSdEHs6PxqIIunBvFuEvroTvSaA5+82X2qbiN15/96qSBnD4Yczr0FOdfUHkSFv1sXIQJvwGkMIq/L7bwKU4v7kn6HMJbWnqrRODpuqHbEmarQrsygA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSBb3rJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSBb3rJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3017BC116D0;
	Wed, 25 Feb 2026 06:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002730;
	bh=8eIvQBDzGAYabG3K+Ytjt7XNFtUNgo6aUAbf+NPyGXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSBb3rJFOK4BEoDfhg9V2qpix0CrniKIfcALCpJ1vMzQXFJ4A4lxd+9xHiU46Fd6M
	 eKWDWVja5UYYyyEVw02VroCfrFwxlYyx2xHMnJiL1Acl9DwU1nRW0oPbHe0YvVe4ty
	 JBpt2XU+tGT1ybEp7Bj8VzS8rjD1b77X1N9ONYls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 543/641] net: remove WARN_ON_ONCE when accessing forward path array
Date: Tue, 24 Feb 2026 17:24:29 -0800
Message-ID: <20260225012401.688543837@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 5b536860138d1..ff70c902a4196 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -738,7 +738,7 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 {
 	int k = stack->num_paths++;
 
-	if (WARN_ON_ONCE(k >= NET_DEVICE_PATH_STACK_MAX))
+	if (k >= NET_DEVICE_PATH_STACK_MAX)
 		return NULL;
 
 	return &stack->path[k];
-- 
2.51.0



