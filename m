Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619292;
	b=b5uyTuoCHBAfMiIYVhpybGNFDDF5ioekGH7gik5GcghDlEXSAUnE24M3J5ZrDdWN2CgW
	 eQ32WMxUCUlIqFteOJ8SqgugzdcMqJvCh73DuFH4ZkW7ete5q8NoIgePYEspAMsBr2F7z
	 jkd+qCp8QT8fycoJDzKXL/feW/M/7gB5KNeVwSJJD4ZDV2Hgt2BStlymUjyh5uI5Z02k4
	 xSu+KdSyw2CtB2UAiJlPavn0KotehQAKrd9DnvPHsU8UmZhqcfi6w3uDHCB5mg16HXAmJ
	 LDgiePamNOoxNLb0epEPeII/LI3CcwJF/pZjXTNd0INEwYqpFCp+Tg/EVcd7w2snflA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pUUQ1U1eOdKz039XcbVzzpWRTfW5Mil0w7kGXim3J+8=;
	b=v1HYyRZbe2DMm577DEssWEx7w0z9pqmzkyGFdEI2RaHbtS3rTVlUy4hlTHOaceuXngOM
	 cdWA4a1MscHQiOHcrDaO8ekCm1P7y5qcOJUStqJCbPeNH9KyJr+K9tfJEfnGFSEik+fVx
	 QlM7o2OFzw1nUqreWL1yipmTNrhVrvFsbPazZ3SNACEsQcMvP1K/g3onms1qGRkBlzxfE
	 M5phT579za5SWxellu3ty7JCwNXVJQsVhKZYC7n/lKHUJJDjTrJPKOhpyC+eVr+3u3Jwh
	 muI+Gil1Ub4wbsXH6xS7BCe6aq6u+/Z8aIWfs+JNAZNl0PjGrJ/7BGfOh+KJuFOmjdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QP5e9TJc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C121D606A32E;
	Wed, 25 Nov 2026 15:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QP5e9TJc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81231F000D2;
	Wed, 25 Nov 2026 15:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619292;
	bh=pUUQ1U1eOdKz039XcbVzzpWRTfW5Mil0w7kGXim3J+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QP5e9TJcuW2Dp+UOLLOur7GU6ORZS22GVgPQRfUcJM2eDQLz5q4MTcghDykDJon4D
	 m/TOnfFkyKm2hFPJLRpVDPVUu8INEQSwncPBjIRUSQ3BcIQoQb8mczSKzY3HTFkbeI
	 0/W+GBrJe/CpYejdKcfK/ifJhM6J4nK5vNMzahPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0505/1005] net: Fix memory_allocated leak in __sk_mem_raise_allocated().
Date: Wed, 25 Nov 2026 15:30:43 +0100
Message-ID: <20261125143833.574370731@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 8012eec76b7e6c0d9fb338fe8e3db6ca1b419da4 ]

__sk_mem_raise_allocated() calls sk_memory_allocated_add() and
reuses the return value to check if it was called.

However, sk_memory_allocated_{add,sub}() cache a value in per-cpu
counter, sk->sk_prot->per_cpu_fw_alloc, up to sysctl_mem_pcpu_rsv
before reflecting it to sk->sk_prot->memory_allocated.

Thus, sk->sk_prot->memory_allocated could have a negative value,
and proto_memory_allocated() returns 0 in such a case.

Then, if mem_cgroup_sk_charge() succeeds, sk_prot_mem_limits()
checks are bypassed, and if mem_cgroup_sk_charge() fails,
sk_memory_allocated_sub() is not called, leaking counters.

Let's use sk->sk_bypass_prot_mem instead of allocated.

Fixes: 7c268eaeec63 ("net: Allow opt-out from global protocol memory accounting.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261105212905.3122712-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index a74be1cc93024..f93ae40ef6bd7 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3357,7 +3357,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 			goto suppress_allocation;
 	}
 
-	if (!allocated)
+	if (sk->sk_bypass_prot_mem)
 		return 1;
 
 	/* Under limit. */
@@ -3438,7 +3438,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 
 	trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
 
-	if (allocated)
+	if (!sk->sk_bypass_prot_mem)
 		sk_memory_allocated_sub(sk, amt);
 
 	if (charged)
-- 
2.53.0



