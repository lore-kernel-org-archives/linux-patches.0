Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF56A258EF6;
	Tue, 11 Nov 2025 01:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823048; cv=none; b=CX2LfxcSEBfS3w96enDcETurwnY74cYkMoiwFxRkmmRYDzcVvKE0vNAXs0iXeLZSqe1bwf58OTMS++UMy87BSWBv8Ltv5BQVRPmV1SujEKPiiQhU0P4+SiBXudznp74y5WpSMfZyUoluVAiqh5kfsUmKqQhbBiznC1iwqpjbJbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823048; c=relaxed/simple;
	bh=GDuCKFP6H5YHx6iyK/mfCKiVvZV+2lIA8m9nyrnVUV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kotbzK6wxBtau1Nej8g+0BJca6sPu+9WCJqmDmofl/PRVhOj/l6+iUdINJjsiEQYaMxxTEjHo29u5IbhBSEgbjXEVtwsgv2yn6Yibyz4hNmZc2lhHJBoEQqSX0sYR9FT3XghkhQB17VYLlU6j66jlfo53ZFK5AB685dPdpBae2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIFSjCSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIFSjCSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4CAC19422;
	Tue, 11 Nov 2025 01:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823047;
	bh=GDuCKFP6H5YHx6iyK/mfCKiVvZV+2lIA8m9nyrnVUV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QIFSjCSrdoszphiWDr7fpYrJuacAuMxgZM5wjaw1NzPo7Vw7QZGp+qBg2BVpDhH0w
	 Zd6qhqq2RIZBhpudZKWjkcxjwuJxff+1bzDSHudLUTqmkYKl1m5Rs7glt4MsccbPWB
	 QgbObjKDAROVy+LZMlXzfqSMA2iijlp8YN6frbxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/565] tools/cpupower: Fix incorrect size in cpuidle_state_disable()
Date: Tue, 11 Nov 2025 09:40:17 +0900
Message-ID: <20251111004530.557949992@linuxfoundation.org>
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
index 0ecac009273ce..f2c1139adf716 100644
--- a/tools/power/cpupower/lib/cpuidle.c
+++ b/tools/power/cpupower/lib/cpuidle.c
@@ -233,6 +233,7 @@ int cpuidle_state_disable(unsigned int cpu,
 {
 	char value[SYSFS_PATH_MAX];
 	int bytes_written;
+	int len;
 
 	if (cpuidle_state_count(cpu) <= idlestate)
 		return -1;
@@ -241,10 +242,10 @@ int cpuidle_state_disable(unsigned int cpu,
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



