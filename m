Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8243A291;
	Fri, 21 Nov 2025 13:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732396; cv=none; b=sBqMOWjbHfyIH9uFAH2MR/Fvc7f1Rymg3Ar+SjGIZtR3WuipBiLcbD7I4At8jIJhPG0OOuFVL1vnXFqMWNRaQVcIv80o9JDcdJm4E+g6irQYBRKs1RD4uPY1Gw1kvQN/+V8J5KeoFJBJWBU+1FFAM4udz+UIlVD/mBTaXdn9eLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732396; c=relaxed/simple;
	bh=yQ3M9nvof/QIKOHdCuwTsMCsH3tk6olO8bJYvs2CSns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKKd9+3r9u6HAj+VX8bhUrQJ8x4YF9Sq2LQjYh7lJuP5f/F38mKeSOS62sEuTMa6CE+KD4ka6MNjQROkH8qRPpoo9GCjQwjUtSJToEqoKuGMLc+tN7VJQDUGuMevAWw4n6R+OSmEFCSPnCg4fbWSHazJQXc1jAKm7NvSepj2IBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMDg4WcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMDg4WcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972D1C4CEF1;
	Fri, 21 Nov 2025 13:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732396;
	bh=yQ3M9nvof/QIKOHdCuwTsMCsH3tk6olO8bJYvs2CSns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMDg4WcUkO+g5AkU/reNPmbNZ8hNutTiV0CaP6eVL/CpEbqXx+6cIggURukgcjE8O
	 JpekBbrcCLIyKMjlh9nZzWoaZdBA7lWnBT4Ktv4WxaIiLIP+jteLhK1oREORV6WqRZ
	 LrNyMhr+HzbMnIdwo1DPDU2LZE3YX3x3v7cHkryg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/529] tools/cpupower: Fix incorrect size in cpuidle_state_disable()
Date: Fri, 21 Nov 2025 14:06:46 +0100
Message-ID: <20251121130234.832744919@linuxfoundation.org>
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



