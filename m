Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F97B3B9616;
	Sat, 17 Oct 2026 17:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258381; cv=none; b=Kjkpv8evOMbFh54+ySMXf0VRZC1oDcjQuxwbYOUgV74frIg38aGA3WBtXsVuNSOnEieCpN/wrxXS02mAi0rc64R3caflzmaiqwJTFoQktSVSjrZZfMgytVFuyjHVbDXsC6AzP829l7drclqw5e4kf8cGOQ/1s9hKDqcW/uL/3CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258381; c=relaxed/simple;
	bh=6c6k1S6oYFGWHoYrsv5IRT86V9tv9I4+XlWUCMfsCHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sM0HVWqjyxMl/srqfswLx91vsobmEKTz0UTFxAYR5zWhGwrFzkuXmI7/z0361uLGWe5wcukgAqfYpa5Uj9VMhHHjw3rWgtAxcCRg/D+AGdj8eLXylv504+MCw5z6IfxaFp7wfTSzBo3f6teL54lSC94oImQ7UlnVMw/65hxa5Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTeDsaWC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTeDsaWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EA81F000C5;
	Sat, 17 Oct 2026 17:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258380;
	bh=VMoV3Nd+crTw9iJqiMGI8CkYr2QYDBEgR9bYt6hFbJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KTeDsaWCK9PGvP/kSAG8UWdvtXPMxuLahRsqBCslff77BcMtpL+LGN8HNt5L/fETw
	 f9IHoh3zhdi+j0HcJVQkKl3CH1VXfGS1z8Aq2rP4gvyy8JsipLnRUTnxWJhOctruN4
	 uvnk2/910yyfPzZ0KkMS20xaD9ojZ+Mk2RrZ1fk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0865/1674] bpf, arm64: Enable the inline of bpf_kptr_xchg()
Date: Sat, 17 Oct 2026 17:52:17 +0200
Message-ID: <20261017160453.317231713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 18a45f12d746c06b7361b0cce59cf8e8b9e38da6 ]

ARM64 bpf jit satisfies the following two conditions:
1) support BPF_XCHG() on pointer-sized word.
2) the implementation of xchg is the same as atomic_xchg() on
   pointer-sized words. Both of these two functions use arch_xchg() to
   implement the exchange.

So enable the inline of bpf_kptr_xchg() for arm64 bpf jit.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Link: https://lore.kernel.org/r/20240119102529.99581-2-houtao@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: ef06fd16d487 ("bpf, arm64: Force 8-byte alignment for JIT buffer to prevent atomic tearing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index c66fe02acc605..1fcdb129ada8a 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -2364,3 +2364,8 @@ int bpf_arch_text_poke(void *ip, enum bpf_text_poke_type poke_type,
 
 	return ret;
 }
+
+bool bpf_jit_supports_ptr_xchg(void)
+{
+	return true;
+}
-- 
2.53.0



