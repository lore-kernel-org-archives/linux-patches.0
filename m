Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971AA17CA12;
	Mon, 10 Mar 2025 17:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628858; cv=none; b=G6SexH5NCe2lM4F7vWaHDA+wAGswvPZn+gUcMYp4jRR1eTYa0xF+WBRWz8sbJs/85g762kzTwHKaMM9BntSLXZUGEWPT/o1R4A9Rm57OIncCP9G6Z+ONp0HsBm/xLND1e+y10ARr2hxgOuoL/TV+QyrEhaHRs373s5yKWYdAUD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628858; c=relaxed/simple;
	bh=pzCxNkOPQCwjLE4aT4jEnqxGjpugCKQt7F7mYng1wxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5jWkSyIvgncKeDgioiB9XwMEamgl5ID9oovL+tuTFT205hGhf0579oUfSwz6NWTk6FMZMcEt/hTpauAKmeQ/b1jb6fwjhWmn282312T/PIqLO5K61xjEE48rxmgVY1wnHTn2p9MawU6S0T8YDFqU6aSIhxmZtAWqxdhhjBKHCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SInEO1Ad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SInEO1Ad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2CCC4CEE5;
	Mon, 10 Mar 2025 17:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628858;
	bh=pzCxNkOPQCwjLE4aT4jEnqxGjpugCKQt7F7mYng1wxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SInEO1Ad39l3cZ/vWX5d+6Lq4+E1SnCNd6iakVC60jdIz2HseN5Gvi6V5ApaXdISm
	 9emEI9qyLXGeDZX1G3+VL/2Cgl+tA8wNGGF9V8kURJmgI9tSXyVtMc6QRUTaHlshbR
	 0R1X0dq7XAxhVIJnMQlPoZrf+N4vRma5KzpK6Pd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+97da3d7e0112d59971de@syzkaller.appspotmail.com,
	Puranjay Mohan <puranjay@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/620] bpf: Send signals asynchronously if !preemptible
Date: Mon, 10 Mar 2025 17:59:00 +0100
Message-ID: <20250310170549.292728742@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 87c544108b612512b254c8f79aa5c0a8546e2cc4 ]

BPF programs can execute in all kinds of contexts and when a program
running in a non-preemptible context uses the bpf_send_signal() kfunc,
it will cause issues because this kfunc can sleep.
Change `irqs_disabled()` to `!preemptible()`.

Reported-by: syzbot+97da3d7e0112d59971de@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67486b09.050a0220.253251.0084.GAE@google.com/
Fixes: 1bc7896e9ef4 ("bpf: Fix deadlock with rq_lock in bpf_send_signal()")
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20250115103647.38487-1-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 126754b61edc0..60acc3c76316f 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -799,7 +799,7 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
 	if (unlikely(is_global_init(current)))
 		return -EPERM;
 
-	if (irqs_disabled()) {
+	if (!preemptible()) {
 		/* Do an early check on signal validity. Otherwise,
 		 * the error is lost in deferred irq_work.
 		 */
-- 
2.39.5



