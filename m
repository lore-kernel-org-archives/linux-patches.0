Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D9E46D559;
	Wed, 30 Sep 2026 16:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787498; cv=none; b=J9xE2AW+tYy4QVVpTG5Pp6Z2KJ2LLprPA6UJ/nls8xrK7RxA6FRzddrXNz6CLpO7IZAb3rbx1i74rslvGPd/2O4v309RT0ARS0wcoNYTLoe6Ky68hwMjrt/vtH584B7a4yxdC3W0LunBCPEWJwjHcmC4FXXm/kgUho1AN0Zv3Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787498; c=relaxed/simple;
	bh=zIe1AR40BnqDpdo9KqSzxWXPmaA2HG9Sh84ybfL2sg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gVV6f//E6/jOTPQgUkCFTyxeKuGMOq6yql8jlNkwwPk8wOcjGU9cp9aPIkyEvNGVU5qflOi8/MAv5q8V/8lhPXN5EdXy/XjEX6DtZz7r3W1NeuVI7bzy3cEJyUPG/M9AMb++ZSrUVDDT7c+3YV5TQVKYUG6sWbTJu3bZ/nJwFjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nNOPywYa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nNOPywYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE811F000FF;
	Wed, 30 Sep 2026 16:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787496;
	bh=D7ccieOTuiaW7TYAu4Mre4Oy26Z/nd8L6hXiQImOC8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nNOPywYaCycKi64l36hWcHcADX7k1Gl3QBr2DV6z29ppE27b8EBkwIczo9ChrkHdP
	 qLwkZ1MQ1/DYM10O+ajl1hrUf9u/X4TCNXRBvtPsutQnI2crCdyT7cPXCiaYcmVL2r
	 x3YESzicM+xNAgxgHcBR24BIy7tjsRRynco6rHJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 206/457] bpf: Zero-fill other CPUs when BPF_F_CPU creates a per-cpu hash element
Date: Wed, 30 Sep 2026 17:25:11 +0200
Message-ID: <20260930152350.499138249@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit c3a66e5f5bab3912e9f84223c5a982bf4333d5a1 ]

pcpu_init_value() initializes the per-cpu area of a newly created
[lru_]percpu_hash element.  The area is recycled, so when the value
comes from a BPF program (onallcpus == false) it writes the running
CPU's slot and zeroes the rest.

bpf_percpu_hash_update() passes onallcpus == true, which delegates to
pcpu_copy_value().  pcpu_copy_value() writes only the CPU named in
map_flags when BPF_F_CPU is set, so on the create path the other slots
keep the recycled element's values:

  update(k1, 0xdeadc0de, BPF_F_ALL_CPUS)  every CPU holds 0xdeadc0de
  delete(k1)                              element back on the freelist
  update(k2, 0xc0ffee, BPF_F_CPU | 0)     creates, writes CPU 0 only
  lookup(k2)                              CPU 0 0xc0ffee, rest 0xdeadc0de

Zero-fill the other CPUs on that arm too.

Fixes: c6936161fd55 ("bpf: Add BPF_F_CPU and BPF_F_ALL_CPUS flags support for percpu_hash and lru_percpu_hash maps")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260924102321.2120434-2-donggeunyoo.kernel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 5117447ac291b..61ef6191f79ad 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1055,14 +1055,17 @@ static void pcpu_init_value(struct bpf_htab *htab, void __percpu *pptr,
 	/* When not setting the initial value on all cpus, zero-fill element
 	 * values for other cpus. Otherwise, bpf program has no way to ensure
 	 * known initial values for cpus other than current one
-	 * (onallcpus=false always when coming from bpf prog).
+	 * (onallcpus=false always when coming from bpf prog,
+	 *  map_flags & BPF_F_CPU when coming from syscall but setting
+	 *  only one cpu).
 	 */
-	if (!onallcpus) {
-		int current_cpu = raw_smp_processor_id();
+	if (!onallcpus || (map_flags & BPF_F_CPU)) {
+		int init_cpu = (map_flags & BPF_F_CPU) ? map_flags >> 32 :
+			       raw_smp_processor_id();
 		int cpu;
 
 		for_each_possible_cpu(cpu) {
-			if (cpu == current_cpu)
+			if (cpu == init_cpu)
 				copy_map_value(&htab->map, per_cpu_ptr(pptr, cpu), value);
 			else /* Since elem is preallocated, we cannot touch special fields */
 				zero_map_value(&htab->map, per_cpu_ptr(pptr, cpu));
-- 
2.53.0



