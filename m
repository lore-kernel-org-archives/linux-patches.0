Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5DD337100;
	Fri, 17 Oct 2025 15:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714777; cv=none; b=WSnfVxqklCx2Z46CXQx1PYYjIi+94/SVQYbO5HjpstPPDFm8KOpkPCyEjKJQxXCMyqcxsZA3RK6NRETDh4tXmCEvjJNbM9tfeyEAsnlCKpVs14bNQqIbLeCnPD/98X+QDNpn9JADCF4s55+aWrqsqQQCmwmxnq1AlQLJvFFk94A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714777; c=relaxed/simple;
	bh=Y4mtJT0F198aOUGe/KHcUdOUCGbNgc4VouaCQrh7v+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7Xz6/hg13iHYluadn9CA94L1X4+BkqoWB4FhiHEIERQM0FeOYHJAS2US++8utiMF4YA/JHNWtBxDnPQSLX0qHmQnLBt8eoeD87mBxr1Xvx3P0mkaeVT0QFki0zafbzAQCuPPAAsEUVFV/uqSmL9xWCJX1RP/9hOJSPeI5pGAI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIBoiSqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIBoiSqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99871C4CEE7;
	Fri, 17 Oct 2025 15:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714777;
	bh=Y4mtJT0F198aOUGe/KHcUdOUCGbNgc4VouaCQrh7v+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIBoiSqEs9NOptEm1Z31TuzJtDbqW3TZXRAECzTcXFSZRsXFX56YLSg/jtXv5sAQt
	 s0TiawhWxqEheufumTQ3SccEYDGTu6+5J3LjOA5cpEsAu0ao2bIOlnMJeMfbU3TVkM
	 E4b0ZzZMEKsyUa2GZaN7X/urDi1SlF2k5S0X/Y8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.12 262/277] s390/bpf: Write back tail call counter for BPF_TRAMP_F_CALL_ORIG
Date: Fri, 17 Oct 2025 16:54:29 +0200
Message-ID: <20251017145156.727976700@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

commit bc3905a71f02511607d3ccf732360580209cac4c upstream.

The tailcall_bpf2bpf_hierarchy_fentry test hangs on s390. Its call
graph is as follows:

  entry()
    subprog_tail()
      trampoline()
        fentry()
        the rest of subprog_tail()  # via BPF_TRAMP_F_CALL_ORIG
        return to entry()

The problem is that the rest of subprog_tail() increments the tail call
counter, but the trampoline discards the incremented value. This
results in an astronomically large number of tail calls.

Fix by making the trampoline write the incremented tail call counter
back.

Fixes: 528eb2cb87bc ("s390/bpf: Implement arch_prepare_bpf_trampoline()")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20250813121016.163375-4-iii@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/net/bpf_jit_comp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -2828,6 +2828,9 @@ static int __arch_prepare_bpf_trampoline
 		/* stg %r2,retval_off(%r15) */
 		EMIT6_DISP_LH(0xe3000000, 0x0024, REG_2, REG_0, REG_15,
 			      tjit->retval_off);
+		/* mvc tccnt_off(%r15),tail_call_cnt(4,%r15) */
+		_EMIT6(0xd203f000 | tjit->tccnt_off,
+		       0xf000 | offsetof(struct prog_frame, tail_call_cnt));
 
 		im->ip_after_call = jit->prg_buf + jit->prg;
 


