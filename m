Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8135828C5AB;
	Wed, 23 Apr 2025 15:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421392; cv=none; b=sMpZ7sXxERq3dul8IORO+2mEVSsEAjoJRFdjQADJq42z4ZpGPgKuFy8I6p0xEDyU1ZQ5YKcuaZPc7EUus4FCYWVmTWCqUJHlp3wqXPa7STBzp5/N38vX8zUDt/aJfymgmdCLXWzLEgTt1rlVrEhtAhOUINRO0OXJFgvSliUEk80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421392; c=relaxed/simple;
	bh=7rZWD4y//BBe1crG7meFDmfnGQC3fzpf0rVpWgGERso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCulXcpAVw3dHYUR1BCiRPTcOIoEpqpMxlsZ73oGxsBxjel7UX1jS++gYDCTkfm58pzlnc0N7aBNbHgvd5PcRMQ6n0vhAaDI3Lo+z1ydxHJIM1unk4wZLqyKXzNiefjFUa8vFUvaiUB39mwc+peHLcpQEA07FSYNFMchWb9hQO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onROUGa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onROUGa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3639C4CEE2;
	Wed, 23 Apr 2025 15:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421392;
	bh=7rZWD4y//BBe1crG7meFDmfnGQC3fzpf0rVpWgGERso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onROUGa1s66oSb5Ch7P7CHN3DunE40ONMv9tlVlm83QgMuPmmxAiCrPYTocAQmwuU
	 SBCz4rczfbROjUBapTFxa+Qkmadut2eyhoy9SOqcbC2X2SkUyhBr4l8ORzYaiFmS1K
	 CmhR02MnmiIgidwAKnHCjFV9wRYO0XJ4J4bQvFOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Zavaritsky <mejedi@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.12 217/223] selftests/bpf: test for changing packet data from global functions
Date: Wed, 23 Apr 2025 16:44:49 +0200
Message-ID: <20250423142626.004048691@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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


