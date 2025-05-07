Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775DF1EB5DD;
	Wed,  7 May 2025 19:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644920; cv=none; b=SsXfhKqM3/qYE+wh9tjIJq97VEUlM8BU/2vbqS1bkkwmVSnakcC9uBp8XFjG1xgRdcun36FQAKq2LBHSSZ9fxAbzeXo6Md8FiuvFnjWbK/7T5NTsR5MPITfImXw23eG55YutnsHbaofKm+xEwQ0E+tYWYVNR2zYsvQ1TxU3Fq2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644920; c=relaxed/simple;
	bh=9KSSKpSVTTaSpzc4gpqZR61Tnt5plZekX/L0nIJ7QgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qc+Up1aIHbqkXiebKG2XP+mRiCgmkUueLorKE1UGoa/zq3wOhY4P2cWXebNYgBnJATE4HVoAgr9FkJgTIqyQzLSs4PqXaL0TZze9vnpcOpd5sFx3BJeGXpJxDLknjH6z9v76mUjjPSWQn9M5nznG3HI1y5z1juMZ2sMTgDqQ0Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrFg3Gtd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrFg3Gtd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBEB1C4CEE2;
	Wed,  7 May 2025 19:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644920;
	bh=9KSSKpSVTTaSpzc4gpqZR61Tnt5plZekX/L0nIJ7QgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrFg3GtdGvtLjr80O901vl+jcLZSk+dmDYDS0pHyDDELX9fMUSxVh9Lt+kXfgF4Ud
	 jruXo6SagibUQEhl2afHf1X55Xy4FJepf+EYmLoM1uaJoF/kTdnOzr1smyv0OJYz2q
	 iC3ox35tObxj6sLjhV0F0EMPHQVnE13PLgDMKAhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Zavaritsky <mejedi@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 036/129] selftests/bpf: test for changing packet data from global functions
Date: Wed,  7 May 2025 20:39:32 +0200
Message-ID: <20250507183814.998795348@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

commit 3f23ee5590d9605dbde9a5e1d4b97637a4803329 upstream.

Check if verifier is aware of packet pointers invalidation done in
global functions. Based on a test shared by Nick Zavaritsky in [0].

[0] https://lore.kernel.org/bpf/0498CA22-5779-4767-9C0C-A9515CEA711F@gmail.com/

Suggested-by: Nick Zavaritsky <mejedi@gmail.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20241210041100.1898468-5-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/verifier_sock.c |   28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/tools/testing/selftests/bpf/progs/verifier_sock.c
+++ b/tools/testing/selftests/bpf/progs/verifier_sock.c
@@ -977,4 +977,32 @@ l1_%=:	r0 = *(u8*)(r7 + 0);				\
 	: __clobber_all);
 }
 
+__noinline
+long skb_pull_data2(struct __sk_buff *sk, __u32 len)
+{
+	return bpf_skb_pull_data(sk, len);
+}
+
+__noinline
+long skb_pull_data1(struct __sk_buff *sk, __u32 len)
+{
+	return skb_pull_data2(sk, len);
+}
+
+/* global function calls bpf_skb_pull_data(), which invalidates packet
+ * pointers established before global function call.
+ */
+SEC("tc")
+__failure __msg("invalid mem access")
+int invalidate_pkt_pointers_from_global_func(struct __sk_buff *sk)
+{
+	int *p = (void *)(long)sk->data;
+
+	if ((void *)(p + 1) > (void *)(long)sk->data_end)
+		return TCX_DROP;
+	skb_pull_data1(sk, 0);
+	*p = 42; /* this is unsafe */
+	return TCX_PASS;
+}
+
 char _license[] SEC("license") = "GPL";


