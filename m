Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466AA4C97;
	Tue, 11 Nov 2025 00:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822193; cv=none; b=nUoA2w1uYk89McaKrHPPse/I1O1uQ6j50DI+x+y259tsHMHwz34U8mBctayK01evSWyMksPGdSSnZgT2DyX9F6OrhbUd/JR4rLFQZUIWMREEWyb6NZ4NFdzfuIKzF9acup22EQ8qoHvf4Lrh5HyQHh7ZjKyECxFXMXVbwhW/mLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822193; c=relaxed/simple;
	bh=t8hRWniw7BnVYnIecsA3aqZpFgyEZMI26D7odEUVbZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAz4LMgPqau3vjlYNvec8qgYxIkGlWQjjk87acCgQv4t8jRhEVcQX0f4/dUMsKsrLcTYJqfzEh4EhFUM+MnK643UmiQ0tMp0lSqXBs5v8OY/6Bx3ObA+rsXhox9iwOqTtMskYm0V8Enzss77NNCXk87+bPxtgG1LF5AulOEyKws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gUn8iZq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gUn8iZq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98A6C4CEF5;
	Tue, 11 Nov 2025 00:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822193;
	bh=t8hRWniw7BnVYnIecsA3aqZpFgyEZMI26D7odEUVbZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUn8iZq4dmj4o6PxJc0nCdnS1wR6cehSu5RGgzVA1RdPdYTLRTM51UfbnmyHLeWwH
	 iPHJCAd/i1CcsugC5n+vqMECn2vvbvACnRoSapmZmKo3cu3o1KswolmYemO8x5C8sp
	 NQbDU3yntKuB3oXGN+IZrRgWqF/8ZDPhPJmejMJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 054/849] libbpf: Fix powerpcs stack register definition in bpf_tracing.h
Date: Tue, 11 Nov 2025 09:33:44 +0900
Message-ID: <20251111004537.741844654@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
index a8f6cd4841b03..dbe32a5d02cd7 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -311,7 +311,7 @@ struct pt_regs___arm64 {
 #define __PT_RET_REG regs[31]
 #define __PT_FP_REG __unsupported__
 #define __PT_RC_REG gpr[3]
-#define __PT_SP_REG sp
+#define __PT_SP_REG gpr[1]
 #define __PT_IP_REG nip
 
 #elif defined(bpf_target_sparc)
-- 
2.51.0



