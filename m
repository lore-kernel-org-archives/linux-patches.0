Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF32229696;
	Thu, 12 Dec 2024 16:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022175; cv=none; b=D9GQHQgaKvcvGLl+Fti0I3DUWbJo914dcjcSmV6FKrv+Ru5PA/5MdNBM3jf0Tiv07GSjmoZVYrQnwZsLZPsLHSm+SEBPUnQgrk3r8fzrkvmYTblBJDhe4F31ZZIg+2Su/4BaMOBLM7ijbxoZIX+08oHf6yI0PHKgm1Kh+ZELKFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022175; c=relaxed/simple;
	bh=lDTGMk+l4Dx7Ate3TDj6yY/32uVqTjDKlDmOZGeYYTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miqBeFnEdG6p/Edr+OVz5j4QSkyR5cquF8j8YHjyIIm92ClzjBxlh5r7zDWVWEWnvjDtqIexSfrVpV7zgu5On6JhVdxBpLD0SeJoa3gSbet9GriqsTpXcdrEUtaENwoAX9eWARCI0l/rIPPL/FBY0pUllqR+wZkxGwlSSVU0Sgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6jKObp+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6jKObp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A42EC4CECE;
	Thu, 12 Dec 2024 16:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022175;
	bh=lDTGMk+l4Dx7Ate3TDj6yY/32uVqTjDKlDmOZGeYYTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6jKObp++1nG9ydUYmN5gnR+lF51vn2iPOVHVeRGCk8dqFbpJG9j36sbsMpDy8zSe
	 JHOrKN5SBFayDugsUuZRANkC6zccG5FMhDa3CUTXGSF0CUDhqsV+1j2yKVpXSTCCJG
	 Hpk2nLGItoDn06gnWbFBDsW/+UUu0/IK4qPeakcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raed Salem <raeds@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 169/565] netdevsim: rely on XFRM state direction instead of flags
Date: Thu, 12 Dec 2024 15:56:04 +0100
Message-ID: <20241212144318.155079396@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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



