Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907122EFD81;
	Fri, 21 Nov 2025 13:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732271; cv=none; b=q3kEhCECTr6qWJrRad2HoydQoPcFLkO14utzEcXGY+w+X+Q6+4pG9JWrybNMj4m8TQoRHDI7JrPkkKE/OSzApaWictNbS9wB9fYlSS7+dhTh0zPKYNfjL4LDvuMHPhphh9d+eot6gs/gsMVJZZFb6PtslSP2GfiCg69HxojC6Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732271; c=relaxed/simple;
	bh=RHvIzzYmMuT5lBzIZ+myBZC8dTSLlZFjIDfjsfDfyXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrHql0M5/dOBk+M99eVG12RXnwxalKY5tDXDg5f5RcUSVQhkDMU1hIgp7slYDorCJWNs7OELC4vgAl/8OsjkE13JVekIv/yK499pFGK6K6oFON6esKoeQCZxuhoYMonk0d1ykOOFPFaqt1vagW36lU+VH8574+3/cofM6A2jZ3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ms3Z6sWr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ms3Z6sWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E825C116C6;
	Fri, 21 Nov 2025 13:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732270;
	bh=RHvIzzYmMuT5lBzIZ+myBZC8dTSLlZFjIDfjsfDfyXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ms3Z6sWrkClnBjTX93rjaiYi1wFTnLp7voRa1k5yroRQv5wPWmwOVPDPVfeLFaScv
	 hYSnRsjtbNnY7Z7GPGovIwqYgs3ehwyX8BLzbitL/ng4qWOZBy7supVNuGtNznVEG+
	 xHokYMadV1WU36n7HH3rLHK+rwgNVMItqOMayVZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/529] libbpf: Fix powerpcs stack register definition in bpf_tracing.h
Date: Fri, 21 Nov 2025 14:05:28 +0100
Message-ID: <20251121130232.036157347@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index 1c13f8e88833b..66b925bd954eb 100644
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



