Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EB618FDDC;
	Tue, 10 Sep 2024 10:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962663; cv=none; b=lOg+y2witt3e6kQkjvavPMR0ANS/iF3UmqGt5pkewYIZFfrU25EW2+9Y43+kBWUd1SUtNFI9uouawPTV/k3+dFnnN2abZ+jdPIAm2TRbzHuGEsF8X00PEkJJ/5xOefxmwzr0Ixt5iJN3pSfwbth1InF2GlhMUykdlzNroAP+ZBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962663; c=relaxed/simple;
	bh=cpOtSX23qmeZ1VVgSk6Ce8mCL/+0Mk96/BVB6phN9ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZnZwwpzp1OT7nMb68LoZrc5sHqiuoAV4d+RDW/iH3UhEBcEFVseFI0dLTVjlkp8EVMDMMO7Xv0wyiFOoCjWhPm1WM5soTQy0fAuV0SxjhbuAdokzRVRyaJkg98sHtYhOm1T3BNfJ+bOvOZI++eiXp5C4v+qaZsx2gANWzRQ7H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAlXCUGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAlXCUGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3EFC4CECD;
	Tue, 10 Sep 2024 10:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962663;
	bh=cpOtSX23qmeZ1VVgSk6Ce8mCL/+0Mk96/BVB6phN9ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EAlXCUGnXEPv+dw9zZXIczHyXvbH7n3ZxTjDd4hzzfcU7AcVhzNYGfgpzhraTc8/G
	 qBiHKw9gciBMGj68WEhKd1o0v7ixqVcI3sjMNo1wefUtZw2ebDI1cGfiAlhCTSSO7X
	 tbUvYYzh746V4ofiwm4BEQmBN4NeEqyu5uUB1jFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Zheng Yejian <zhengyejian@huaweicloud.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 109/121] tracing: Avoid possible softlockup in tracing_iter_reset()
Date: Tue, 10 Sep 2024 11:33:04 +0200
Message-ID: <20240910092551.006386066@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

From: Zheng Yejian <zhengyejian@huaweicloud.com>

[ Upstream commit 49aa8a1f4d6800721c7971ed383078257f12e8f9 ]

In __tracing_open(), when max latency tracers took place on the cpu,
the time start of its buffer would be updated, then event entries with
timestamps being earlier than start of the buffer would be skipped
(see tracing_iter_reset()).

Softlockup will occur if the kernel is non-preemptible and too many
entries were skipped in the loop that reset every cpu buffer, so add
cond_resched() to avoid it.

Cc: stable@vger.kernel.org
Fixes: 2f26ebd549b9a ("tracing: use timestamp to determine start of latency traces")
Link: https://lore.kernel.org/20240827124654.3817443-1-zhengyejian@huaweicloud.com
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Zheng Yejian <zhengyejian@huaweicloud.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8bf28d482abe..67466563d86f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3487,6 +3487,8 @@ void tracing_iter_reset(struct trace_iterator *iter, int cpu)
 			break;
 		entries++;
 		ring_buffer_iter_advance(buf_iter);
+		/* This could be a big loop */
+		cond_resched();
 	}
 
 	per_cpu_ptr(iter->trace_buffer->data, cpu)->skipped_entries = entries;
-- 
2.43.0



