Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74FC1ACEAD;
	Mon, 30 Dec 2024 15:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573546; cv=none; b=UgtUJjkRd9qIJ098B9lBw/vS9q3wvaoNd7PgmD8tAHBWkDcM07MbptX4WjB1Vs1enXQXJ49TbVPSr/pJXLyDQ+fKd1I7GmXvV2w5thBDbp1LjebDLIxtFmQkhegeU35XzIYb99zrPehlKbRJbGYe9f1D3vxIHLed2XaFlxdaFLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573546; c=relaxed/simple;
	bh=ftlBm7japz6dkcj7pc/+vyQ6SOre9QHZtVBy07an7CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MZIqHnu/zZiBuvgTZguov4s0Gx52GVgSN9xui+wjT9s/ymM/Gh+bEdX7LvRzK9VNX5gOdH2un10L2SDnKtJt21sxq4ocQiPJ2R4ZBSTt2t3cEhzOrHrXf/iOzyJxOL9k2aFhhG1+Gj2mtr+no0J74e49hlWj67PMyasdEX1Unzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPCjzUvv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPCjzUvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DA8C4CED0;
	Mon, 30 Dec 2024 15:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573546;
	bh=ftlBm7japz6dkcj7pc/+vyQ6SOre9QHZtVBy07an7CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPCjzUvvJZDTkzHluL/C2PPTPY2Z9pRgMwzGLpwTuHVNTN7M1EC2xDBL7e/B5zHfB
	 0pC1UaR9x9YYSvFrsypTEtNpsCT03wiN4BRmNmZN2SPpZuIVonmaOMz7FfkBy4N/3i
	 BVR/dWEPFAcdFARaBBffY7nRKqIDoxy7DpP9P27M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.1 18/60] dmaengine: mv_xor: fix child node refcount handling in early exit
Date: Mon, 30 Dec 2024 16:42:28 +0100
Message-ID: <20241230154207.979780234@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 362f1bf98a3ecb5a2a4fcbdaa9718c8403beceb2 upstream.

The for_each_child_of_node() loop requires explicit calls to
of_node_put() to decrement the child's refcount upon early exits (break,
goto, return).

Add the missing calls in the two early exits before the goto
instructions.

Cc: stable@vger.kernel.org
Fixes: f7d12ef53ddf ("dma: mv_xor: add Device Tree binding")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241011-dma_mv_xor_of_node_put-v1-1-3c2de819f463@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/mv_xor.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1393,6 +1393,7 @@ static int mv_xor_probe(struct platform_
 			irq = irq_of_parse_and_map(np, 0);
 			if (!irq) {
 				ret = -ENODEV;
+				of_node_put(np);
 				goto err_channel_add;
 			}
 
@@ -1401,6 +1402,7 @@ static int mv_xor_probe(struct platform_
 			if (IS_ERR(chan)) {
 				ret = PTR_ERR(chan);
 				irq_dispose_mapping(irq);
+				of_node_put(np);
 				goto err_channel_add;
 			}
 


