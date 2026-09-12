Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B781E5B9F;
	Sat, 12 Sep 2026 07:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199661; cv=none; b=AzzGBrg1N1NKGTCJLFEHjKmZISmQTusqaFA7Jo2Et80PhACZpI7xWtbMow8tZxAx7ZIWZIuFrmLPk6niwGneVslo2DQ6ewFGqmpPfG1pZJ/YCcCuoB4wNjuhhKqakgVxAO2zwNiYUm6T9HymS6sKvr4ZnWuV7VMaGZcMjNH7EO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199661; c=relaxed/simple;
	bh=RFh8RZB2kSaFPk9u7RWMB7XzXu7yc7GKmounlHAY1Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYI+5LQGKHP7YqSnw1e5cIAgJS9X/6ZgBkCSLQJakJJWe38OKR0qfQoW890hBFGR0gXGhIaA4FR4n9AxrIEpH+ugpj9hamSiTqno+anDUy+v2HsYBnVEeLnM77s2zry09FxmjV7xxu59ik+dhy8ROdIjRT8mfgEZMs/1nz/A8ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ux+u9cMX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ux+u9cMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88DA1F000FF;
	Sat, 12 Sep 2026 07:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199659;
	bh=WHXycXsd/cNa/k97OBYHXG3MGXybdySxJAHMFSsstB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ux+u9cMXcZpUT1zYWTchBAmyZosC5Yhyw7FlEvhYIEBHPzKSp7GPmzdK0ngKjf1a8
	 v9kN9GbYn7Um62exraFdKwJwTttzj6KlbLEShx9zlrRmzYTuqZI/wBpsHjuPxHRmj2
	 oVpBXLPboAs5TVASN9QhODK6RsRLLw16yUbIYREg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0629/1815] xfrm: Fix skb double-free in xfrm_dev_direct_output()
Date: Sat, 12 Sep 2026 08:39:39 +0200
Message-ID: <20260912065703.645757058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanghyun Park <sanghyun.park.cnu@gmail.com>

[ Upstream commit 2aed51fc58d9ce450e2c116efb956160fd06fa02 ]

A return value other than 1 from local_out() means that the skb has been
consumed or its ownership was transferred. xfrm_dev_direct_output()
nevertheless frees the skb on this path, causing a double-free when
netfilter drops the packet and invalidating any other owner.

Return the local_out() result directly, matching the ownership handling
in xfrm_output_resume().

Fixes: 5eddd76ec2fd ("xfrm: fix tunnel mode TX datapath in packet offload mode")
Signed-off-by: Sanghyun Park <sanghyun.park.cnu@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_output.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index cc35c2fcbbe09..e305ba32e356b 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -636,10 +636,8 @@ static int xfrm_dev_direct_output(struct sock *sk, struct xfrm_state *x,
 	nf_reset_ct(skb);
 
 	err = skb_dst(skb)->ops->local_out(net, sk, skb);
-	if (unlikely(err != 1)) {
-		kfree_skb(skb);
+	if (unlikely(err != 1))
 		return err;
-	}
 
 	/* In transport mode, network destination is
 	 * directly reachable, while in tunnel mode,
-- 
2.53.0



