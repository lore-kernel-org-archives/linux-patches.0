Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B28A511180;
	Wed, 30 Sep 2026 15:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783681; cv=none; b=YFv93x+Pi2vrd3mDzcO7eeWxnFfZ4QvEYueBdc/6bWpgLQeLzfD83P7kpGtDwxAX5nlhKnLFWte9oWGjKm0e0kHUEFUTk45kqSmhZ2o6L26eXyhuh4C5QC5IKV66wke8fUNeqyPFptYtxyfnmTTvRW4F9UcTy4NP9mUKH/VA/wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783681; c=relaxed/simple;
	bh=Nk6mloxta1GmbX9uddKHes3mOzZHyHOsCXI3O7NDwG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfOfpTbyWNy87UltzynbH1Y+gtKsscY0DskdWogaRCo3bYVCbH/4ev5SvzupQKjzv4SxIoLc3nWCcu28OLcRIFqn66TJGAwuBKS4ivEC8HSNziPYL35K+PoVfr7Goti7sFtbd8bP59lxMYo6VPw5nDP47jRmXy9H1dg7zLWgzM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0w4z1zD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0w4z1zD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D707C1F00893;
	Wed, 30 Sep 2026 15:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783676;
	bh=3XJ0iV5cyyZGuFy+XFqGvbLtBaY/itisBhil7PQd8v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q0w4z1zDax0xe7b2NKW/LZRr3TqXxeU6125U47folucNncDJpA2HjrkobfKC9wVmB
	 G4XHbz8nYVcYY8iEzwSktpTqy5JH3bz/KN/1x+7nHQbqnSR3+k3+jMeEpvP0yaoR+I
	 Zw/g859/y+WYUy8G3UGI7ZZhrhXUSAADjdx1E4/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+adfca3e91be95776@bugs.sh,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 482/595] bpf: Disallow bpf_skb_pull_data() for LWT_SEG6LOCAL
Date: Wed, 30 Sep 2026 17:26:15 +0200
Message-ID: <20260930152358.052612828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit e4a62833adff6ef0fe7c0b90393204fe3c26b5c5 ]

An LWT_SEG6LOCAL program can invalidate its cached SRH with
bpf_lwt_seg6_adjust_srh() and then call bpf_skb_pull_data(). The latter
may reallocate skb->head, leaving the per-CPU SRH pointer dangling.
Post-program SRH validation then writes through that pointer.

Disallow bpf_skb_pull_data() for LWT_SEG6LOCAL programs so the verifier
rejects this unsafe helper combination. Other LWT program types continue
to expose the helper through lwt_out_func_proto().

Fixes: 004d4b274e2a ("ipv6: sr: Add seg6local action End.BPF")
Reported-by: co+adfca3e91be95776@bugs.sh
Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Closes: https://lore.kernel.org/all/GCy0KRM2IcQGoJQTjJEU9D0maBxXzEDHuQpq@bugs.sh/
Link: https://lore.kernel.org/bpf/DL9COXZQXX4V.1FN45QO2Q77ZH@gmail.com/
Link: https://lore.kernel.org/bpf/20260909040807.3885815-2-bestswngs@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 25fd2f34d12e2..25f80c26f2e92 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7625,6 +7625,8 @@ static const struct bpf_func_proto *
 lwt_seg6local_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
 	switch (func_id) {
+	case BPF_FUNC_skb_pull_data:
+		return NULL;
 #if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
 	case BPF_FUNC_lwt_seg6_store_bytes:
 		return &bpf_lwt_seg6_store_bytes_proto;
-- 
2.53.0



