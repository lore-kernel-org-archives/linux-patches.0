Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E972A221F20;
	Mon, 13 Oct 2025 14:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367096; cv=none; b=awq70MTsJJ5/GFCo1oIWZEU1m16OgJPAckruWaSeqLGC8/2Xul4AslJlPvS3yWnDCPMyfgkQKQ7mSyS1tFMgcEqkQFHtt10BLalqmpB/vdUfLCw6B2oEwX6SxDhwrykXg9+Z4hFqAeqnC8mvSNtJOtBLr9wPSYgUcNlSUz3RnaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367096; c=relaxed/simple;
	bh=1Wam95m/XtbYPq1mhpZzXjcgw0UyZj9CZEfnY2AjPZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bw5cf286FJzt5n0kLo+8Oka1sBNs9f72bhLiXc3XzW31y1eI17onBAnoOcmNpWQ+u2QqzerleYtjNJ6mgUqt1wmG42wwbY0w42tkTZoNV/zrKOgOEcDNT4PywdgA7IcEKtwIMVZJAbhqrnrLX2VNCQrUAXRnAbtOMaToJ9CWCsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVl/rR1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVl/rR1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6DEC4CEE7;
	Mon, 13 Oct 2025 14:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367095;
	bh=1Wam95m/XtbYPq1mhpZzXjcgw0UyZj9CZEfnY2AjPZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVl/rR1wg8dAavqkCJyqdOQE9ju/U7Hrj3iNeurfY5cnQ9d19VfPAL6X9NwT64tbQ
	 2x7+rWgAqHDm0gLYTxwzAKjhSOiLXB0ReEC7rfrhmEH9h4MFooCAVC2d0/edx12EcT
	 QDMOIbTdxni2AsN6CBeRbkzmsJySVOp3G2NhONo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/196] bpf: Remove migrate_disable in kprobe_multi_link_prog_run
Date: Mon, 13 Oct 2025 16:43:50 +0200
Message-ID: <20251013144316.646626696@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Chen <chen.dylane@linux.dev>

[ Upstream commit abdaf49be5424db74e19d167c10d7dad79a0efc2 ]

Graph tracer framework ensures we won't migrate, kprobe_multi_link_prog_run
called all the way from graph tracer, which disables preemption in
function_graph_enter_regs, as Jiri and Yonghong suggested, there is no
need to use migrate_disable. As a result, some overhead may will be reduced.
And add cant_sleep check for __this_cpu_inc_return.

Fixes: 0dcac2725406 ("bpf: Add multi kprobe link")
Signed-off-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250814121430.2347454-1-chen.dylane@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 243122ca56793..e6fde598f7629 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2636,18 +2636,23 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
 	struct bpf_run_ctx *old_run_ctx;
 	int err;
 
+	/*
+	 * graph tracer framework ensures we won't migrate, so there is no need
+	 * to use migrate_disable for bpf_prog_run again. The check here just for
+	 * __this_cpu_inc_return.
+	 */
+	cant_sleep();
+
 	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
 		err = 0;
 		goto out;
 	}
 
-	migrate_disable();
 	rcu_read_lock();
 	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
 	err = bpf_prog_run(link->link.prog, regs);
 	bpf_reset_run_ctx(old_run_ctx);
 	rcu_read_unlock();
-	migrate_enable();
 
  out:
 	__this_cpu_dec(bpf_prog_active);
-- 
2.51.0



