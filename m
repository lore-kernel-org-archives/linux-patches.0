Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD3721FF25;
	Fri, 31 Oct 2025 14:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919448; cv=none; b=MYJhFaSIuNcjgRA7VGOpeZwJoPe7GfFLKXxvfQbtCNMWFkqiPrrzY3vp85iCH2XMgl8ksLg+OZ6YeF19/+O9itL7slwaWeEpbSWoxTt2p9WuBaC98GAnMF0c3tS1uUQjYkNC9WJWX3cOI74+PZng4sWnGGMpF/3GAYKfu1xn57A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919448; c=relaxed/simple;
	bh=e/UGmq2FYKEPDx1hYGZdFZxJmYDnNp4hY7DbXGET4zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MM6zXAR0Z+ajo7jVjV3n5mO/7+Bn83eLhQbWLJz+2YyCohdZgK0ft7ngDFtMtFWWdvdXW/APBLvcYxERRbKFEzpG1Rr/2V8+C7YRoh/msSj0EYaARivUrQ2krpYqT9ZZw1M+xnDlEb5VGn90h1ggzMLLzuDiTdVx1ww22SumqUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KtfzJLLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KtfzJLLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADF9C4CEF8;
	Fri, 31 Oct 2025 14:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919448;
	bh=e/UGmq2FYKEPDx1hYGZdFZxJmYDnNp4hY7DbXGET4zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtfzJLLiliuwAoUUaBCc78eBANibN0eCfdFc2viRcYf0bA8PJxbPMHGVkdCeWyzim
	 xgmPQhr8h3gIIZt3QkBE9LCgIjmpfHmMtK1OAbB6maGNMweXxq64i8UJXDVRzil82Q
	 5CjSRfbqKx7KbfSAlHno040OOpprgaYYLUqcy0EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 22/40] sched_ext: Make qmap dump operation non-destructive
Date: Fri, 31 Oct 2025 15:01:15 +0100
Message-ID: <20251031140044.547031513@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit d452972858e5cfa4262320ab74fe8f016460b96f ]

The qmap dump operation was destructively consuming queue entries while
displaying them. As dump can be triggered anytime, this can easily lead to
stalls. Add a temporary dump_store queue and modify the dump logic to pop
entries, display them, and then restore them back to the original queue.
This allows dump operations to be performed without affecting the
scheduler's queue state.

Note that if racing against new enqueues during dump, ordering can get
mixed up, but this is acceptable for debugging purposes.

Acked-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/sched_ext/scx_qmap.bpf.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/sched_ext/scx_qmap.bpf.c b/tools/sched_ext/scx_qmap.bpf.c
index 5d1f880d1149e..e952f525599bd 100644
--- a/tools/sched_ext/scx_qmap.bpf.c
+++ b/tools/sched_ext/scx_qmap.bpf.c
@@ -56,7 +56,8 @@ struct qmap {
   queue1 SEC(".maps"),
   queue2 SEC(".maps"),
   queue3 SEC(".maps"),
-  queue4 SEC(".maps");
+  queue4 SEC(".maps"),
+  dump_store SEC(".maps");
 
 struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
@@ -578,11 +579,26 @@ void BPF_STRUCT_OPS(qmap_dump, struct scx_dump_ctx *dctx)
 			return;
 
 		scx_bpf_dump("QMAP FIFO[%d]:", i);
+
+		/*
+		 * Dump can be invoked anytime and there is no way to iterate in
+		 * a non-destructive way. Pop and store in dump_store and then
+		 * restore afterwards. If racing against new enqueues, ordering
+		 * can get mixed up.
+		 */
 		bpf_repeat(4096) {
 			if (bpf_map_pop_elem(fifo, &pid))
 				break;
+			bpf_map_push_elem(&dump_store, &pid, 0);
 			scx_bpf_dump(" %d", pid);
 		}
+
+		bpf_repeat(4096) {
+			if (bpf_map_pop_elem(&dump_store, &pid))
+				break;
+			bpf_map_push_elem(fifo, &pid, 0);
+		}
+
 		scx_bpf_dump("\n");
 	}
 }
-- 
2.51.0



