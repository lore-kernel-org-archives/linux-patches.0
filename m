Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C33F30C374;
	Mon, 13 Oct 2025 15:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368919; cv=none; b=MANxph/lsILAEY+FbwjpMvF12RDIKwQvBnLhaZE1ZsFVZLoe2RSwkg1kBUNSX50OseTzSS6kfHR2pMp9h2iN4hC/6RrbOiEk3xSd5r2sS5VS1Yg/akjh5YhyfYfkkr7jF4A1fB4GIpD7KM5bnoVGYykWt5pb1N778nbNtkNlbU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368919; c=relaxed/simple;
	bh=9qAQ8pHxaQefcElbyFqbotNBK0TBSrP/fzM3SWkwoiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXbNG/2Ov6JMBNRWpoxrMy1y45Bbbn6+fYRydON7ItPVYQKbpWAaU00L23yes4waKSOIsxTs3BgZUA40DO4vIPgPfboAfLOZ/XegL7w5V06vxOWo+FvvMG+BZxe/E22Qm2mcJPCU6aWsl0lfPBfZ2aS1ceCWDqtAqNxZnPY5KcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSwXOf1d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSwXOf1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9587CC4CEE7;
	Mon, 13 Oct 2025 15:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368919;
	bh=9qAQ8pHxaQefcElbyFqbotNBK0TBSrP/fzM3SWkwoiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSwXOf1dxYbSt407BoWdv3yL8VO9kk/cw2R4uOcdejMaIx/dVgctaXr1ki8bGcn9L
	 xx8cfBvJP7nTIB+VUwo6MFx+bEFU1FSBegHq35tTrE21/irFdnL2x5OMJuYezm9Bsa
	 b+wswK+VyoarZSr+pwq4s/BvwxitfgZUaCtxlfho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Chen <chen.dylane@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 065/563] bpf: Remove preempt_disable in bpf_try_get_buffers
Date: Mon, 13 Oct 2025 16:38:46 +0200
Message-ID: <20251013144413.644580637@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Chen <chen.dylane@linux.dev>

[ Upstream commit 4223bf833c8495e40ae2886acbc0ecbe88fa6306 ]

Now BPF program will run with migration disabled, so it is safe
to access this_cpu_inc_return(bpf_bprintf_nest_level).

Fixes: d9c9e4db186a ("bpf: Factorize bpf_trace_printk and bpf_seq_printf")
Signed-off-by: Tao Chen <chen.dylane@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250819125638.2544715-1-chen.dylane@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 8af62cb243d9e..9c750a6a895bf 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -774,11 +774,9 @@ int bpf_try_get_buffers(struct bpf_bprintf_buffers **bufs)
 {
 	int nest_level;
 
-	preempt_disable();
 	nest_level = this_cpu_inc_return(bpf_bprintf_nest_level);
 	if (WARN_ON_ONCE(nest_level > MAX_BPRINTF_NEST_LEVEL)) {
 		this_cpu_dec(bpf_bprintf_nest_level);
-		preempt_enable();
 		return -EBUSY;
 	}
 	*bufs = this_cpu_ptr(&bpf_bprintf_bufs[nest_level - 1]);
@@ -791,7 +789,6 @@ void bpf_put_buffers(void)
 	if (WARN_ON_ONCE(this_cpu_read(bpf_bprintf_nest_level) == 0))
 		return;
 	this_cpu_dec(bpf_bprintf_nest_level);
-	preempt_enable();
 }
 
 void bpf_bprintf_cleanup(struct bpf_bprintf_data *data)
-- 
2.51.0



