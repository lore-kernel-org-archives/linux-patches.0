Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EBE33F8A1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300926; cv=none; b=lPs0iTjQZivNdZaOtdaqWE3nWONFLh3sdqGchKUnLkIaIXbxCUe6eh6CmT/yIIl+9wQtnuuvdc6qOcsyDam/DUhA+wj9reZ93p9sCY3dEOcwFTLxN4yo//kkeCK1+JzNNjmyhnixaskSLhDg+rtnGVHdUgzLOjSH3ucG0LcafRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300926; c=relaxed/simple;
	bh=ANDSCPHjokIvXexJoyEmdLJh4bwF/OZdktQa/MDY09o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/4rNl2EeR2wPFSJRlZ7/PerdWWZbI1oCmhoH/pRFU53xp7L2sjwTtBY+577V0mVT7zV7CaPIIZaZBPWhQsPtHAZk4z6DikpkFM+EbZtkg81792ak0Owya9RhG5VHiPrQ8Y7B8AhTKcDa3AGtaKT9ykl8j2rj9cDdIboHd5Dat4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WV25ND8H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WV25ND8H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A50EC19423;
	Sat, 28 Feb 2026 17:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300925;
	bh=ANDSCPHjokIvXexJoyEmdLJh4bwF/OZdktQa/MDY09o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WV25ND8HZoSpy/8R3FMhj7+Ux7g5JEL6TAkuTCskETaz1Ca+lAr8PFq0plS0m1dkq
	 dRVqnL24PX89feWuTrnj+kkIzx5RGN0TlwEhet4AIFNqeCdrRt3vpVVLT8JqeAuyfM
	 kOPInFBTZCdhXibvNsaS60FwZWIi36NLKHbQ2X5Znb+7fcmR/grJTuDx4ImXXgfiS6
	 FGjwq/GwRBcWn0yGVXa8oEmz6htODP7sRiVA5rSSYuTCPGIlPhkbAcCTplyUGJoaTC
	 0ejlnqDK0zSXgZVBEezJuHOQvFNuCagAO9H4Oxm/mnowaRO+nGW9lY7n9jqDxnLmVN
	 hEJ3DihdpY7bA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/752] tools/power cpupower: Reset errno before strtoull()
Date: Sat, 28 Feb 2026 12:35:55 -0500
Message-ID: <20260228174750.1542406-44-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit f9bd3762cf1bd0c2465f2e6121b340883471d1bf ]

cpuidle_state_get_one_value() never cleared errno before calling
strtoull(), so a prior ERANGE caused every cpuidle counter read to
return zero. Reset errno to 0 before the conversion so each sysfs read
is evaluated independently.

Link: https://lore.kernel.org/r/20251201121745.3776703-1-kaushlendra.kumar@intel.com
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/lib/cpuidle.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/power/cpupower/lib/cpuidle.c b/tools/power/cpupower/lib/cpuidle.c
index f2c1139adf716..bd857ee7541a7 100644
--- a/tools/power/cpupower/lib/cpuidle.c
+++ b/tools/power/cpupower/lib/cpuidle.c
@@ -150,6 +150,7 @@ unsigned long long cpuidle_state_get_one_value(unsigned int cpu,
 	if (len == 0)
 		return 0;
 
+	errno = 0;
 	value = strtoull(linebuf, &endp, 0);
 
 	if (endp == linebuf || errno == ERANGE)
-- 
2.51.0

