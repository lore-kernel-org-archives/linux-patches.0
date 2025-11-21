Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5702334DCEA;
	Fri, 21 Nov 2025 13:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732360; cv=none; b=oVNuybZ/wwovic22YMa5MK5z1+aGgGOU4SDBXqZwA6LvCO+AefSdc3apjpy4FOqiMGTygr4Pnugx72SpIJpw//MO7wZ8U15VrZzjbG8Yyz5fqy5i9lbX1FTIDgyuB4h4hEG727fxMxxt5FmDDzy5DeDUbV51XHRdR5fa3ohlXm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732360; c=relaxed/simple;
	bh=FJArwWMiGRZMhMEqeGmt/w81jlUbbYCQr1x53EM7R0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyuR6UZ9VVRtFD4HP2xTVYEVFadG/aPGXxv8ElWSV60RzQSsVOdNgNvNnqPbAqz5yk4fVaTisok9tFoE+0tvmmqs77b4AfKJ6gv5CNVs74sWKgcA2EJLSekbFN+T/kkwOQq9JdWD4L2MenqRofEIOG1Wc5BGFPEeRsuDn4M1EJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AasHcrV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AasHcrV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD283C4CEF1;
	Fri, 21 Nov 2025 13:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732359;
	bh=FJArwWMiGRZMhMEqeGmt/w81jlUbbYCQr1x53EM7R0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AasHcrV9QTHk2fEk7d7nqIs5xZ1FQRihowYD4fJ/NEvUq4kghxJzIBoQlz1bGhvww
	 lchIFMwT63VAOOTLI4gcewRqVs5MeOEuvA746eVzmAQcdFc7a36ZrictwhYSosHYsQ
	 0FOCTcRz0MI0ZeBR09zcALsRf2SCeGHH7COQqtGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/529] tools/cpupower: fix error return value in cpupower_write_sysfs()
Date: Fri, 21 Nov 2025 14:06:31 +0100
Message-ID: <20251121130234.303097627@linuxfoundation.org>
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
index 7a2ef691b20e1..c2a7af89a67bb 100644
--- a/tools/power/cpupower/lib/cpupower.c
+++ b/tools/power/cpupower/lib/cpupower.c
@@ -55,7 +55,7 @@ unsigned int cpupower_write_sysfs(const char *path, char *buf, size_t buflen)
 	if (numwritten < 1) {
 		perror(path);
 		close(fd);
-		return -1;
+		return 0;
 	}
 
 	close(fd);
-- 
2.51.0



