Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0F32641CC;
	Tue,  8 Apr 2025 11:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113210; cv=none; b=H316P2ooTrTBwbnNC8f4haoGHgBL1Y0907UzRlGyyvSN13PGaUq/ZFXg8+MTVa+Exyd80X/njWqr0ZW/AE7hFsrMBCsZw/6y1mbs/UUcU8hB1/Y7ueGeJUZOEWweewUVwifLu75E6juYI2yonhgBPDBRs1xFxSC5jJdlmeE9FPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113210; c=relaxed/simple;
	bh=4n7BdKQY6t4HfQ7B3KtIa64X49JFeRoc8/ogycHfTto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWAzRTaP8uaxHmmoBqOzJpv/ppU98x0lfgr6/5zO6uhRsEu+J36eayQJiNVKIt/aUoyvpKTvvBDQRiqO8DFY0RYEHFDsCoecEynaajm3LSgjYqPefRek3vbGZtDSmHfngFEpGX3tUSkJybxRKI9mQuMwF+0WPiLqMXjRooysBbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iEnyXy6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iEnyXy6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F042C4CEE5;
	Tue,  8 Apr 2025 11:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113209;
	bh=4n7BdKQY6t4HfQ7B3KtIa64X49JFeRoc8/ogycHfTto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iEnyXy6SG/JOTvkilEgeXJ+m6Y5g/Cowlxa32KhOGiCzXmd/NTe6FvknI/mTaq0uZ
	 Bog0zs+HobqLvS0Rq0a0uuk2QmaMQDqgL3wGJn6wbbmWdf2pVi5sCh2DzdIrWaKUxo
	 wXwlPuysRVlUq8kzHTLS1RydKIvwUtJCRQnHgZVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/268] bpf: Use preempt_count() directly in bpf_send_signal_common()
Date: Tue,  8 Apr 2025 12:48:06 +0200
Message-ID: <20250408104830.521554401@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit b4a8b5bba712a711d8ca1f7d04646db63f9c88f5 ]

bpf_send_signal_common() uses preemptible() to check whether or not the
current context is preemptible. If it is preemptible, it will use
irq_work to send the signal asynchronously instead of trying to hold a
spin-lock, because spin-lock is sleepable under PREEMPT_RT.

However, preemptible() depends on CONFIG_PREEMPT_COUNT. When
CONFIG_PREEMPT_COUNT is turned off (e.g., CONFIG_PREEMPT_VOLUNTARY=y),
!preemptible() will be evaluated as 1 and bpf_send_signal_common() will
use irq_work unconditionally.

Fix it by unfolding "!preemptible()" and using "preempt_count() != 0 ||
irqs_disabled()" instead.

Fixes: 87c544108b61 ("bpf: Send signals asynchronously if !preemptible")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20250220042259.1583319-1-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 9d8f60e0cb554..545393601be8c 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -853,7 +853,7 @@ static int bpf_send_signal_common(u32 sig, enum pid_type type)
 	if (unlikely(is_global_init(current)))
 		return -EPERM;
 
-	if (!preemptible()) {
+	if (preempt_count() != 0 || irqs_disabled()) {
 		/* Do an early check on signal validity. Otherwise,
 		 * the error is lost in deferred irq_work.
 		 */
-- 
2.39.5



