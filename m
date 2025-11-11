Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45163AC3B;
	Tue, 11 Nov 2025 01:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822884; cv=none; b=TbZDRiV8YxR0RnUqy1FLhHszNE3z01gjy+7k8Ct8wwzkys6dAfFB7kbkFiqd0hXHdrxXp7tx6TpZC57Nx9PHlfcAeDJcpnRtw3JY3yaiaZ3V3xnZ/BjPoNm42wePcxN7OeMM3zIpZCTKL/CmVOjiTxCcsBI6H2I4mpr5lF0vk2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822884; c=relaxed/simple;
	bh=wNHpvYqTD8lC6twzBml9J1O53EKBV3lJAbxxCuo/Lbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Td+0a6hJSeNVURB6CuMFHH3E4wFCPCCcTjSZ6F7Er/SmkKVY442gL1X2ZaN7zGYVImIZQ0/CgUjgfmi9ueU/HnYvZJpoUnajIKZfhKl0FMrdfJdL+5xj8yjgF9Nfv0+AbBceJHi1f6Mk2NDRZYVw/18qjx25YXZ3vEos6fXsRZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WiGtS/20; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WiGtS/20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD29C16AAE;
	Tue, 11 Nov 2025 01:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822884;
	bh=wNHpvYqTD8lC6twzBml9J1O53EKBV3lJAbxxCuo/Lbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WiGtS/20w50pOgiblS6ZFDp8h+dih2q7wCZII/oovMCA3nLHe88XVQkxyPi3RdoKq
	 zxiWUBmAGuwpypsGpym8Di/rbp2pWmq2sY/vPFVPrRWOqZ5M8zfTxfG+qOBjZLWeIc
	 nlIbOXT+1gG+/fZ1N3KSbKxU7oWGgtuPGvTA4nHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 189/849] tools/cpupower: fix error return value in cpupower_write_sysfs()
Date: Tue, 11 Nov 2025 09:35:59 +0900
Message-ID: <20251111004540.995979859@linuxfoundation.org>
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

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 57b100d4cf14276e0340eecb561005c07c129eb8 ]

The cpupower_write_sysfs() function currently returns -1 on
write failure, but the function signature indicates it should
return an unsigned int. Returning -1 from an unsigned function
results in a large positive value rather than indicating
an error condition.

Fix this by returning 0 on failure, which is more appropriate
for an unsigned return type and maintains consistency with typical
success/failure semantics where 0 indicates failure and non-zero
indicates success (bytes written).

Link: https://lore.kernel.org/r/20250828063000.803229-1-kaushlendra.kumar@intel.com
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/lib/cpupower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/cpupower/lib/cpupower.c b/tools/power/cpupower/lib/cpupower.c
index ce8dfb8e46abd..d7f7ec6f151c2 100644
--- a/tools/power/cpupower/lib/cpupower.c
+++ b/tools/power/cpupower/lib/cpupower.c
@@ -56,7 +56,7 @@ unsigned int cpupower_write_sysfs(const char *path, char *buf, size_t buflen)
 	if (numwritten < 1) {
 		perror(path);
 		close(fd);
-		return -1;
+		return 0;
 	}
 
 	close(fd);
-- 
2.51.0



