Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833798060B;
	Mon,  8 Apr 2024 13:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582028; cv=none; b=b+HcZLfu125CtZA547FVLRn1qkEw1q1P/wtIgJEQ+emvdsMfMQHMbOZuD5AbHARBxk/hb79NKRwscXkRQoBW3i+JtZjAdhMFlFDZrwqRSuLzaL1zRiPipu5U86Ssmtmda0DnMfsuzid1U6FKNoxwog+TP2Iy6r7x5LHr5JiOUJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582028; c=relaxed/simple;
	bh=3T/eLr9wIIMnLe6tEwC9IavsH05vQQP7h4P/TeFZ9fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2N6guiEGafgRzHOmeNFhvaz/tDhcLgUzvB177cdpHi9ouhu07QNcw472i/TaHrusAytuhP5WbkoF9u9743LmM/niKCJdslwc5fhCVd8byzwbWpHsndvLldqrEG+NPyynZ36IaTxC+wevQVewEI9wjBMKhzfC3f4UgVRSv6n8KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1aeiljGu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1aeiljGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0FDC433F1;
	Mon,  8 Apr 2024 13:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582028;
	bh=3T/eLr9wIIMnLe6tEwC9IavsH05vQQP7h4P/TeFZ9fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1aeiljGu7l9jH0oHlHGhvl+/jy6th5noQOMaySBl3b5ln6a9ks1NfvpU5e74KJwrV
	 ncGXwU1mFPTYEWIF/IgYSxHIRy9b1csDoB/ar1cea3t6KhjornkI9VF8qb0pLjrZkj
	 EOHDhceLeL3fT0EDdikANaV+uxhXNWF4JmZReOXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/252] x86/CPU/AMD: Move erratum 1076 fix into the Zen1 init function
Date: Mon,  8 Apr 2024 14:55:57 +0200
Message-ID: <20240408125308.440619948@linuxfoundation.org>
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

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit 0da91912fc150d6d321b15e648bead202ced1a27 ]

No functional changes.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Link: http://lore.kernel.org/r/20231120104152.13740-5-bp@alien8.de
Stable-dep-of: c7b2edd8377b ("perf/x86/amd/core: Update and fix stalled-cycles-* events for Zen 2 and later")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/amd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 28c3a1045b060..71503181bffd0 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1028,6 +1028,11 @@ static void init_amd_zn(struct cpuinfo_x86 *c)
 #ifdef CONFIG_NUMA
 	node_reclaim_distance = 32;
 #endif
+}
+
+static void init_amd_zen(struct cpuinfo_x86 *c)
+{
+	fix_erratum_1386(c);
 
 	/* Fix up CPUID bits, but only if not virtualised. */
 	if (!cpu_has(c, X86_FEATURE_HYPERVISOR)) {
@@ -1087,11 +1092,6 @@ static void zenbleed_check(struct cpuinfo_x86 *c)
 	}
 }
 
-static void init_amd_zen(struct cpuinfo_x86 *c)
-{
-	fix_erratum_1386(c);
-}
-
 static void init_amd_zen2(struct cpuinfo_x86 *c)
 {
 	fix_erratum_1386(c);
-- 
2.43.0



