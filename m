Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E874A12D77F;
	Tue, 30 Apr 2024 11:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476343; cv=none; b=GCYq/+BE7WCfJTTUskt63jwCVkV3wkRgG6nqUO6sf0V4tbce1VaAxgazdW2LGUkmUzpmrzbwJQF5Eac49gCXopjMMuy1VPjQVpLMfDP4f5t0lALQFxcr9ryvOuIYydYb/x5kFFeD55pQlD4iYRfsAfPG5O38XST1s2ddo1a2pFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476343; c=relaxed/simple;
	bh=GIaQw0xALEATdH2i3pVgPxI2YFM28qROfU9mNWXWCBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8Q0V+PwpTBggPJDBHOgLrSsJVOFvIPOT+Pcv13mBwFU7xzZ3HL7SNrcJk+WRdZI6owScTow3X+iT/duNZ7le362yBeFxhBEIqNuEN4TkVUkHyU8DTUc8I2aD9OzsiQqjDPvF7Ns+0Ap/YY4f2MGrSVdEas/JcMhKICQTiMDqdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRlWnNXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRlWnNXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5554EC2BBFC;
	Tue, 30 Apr 2024 11:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476342;
	bh=GIaQw0xALEATdH2i3pVgPxI2YFM28qROfU9mNWXWCBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRlWnNXVQ1AAKkwZlkfNeeDZRVnRcOlbotFUHTg1Wkj3o9HZd4hNgX4AX8zE3yhXY
	 /SB2lz2z83OBW1FHQLBq1Fi7wJzILqf7w5osDbqzGFSa4NdERXf8VmOM059rcaJBTy
	 rvR7ldnghIyKwYb9CIt1lWVET96oQtfkg3/A2MnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Robin H. Johnson" <robbat2@gentoo.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.4 086/107] tracing: Show size of requested perf buffer
Date: Tue, 30 Apr 2024 12:40:46 +0200
Message-ID: <20240430103047.196043226@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin H. Johnson <robbat2@gentoo.org>

commit a90afe8d020da9298c98fddb19b7a6372e2feb45 upstream.

If the perf buffer isn't large enough, provide a hint about how large it
needs to be for whatever is running.

Link: https://lkml.kernel.org/r/20210831043723.13481-1-robbat2@gentoo.org

Signed-off-by: Robin H. Johnson <robbat2@gentoo.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
---
 kernel/trace/trace_event_perf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -395,7 +395,8 @@ void *perf_trace_buf_alloc(int size, str
 	BUILD_BUG_ON(PERF_MAX_TRACE_SIZE % sizeof(unsigned long));
 
 	if (WARN_ONCE(size > PERF_MAX_TRACE_SIZE,
-		      "perf buffer not large enough"))
+		      "perf buffer not large enough, wanted %d, have %d",
+		      size, PERF_MAX_TRACE_SIZE))
 		return NULL;
 
 	*rctxp = rctx = perf_swevent_get_recursion_context();


