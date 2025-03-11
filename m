Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565A525E834;
	Tue, 11 Mar 2025 15:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706468; cv=none; b=XpAeuL+L9vdHdEAE3bU754SqaQLnXDQpQkyJD9DSxtxXlHcRDsjWfbwnWBQpPVexAu2OeLj0ggnCDqnaAdT6m64FV4hJzakq2Rsf0eA970qzeTjbzaBSvg3kBlQa/tzN25dBi/yRchGLpF/BmYtxwftSzvuEleqUNwU2GcYmhN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706468; c=relaxed/simple;
	bh=ZW11oRBJnZ2dmGNKvmRrjUVXKfH8yk/0yIWm8ul3AHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjqLtARtIy2IZDprFtDBi9auFijBarAfcxZiG7DknsqWlAE07Qt3vOdpkNRpnUotUNKIC9vfNg4zh7vo/WZoxqM4Q+qYpHJ3yhBaBgn7LXu7kwBYV9f5EyO0UGhKk+2OxBfrEQZmQ+5RyLTkI/+femhM7W4fDns6P8QjlvdP+7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLyD3jKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLyD3jKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25A9C4CEE9;
	Tue, 11 Mar 2025 15:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706468;
	bh=ZW11oRBJnZ2dmGNKvmRrjUVXKfH8yk/0yIWm8ul3AHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iLyD3jKRcUbbOBqv/n2C0WiNClOKhCmqmhiN1KD5/5MBP1SBy2KHENtZjwqkTta5k
	 9W3gwujNQUTODqbj6xA1pZAHi3jBqS+hQybYAixGDBsFX3M6XSTH7zOqbRHkgHGkym
	 nseYkIMdt9r9vkYgIhAqObp5Te50o5EjUsceUAns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+97da3d7e0112d59971de@syzkaller.appspotmail.com,
	Puranjay Mohan <puranjay@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/462] bpf: Send signals asynchronously if !preemptible
Date: Tue, 11 Mar 2025 15:55:25 +0100
Message-ID: <20250311145800.684693627@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 71e0c1bc9759e..1656a7d9bb697 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1081,7 +1081,7 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
 	if (unlikely(is_global_init(current)))
 		return -EPERM;
 
-	if (irqs_disabled()) {
+	if (!preemptible()) {
 		/* Do an early check on signal validity. Otherwise,
 		 * the error is lost in deferred irq_work.
 		 */
-- 
2.39.5



