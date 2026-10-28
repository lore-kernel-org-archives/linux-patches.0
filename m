Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207442;
	b=al9p+2mQQY0tZAqHQqPSeH8LIvy07HCYVYwIkbF1tKRKxNhz5iAxUYa996mKjvOWSs6q
	 kjqKZdzZybOdKq9rVschh2j8wwwjNXiuCSA8idUBtJ1MJPLUNAlGq2rmaEhlMNUStnEmI
	 dCdFLPkDfb5RKdiz4DyuTQ7cmS2pbuwH2XlLVKaOImTK5UyEeYL+nqHimCXu1vm8xh8gE
	 WRw5xOUXUofRX7jnLH7zaYyYpMuO+yZZ/ZrzeDeOuP1IhBehL1QR0YZ3Xs8UiaH3SEhvy
	 mCURgMrZHfvFKbwf8okI20wnghY/z12RJkasA3wZ0yH6goVUWADvcxPvtYb/y9aY5TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hZCRiwzZTHMtF80KLOI2qsWvrlA5apkbZSgxgOPv/5s=;
	b=BOrV5vr46kIWMmDgyA19DL1qEw0dIMud6zAncHVLMlmf+1j+gUMOw0RMNNqomD14STQq
	 tC7KmFeqhMhC17iQ6AzqRgVyOQQ64vBExgnVi5647L0Lh0c4fhRKnpezn8upWVb4RKETL
	 ZL6XiLn06cOOc8Tu9R830xC2fwqv4cwOjMB57n6L/eOIeXN1LprTG3Q6G2Y2jziXJyHIt
	 /xOek5riPBzBJmZkMVkKXKyzcg8VQhr/VTGt8F+dAZJXNpM+hcQ3kSd+XCOnF6TpGP275
	 Rpve+Xxx+GxzIfmO9wqjjkTb/9bV6KsqdfkjlJSZC2ZReDL+SrQvoekdzcO8FLD0f+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uU8JAGAx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BA1606A31A;
	Wed, 28 Oct 2026 17:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uU8JAGAx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72CA1F01825;
	Wed, 28 Oct 2026 17:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207442;
	bh=hZCRiwzZTHMtF80KLOI2qsWvrlA5apkbZSgxgOPv/5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uU8JAGAxJfJHH5qe8JekF4Y33AcXAqdeRLWrUgT60I5IC/kx9cqjkQFyn2xFFmwhd
	 mopnOvNil2nZbgexa5kN6QfOs0LbSkj60W92qe+jre9WOtkCWUqpMWzzqx5YbIc65f
	 3PAcosCKl1NRhgk6BCwB2AuoD+04Ux1EtTUMvL9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Tianyu Lan <tiala@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/247] x86/hyperv: Avoid using per-cpu output page in hv_apicid_to_vp_index()
Date: Wed, 28 Oct 2026 17:57:02 +0100
Message-ID: <20261028165947.816744418@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhkelley58@gmail.com>

[ Upstream commit 7b74c117e2aac78e0f723e1c9c3644451c56b0d9 ]

hv_apicid_to_vp_index() currently uses the per-cpu hypercall input
and output pages. This function is called when running in VTL2 and
when running in an SEV-SNP CoCo VM with no paravisor. In the former
case, the output page is allocated, but in the latter case it is
not, so the hypervisor stores the output VP index in memory that has
not been allocated by the guest.

Fix this by using the input page for both input and output. The
hypercall has very small input and output, so sharing the same
page for both is straightforward. An alternative fix is to
allocate the per-cpu output page when running in an SEV-SNP CoCo
guest, but this uses significantly more memory, particularly
with larger vCPUs counts.

Fixes: 86c48271e0d6 ("x86/hyperv: Fix APIC ID and VP index confusion in hv_snp_boot_ap()")
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/hyperv/hv_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 5d7e5b53e33ea..733802ffcc66e 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -750,7 +750,8 @@ int hv_apicid_to_vp_index(u32 apic_id)
 	input->partition_id = HV_PARTITION_ID_SELF;
 	input->apic_ids[0] = apic_id;
 
-	output = *this_cpu_ptr(hyperv_pcpu_output_arg);
+	/* Treat input as having 2 APIC IDs so output is 64-bit aligned */
+	output = (void *)input + struct_size(input, apic_ids, 2);
 
 	control = HV_HYPERCALL_REP_COMP_1 | HVCALL_GET_VP_ID_FROM_APIC_ID;
 	status = hv_do_hypercall(control, input, output);
-- 
2.53.0



