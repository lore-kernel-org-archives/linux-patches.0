Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB9B3DB983;
	Sat, 12 Sep 2026 12:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216082; cv=none; b=kSDiJQ5mwJL9MqPuQ9OY1gkZG0fDbb7Ot1Ct/lG6efrRF+y+pc1Ktt/lVuDza2ArZV8D/p/djamlym/2atjmF1W2/HYnswsLc7iU6wudqyOIulX9GeqqttJnInOQWhKRxD4zwOaL+s8B1qmOtIKaBfa82P/JVr/Lw8rYc24cms4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216082; c=relaxed/simple;
	bh=C/f5r6VNPt6TifmHg4YG1ddocgr+8hE09lElM0cuH0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5FXYl1/ETS6ZEaiRM5cCiNCya8bPnVK3qkeX7FCUovgobpQfY9eQojaXxyOKDfp98GBKEUg18v/4LkFK1sN/ylLftMj4ZnK8TrKiO/D7dGiHqDbaI2GSIyUEUHJ/kB1D9xiAWJ8/macJOAnyKvjRBRxjmd2JPchDgA9/FYch3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEqUiw8O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEqUiw8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D5C1F000FF;
	Sat, 12 Sep 2026 12:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216081;
	bh=OX9My94QoQzXxmwzLaebSfMAkHuSXLLZTYNHfXnP22E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HEqUiw8O8TfLweFULnsq4H7I427ZNPkmpSkwYMBpXcfc+USdOUO7HHwTnYs3+VYMb
	 vD+fDhcsfR5YoP5Jg8LJDXnBEMsj54/6Sm5sY8Gv+5DX1e1DUS8dcfWCWJCUhW4iZA
	 FxtOOrmj6M0cL6C+uiYN/15wta1Czt7p9sGGCpQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0665/1376] xfrm: Fix skb double-free in xfrm_dev_direct_output()
Date: Sat, 12 Sep 2026 08:51:31 +0200
Message-ID: <20260912065622.364036891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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



