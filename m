Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773910;
	b=kHd/Ze+oJqcotKGzs32t+9/LuSkSvnhtWq2f2FBRUs5+rOZiyr4yjdjxgMw/T1PFUDyf
	 7Ul7vLexI/4ebTd+nF/wa5HyrRQ34O/Ae9HZRERtvOXZmx4TL6xHEyzcmibwKLtEWiN1y
	 kFZzzGgMEciFjzF3gYuSmKILkRdO/zbhyYW6Ify5dGzDKbeNsGNZEhhuKMxy6Di3mfME7
	 dkiZzPd82YTToWyq8DTS4aqmVs2rRi1OE6cFBEBj0GsmUgLrPx+OL7bHGCR1G9cIfBBtJ
	 w1Q8kANCxekp23NzF7AE3vvwa45rVPCk+3OFAuhKx09r+QiDS0buQEfEqkgXEqirNbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8lZND4jVNBnqZrhbbkv4q7wcSAmn6tDfVmFcne5VMsY=;
	b=XIMD9yRbxLNzBV3vflkGOejhOS5DH+ZEbfRSP2S1/c/5QyHXV0E57Jh62UmgAnSA4bIL
	 5dy1VhZVjx9yagvCKypb6vjitjS4qsCmGzgwFhx46n5otiTjEizwjPTMgtLA7UWvfBcZU
	 ObV/3HClB1rw2QacNw70IPMcjerNqeuynbeG7lWzg8wjIdMBqAMz4Brp1W15X+a0qwOAU
	 OqMG+HXnWRuoj+cLU2uUA5twDmRUkR/4Ykq1gjPGMaa6l5GGkSXg3EmXhb7Bw3cuWlZSj
	 hcnXzqmlhRHKOgHagpFuFuRa/2Rj+lDOoXaduUR5ePTbGC9rj19ZL6cFVO7cKJfBFZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uGxbCwgw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FB3606A31A;
	Fri, 23 Oct 2026 16:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uGxbCwgw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A426C1F01825;
	Fri, 23 Oct 2026 16:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773910;
	bh=8lZND4jVNBnqZrhbbkv4q7wcSAmn6tDfVmFcne5VMsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uGxbCwgw4KNPfyOGZDPKCDLU26ZbHH6hBUjB8n1EVRosmIhn6Teinmzr98FqvS8ZI
	 bClWtqZ4NhyMCCi7Ia8ey7DxbXtZmEB/gcWl/YVwkT2b0/VLFE/EomYSlgAc4nzEY1
	 GvXez6m6KzN34V2O1Fo1jdm6anvEzSxDS4JmqL0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/193] tools/power turbostat: Fix fd_perf leak on reset
Date: Fri, 23 Oct 2026 18:34:55 +0200
Message-ID: <20261023163714.633668950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 313872f64a9a9..47471377ff43c 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5768,7 +5768,7 @@ void free_fd_msr(void)
 	if (!msr_counter_info)
 		return;
 
-	for (int cpu = 0; cpu < topo.max_cpu_num; ++cpu) {
+	for (int cpu = 0; cpu <= topo.max_cpu_num; ++cpu) {
 		if (msr_counter_info[cpu].fd_perf != -1)
 			close(msr_counter_info[cpu].fd_perf);
 	}
-- 
2.53.0



