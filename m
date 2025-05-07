Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675BE28DF4F;
	Wed,  7 May 2025 19:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644768; cv=none; b=lXJFDMQosvCQ0Nr/7qGntvVUpR8VGFfHDKXEyjKrXBllj58M8lOTXTl1vP3z9SJM+MC4wZqdB8lkIVYxfNU3ilFC91yw/41Weu+05fl7VUNNggrz5YyxIULbnrsXxXOP3qopAN1g05WSzF8ruPPUZtiODsvRpwA6omABKCumx0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644768; c=relaxed/simple;
	bh=DG4ofd+BWGh1QmYDzQ7xvDWQ45Kr47JChk2Ro0jjYbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hCPX/7lGpSlnGhNyyoHcFuWrBx8ddJ9mREkMDAem5RCnDq0G1C+mKg92A8M4lkGBV6sn++3fwW1Bai8M4iPA24C7CVe+S81DG+TuGyv/wrG/hgoLqvbFGeijopCA3PDSQLmGlqwBHT2Fc1e4EpRhSgyj3pPTLNi4NoX53QBuXGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m25VCuy7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m25VCuy7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5FDC4CEE2;
	Wed,  7 May 2025 19:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644768;
	bh=DG4ofd+BWGh1QmYDzQ7xvDWQ45Kr47JChk2Ro0jjYbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m25VCuy7ZKCtrVT7HasjLZ/NAobGQzw8JSExDPoiAC0Hoyevt7hXW1v2oJvdq15SN
	 EfPpHWZIXgLcKs5tJOGbSV2OZohGBaiFsgQzppee1jeTA6FM9buour7OUEmkRCU6Ej
	 Sss1T0Kv/kPEJriCX1dPHcgaLcOxgQU8KmEyTaEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jibin Zhang <jibin.zhang@mediatek.com>,
	Shiming Cheng <shiming.cheng@mediatek.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/164] net: use sock_gen_put() when sk_state is TCP_TIME_WAIT
Date: Wed,  7 May 2025 20:40:08 +0200
Message-ID: <20250507183825.951897263@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Jibin Zhang <jibin.zhang@mediatek.com>

[ Upstream commit f920436a44295ca791ebb6dae3f4190142eec703 ]

It is possible for a pointer of type struct inet_timewait_sock to be
returned from the functions __inet_lookup_established() and
__inet6_lookup_established(). This can cause a crash when the
returned pointer is of type struct inet_timewait_sock and
sock_put() is called on it. The following is a crash call stack that
shows sk->sk_wmem_alloc being accessed in sk_free() during the call to
sock_put() on a struct inet_timewait_sock pointer. To avoid this issue,
use sock_gen_put() instead of sock_put() when sk->sk_state
is TCP_TIME_WAIT.

mrdump.ko        ipanic() + 120
vmlinux          notifier_call_chain(nr_to_call=-1, nr_calls=0) + 132
vmlinux          atomic_notifier_call_chain(val=0) + 56
vmlinux          panic() + 344
vmlinux          add_taint() + 164
vmlinux          end_report() + 136
vmlinux          kasan_report(size=0) + 236
vmlinux          report_tag_fault() + 16
vmlinux          do_tag_recovery() + 16
vmlinux          __do_kernel_fault() + 88
vmlinux          do_bad_area() + 28
vmlinux          do_tag_check_fault() + 60
vmlinux          do_mem_abort() + 80
vmlinux          el1_abort() + 56
vmlinux          el1h_64_sync_handler() + 124
vmlinux        > 0xFFFFFFC080011294()
vmlinux          __lse_atomic_fetch_add_release(v=0xF2FFFF82A896087C)
vmlinux          __lse_atomic_fetch_sub_release(v=0xF2FFFF82A896087C)
vmlinux          arch_atomic_fetch_sub_release(i=1, v=0xF2FFFF82A896087C)
+ 8
vmlinux          raw_atomic_fetch_sub_release(i=1, v=0xF2FFFF82A896087C)
+ 8
vmlinux          atomic_fetch_sub_release(i=1, v=0xF2FFFF82A896087C) + 8
vmlinux          __refcount_sub_and_test(i=1, r=0xF2FFFF82A896087C,
oldp=0) + 8
vmlinux          __refcount_dec_and_test(r=0xF2FFFF82A896087C, oldp=0) + 8
vmlinux          refcount_dec_and_test(r=0xF2FFFF82A896087C) + 8
vmlinux          sk_free(sk=0xF2FFFF82A8960700) + 28
vmlinux          sock_put() + 48
vmlinux          tcp6_check_fraglist_gro() + 236
vmlinux          tcp6_gro_receive() + 624
vmlinux          ipv6_gro_receive() + 912
vmlinux          dev_gro_receive() + 1116
vmlinux          napi_gro_receive() + 196
ccmni.ko         ccmni_rx_callback() + 208
ccmni.ko         ccmni_queue_recv_skb() + 388
ccci_dpmaif.ko   dpmaif_rxq_push_thread() + 1088
vmlinux          kthread() + 268
vmlinux          0xFFFFFFC08001F30C()

Fixes: c9d1d23e5239 ("net: add heuristic for enabling TCP fraglist GRO")
Signed-off-by: Jibin Zhang <jibin.zhang@mediatek.com>
Signed-off-by: Shiming Cheng <shiming.cheng@mediatek.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250429020412.14163-1-shiming.cheng@mediatek.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_offload.c   | 2 +-
 net/ipv6/tcpv6_offload.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 2dfac79dc78b8..e04ebe651c334 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -435,7 +435,7 @@ static void tcp4_check_fraglist_gro(struct list_head *head, struct sk_buff *skb,
 				       iif, sdif);
 	NAPI_GRO_CB(skb)->is_flist = !sk;
 	if (sk)
-		sock_put(sk);
+		sock_gen_put(sk);
 }
 
 INDIRECT_CALLABLE_SCOPE
diff --git a/net/ipv6/tcpv6_offload.c b/net/ipv6/tcpv6_offload.c
index ae2da28f9dfb1..5ab509a5fbdfc 100644
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -42,7 +42,7 @@ static void tcp6_check_fraglist_gro(struct list_head *head, struct sk_buff *skb,
 					iif, sdif);
 	NAPI_GRO_CB(skb)->is_flist = !sk;
 	if (sk)
-		sock_put(sk);
+		sock_gen_put(sk);
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 }
 
-- 
2.39.5



