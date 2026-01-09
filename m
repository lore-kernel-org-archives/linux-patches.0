Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B7233ADB8;
	Fri,  9 Jan 2026 11:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959690; cv=none; b=CvWbPRv1nYJMjuenYTa+WZR0lE6zGgYKPEiJ5kSuBgajvjJp/tJjqcoS/EcaF4NdeIHNQAu1gzssONYeRUtOVx6jm8YDWy6nTWtt+NZy/Uoan0bOVjEKNhqqUdo4lHcdwHjFBYD2y8ErPS0xs44fE2olBZL6frNY/iiEgmd0YF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959690; c=relaxed/simple;
	bh=zxpfWaS3VGQis7IXZ0z/Boxh3i3pQibWKIkXacUwPqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LszMS4G5bS3gxmgEei7MzttSvLKxeKUqBVL9w+5HBlfzpwgsigHj3tRtQUKY6SXoU48eERdggmUOGeSi/uhtUlXvBkgRPqH3i61aYjRc8KBMVYXZPhh1FAmvzxvRGJY+P5ptTmTTx9uw/w0ra5266XRhcEsdmxOrULVYksFB3s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xeTi21IY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xeTi21IY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753F2C4CEF1;
	Fri,  9 Jan 2026 11:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959689;
	bh=zxpfWaS3VGQis7IXZ0z/Boxh3i3pQibWKIkXacUwPqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xeTi21IYWyHDauUJVJkZTqQxTUnlqfc1eFDbr6YHvEp/2pAVc5t6K3e0C4XcV9DXz
	 idtd0OoAFJ+jlTc96cPAL/kH5+2L1cY8vHFrRQXvq0MmcaxIx5/v+2hgf2w+mPTA2s
	 WSL9JC7B2n7Ky8oVYR53K6J5MjklhUe117/4fXog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/737] cpufreq/amd-pstate: Call cppc_set_auto_sel() only for online CPUs
Date: Fri,  9 Jan 2026 12:34:38 +0100
Message-ID: <20260109112139.229173623@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

[ Upstream commit bb31fef0d03ed17d587b40e3458786be408fb9df ]

amd_pstate_change_mode_without_dvr_change() calls cppc_set_auto_sel()
for all the present CPUs.

However, this callpath eventually calls cppc_set_reg_val() which
accesses the per-cpu cpc_desc_ptr object. This object is initialized
only for online CPUs via acpi_soft_cpu_online() -->
__acpi_processor_start() --> acpi_cppc_processor_probe().

Hence, restrict calling cppc_set_auto_sel() to only the online CPUs.

Fixes: 3ca7bc818d8c ("cpufreq: amd-pstate: Add guided mode control support via sysfs")
Suggested-by: Mario Limonciello (AMD) (kernel.org) <superm1@kernel.org>
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index a64baa97e3583..7e7fa04188cf6 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1100,7 +1100,7 @@ static int amd_pstate_change_mode_without_dvr_change(int mode)
 	if (boot_cpu_has(X86_FEATURE_CPPC) || cppc_state == AMD_PSTATE_ACTIVE)
 		return 0;
 
-	for_each_present_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		cppc_set_auto_sel(cpu, (cppc_state == AMD_PSTATE_PASSIVE) ? 0 : 1);
 	}
 
-- 
2.51.0



