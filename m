Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9655632572C;
	Wed,  3 Dec 2025 15:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777559; cv=none; b=gSXxPhpxMa4oBe433YdvFnKO8fcFBJP1C8bbe5f9F8I2T/MmiSKqg1gFxSVStS0Oa/dMhdqMGzU6ARPHRvwWZvdWpMeIbgbPca6PfwcgrR6pFJEmdbjBjLfYh82fSLNeoao8aiSVTYC/03D17SY8Gbz/oemVtVV41T/VN1W3srg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777559; c=relaxed/simple;
	bh=iPVvGTGdquT1OiPo2SaXLoDyB0m+v8Cex4DV7J5K/FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBgXdxByxhuf1NKK+rDqy/5w6NAvocsJ8EgPauUEv7VMwwskhPjGBMhfitd00QVGPjWNNsE0fGXstkBKvWRIvNIG11LcDlLhYcf0RvIrabVTjCZZtZHg0Fppdv3w++OdBT64L7c3gG75ZEVySnnEkXA0m7ouK9UX05qJg7xX534=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DMqRdZ9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DMqRdZ9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025F2C4CEF5;
	Wed,  3 Dec 2025 15:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777559;
	bh=iPVvGTGdquT1OiPo2SaXLoDyB0m+v8Cex4DV7J5K/FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMqRdZ9Wa90Q7agJO6MUqtT7rJNVO565TlKxmzw5uR7g/qHybyyKfPv6QwzhJ1CTC
	 MWtCAHcoZ4SCbyahzNK+CFDjyMoZPeEswmkRHbIssC4ym5/gi0lJ3Q/vXESbE0TC6T
	 rpySoU24JQi8N5l23rOhuQOiq0wi9y8zHH876qnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/392] tools/cpupower: fix error return value in cpupower_write_sysfs()
Date: Wed,  3 Dec 2025 16:23:47 +0100
Message-ID: <20251203152416.938581757@linuxfoundation.org>
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
index 3f7d0c0c50676..0e29365e23a59 100644
--- a/tools/power/cpupower/lib/cpupower.c
+++ b/tools/power/cpupower/lib/cpupower.c
@@ -48,7 +48,7 @@ unsigned int cpupower_write_sysfs(const char *path, char *buf, size_t buflen)
 	if (numwritten < 1) {
 		perror(path);
 		close(fd);
-		return -1;
+		return 0;
 	}
 
 	close(fd);
-- 
2.51.0



