Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773892;
	b=m77MusgAJqDq35wZuBvgPHR5dlB0ScEYpAeQUglfL8hDoq95HPslaLCLgfrLEGOXXKE3
	 6ONijcQmIKZ0nB03xER1AK0i83yRMBVUhG+NBMMuDL41pFCnF9bTJi8WXFDJAij4gDkGD
	 xg7gn7wZov8raqpz+1ELGFq2viivcm6bBX4L9rSq1KraepIKUVUseqiPO11qE6jP2ueI3
	 MmCJLohhpiVAL6/Hi/uQ1xgrBE+20IMRn0mlqOU4emKYG+9u46aWrnvs1mR8Ezg1fEmZm
	 3EV85bU7oXNobxqp3AwzUf2ysF0te60DFutVNyCRvy4M6g1+mJl5YGMb19AVuwdw9kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773892;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pPV3c0y++a4Q9uGKbjEgcEc/npdhnsTboOTGXmxm1wk=;
	b=qWlHDdvS9JBM7VjtkCEFRhZDCT8I7YM+0xUN3EOhGqmzJMkqI4TPeGmxoTkicI0HOX2d
	 rlUtNBhzq5gX64KfyS9azUkPn17o8vJJuRFgYzFbtQeVzY1tM2tX266Q1HgwKmLNxsQJk
	 Zd7fAl+yiqtyUbvXilFZlyhvyORHCc6og1ThW3trr3O/wfVjVEadzOk5NTzgXeKaJaT67
	 puQXEro8Xql7vvvrRiWMvJJVsXntXgt/J5E8rkKbt4Y0WsBVRny+kMGEbojIVJ67oBP8h
	 WeORvCDF/tWvoDfU48yEMHuH6sM1sT1PpQG1zEvnXerEaygxNJrcfBBexWyXQ9hVbCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KS2g0jQT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBCD606A320;
	Fri, 23 Oct 2026 16:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KS2g0jQT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2FA1F01825;
	Fri, 23 Oct 2026 16:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773892;
	bh=pPV3c0y++a4Q9uGKbjEgcEc/npdhnsTboOTGXmxm1wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KS2g0jQT6czF4U8spJviVXXG1ddjVGRWwKjp8KSk3j24sotQnmf7lFOeapQ283q0a
	 gQv4qDeFOzT23N4h/Iy095D65oochfaewp2QTzsr1zJZHW4rguHKtUCfjj8LRxGhdn
	 AHTi+NLP538Dfs/ohao/MmSP1v/sngsMifMjfPH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Tianyu Lan <tiala@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 014/193] x86/hyperv: Avoid using per-cpu output page in hv_apicid_to_vp_index()
Date: Fri, 23 Oct 2026 18:34:51 +0200
Message-ID: <20261023163714.539865018@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 085ef4f2e73a9..498d48b575e51 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -713,7 +713,8 @@ int hv_apicid_to_vp_index(u32 apic_id)
 	input->partition_id = HV_PARTITION_ID_SELF;
 	input->apic_ids[0] = apic_id;
 
-	output = *this_cpu_ptr(hyperv_pcpu_output_arg);
+	/* Treat input as having 2 APIC IDs so output is 64-bit aligned */
+	output = (void *)input + struct_size(input, apic_ids, 2);
 
 	control = HV_HYPERCALL_REP_COMP_1 | HVCALL_GET_VP_INDEX_FROM_APIC_ID;
 	status = hv_do_hypercall(control, input, output);
-- 
2.53.0



