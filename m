Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207454;
	b=LoHWW4EpPmaWALwFNMY7BY5jXjNQ+fOdzK7m1uJXqX1tRlWEagWk/GO3TKvPBiXH867l
	 b2ByQKnaClr7KWJt4IpF6JDu9vNxBP5THMaD60IL1ZSoir+M5qHKmVoPnIljciIwkdGxB
	 oxQgfmFsjoFiuMp/FSZ8fUB+KJehWWeQkGBxERlc7btcTs7U7eM7EjWGGjw0wWmvrhCHn
	 1U59jHR+XutoxKwoeDgPSwbDgvW1+0F1s6bq/NdK3/4d7jTT1ke7AsQaCZ4AeWPniEb0/
	 k0emCO9/P2lCraEzKzzYKQL0kgCXPvOsxaQ7nlr+CQHtoQXZMBLmSsQmClzufvIMEGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VCUordlbijojn9pvTfjy7WRbXkgkl1Qv7pNSR6XZnSg=;
	b=3qowt36KGgbb8+TYU/OclDx+ZA2FUyffbryZDn5vHNxTAdteEW/uT3cIgu1/hHnukr6Z
	 kPVrwZlKSbMcj5RbDSindrMbmo6hxdhDgHotCMu4gzC+F7dcNJBE5Fl7qBC5TyPU3hSib
	 AfeP3+qsPeA3XJ80bQZAU7iwXRdnkKr0O6LnuAy8fJrL0HQnk7DPmUxg1Sx9qSglErtDg
	 hoKrbf5iIM1yu43Z6+wguJBZHAWESA+oVkxJt71oiHJm+cqQy4wgFzKro1zjT8XTkCC7O
	 BfT1lsvJH9EMU5F7ReIMR5VH7cXMg7S8NhXISQogaPcI+DGw9uJ+3wum8OvlPAkXCrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ek5cRvnJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7834606A31E;
	Wed, 28 Oct 2026 17:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ek5cRvnJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351271F01825;
	Wed, 28 Oct 2026 17:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207453;
	bh=VCUordlbijojn9pvTfjy7WRbXkgkl1Qv7pNSR6XZnSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ek5cRvnJDZB8mdftnpGbXucyYAND5Cn58sdkjs3cCkjHR1HLtQx00hxX6lI4gl33c
	 DJ+kteVn61AP0MZIem6Z3DXGkIgC7ihOK6etHN9e7oDhsPdsxUAEt5T6ojay8S319w
	 RXbD9t94FR1x0LONc22QLBOr+SANitHIgupjPeRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/247] tools/power turbostat: Fix fd_perf leak on reset
Date: Wed, 28 Oct 2026 17:57:05 +0100
Message-ID: <20261028165947.888895235@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 767c64414c4c5fffd6cbc3a1cf1fb8138b28645b ]

When turbostat notices a topology change,
it frees perf file descriptors for each CPU
to prepare to re-initialize.

Fix an off-by-one error in that per-cpu loop that
resulted in a file descriptor leak of the file for
the highest numbered CPU in the system.

Fixes: 67bab430f4e7 ("tools/power turbostat: Group SMI counter with APERF and MPERF")
Assisted-by: GitHub Copilot (claude-sonnet-4.6)
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index fb1c65f6ff9de..8b6180baa188d 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5194,7 +5194,7 @@ void free_fd_msr(void)
 	if (!msr_counter_info)
 		return;
 
-	for (int cpu = 0; cpu < topo.max_cpu_num; ++cpu) {
+	for (int cpu = 0; cpu <= topo.max_cpu_num; ++cpu) {
 		if (msr_counter_info[cpu].fd_perf != -1)
 			close(msr_counter_info[cpu].fd_perf);
 	}
-- 
2.53.0



