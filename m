Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAC12F12D2;
	Fri, 17 Oct 2025 15:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714028; cv=none; b=KfNKt3BspBN08TQwSLzIG6AEBpMKcDgiWzjQis7Nba3QFhm/0ye2g+tzhEpeftFAwHu5Ls7jHwM4YD+D1eIit39cfHhf4czUyZR1MfK3bsAv0U33LygMAoXiGlVn5l3yJjZ/hXkrPHDgn8C6soMJx+1n+psaoNljjVO33tclTnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714028; c=relaxed/simple;
	bh=ItwNxCZ4k6W4Al/UKxHmb11K6ndvXeBoyI3IOtiVIlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AgqE034yZBFK0n+I3xwtcbSC7qEP8/OcgaqPosbSku0+ehjP+Xd9XxnKS7j1xkPYQ5Knp3X91WhMMoRGH3rhua/otgwq9tl3d9q55p6+tpzLlAy+j2cZyN8krobyXSuaidfDP+/SqLTGGEpBho91OkZyenYfzNHiYz8QI93m790=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJuZegS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJuZegS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C469C4CEE7;
	Fri, 17 Oct 2025 15:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714028;
	bh=ItwNxCZ4k6W4Al/UKxHmb11K6ndvXeBoyI3IOtiVIlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJuZegS8rt9yrWyfXBQSOXNOLQRpmXoaWCDF/hiFL3ZBfTmwHondo+zySopVLfQHS
	 14NVY79hFGJD+ZgVPpmrDDLtATNmUZ1N22NiQEhZu9VZRiFFKJ/xrGAuj3tWXppqEI
	 M88ahe2Guot7lPzwSdTX0muF/Rk4NOkk5KT0i3Ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 6.6 189/201] s390/bpf: Write back tail call counter for BPF_TRAMP_F_CALL_ORIG
Date: Fri, 17 Oct 2025 16:54:10 +0200
Message-ID: <20251017145141.704309856@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2462,6 +2462,9 @@ static int __arch_prepare_bpf_trampoline
 		/* stg %r2,retval_off(%r15) */
 		EMIT6_DISP_LH(0xe3000000, 0x0024, REG_2, REG_0, REG_15,
 			      tjit->retval_off);
+		/* mvc tccnt_off(%r15),tail_call_cnt(4,%r15) */
+		_EMIT6(0xd203f000 | tjit->tccnt_off,
+		       0xf000 | offsetof(struct prog_frame, tail_call_cnt));
 
 		im->ip_after_call = jit->prg_buf + jit->prg;
 


