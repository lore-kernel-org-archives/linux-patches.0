Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE577268C6B;
	Tue,  8 Apr 2025 12:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114010; cv=none; b=EuTo2i1TiLo4ZIzp+CrsbC89ncCBvpPOhZcyGAL00opKrkJVyS/nT/f5+EAebtmLJTTpJmMpEJ6Trz30Jrk6BZTGZvJrsxh2IhM9BFajPxY7+frj/z7S0lXBksqtZ8Q8rMc2c1XcG+dqSCPjNxdJGD1nJJ4wRkugIx05at6Rt7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114010; c=relaxed/simple;
	bh=H4HR6W7JsRZs31Rlac+HtXtwcsAI3ksVRoMEjFfdS4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ddt3lXgsQ7mVmLdb+LT/RvC/s+yQwQAuHdM3PU98HGyj8n0b5kma2uzxwy4XZE0QGwh9yCJswsmmDnYCTSn3ZsMnIXAStb/yOJ2cTvg5Twy8+13j07b0gcQLA9/8Z2zsikosmohXHShg5S0+8WB081Xhh7rQyJw8gRIMr4h69Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hNQg0AlL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hNQg0AlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807C9C4CEE5;
	Tue,  8 Apr 2025 12:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114009;
	bh=H4HR6W7JsRZs31Rlac+HtXtwcsAI3ksVRoMEjFfdS4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hNQg0AlL6O+3qcaPoo78aZETClTb4K0CVqVJ3y5CzxGSBgFYdQ2siU9H5Zh4NQcBj
	 tky9slomJ4JrJZ9Zt+FuWenUVIq0kNI67DKjzaFPxj0gaKgq8NusCBYrvGqRFt6Trj
	 qX4CJ9SFAX+I244RKu/ky6jzT2wgy5SAMMMDiWtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/154] bpf: Use preempt_count() directly in bpf_send_signal_common()
Date: Tue,  8 Apr 2025 12:50:43 +0200
Message-ID: <20250408104818.599222155@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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
index ac3125d0c73f1..75ea2ab532134 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -653,7 +653,7 @@ BPF_CALL_1(bpf_send_signal, u32, sig)
 	if (unlikely(is_global_init(current)))
 		return -EPERM;
 
-	if (!preemptible()) {
+	if (preempt_count() != 0 || irqs_disabled()) {
 		/* Do an early check on signal validity. Otherwise,
 		 * the error is lost in deferred irq_work.
 		 */
-- 
2.39.5



