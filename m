Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90AB3491EB;
	Wed,  3 Dec 2025 16:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778735; cv=none; b=sn87RUp7x7YVv7aYjANROVS4VODWSTxBsb//4ZC0IorQ9ZWrNa0fsEcDZErI3oa3VS4zmKTn5H9RSc6fl4g2+Jo3OiePMPbRm4GyI9qQlfrSLZCiM6N8wmFh4OOCXzQgNtmT09P0ZIQCWjTWUHzylh1fqvokftEGutvsKCofDxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778735; c=relaxed/simple;
	bh=iVAE8MI79OR3xk+upiPWP/JE6FcVsftqPo3DbwT7d3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcSOpLAOwyrh8r96pNRx9VSlvJEox57kLpb0/hupRdqRDWEbyAIBN6JRV5FS/jliZhYKTjetmDPaMC65iR8NFxNsApWRUoqfqC0BSwBJm6/HXhF7MQecH5TSpLIyDZFRqgH/mwaz21Q9rPRsL/uuF/WaeyAoLHnYtrCafIaFUOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3fNpAdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3fNpAdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C1BC4CEF5;
	Wed,  3 Dec 2025 16:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778735;
	bh=iVAE8MI79OR3xk+upiPWP/JE6FcVsftqPo3DbwT7d3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3fNpAdT1Po5f4ksi01nqgly2DackTFRordcthOlOLQCQLJDmGx97j5KMOGsz+t23
	 O0gcbyN3n9QGPjceOaVXg9hBf9fC80c2alRXQHN125UTJCNyCFDjJBnsBNBP6Y4otF
	 YtvkYvY2lfTzDvIxWxqOQ/71oz1yQB/DRbhxhez4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/568] libbpf: Fix powerpcs stack register definition in bpf_tracing.h
Date: Wed,  3 Dec 2025 16:20:46 +0100
Message-ID: <20251203152442.305261720@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 7221b9caf84b3294688228a19273d74ea19a2ee4 ]

retsnoop's build on powerpc (ppc64le) architecture ([0]) failed due to
wrong definition of PT_REGS_SP() macro. Looking at powerpc's
implementation of stack unwinding in perf_callchain_user_64() clearly
shows that stack pointer register is gpr[1].

Fix libbpf's definition of __PT_SP_REG for powerpc to fix all this.

  [0] https://kojipkgs.fedoraproject.org/work/tasks/1544/137921544/build.log

Fixes: 138d6153a139 ("samples/bpf: Enable powerpc support")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Naveen N Rao (AMD) <naveen@kernel.org>
Link: https://lore.kernel.org/r/20251020203643.989467-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_tracing.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
index 9c1b1689068d1..8f87a1765c80a 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -202,7 +202,7 @@ struct pt_regs___arm64 {
 #define __PT_RET_REG regs[31]
 #define __PT_FP_REG __unsupported__
 #define __PT_RC_REG gpr[3]
-#define __PT_SP_REG sp
+#define __PT_SP_REG gpr[1]
 #define __PT_IP_REG nip
 /* powerpc does not select ARCH_HAS_SYSCALL_WRAPPER. */
 #define PT_REGS_SYSCALL_REGS(ctx) ctx
-- 
2.51.0



