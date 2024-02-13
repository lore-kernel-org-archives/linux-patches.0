Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743CD5FF19;
	Tue, 13 Feb 2024 17:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845743; cv=none; b=rL4ljQooBXVtFcKLce5ZQlS4PvaPt79p/0P0OXkwgqyNAVeVucfJeXBCOTKWw3fAFWnxKpV6lgkLKBiwYxYRIXD9qL8J8Q6T3yd/xYmrLZQhTSoYjRVO2cJ9io3P/IWuvjtQHdP57LMgWe7Uk9lV+g6PEL1d1zdmM8j25t4g/Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845743; c=relaxed/simple;
	bh=xVw0g+wV7KN5RAJ8qFIfWI0qfKiKnXQSn8DCpr0ISSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B6FuxtUQhBmpfsc8tFtigOf/kz4oLQ6/ECxZIxPYg00lihlw2mEKbtDZ7SoSm3arhM9In+ARWnIA6TSHLyZbxFdaeZ/YulQ6Qf4rpeUZxAnaO2DZKdE2puAu4I6wlkypcNlHmyZXuiK6nTsn0VwvoSYWbKsf46ld8J2VCLmfDj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHX1cDQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHX1cDQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E3FC433F1;
	Tue, 13 Feb 2024 17:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845743;
	bh=xVw0g+wV7KN5RAJ8qFIfWI0qfKiKnXQSn8DCpr0ISSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHX1cDQxbrLuBfC9VWoB/t0AZWtDh5CX+0qxlTrfYd/cWXzz7mHR9fj+GN9MZg+WH
	 sPsKSVEUyMO4HbWuJhQwpuKRNVOnFLn6BEwP3QOjQOvKGd5+Pi0cybZqePYNP4jzFp
	 zP17H7hXp9LgKpezlKqd4t1skOf0A6K8ZrXMI9r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 044/124] hwmon: (coretemp) Fix out-of-bounds memory access
Date: Tue, 13 Feb 2024 18:21:06 +0100
Message-ID: <20240213171855.025006423@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 4e440abc894585a34c2904a32cd54af1742311b3 ]

Fix a bug that pdata->cpu_map[] is set before out-of-bounds check.
The problem might be triggered on systems with more than 128 cores per
package.

Fixes: 7108b80a542b ("hwmon/coretemp: Handle large core ID value")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240202092144.71180-2-rui.zhang@intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: fdaf0c8629d4 ("hwmon: (coretemp) Fix bogus core_id to attr name mapping")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index ba82d1e79c13..e78c76919111 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -509,18 +509,14 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
 	if (pkg_flag) {
 		attr_no = PKG_SYSFS_ATTR_NO;
 	} else {
-		index = ida_alloc(&pdata->ida, GFP_KERNEL);
+		index = ida_alloc_max(&pdata->ida, NUM_REAL_CORES - 1, GFP_KERNEL);
 		if (index < 0)
 			return index;
+
 		pdata->cpu_map[index] = topology_core_id(cpu);
 		attr_no = index + BASE_SYSFS_ATTR_NO;
 	}
 
-	if (attr_no > MAX_CORE_DATA - 1) {
-		err = -ERANGE;
-		goto ida_free;
-	}
-
 	tdata = init_temp_data(cpu, pkg_flag);
 	if (!tdata) {
 		err = -ENOMEM;
-- 
2.43.0



