Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AA32FE58D;
	Mon, 13 Oct 2025 15:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368990; cv=none; b=LNdv2d3HFgIhIukfCrLxTKPhMNye8oa3GcyqE1YuxTr3CUm0Jzn8s9D8OoQHUViWBCNIyW7aQxhaJAk8DGhphISGZKLOcI960Zsr1+T1tVD+jEyLEcXe5tHKj4SJvmuDaSq1czNHuZQ8FnTq6FIBQhHblzGvd2Osqya+tMnwA4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368990; c=relaxed/simple;
	bh=w1e6NB3xeVnUj4H6qB32xdUiAvfVlg9yv2eRnW4zcMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7a6AwsxJFMpcCgRXl7Lmue5wtQ+4NADa1qwBzOCRVJl62M54GUOzgFx4Oqy/9Ucy6KBs41CKR78HOW4lChRS66ZSWOS7Ox6e39OcIHjk7tajRdWa+OuOkdbk4Jj2tZEGmCSG3EFFhorCYdzbgnVyiqkWCwmKhjqUf63TVZ+rmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lpr26LZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lpr26LZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2862C4CEE7;
	Mon, 13 Oct 2025 15:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368990;
	bh=w1e6NB3xeVnUj4H6qB32xdUiAvfVlg9yv2eRnW4zcMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lpr26LZrnbbCyaPRz33sU3ZzxAdlj5GAmzv32bPsN72pH1RuRmmboVHBXs9be6ztc
	 836dRjwQhcfT2P1qYq2fyoAlDzwKup3m+eA6rWSBnDl/jzQmb1HjnhQZC6LPgjCGvs
	 yA0NRbzK9u9g7+gvRg7HHRB8N/QArZ5eUAYRlmKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 056/563] s390/bpf: Write back tail call counter for BPF_TRAMP_F_CALL_ORIG
Date: Mon, 13 Oct 2025 16:38:37 +0200
Message-ID: <20251013144413.319698169@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit bc3905a71f02511607d3ccf732360580209cac4c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index ccb83ac3e6f32..b2b8eb62b82e0 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -2839,6 +2839,9 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im,
 		/* stg %r2,retval_off(%r15) */
 		EMIT6_DISP_LH(0xe3000000, 0x0024, REG_2, REG_0, REG_15,
 			      tjit->retval_off);
+		/* mvc tccnt_off(%r15),tail_call_cnt(4,%r15) */
+		_EMIT6(0xd203f000 | tjit->tccnt_off,
+		       0xf000 | offsetof(struct prog_frame, tail_call_cnt));
 
 		im->ip_after_call = jit->prg_buf + jit->prg;
 
-- 
2.51.0



