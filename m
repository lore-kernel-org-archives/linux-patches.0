Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774369;
	b=JXtecjc5xX+Tz3K4h+yKxikHDEu4JCixFnUNLSv8xKnCDYiaa/zOuMpLKlQycOD2Pouq
	 dDXbHF8wkhTGP4ctuB0SR2WXuBeWj7OxOGAHlfj7mYtTgDHALhmKQUXh0LrCA78ulXNF2
	 JUIIZJw4tfGRdvzBe6YoLP7MTqDhumhPSN0aNDe4aQNUBTAPeGKevkVD1zNYdmkhPRJiW
	 gKQohXdvzxgrRc5qYlUBIbnwRqxrZwnUJH+fqOZU2AcLojOYMCXxexYYO5noOr90m92zy
	 vB9F5cfFVKhDoLNoOG35FbTL8MSu3dFrfjq5aOqBCYh2oGCDYKNQ6wsbtWRwBtRqdzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TVttGBOyNOjVrgCwgsc6d9S/3Zd8SfbWwS0FQE8uc6Q=;
	b=04hcV6xPVDtY0aUJHRMlP+8+SdXL3Z46Juw2kX3sISUWVeaXwdlWO2Co8Tsr3gTk0pBE
	 WPX5DRk3obIbigZvlv2+mRUyevynaa8QAimLh7HSpMJXK8FCK+JSntkgvRipAQbdSjvMJ
	 2R/2SOPwJJuYzTIPPyIofYtaLoR8z1dcgbl2OvZXT3+F8Ny0Net0wmaJH7NLcL2zgHQV1
	 NXgrISCa9YylgHo77PXG5HN4bcBTnyYuSEAgeAAB07dwkDSK6PZ0sNFTr0oEm/Zxh95Qe
	 43I/QdCtiVLuu0UNc+8dvuhgCog3jjbBWaC7b3hcKXJjc4X1UKnGQqpNUNnh0JjNvMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QvcOD4by;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5454606A31B;
	Fri, 23 Oct 2026 16:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QvcOD4by
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E5E1F01825;
	Fri, 23 Oct 2026 16:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774368;
	bh=TVttGBOyNOjVrgCwgsc6d9S/3Zd8SfbWwS0FQE8uc6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QvcOD4byQ3zMTD5c/iWzQ01aGXnPfC4aNrxLhKQ0WI6hXBiZYQXa3hW6svEmd8Nkf
	 izfvLifUEqlIaIeQOZrOltka93BzjQD+Bo4/PojmKJyGWL0FpVywZZZFWegOSjNyJO
	 WVjbhPPiF/WC/ABSD4sBD9PNxIUeoc8Zs7KuBmKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 018/242] tools/power turbostat: Fix fd_perf leak on reset
Date: Fri, 23 Oct 2026 18:37:40 +0200
Message-ID: <20261023163714.216795568@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 6d3a58df678dc..fc488157d3a37 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5915,7 +5915,7 @@ void free_fd_msr(void)
 	if (!msr_counter_info)
 		return;
 
-	for (int cpu = 0; cpu < topo.max_cpu_num; ++cpu) {
+	for (int cpu = 0; cpu <= topo.max_cpu_num; ++cpu) {
 		if (msr_counter_info[cpu].fd_perf != -1)
 			close(msr_counter_info[cpu].fd_perf);
 	}
-- 
2.53.0



