Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF6A3019D8;
	Sat, 12 Sep 2026 14:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224036; cv=none; b=TQA8qWfff3rY3PypGpez/09LHm4ttp/oKC0UJYR3IAsGxIXcAe8u21crHQEjRIT1JIAXQfLdLf2jIXgUT6xwbWMNWAr7QqOpFmleFED8UxZSEvYYRa1CAzpFvBzXQR9gsYqYGgJcIufW1Dyf6gTricTv7tdPN4YsNvFhzgH+FjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224036; c=relaxed/simple;
	bh=B0pfCfQL6DgkgCyagQ6f8hcrzKxHPFnsLUWitKNqhU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrvcRaTWzjbqqRFWXDpC+oPnjuSJjyrRVptaCqfIOxqOfyKJwUMD/0CFterDyDTbgfIjX1eH+P6lwzPN1+66v169o4eY+O8IOXAiWugxfWiOWIap7MkCD8ypVO/3pWpCr1b007H+3MBUXJETSu84J47RMJvoqncXwwcM1fHCXkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBttxeRp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBttxeRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63941F000FF;
	Sat, 12 Sep 2026 14:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224034;
	bh=eTLXkZVGkrV1elnZiNYIBLVvV/Bavov9b17LnjGUDoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JBttxeRp4tJKY+zFfjBeLfZyPoSvoqE/QMS10cb2punm4yjhFzsPWLxZRSBm+ah9q
	 ochx8kBUYWeQhBgNd3DcDyFYPcv1y0livDQpvp4dObdlXPudRcjLor9tYGJHqXeTxb
	 RQ8vw/4nv4cCdZ6z/gb70wOQBMlvFeDIJ+swMqzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0867/1424] xfrm: Fix skb double-free in xfrm_dev_direct_output()
Date: Sat, 12 Sep 2026 08:54:59 +0200
Message-ID: <20260912065626.734464924@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index a5b5d82bd7550..53654c5fa9e98 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -627,10 +627,8 @@ static int xfrm_dev_direct_output(struct sock *sk, struct xfrm_state *x,
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



