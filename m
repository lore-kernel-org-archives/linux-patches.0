Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95114F405E;
	Wed, 30 Sep 2026 18:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792090; cv=none; b=HclM8ljWGgkXZi57Av06dAtM3AcqEjgqSGdJhHOmoIWS7BiH1bkOnhVN8Px5twwSQygeNI74xPoAT2vOTBcnpF4Z1kVglD1BQxGyMYphhoRI/oa6ege8EpKXXp5/6k7KOGHU8Rl8gLJJtFyRLhHpSvtSKqBNxh+Jqh7vObJptuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792090; c=relaxed/simple;
	bh=aj3e0noyxpNJzVWekrCAbtVTsdMJ457milqJEIzEeQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGbFwptJ4rfs1/EdFZnMFhu/sFi832AeaJVFV+wzidPf5VMofdHFEhMzLYgULVnH3WJraHpJ713ZtaAKiFuaV1Fz/ymC8trc7YeypdrGd2nTwTuN3/XhQRkSpT74yT9VVaf0oIf4W5AFGX9PRVh2tlqre8lrTpGMQIQ81sXOwbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVpGu+S7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVpGu+S7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B171F000FF;
	Wed, 30 Sep 2026 18:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792089;
	bh=XjEQjtut+dXcVp4wREpxtxZJ6zzkvjW6lkdbvjymN6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JVpGu+S7f7zBh5zQGraW/snER1QAGl36ux71sxlaF+1/Vldl3xQjuR099OvWN5x9N
	 I2PRes1JRjGXS485DJTmQ46Nam8vbqhj/bx/trgGlwV+idYyTE3YKI02yCsFQLHr/N
	 GYrK0E8dHhjkFxp1+dB5h95dQAly1vJwSrELD/tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 532/752] dmaengine: ti: k3-udma-glue: fix NULL dereference in k3_udma_glue_release_rx_chn()
Date: Wed, 30 Sep 2026 17:26:42 +0200
Message-ID: <20260930152409.764390597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>

commit 0294b6dd515256c03ea2dbf508ddd3826d788579 upstream.

If devm_kcalloc() for rx_chn->flows fails in a channel request function,
the error path calls k3_udma_glue_release_rx_chn(), which dereferences
the NULL rx_chn->flows pointer in k3_udma_glue_release_rx_flow().

Skip the flow release loop in k3_udma_glue_release_rx_chn() when
rx_chn->flows is not allocated.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d70241913413 ("dmaengine: ti: k3-udma: Add glue layer for non DMAengine users")
Cc: stable@vger.kernel.org
Reported-by: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
Signed-off-by: Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260812053426.3521589-1-Alexander.Chesnokov@kaspersky.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti/k3-udma-glue.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/dma/ti/k3-udma-glue.c
+++ b/drivers/dma/ti/k3-udma-glue.c
@@ -1103,8 +1103,9 @@ void k3_udma_glue_release_rx_chn(struct
 		rx_chn->psil_paired = false;
 	}
 
-	for (i = 0; i < rx_chn->flow_num; i++)
-		k3_udma_glue_release_rx_flow(rx_chn, i);
+	if (rx_chn->flows)
+		for (i = 0; i < rx_chn->flow_num; i++)
+			k3_udma_glue_release_rx_flow(rx_chn, i);
 
 	if (xudma_rflow_is_gp(rx_chn->common.udmax, rx_chn->flow_id_base))
 		xudma_free_gp_rflow_range(rx_chn->common.udmax,


