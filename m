Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1D88F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23966C433C7;
	Sun, 16 Jul 2023 19:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537510;
	bh=CpMhOWXj1IoEz1RHroI/zE/MfEYy+gLPEF1zcL6HKi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHrnDYes/0jGXQbvTuBLimniOKx+3CPP3UiVAd0rrNnsoVFI08H2dQQDwcA5hsuLt
	 YPiE2McVmBIenMqTQQ3o3itlquW2j72JMy0fIVfrVBWGjhng79kfh38X8MzlBndFej
	 ZMTe7mjM9K1FDy9S53bHrOJIjKKvtVhn7iVeLx9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Stanislav Fomichev <sdf@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 122/800] bpf: Dont EFAULT for {g,s}setsockopt with wrong optlen
Date: Sun, 16 Jul 2023 21:39:35 +0200
Message-ID: <20230716194951.939544347@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit 29ebbba7d46136cba324264e513a1e964ca16c0a ]

With the way the hooks implemented right now, we have a special
condition: optval larger than PAGE_SIZE will expose only first 4k into
BPF; any modifications to the optval are ignored. If the BPF program
doesn't handle this condition by resetting optlen to 0,
the userspace will get EFAULT.

The intention of the EFAULT was to make it apparent to the
developers that the program is doing something wrong.
However, this inadvertently might affect production workloads
with the BPF programs that are not too careful (i.e., returning EFAULT
for perfectly valid setsockopt/getsockopt calls).

Let's try to minimize the chance of BPF program screwing up userspace
by ignoring the output of those BPF programs (instead of returning
EFAULT to the userspace). pr_info_once those cases to
the dmesg to help with figuring out what's going wrong.

Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
Suggested-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20230511170456.1759459-2-sdf@google.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 517b6a5928cc0..5b2741aa0d9bb 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1826,6 +1826,12 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 		ret = 1;
 	} else if (ctx.optlen > max_optlen || ctx.optlen < -1) {
 		/* optlen is out of bounds */
+		if (*optlen > PAGE_SIZE && ctx.optlen >= 0) {
+			pr_info_once("bpf setsockopt: ignoring program buffer with optlen=%d (max_optlen=%d)\n",
+				     ctx.optlen, max_optlen);
+			ret = 0;
+			goto out;
+		}
 		ret = -EFAULT;
 	} else {
 		/* optlen within bounds, run kernel handler */
@@ -1881,8 +1887,10 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 		.optname = optname,
 		.current_task = current,
 	};
+	int orig_optlen;
 	int ret;
 
+	orig_optlen = max_optlen;
 	ctx.optlen = max_optlen;
 	max_optlen = sockopt_alloc_buf(&ctx, max_optlen, &buf);
 	if (max_optlen < 0)
@@ -1905,6 +1913,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 			ret = -EFAULT;
 			goto out;
 		}
+		orig_optlen = ctx.optlen;
 
 		if (copy_from_user(ctx.optval, optval,
 				   min(ctx.optlen, max_optlen)) != 0) {
@@ -1922,6 +1931,12 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 		goto out;
 
 	if (optval && (ctx.optlen > max_optlen || ctx.optlen < 0)) {
+		if (orig_optlen > PAGE_SIZE && ctx.optlen >= 0) {
+			pr_info_once("bpf getsockopt: ignoring program buffer with optlen=%d (max_optlen=%d)\n",
+				     ctx.optlen, max_optlen);
+			ret = retval;
+			goto out;
+		}
 		ret = -EFAULT;
 		goto out;
 	}
-- 
2.39.2



