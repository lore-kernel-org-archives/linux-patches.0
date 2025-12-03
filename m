Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB9B23B60A;
	Wed,  3 Dec 2025 16:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779002; cv=none; b=L/5BBri2KNwr2pWM5G8nUmIvXaBPXdqTF7E/48tR9grGRoaMryuegfjixM8PfEFQV8xjRGyMgvImzPGJ8iVPMcLnIU6oCmLBe8Wh6w+OSluQXH3PLszaxaaLX4ECz1SXESqeSREUw2qUfD065x/nl+zUpCTrbpPwxodx7VZytso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779002; c=relaxed/simple;
	bh=ynkurR+NqJiMKABapQpOwQ5fvtJYReIHMKDJnQm76Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHAJmmW2BmI9hgxg3/8f3p2+Co7mZhx9y5nu4l8qycKrY5qh09LA3He9JEaF5nHXatG/rLTS9jTSyeNM6S5bdliAOz/LbDI2vc49iJKl5orwNFEpBucVrFEZgfJFR58Nisu4aoIXEhh8AuWM6tF9CKUVjkVR5BfR6ZITO5bc8cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wegsC9tz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wegsC9tz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF1AC4CEF5;
	Wed,  3 Dec 2025 16:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779002;
	bh=ynkurR+NqJiMKABapQpOwQ5fvtJYReIHMKDJnQm76Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wegsC9tzJ7NdLCyH0Tnbyw1/Nay2qZdGA1lteDSaW0DXYexcI00bxPOMEZubYe8Fk
	 Vz33DIUBIa1OZ4TBeg2hGgf8bzqgfKN+zrjWaQjumdpBphkT/g68tM+LZW9En5m9PU
	 9mccF8Krt08lpk330N+Jencq6kAxE7RgyXVgAkDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/568] tools/cpupower: Fix incorrect size in cpuidle_state_disable()
Date: Wed,  3 Dec 2025 16:22:07 +0100
Message-ID: <20251203152445.307702179@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 23199d2aa6dcaf6dd2da772f93d2c94317d71459 ]

Fix incorrect size parameter passed to cpuidle_state_write_file() in
cpuidle_state_disable().

The function was incorrectly using sizeof(disable) which returns the
size of the unsigned int variable (4 bytes) instead of the actual
length of the string stored in the 'value' buffer.

Since 'value' is populated with snprintf() to contain the string
representation of the disable value, we should use the length
returned by snprintf() to get the correct string length for
writing to the sysfs file.

This ensures the correct number of bytes is written to the cpuidle
state disable file in sysfs.

Link: https://lore.kernel.org/r/20250917050820.1785377-1-kaushlendra.kumar@intel.com
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/cpupower/lib/cpuidle.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/power/cpupower/lib/cpuidle.c b/tools/power/cpupower/lib/cpuidle.c
index 479c5971aa6da..c15d0de12357f 100644
--- a/tools/power/cpupower/lib/cpuidle.c
+++ b/tools/power/cpupower/lib/cpuidle.c
@@ -231,6 +231,7 @@ int cpuidle_state_disable(unsigned int cpu,
 {
 	char value[SYSFS_PATH_MAX];
 	int bytes_written;
+	int len;
 
 	if (cpuidle_state_count(cpu) <= idlestate)
 		return -1;
@@ -239,10 +240,10 @@ int cpuidle_state_disable(unsigned int cpu,
 				 idlestate_value_files[IDLESTATE_DISABLE]))
 		return -2;
 
-	snprintf(value, SYSFS_PATH_MAX, "%u", disable);
+	len = snprintf(value, SYSFS_PATH_MAX, "%u", disable);
 
 	bytes_written = cpuidle_state_write_file(cpu, idlestate, "disable",
-						   value, sizeof(disable));
+						   value, len);
 	if (bytes_written)
 		return 0;
 	return -3;
-- 
2.51.0



