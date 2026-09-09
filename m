Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0814565117;
	Wed,  9 Sep 2026 14:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963415; cv=none; b=WIFE/d3OZV6NNAh292riaxUBxZzEvw3zz6AlvXEpukZefz9WkfBnr7CjrzXp14xo6YbcErr1BcVozQ3Ap3/6hvP7ScFXgRxzc4QYWLHIfMb7Cj1caGdrep6nL2ukgJX1QeyHwz++ygHqFGfnx6SIs/sm1TyS5IcSae1AnxviLRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963415; c=relaxed/simple;
	bh=wdBS76CSpxIpdTh1vzLmLUU5ls1zFt0t93pd0E9nTv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3A5zD/umvs5uy/jO9kcjunhZH/KVGYT9YH10PyAeB5aDxg5bLilkiuu87eE07Hhy6n8k43s+oGJkx5PHzA6TWo+9kaFNJPCvUiori6RS7C+iBsAc1azQ3NFaW8u7CQHPMPtEvkxc6gEieghOlcKgBH3iScXAcnDJvosx77mAUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wMZ3BvyJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wMZ3BvyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2275F1F00A3A;
	Wed,  9 Sep 2026 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963414;
	bh=xtXIr3RFA5isT7MYBK2rQZcs7DL5utyrGgndomWPIC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wMZ3BvyJDcy2KuArutP1jj/PmH2pVJeIhPw9l+m6XejX1q5DNKOR2HKKLmklS3L2Q
	 2MpaMX5PGNokbCYgbFRj9bSqq8FywWyrdrGqrFi5nXksiJp9rJJPIAJPGbYCODLpp4
	 xwHpPA5mexkN0YVMVeECacayVrQYjK36r9zkKcHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Martin Kaiser <martin@kaiser.cx>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 070/583] dmaengine: fsl-edma: tracing: no ptr dereference during log output
Date: Wed,  9 Sep 2026 15:35:55 +0200
Message-ID: <20260909134240.505459981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Kaiser <martin@kaiser.cx>

commit 2ea04dca8e627f722caa7a2037cfbae0257f3501 upstream.

The fsl edma events store a pointer to a struct fsl_edma_engine in the
ringbuffer and dereference it when a log entry is printed. At this time,
the pointer may no longer be valid.

Event injection can be used to trigger a crash:

$ cd /sys/kernel/tracing
$ echo 'value = 0' > events/fsl_edma/edma_writeb/inject
$ cat trace

The log output needs only edma->membase. Add a membase field at the end
of the event and use the new field for log output. Keep the existing
fields for backward compatibility.

Fixes: 11102d0c343b ("dmaengine: fsl-edma: add trace event support")
Cc: stable@vger.kernel.org
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260718130024.341243-1-martin@kaiser.cx
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/fsl-edma-trace.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/dma/fsl-edma-trace.h
+++ b/drivers/dma/fsl-edma-trace.h
@@ -19,14 +19,16 @@ DECLARE_EVENT_CLASS(edma_log_io,
 		__field(struct fsl_edma_engine *, edma)
 		__field(void __iomem *, addr)
 		__field(u32, value)
+		__field(void __iomem *, membase)
 	),
 	TP_fast_assign(
 		__entry->edma = edma;
 		__entry->addr = addr;
 		__entry->value = value;
+		__entry->membase = edma->membase;
 	),
 	TP_printk("offset %08x: value %08x",
-		(u32)(__entry->addr - __entry->edma->membase), __entry->value)
+		(u32)(__entry->addr - __entry->membase), __entry->value)
 );
 
 DEFINE_EVENT(edma_log_io, edma_readl,


