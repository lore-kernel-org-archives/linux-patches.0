Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EA62882A7;
	Thu, 27 Nov 2025 15:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255722; cv=none; b=ZfV6P5/WaXeXahkjx1EHeOWBh3I6LKL2Dvl8ulf7x8v7p0CXVQqGWWQgZ+K/7BLoq+paXENmWju/Gmks3jxsEspo/FzEcPhTrmctv9ztUTSLrOe09PlVrW6Q0bTYHztAnQ7JVLQaWfvHSr61NEeVerqKAEbKiwHCAogMj6MC51E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255722; c=relaxed/simple;
	bh=f04QJZ0UlL69kKVZyifNQ3mKql89jIr4MUU/p0f+H+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ub4Pjhy4tqGIy4cGjFJJRKosNHmc0Ioh+IBfCADR79GIp7N0K5i9LsrbrvneI03mpVidgr4jqNN3Yumbu8s6OLCOXYWjzhcNzHDRcFc0n0i06DThqmOVaW6sZVjleAsTdTic4vgCdfr5MsyNRCagov51Ck7Cd0Ih2nAE/rryJdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmgFojFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmgFojFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08013C4CEF8;
	Thu, 27 Nov 2025 15:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255722;
	bh=f04QJZ0UlL69kKVZyifNQ3mKql89jIr4MUU/p0f+H+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmgFojFQeaDV34j+0hoVZPVKmWTamB3ydafGcvhcSCbj2Qi03vPbsVPEVFUgsxGsN
	 lyKqJl5diEXTDB9cQDCSJ6gqt45jM15S2PUw7uspITVKTjmXTvhrHqMdPD2bGZvI0V
	 01t0+z2/sRTUgOAK+M0CZc5UQxeZNXTrDGEiWpIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 090/175] xfrm: Prevent locally generated packets from direct output in tunnel mode
Date: Thu, 27 Nov 2025 15:45:43 +0100
Message-ID: <20251127144046.249801895@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 59630e2ccd728703cc826e3a3515d70f8c7a766c ]

Add a check to ensure locally generated packets (skb->sk != NULL) do
not use direct output in tunnel mode, as these packets require proper
L2 header setup that is handled by the normal XFRM processing path.

Fixes: 5eddd76ec2fd ("xfrm: fix tunnel mode TX datapath in packet offload mode")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_output.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index a98b5bf55ac31..54222fcbd7fd8 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -772,8 +772,12 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 		/* Exclusive direct xmit for tunnel mode, as
 		 * some filtering or matching rules may apply
 		 * in transport mode.
+		 * Locally generated packets also require
+		 * the normal XFRM path for L2 header setup,
+		 * as the hardware needs the L2 header to match
+		 * for encryption, so skip direct output as well.
 		 */
-		if (x->props.mode == XFRM_MODE_TUNNEL)
+		if (x->props.mode == XFRM_MODE_TUNNEL && !skb->sk)
 			return xfrm_dev_direct_output(sk, x, skb);
 
 		return xfrm_output_resume(sk, skb, 0);
-- 
2.51.0



