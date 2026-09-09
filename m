Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEFF4C6803;
	Wed,  9 Sep 2026 13:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961919; cv=none; b=bov3Es89MKJDW56n7Ha+tOX8YmJ+E1hW3Urs5/4rmU/v4jm5i0hRehCnhvQ0x2kRIOUgMpDAEsHgpvAVZLWaWkrxeybjJsc2rexNVMv09ueRWfsEwnpaVpAsuuw/eJKrZyAMlVmuyF19JIsaqA+jCUiFSUsYuc4WLScN9iSkhns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961919; c=relaxed/simple;
	bh=c6R3Vx/LCwkHX3hY13ACGsDzD0IEz9Of7WMWi8dUExU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhWlt7u0xhG1J6utUAXheCy1DJAl+XR3OFrjM1+WLgQi9OZZH6OQUS2bdsV6+GTJQRhTmh7OQVTQkxqH3BnWU61w8TCbwgMVzzXuFUJ5YzJaf+ZoKa4tAVpv5sRAsoqjSzRd0bSEXsF780GdUwNEtKJf4fV3lrczhbQtOYHGibM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yiMPzdZM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiMPzdZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE48B1F00A3A;
	Wed,  9 Sep 2026 13:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961917;
	bh=Ggm1i8w6eALbYx8T96OOKNzQEGDq81zuA742e+M1PWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yiMPzdZMR4OZnPsfBsmZV9KqCFzERBWTKqpKTLf3U9WQnS0MY0KojAhaZT/xEympN
	 m+BtPQmXfVpCjFIpXoxvMdWSbQ3hf8Kk6hinH88zUQm/krm01nKQFRdgpn6YxEPxvJ
	 mnG9vvE4RmrYFkwzQRUTpiCCXhrQqqGQac4TrLRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Martin Kaiser <martin@kaiser.cx>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 7.2 109/556] dmaengine: fsl-edma: tracing: no ptr dereference during log output
Date: Wed,  9 Sep 2026 15:36:29 +0200
Message-ID: <20260909134234.315067567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


