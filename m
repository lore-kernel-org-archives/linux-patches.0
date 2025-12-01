Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97C0253958;
	Mon,  1 Dec 2025 11:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588425; cv=none; b=qOzXvwuXwvNxVW2NbcICuGeRuZHeULnN6MM0GnWaFvVnv+uOrnjJAfS/5k///qTfiCBOOLFuWVxHL314GhJ4737Dmwwhpyyfv4wW88iqbZ7abfgSNFYtVCg2UVsrBKaK84su8PsJ2X0SBxK8M0QtP16SJa7lwYeW9s5nb+Fnro4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588425; c=relaxed/simple;
	bh=wQPhro2GLEYMjOHrC/KCtxb5Q/R4Tku+KxrJZsgeFSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5XllLv/kPJUT79de7yfmX3yLwQ3VsC4G0USuDVpHjy4/mUcYQddMaqK9g5oPq6uiYG8KNg01ODCGEU5P1iL24RaAsrNhpom9K7FrSTfGPBBJRNqdJN1uIuVXEGKpMriKkK2xFV0lmdLxvz/i3EX9EWLuCKPjZUGXxj5NCflHvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fO1bSSPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fO1bSSPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701CDC4CEF1;
	Mon,  1 Dec 2025 11:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588424;
	bh=wQPhro2GLEYMjOHrC/KCtxb5Q/R4Tku+KxrJZsgeFSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fO1bSSPVgaVa6x49rWQ1UdCmdf6FHSj/bXjhC6TL+z5hyf/TAMhjQZ8yQJYiTyv0v
	 H3yWozhLp4ofJdqLO+oEXLzx2tuGqRYKN0EI+8IcEkKBokXv2yo3nnLZ+NXp7j+Qjh
	 3Bd8LBN8tudLnuzTNkUrAeP2oFjGM/vJDsaPPV3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/187] tools/cpupower: Fix incorrect size in cpuidle_state_disable()
Date: Mon,  1 Dec 2025 12:22:30 +0100
Message-ID: <20251201112242.768760639@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



