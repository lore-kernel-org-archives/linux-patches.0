Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE9A21504D;
	Wed,  7 May 2025 19:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644935; cv=none; b=fB25qlNl5aDI3o1AYFAxe0k1jM2emoVlsHu73aKi7fCcqnw5GXhI466pVaC51hsj1IZi+Fx5YELWFObo/aLih1f5qpLAQNH5UcT1/vQ6MkyHEUhhoozYcCwWFcIrUUunmil89cvf+XWGw7dkjRLvC2smWF8bbUUD4fzA2mn5vSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644935; c=relaxed/simple;
	bh=roNgLCauPA+IW/Hap9ybY5QHJWPzeuaX98p5FlI12kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXmVPqNaUhGDc1fp4EkENMmgj0F++32GwVOMeF7LOKkAQbNE+Z7BxMlVrpPpruqEw4bycCiwU3XiAr0dg35TCf3TgjlGYfLneuSgyBLXIwHuAZVKmt6gTxNT8ZTDQcKsZsxi2ulSojd3SDVPfgmXdyWJ1k4Z0T9DUP0I0USNHEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17/7f6ls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17/7f6ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401DBC4CEE2;
	Wed,  7 May 2025 19:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644935;
	bh=roNgLCauPA+IW/Hap9ybY5QHJWPzeuaX98p5FlI12kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17/7f6lsYCHv7YYEljHu0HyvjycGOphEkbpgsjsTOuUT3NPXfauR/fO2A89qADHd4
	 RxwK+HDxvcqVXFjbOYeIYMWEORstQZ3zahVvzvWZbr49To1U1Xwo1J0+PGqTIEOFCj
	 kSDgSob4cFmS0PNuCz5ljKPBSLbSzpUC9vNlkBbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 040/129] selftests/bpf: validate that tail call invalidates packet pointers
Date: Wed,  7 May 2025 20:39:36 +0200
Message-ID: <20250507183815.166499207@linuxfoundation.org>
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

commit d9706b56e13b7916461ca6b4b731e169ed44ed09 upstream.

Add a test case with a tail call done from a global sub-program. Such
tails calls should be considered as invalidating packet pointers.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20241210041100.1898468-9-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/verifier_sock.c |   28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/tools/testing/selftests/bpf/progs/verifier_sock.c
+++ b/tools/testing/selftests/bpf/progs/verifier_sock.c
@@ -50,6 +50,13 @@ struct {
 	__uint(map_flags, BPF_F_NO_PREALLOC);
 } sk_storage_map SEC(".maps");
 
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(max_entries, 1);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+} jmp_table SEC(".maps");
+
 SEC("cgroup/skb")
 __description("skb->sk: no NULL check")
 __failure __msg("invalid mem access 'sock_common_or_null'")
@@ -1004,5 +1011,26 @@ int invalidate_pkt_pointers_from_global_
 	*p = 42; /* this is unsafe */
 	return TCX_PASS;
 }
+
+__noinline
+int tail_call(struct __sk_buff *sk)
+{
+	bpf_tail_call_static(sk, &jmp_table, 0);
+	return 0;
+}
+
+/* Tail calls invalidate packet pointers. */
+SEC("tc")
+__failure __msg("invalid mem access")
+int invalidate_pkt_pointers_by_tail_call(struct __sk_buff *sk)
+{
+	int *p = (void *)(long)sk->data;
+
+	if ((void *)(p + 1) > (void *)(long)sk->data_end)
+		return TCX_DROP;
+	tail_call(sk);
+	*p = 42; /* this is unsafe */
+	return TCX_PASS;
+}
 
 char _license[] SEC("license") = "GPL";


