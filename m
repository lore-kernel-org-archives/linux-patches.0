Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7441E2F8BC9;
	Thu, 27 Nov 2025 14:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255248; cv=none; b=qA1d+N1ABTOPiEncV+Zke7RILjYEY+aUqOgQJ7kojfv8z7MgMMnUPf/AVcA1cPWJt4Og+L4hfGcfU6D1KFSqUCl/i67b0vpdjSXMyl55b9fLYoKKPRIDGwF++z/65JNQbmgNR6mR/RyJZD5ZTBoanJjjiALjMAEa7HOQgaOQOSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255248; c=relaxed/simple;
	bh=zorpkr6U0gB9k1WMOM2RZv9Hr0xxxV9BnJraugY2eDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=datjyoVx8zzVHkJ4+5fzmDCit11Ql1MJR02gIDeBk202f7Ixd7tR4L3KEtJqW6GyL2D5q33RS/Xq4tfgZWtN88XwjijxgEuk4jsR9MLe9RpEBMWX+17XlUeVSJvefGigJc1p93JcYif/nvhMn8X4+Q0jiDYQ+PeVoRVmqsaVaQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CpzzjjqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CpzzjjqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816C3C4CEF8;
	Thu, 27 Nov 2025 14:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255246;
	bh=zorpkr6U0gB9k1WMOM2RZv9Hr0xxxV9BnJraugY2eDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CpzzjjqZONLkjRv/aiQPb+GNyIcBjqqjY0wf83HPTTXggCOCRwXujP0iirnkvaM7l
	 8qowut2axOUI0X1CoQaVMlcXcXYEptaTqvhSB8D5y/jq71kaMw7xAr35My02E/GB8N
	 Cri30985P8kNl94hDp3YIjOmONexfh5K4+ex5DoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/112] xfrm: Prevent locally generated packets from direct output in tunnel mode
Date: Thu, 27 Nov 2025 15:45:59 +0100
Message-ID: <20251127144034.927887776@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



