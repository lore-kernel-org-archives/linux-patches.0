Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033DF280335;
	Thu, 27 Nov 2025 14:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254942; cv=none; b=NWgETxOHj0m4Lf+6lTiMz2sNZHeBfYZ+mcoRGl/l88FdC1XrCG3J5H/bC30eTvA9VD3sze1KmGykDCcl15pE3ez6NJHQkgWA9seHz9A4i1P7ikgQVyrMVvbHl9QaPwFbmGaesAEGzek25LpNUEcJyavERQqJyhRIshf//uWLnkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254942; c=relaxed/simple;
	bh=XtYAdB9frzZkskPriRryZQLiHLvn2xoL1sy8Cd+m4kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnTY1RZiAdqjpMUE6kBxKlg1kD8WLZwUJIPPAIKrK/uJnCWVdbFPX0RVepmxfMOJnQ44HQa44WC46BR+PdOycJhXNwb8wSBWpBD3s6dQIzsMAYGHD4yNQhHroadO7rf2F54+ZeGBMLtUrFaGXh7ekL0ex6ZdhOjMEUyGE+JvHuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKb/xTBe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKb/xTBe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C593C4CEF8;
	Thu, 27 Nov 2025 14:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254940;
	bh=XtYAdB9frzZkskPriRryZQLiHLvn2xoL1sy8Cd+m4kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKb/xTBeWMeosk/lBtDLBV5ZMGL4DqzUr4ix4LoxGkhQKm0fQcBpdEgoxP0jCYDYM
	 rJf9AyzWKLXlSW2Ghu576DTyaWswvx0WDpqJR02dCIAnTx9Fi9JPdNI2W3WOkVPGdI
	 0tn0lf//kbSsnQN9EUSpDvBeUgWviex0oGB9PltA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 39/86] xfrm: Prevent locally generated packets from direct output in tunnel mode
Date: Thu, 27 Nov 2025 15:45:55 +0100
Message-ID: <20251127144029.257117320@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a30538a980cc7..9277dd4ed541a 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -766,8 +766,12 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
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



