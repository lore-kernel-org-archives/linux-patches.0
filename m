Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A28A1F5F6;
	Tue, 11 Nov 2025 01:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822975; cv=none; b=DgIYy7p4edoAhjTBQpxKJaSJImISaEBsZN18QKEE5+9gYDi+WeddmO91IZq08JOSx8Dsbrv7OnwTZTBaN5yQigmWyPuj5q6k0Hh/luazHKUA227bpcqQq+8oBTpwpAZKi5oBHwt47dqgq4NNEmLspaE6rZ2PRJ+kQpurxeG1HKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822975; c=relaxed/simple;
	bh=sExuHsy5DhuI4m3CyZ8YMwQNslD98gu+It+QATDD9F8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AE3EZNAd/4j6PGOFpBxApczqFBc9lcnEMKN9erom8JwEmtu7vU+aDbVBNp5Hel83Fh3rnVL+WNLqKVPI4xli8r4QrBKgDYYpgZGdDEGxXjEVeJZWvpJCBgejwjIvRgyiTYQpKKRrwvAyVV3zwhtI1tAsNUTkeo6JF/DqJ6ebsxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXrRQPPa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXrRQPPa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80EFAC4CEFB;
	Tue, 11 Nov 2025 01:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822974;
	bh=sExuHsy5DhuI4m3CyZ8YMwQNslD98gu+It+QATDD9F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pXrRQPPaCXLOi/GyRCnov4NLQ84eYUe+YVOVWreWTyDqbQ+xEu6jfQ8Rjc5lgtggG
	 CaLLJF4qnPeLVPQGrnQTLM0QbS3u4RwHxTBG7v4OUry0wByj8t7rR827vNLzncYfwV
	 K/t9Ktc43/oTjGmyDNZacRf7+ee1igxziR6CYTH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 142/565] tools/cpupower: fix error return value in cpupower_write_sysfs()
Date: Tue, 11 Nov 2025 09:39:58 +0900
Message-ID: <20251111004530.136171040@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



