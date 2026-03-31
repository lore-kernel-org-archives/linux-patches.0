Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97CA423A7C;
	Tue, 31 Mar 2026 16:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975562; cv=none; b=RT0Is9aMbrZVIU2FJBksAI162F60F4Dng0glyEiXusZVJIsaRV6zOtYNS1hZ/86SuAQb+JLRRJueREy5Gm9ltLvgonLj3DZPJtLuBZdQH+8XsGMZVDwWICEveNANfYg6xiKnQV0T6Cw9DtlP3fJFgN9dkGN1+LktI2O0OTKsVoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975562; c=relaxed/simple;
	bh=7mYaZKYhPXK9OCLrucvm8V1wMtEeENhL1WE6YtbOi2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjmhEQ1RZfXgCmujqt4oHDXjdpqONPgvL9MAVayWF5C+QT/QhO8WBF+RsekB2cRJe6X6LZGwiAe95n4nKSrpfYgwgaOwBnzsc1BxcuKWBYS16OMaXN0rfC3LaWhhRFhi/ZRJ94bEHGTm5igzyuaRW+16h5YfbMPxlM/bwDdNzeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gnz6mSNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gnz6mSNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5695C19424;
	Tue, 31 Mar 2026 16:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975562;
	bh=7mYaZKYhPXK9OCLrucvm8V1wMtEeENhL1WE6YtbOi2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gnz6mSNN52St/U792YWezx1YwnyiF8GPMdCCUTI4le7P08Xd8Ibp4kN8Vh8q4PX0+
	 kNd8A1io+LOlE2UUtPG3eUom8Gjsjlf3T/ceK6fsNkR4bkw9I2dxMglHpPLJrzfcpZ
	 Ni59GQunMePfju7gwfrFZqzaXU8HukyknOdXts1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.19 309/342] powerpc64/bpf: do not increment tailcall count when prog is NULL
Date: Tue, 31 Mar 2026 18:22:22 +0200
Message-ID: <20260331161810.293735645@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Bathini <hbathini@linux.ibm.com>

commit 521bd39d9d28ce54cbfec7f9b89c94ad4fdb8350 upstream.

Do not increment tailcall count, if tailcall did not succeed due to
missing BPF program.

Fixes: ce0761419fae ("powerpc/bpf: Implement support for tail calls")
Cc: stable@vger.kernel.org
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260303181031.390073-2-hbathini@linux.ibm.com
[ Conflict due to missing feature commit 2ed2d8f6fb38 ("powerpc64/bpf:
  Support tailcalls with subprogs") resolved accordingly. ]
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/net/bpf_jit_comp64.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/arch/powerpc/net/bpf_jit_comp64.c
+++ b/arch/powerpc/net/bpf_jit_comp64.c
@@ -430,27 +430,32 @@ static int bpf_jit_emit_tail_call(u32 *i
 
 	/*
 	 * tail_call_cnt++;
+	 * Writeback this updated value only if tailcall succeeds.
 	 */
 	EMIT(PPC_RAW_ADDI(bpf_to_ppc(TMP_REG_1), bpf_to_ppc(TMP_REG_1), 1));
-	EMIT(PPC_RAW_STD(bpf_to_ppc(TMP_REG_1), _R1, bpf_jit_stack_tailcallcnt(ctx)));
 
 	/* prog = array->ptrs[index]; */
-	EMIT(PPC_RAW_MULI(bpf_to_ppc(TMP_REG_1), b2p_index, 8));
-	EMIT(PPC_RAW_ADD(bpf_to_ppc(TMP_REG_1), bpf_to_ppc(TMP_REG_1), b2p_bpf_array));
-	EMIT(PPC_RAW_LD(bpf_to_ppc(TMP_REG_1), bpf_to_ppc(TMP_REG_1), offsetof(struct bpf_array, ptrs)));
+	EMIT(PPC_RAW_MULI(bpf_to_ppc(TMP_REG_2), b2p_index, 8));
+	EMIT(PPC_RAW_ADD(bpf_to_ppc(TMP_REG_2), bpf_to_ppc(TMP_REG_2), b2p_bpf_array));
+	EMIT(PPC_RAW_LD(bpf_to_ppc(TMP_REG_2), bpf_to_ppc(TMP_REG_2),
+			offsetof(struct bpf_array, ptrs)));
 
 	/*
 	 * if (prog == NULL)
 	 *   goto out;
 	 */
-	EMIT(PPC_RAW_CMPLDI(bpf_to_ppc(TMP_REG_1), 0));
+	EMIT(PPC_RAW_CMPLDI(bpf_to_ppc(TMP_REG_2), 0));
 	PPC_BCC_SHORT(COND_EQ, out);
 
 	/* goto *(prog->bpf_func + prologue_size); */
-	EMIT(PPC_RAW_LD(bpf_to_ppc(TMP_REG_1), bpf_to_ppc(TMP_REG_1), offsetof(struct bpf_prog, bpf_func)));
-	EMIT(PPC_RAW_ADDI(bpf_to_ppc(TMP_REG_1), bpf_to_ppc(TMP_REG_1),
-			FUNCTION_DESCR_SIZE + bpf_tailcall_prologue_size));
-	EMIT(PPC_RAW_MTCTR(bpf_to_ppc(TMP_REG_1)));
+	EMIT(PPC_RAW_LD(bpf_to_ppc(TMP_REG_2), bpf_to_ppc(TMP_REG_2),
+			offsetof(struct bpf_prog, bpf_func)));
+	EMIT(PPC_RAW_ADDI(bpf_to_ppc(TMP_REG_2), bpf_to_ppc(TMP_REG_2),
+			  FUNCTION_DESCR_SIZE + bpf_tailcall_prologue_size));
+	EMIT(PPC_RAW_MTCTR(bpf_to_ppc(TMP_REG_2)));
+
+	/* Writeback updated tailcall count */
+	EMIT(PPC_RAW_STD(bpf_to_ppc(TMP_REG_1), _R1, bpf_jit_stack_tailcallcnt(ctx)));
 
 	/* tear down stack, restore NVRs, ... */
 	bpf_jit_emit_common_epilogue(image, ctx);


