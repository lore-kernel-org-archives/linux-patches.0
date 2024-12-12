Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1BC4F218;
	Thu, 12 Dec 2024 17:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023897; cv=none; b=eSjjwAUsUHHhPlwDiYy0yAN7QHrNIMFWgAyNRjS3WqS+Zs4B3/A2g4YCiWCu8lmoPVjDUPXyeurk7/jD1hq3JwjR/EaAeb4umBIlYa7KdBpQ2KFelIMO9UgcDhl4betv8QijuqMP5ea6oKHp2txoRmduMKcPeWPerrLMF4TVMOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023897; c=relaxed/simple;
	bh=06HP+oMiJ6lNbY41xTaCeOO3qOgSg9SV1k4x9uLFyt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhEqj+0LuONB0ss1RyMJWSCI/Gq9y3/mcxzHLvuFPAl4Lr3CZejMyFxtZ0MDmOqT2fW9Sya2MAlCoAq32bRNuS2FtYrf58Gm0xlshY6cWg2T3SDIpzM8p2jlfa/M3CtCNeUPXZ3Bja8blyjcwB36f4+WFQSJDqPzm8eKH1Ks3b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PeWDon2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PeWDon2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9EFC4CECE;
	Thu, 12 Dec 2024 17:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023896;
	bh=06HP+oMiJ6lNbY41xTaCeOO3qOgSg9SV1k4x9uLFyt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeWDon2MUQBvab5P0b9hw4YLVIO7oUofUlYslwdcEjS3m4ZghTzU2+Gk/yEeb3KDS
	 ARzajzYqdCr2O0YpG3Sz1wCjkbq0jo6ojTEreEHmZIpsvI+mlSoCZ1Nms9fnMSrTFz
	 TUtiOxuux+4meJEVHl/WZALZCChw0wRoS+YbivuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raed Salem <raeds@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 117/459] netdevsim: rely on XFRM state direction instead of flags
Date: Thu, 12 Dec 2024 15:57:35 +0100
Message-ID: <20241212144258.133263221@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 55e2f83afb1c142885da63c5a9ce2998b6f6ab21 ]

Make sure that netdevsim relies on direction and not on flags.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: 2cf567f421db ("netdevsim: copy addresses for both in and out paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/ipsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/ipsec.c b/drivers/net/netdevsim/ipsec.c
index b80ed2ffd45eb..386336a38f349 100644
--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -171,7 +171,7 @@ static int nsim_ipsec_add_sa(struct xfrm_state *xs)
 		return ret;
 	}
 
-	if (xs->xso.flags & XFRM_OFFLOAD_INBOUND) {
+	if (xs->xso.dir == XFRM_DEV_OFFLOAD_IN) {
 		sa.rx = true;
 
 		if (xs->props.family == AF_INET6)
-- 
2.43.0



