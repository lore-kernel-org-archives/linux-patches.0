Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCE7155725;
	Wed,  5 Feb 2025 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766780; cv=none; b=ax8cGZxiShXqDOW6+7VbuEpdtumbwctI/rl0vVK+m87g2O3hBwZvsl/ji1LH/Ov75SL9R+/XPrLGStuOgLlk3UhSfMqaVbSK4ZZXzIH/pnB4AZ7qVesjmQiOTZ888prA4TtUiskeJ0vPHq4nsCTDl9pOMmcpFPW5jczmlE4O4vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766780; c=relaxed/simple;
	bh=k9PEhOU1X1fdVdPMUZjwELSYmLWn+3WntLxFkaEpSIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FzcJ8MDnJxGUpSb0WRD8oT0Lm4gXYlXpKHSiP4EmSnhY7IXSKJ6AyrbGjMlONrfpHT0PnPBUJrUjK9U5X3InZmOshp7KiwPPONVVOigOBMpy5X73GFNrx9jTTtShL3IRoTW5yiQYpnpdCjrgzZIT6WQfB3xu4LLaTgJHVuLrtu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tR7SjDrA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tR7SjDrA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F246C4CED6;
	Wed,  5 Feb 2025 14:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766780;
	bh=k9PEhOU1X1fdVdPMUZjwELSYmLWn+3WntLxFkaEpSIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tR7SjDrAgbcERQHIRZpo/zRC1zpS/G9YAQw5cojN8QbH0ONxdeC3HVYTCSXDrrb4U
	 j4i2O3YOVJp1a00yq33Tde7xd2vZVOmIZkpcMMHC1dYDRVBfO6N6yfT8898gr6z51z
	 NMZHSkQOEjJbYY8SygS2a6D2zUEhpLOfZ54SIHqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+97da3d7e0112d59971de@syzkaller.appspotmail.com,
	Puranjay Mohan <puranjay@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 307/623] bpf: Send signals asynchronously if !preemptible
Date: Wed,  5 Feb 2025 14:40:49 +0100
Message-ID: <20250205134507.971911667@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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
index 9f2f65767639d..2c2205e91fee9 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -854,7 +854,7 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type, struct task_struc
 	if (unlikely(is_global_init(task)))
 		return -EPERM;
 
-	if (irqs_disabled()) {
+	if (!preemptible()) {
 		/* Do an early check on signal validity. Otherwise,
 		 * the error is lost in deferred irq_work.
 		 */
-- 
2.39.5



