Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25AC151988;
	Wed,  5 Feb 2025 14:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766079; cv=none; b=C/Ymo/Av/95Y9o44tTNdmnRfbI/v0iBNg/XYc4wtD8cPXRzbgMjUxIG904+j3pHL+4o0Rom1/CJNto4uhZjJp24foAJkk6YM2/SN+orV16gHDmwM9l/JrjYUf63YKKlSWAW6roMwujhBkp6mM9iREjfeXc1wpp0z7mUNRSoMdIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766079; c=relaxed/simple;
	bh=ebDP24mmcd8QOvjZR4uIF+ge30bKEc21R8jhZttCSsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnilFXopQE63ibI9E8dIk5rbi270ueCK6g3utSttGKWck8yUcUqb+VyV1fYi4dQurlt0Y3BPXeKaDUyve/x4oqSCvHWChhPusQJRpZXZbX/Pyp7o3eAqJPY50UBljlP6EyQ+ekqy93w4mpbMNbnp+CRh6ByeBNP31xau+wKjHlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dM73epCQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dM73epCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16746C4CED1;
	Wed,  5 Feb 2025 14:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766079;
	bh=ebDP24mmcd8QOvjZR4uIF+ge30bKEc21R8jhZttCSsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dM73epCQknDIW06zwuWyCgJQvTCsV3cntozz12NbvQxT2HZyhviMqSjwgdVFKWxIN
	 U8SEj39Z9I4IyhhGXI9hB6Dy12ghzfb4c4kaBfb5ksyIZs5E27154EH925rPY2IxZd
	 K2pBWk4q2V/ava78tnM3O5bTqxYwofzXPh3cHcik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+97da3d7e0112d59971de@syzkaller.appspotmail.com,
	Puranjay Mohan <puranjay@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 285/590] bpf: Send signals asynchronously if !preemptible
Date: Wed,  5 Feb 2025 14:40:40 +0100
Message-ID: <20250205134506.181746452@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b5cf605fb0e60..449efaaa387a6 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -833,7 +833,7 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
 	if (unlikely(is_global_init(current)))
 		return -EPERM;
 
-	if (irqs_disabled()) {
+	if (!preemptible()) {
 		/* Do an early check on signal validity. Otherwise,
 		 * the error is lost in deferred irq_work.
 		 */
-- 
2.39.5



