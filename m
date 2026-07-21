Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C602DEA74;
	Tue, 21 Jul 2026 18:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660039; cv=none; b=mD+qsTyRm52Xw8ptixBgkJWP3Sm2gKbO6ht4Yasju2SFtznLRoJEatRqaO6eFSQHDoFKBRo+9DMbPVCy74Jk5S22ymeivAtLQo0FARXRGyAd188y/VVnZtnvgLtL0+XS9+qGxE7OalVrIgrNxlviKx1cZBuL2ziHXzYqpfYiNdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660039; c=relaxed/simple;
	bh=Ne0e67veMLY+Y2OHwJ9b1cMcLSDSyQJHbgFPWaRpw7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DC+3PXHYS6DvpnTJSMKNfC8hiY9YbUNLKDxL8/qa/u/nF0hkRscmu0zN9NgugyG/QWUZDz2DZpHBP9m4Khv5MW/DTYbA+cEau7dCOgwBzaO+Ae/xIXBxgQkDTbPkmM3jbZgJYiME9pAHmV5JmClDshGE3b0NLkvKaO2ugEZoIeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYkOcDEQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYkOcDEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7040F1F000E9;
	Tue, 21 Jul 2026 18:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660037;
	bh=G2PxHGCqCEbhREk1jjx7NrJA4Yn6b3tm5Pf9dWVueCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AYkOcDEQkmPVCLLD/yrcuSNwbC5AbuH5JfI6B7qnxLpX5KURSwBQCN0+hR21bSdQp
	 9rv24S7/bLXVqS7IA3FLub6cHm3MMqPrHANLeweUKzGgZ4aQI8eUxUTzR/ZY0udvCC
	 6BooDzO9ICnCjkz4QXrEMxHQGKDebWaLgjHNEw1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Xinyu Ma <mmmxny@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Weiming Shi <bestswngs@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0785/2077] bpf, sockmap: reject overflowing copy + len in bpf_msg_push_data()
Date: Tue, 21 Jul 2026 17:07:38 +0200
Message-ID: <20260721152611.310598217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 0c0a8ed85349dae298712d79cb276acfeb794d82 ]

When the scatterlist ring is full or nearly full, bpf_msg_push_data()
enters a copy fallback path and computes copy + len for the page
allocation size. Since len comes from BPF with arg3_type = ARG_ANYTHING
and both are u32, a crafted len can wrap the sum to a small value,
causing an undersized allocation followed by an out-of-bounds memcpy.

 BUG: unable to handle page fault for address: ffffed104089a402
 Oops: Oops: 0000 [#1] SMP KASAN NOPTI
 Call Trace:
  __asan_memcpy (mm/kasan/shadow.c:105)
  bpf_msg_push_data (net/core/filter.c:2852 net/core/filter.c:2788)
  bpf_prog_9ed8b5711920a7d7+0x2e/0x36
  sk_psock_msg_verdict (net/core/skmsg.c:934)
  tcp_bpf_sendmsg (net/ipv4/tcp_bpf.c:421 net/ipv4/tcp_bpf.c:584)
  __sys_sendto (net/socket.c:2206)
  do_syscall_64 (arch/x86/entry/syscall_64.c:94)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

Add an overflow check before the allocation.

Link: https://lore.kernel.org/all/20260424155913.A19FDC19425@smtp.kernel.org
Fixes: 6fff607e2f14 ("bpf: sk_msg program helper bpf_msg_push_data")
Tested-by: Xiang Mei <xmei5@asu.edu>
Tested-by: Xinyu Ma <mmmxny@gmail.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://lore.kernel.org/r/20260615021959.140010-2-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 83fcc64afa206b..f159a21e92588d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2834,6 +2834,9 @@ BPF_CALL_4(bpf_msg_push_data, struct sk_msg *, msg, u32, start,
 	if (!space || (space == 1 && start != offset))
 		copy = msg->sg.data[i].length;
 
+	if (unlikely(copy + len < copy))
+		return -EINVAL;
+
 	page = alloc_pages(__GFP_NOWARN | GFP_ATOMIC | __GFP_COMP,
 			   get_order(copy + len));
 	if (unlikely(!page))
-- 
2.53.0



