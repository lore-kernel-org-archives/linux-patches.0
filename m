Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C2E253954;
	Thu, 17 Apr 2025 18:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914939; cv=none; b=nU+jVRIz9Hg24K4urBI9bnVXl/YT5/+G82r2X3fi10K2WJfzSJ+NZPCHJaDYCmmAK/brLboZdieNQPnfnmxF1eG7NmI1LgJFxo2I7vW8jNWp4eocPlAcjRWPo/c5x5SqDDv5OcA8bfxSbQbv5FLysDb8JvDMov7FnMVg5SCVQII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914939; c=relaxed/simple;
	bh=SrmC1QralFhxFsCcg/Xda12CceGa+FLV8WdZIr6Kn9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chYgQ0vfqgKvi1/+lWO08SSG72En5uB7NwIDbfoo3T0gRSTwRhYpXd6HDRPAeXBUi+0zIA+dI+yOFE1MGq+x61OR008E2maSgDVF6BUM0koB/1Mt0/HE5hc7f8SAT7qdRpxntJPf2bf2afQZoaoEmMp2Ebb3LXDOTasVFWvo+Zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TWS0Sv45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TWS0Sv45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9474FC4CEE4;
	Thu, 17 Apr 2025 18:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914938;
	bh=SrmC1QralFhxFsCcg/Xda12CceGa+FLV8WdZIr6Kn9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWS0Sv45Ai02G0bpeBzZNirUyXmwh6rwoPDBfSkGNit+qhoO7P53zC6LarNxje1KQ
	 zTo2t5JbVrDP7DsP9qlRGRtMBXqD8iEJ/qnP15mJMyFhQA27UHbgh9RK+eG3jTjRlt
	 OjWRw2wC0taiTvRM/qGMCzoJepsuKpdoIURMGyC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	"Rob Herring (Arm)" <robh@kernel.org>
Subject: [PATCH 6.13 381/414] of/irq: Fix device node refcount leakages in of_irq_count()
Date: Thu, 17 Apr 2025 19:52:19 +0200
Message-ID: <20250417175126.781006263@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <quic_zijuhu@quicinc.com>

commit bbf71f44aaf241d853759a71de7e7ebcdb89be3d upstream.

of_irq_count() invokes of_irq_parse_one() to count IRQs, and successful
invocation of the later will get device node @irq.np refcount, but the
former does not put the refcount before next iteration invocation, hence
causes device node refcount leakages.

Fix by putting @irq.np refcount before the next iteration invocation.

Fixes: 3da5278727a8 ("of/irq: Rework of_irq_count()")
Cc: stable@vger.kernel.org
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/r/20250209-of_irq_fix-v2-5-93e3a2659aa7@quicinc.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/irq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -508,8 +508,10 @@ int of_irq_count(struct device_node *dev
 	struct of_phandle_args irq;
 	int nr = 0;
 
-	while (of_irq_parse_one(dev, nr, &irq) == 0)
+	while (of_irq_parse_one(dev, nr, &irq) == 0) {
+		of_node_put(irq.np);
 		nr++;
+	}
 
 	return nr;
 }


