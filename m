Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F558320CD1;
	Wed,  3 Dec 2025 15:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777528; cv=none; b=GYc/7pmFEhHhcpAODaJL/Tra6LXGfCP4o65jGtdiyWt81Avv2qES+9y9TOxeNALL24+iOW0EUcwsP1zvRcS/Z+QI1KzhhyjQNerDlTiT/T3SZkgBUp3Db1LCd6EO77mB/X3QOFibx1l6x4INrDPtqip3y5NjoOnCCFozIqiSfyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777528; c=relaxed/simple;
	bh=u3Txwa+/4NEgdnj6SzozzhxkEmxUaPibI8OQeTuFqZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0Ypb8INMZ24+/VzjVVnHnuFRn/CwddeUc11FgoHi5pIcgEtVIE0gFOZsIbfoI8ndvKQSvnqTI9N2sA4WPBTLZsrg3GcjXwEpuOVGFq5qVWKK8fVinq/CO3tjhYS2W82Sm3/twb96y70GGuXlIBcFwDdmW6VWrB2nbYnXkX5P9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umwyN2EX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umwyN2EX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E923BC4CEF5;
	Wed,  3 Dec 2025 15:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777527;
	bh=u3Txwa+/4NEgdnj6SzozzhxkEmxUaPibI8OQeTuFqZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umwyN2EX6yOXr1uilTuSqZAcueLJNvhPodA9TT0PpsNr24xkK05Bw0ikdqry+STTX
	 qYT/dbL2Ah+MX0EXjs49gSmE9pDT5KlPlrCjS58hvij58C0kigkEX3Rq0cskBZNjMV
	 A4jUi6AQxOMB7S4Kboa/Z0NoTdSjLMwG/sMI5YBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	"Naveen N Rao (AMD)" <naveen@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/392] libbpf: Fix powerpcs stack register definition in bpf_tracing.h
Date: Wed,  3 Dec 2025 16:22:53 +0100
Message-ID: <20251203152414.956510794@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 20fe06d0acd98..950ce502d655c 100644
--- a/tools/lib/bpf/bpf_tracing.h
+++ b/tools/lib/bpf/bpf_tracing.h
@@ -176,7 +176,7 @@
 #define __PT_RET_REG regs[31]
 #define __PT_FP_REG __unsupported__
 #define __PT_RC_REG gpr[3]
-#define __PT_SP_REG sp
+#define __PT_SP_REG gpr[1]
 #define __PT_IP_REG nip
 
 #elif defined(bpf_target_sparc)
-- 
2.51.0



