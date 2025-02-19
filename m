Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D041C7013;
	Wed, 19 Feb 2025 09:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956588; cv=none; b=C5ipDFqaYo35nVHLEyo1bhF217kzx+qjQnnFxAmGxyGjjojJe60RCulA6IuSvY+Rdml4vr4MxpQkLxFtn0mK3PwTeKM1UQX4FrzD6HPTBD/yPfbUgO1GJXjG9GdFJS2CPBKrITJbO0dD43O7GHCIkrCNGw46T0huBBjbzhuwkaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956588; c=relaxed/simple;
	bh=gJpdVsUw1LQ1FyYLU1yPAGqXZG7DqTIVPe0I1Wu3SmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrAKgFyG4YK114l81axjF0+8bbZKNa5O9D1AKiahX4eI7HI5jz2Ip3YZBZ78PxH58+O9In9M1Q/QYqI9fVuT4zY3jzg4T1Kn9d/c1hSJgg/x2F+9XnrzJSKguknJJPXpMfm9P2VwA+W7bZpFgXqSLM1lkcVcepQr7Tf9LzmeuSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sfnh2S7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sfnh2S7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D746C4CEE6;
	Wed, 19 Feb 2025 09:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956588;
	bh=gJpdVsUw1LQ1FyYLU1yPAGqXZG7DqTIVPe0I1Wu3SmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sfnh2S7srFD5j8RBVnzQil/dfvTMTsO21PPOsFoq9FIql5IoOauuUZU0LG+P+ZKjy
	 rzbbuUWZNZnLxBlboUb4xdrn647wLXcMc0yijoBqqAU7hlaiQG9Q2LrPGGpYDt+uyF
	 6xwHl9TS+8p7VrnxtntuvBLCDQFcH7OJ3YSSiIRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 213/578] dmaengine: ti: edma: fix OF node reference leaks in edma_driver
Date: Wed, 19 Feb 2025 09:23:37 +0100
Message-ID: <20250219082701.437226766@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit e883c64778e5a9905fce955681f8ee38c7197e0f ]

The .probe() of edma_driver calls of_parse_phandle_with_fixed_args() but
does not release the obtained OF nodes. Thus add a of_node_put() call.

This bug was found by an experimental verification tool that I am
developing.

Fixes: 1be5336bc7ba ("dmaengine: edma: New device tree binding")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20241219020507.1983124-3-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/edma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/ti/edma.c b/drivers/dma/ti/edma.c
index 9212ac9f978f2..89e06c87a258b 100644
--- a/drivers/dma/ti/edma.c
+++ b/drivers/dma/ti/edma.c
@@ -209,7 +209,6 @@ struct edma_desc {
 struct edma_cc;
 
 struct edma_tc {
-	struct device_node		*node;
 	u16				id;
 };
 
@@ -2475,13 +2474,13 @@ static int edma_probe(struct platform_device *pdev)
 			if (ret || i == ecc->num_tc)
 				break;
 
-			ecc->tc_list[i].node = tc_args.np;
 			ecc->tc_list[i].id = i;
 			queue_priority_mapping[i][1] = tc_args.args[0];
 			if (queue_priority_mapping[i][1] > lowest_priority) {
 				lowest_priority = queue_priority_mapping[i][1];
 				info->default_queue = i;
 			}
+			of_node_put(tc_args.np);
 		}
 
 		/* See if we have optional dma-channel-mask array */
-- 
2.39.5



