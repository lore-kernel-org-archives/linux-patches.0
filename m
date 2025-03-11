Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3170E25EF93;
	Tue, 11 Mar 2025 15:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705504; cv=none; b=LaBYbcJJQK5KOoCWaWcxfKjUwXXDTfupmfW7hPiG1FzIR4foD6RQC9cZigRtdVdG/0xuDmex4odvEhSGVBWP7Ljq5RrzAdbCOi5yBtME39/VeozHrHhgx4DFnw7B8eXGU1ytvLUKxYCe/nFm2CAHYbofXUcNf2ckSYebm934KXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705504; c=relaxed/simple;
	bh=x9Gk9+3pp4oSEwTWujYIqzTbGzminu4gy8QuncAVDpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tv1bJaUixUi6dvV1EP8xrA+bM2/wercnIGt9VC4NHqKAk/jXML19eNHo/DPtBAkWl+remGM8lClbWSUOpsP1NGZ1VdHCEC9YTnphR5UfdE5uAmMzpdu7tintuuDZV7/tUjFSZi9i3akV0a66ak7D8K73vt+wuZHwda18rydf8UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvCyb9N2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvCyb9N2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A379CC4CEF0;
	Tue, 11 Mar 2025 15:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705504;
	bh=x9Gk9+3pp4oSEwTWujYIqzTbGzminu4gy8QuncAVDpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvCyb9N2JcOLnawyGpZUFxTbF0xl4aKkZaOafMHkJDxt5yzSKVTFhEUlxyCR42+Va
	 iidpMSpUmk6FK0A/Pe8p0UUoMlQBFTa/DJsV8I48FOcB/fnLpYjKYaXc4ujp4fWw8y
	 1iyTMAx25md5ydvFNVTYSpkb8V7Rl1VVge0jySLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+97da3d7e0112d59971de@syzkaller.appspotmail.com,
	Puranjay Mohan <puranjay@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/328] bpf: Send signals asynchronously if !preemptible
Date: Tue, 11 Mar 2025 15:56:51 +0100
Message-ID: <20250311145716.525757606@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4a31763a8c5d7..ac3125d0c73f1 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -653,7 +653,7 @@ BPF_CALL_1(bpf_send_signal, u32, sig)
 	if (unlikely(is_global_init(current)))
 		return -EPERM;
 
-	if (irqs_disabled()) {
+	if (!preemptible()) {
 		/* Do an early check on signal validity. Otherwise,
 		 * the error is lost in deferred irq_work.
 		 */
-- 
2.39.5



