Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220D26A352;
	Mon,  8 Apr 2024 13:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581624; cv=none; b=lFejSUeI8vUSEfAgXRf0UJHTvE4oLG2n7mcCH9Lespz2HtHqpElmHXOK9JEeqbjYqW74kCrWmU4WwHYiSpXy2R4PIUvcR281Y56z97uChQPh2VAI8lSWqeBC+Bo1a3rbgK5odvbwZzjAwrXiza1TM4u4ylxV8boswk+hkbPH/ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581624; c=relaxed/simple;
	bh=92+ksTdS7lE3nO5uVcTupTgfRFhkCTLJqMwKDAsFsVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNCRyo6as+Z8bCmyexXaanJjkVZGaqDW1bEbMFhRmVLEvt/Y0xlheQ5c7Mz/W0233YvXhD4Wwbtj/B3H6ZoeF2pZTFZwTTtl5WPlhcABL0CO9ln3zivHZ3u40v46SO4hggElpyV/YbkYKzCCZ47FjycWneUx7viUJ05YW7ZH1BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbPAaKN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbPAaKN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5C3C433C7;
	Mon,  8 Apr 2024 13:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581624;
	bh=92+ksTdS7lE3nO5uVcTupTgfRFhkCTLJqMwKDAsFsVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EbPAaKN6VLMoKNbdlZ4cup52a8tYCzzeenUNBJZ29bNQvOvX9Jp/AZiPNLGbYdot5
	 9WtUpZDHA1loyP6lGxI9q9ByJnXd3aGPLZqBncKIEBhN4hDn+HDFgGCJAR0KyMtz8o
	 G89NBEDmmKHnsMf+IBYQZnSMr7oriEh0nyFPyZRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Savkov <asavkov@redhat.com>,
	Puranjay Mohan <puranjay12@gmail.com>,
	Xu Kuohai <xukuohai@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/252] arm64: bpf: fix 32bit unconditional bswap
Date: Mon,  8 Apr 2024 14:55:06 +0200
Message-ID: <20240408125306.874743959@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Artem Savkov <asavkov@redhat.com>

[ Upstream commit a51cd6bf8e10793103c5870ff9e4db295a843604 ]

In case when is64 == 1 in emit(A64_REV32(is64, dst, dst), ctx) the
generated insn reverses byte order for both high and low 32-bit words,
resuling in an incorrect swap as indicated by the jit test:

[ 9757.262607] test_bpf: #312 BSWAP 16: 0x0123456789abcdef -> 0xefcd jited:1 8 PASS
[ 9757.264435] test_bpf: #313 BSWAP 32: 0x0123456789abcdef -> 0xefcdab89 jited:1 ret 1460850314 != -271733879 (0x5712ce8a != 0xefcdab89)FAIL (1 times)
[ 9757.266260] test_bpf: #314 BSWAP 64: 0x0123456789abcdef -> 0x67452301 jited:1 8 PASS
[ 9757.268000] test_bpf: #315 BSWAP 64: 0x0123456789abcdef >> 32 -> 0xefcdab89 jited:1 8 PASS
[ 9757.269686] test_bpf: #316 BSWAP 16: 0xfedcba9876543210 -> 0x1032 jited:1 8 PASS
[ 9757.271380] test_bpf: #317 BSWAP 32: 0xfedcba9876543210 -> 0x10325476 jited:1 ret -1460850316 != 271733878 (0xa8ed3174 != 0x10325476)FAIL (1 times)
[ 9757.273022] test_bpf: #318 BSWAP 64: 0xfedcba9876543210 -> 0x98badcfe jited:1 7 PASS
[ 9757.274721] test_bpf: #319 BSWAP 64: 0xfedcba9876543210 >> 32 -> 0x10325476 jited:1 9 PASS

Fix this by forcing 32bit variant of rev32.

Fixes: 1104247f3f979 ("bpf, arm64: Support unconditional bswap")
Signed-off-by: Artem Savkov <asavkov@redhat.com>
Tested-by: Puranjay Mohan <puranjay12@gmail.com>
Acked-by: Puranjay Mohan <puranjay12@gmail.com>
Acked-by: Xu Kuohai <xukuohai@huawei.com>
Message-ID: <20240321081809.158803-1-asavkov@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 5fe4d8b3fdc89..29196dce9b91d 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -876,7 +876,7 @@ static int build_insn(const struct bpf_insn *insn, struct jit_ctx *ctx,
 			emit(A64_UXTH(is64, dst, dst), ctx);
 			break;
 		case 32:
-			emit(A64_REV32(is64, dst, dst), ctx);
+			emit(A64_REV32(0, dst, dst), ctx);
 			/* upper 32 bits already cleared */
 			break;
 		case 64:
-- 
2.43.0



