Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AC66F074;
	Wed, 21 Feb 2024 13:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522996; cv=none; b=uz020dvxEWSGgipFPQKQbkYIYodROMLtsW8+gPCaDf0wXp3VAYG2lokpA2NF36PQEF6nuGy+DEx7NIn/bWfBvNSAMWmvzgxfJAHSX8RE4OudVRT7GiVtUaGyNMyGzDc/d+aXkFja02iroCVAfMUdX9xjPWVig1zen1sC6qcUq7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522996; c=relaxed/simple;
	bh=NY7/hAYZTl4f5LGAK0m+EikhY0rq5q2jxn4I/uoc1CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/jiKFPmvFICz1zRXcDHAx0dHQmOs/z8wt8K434S1K3B7yICQu7oR6cY2Ile8YNflDx3lJ4vV7ar5Tk73yYNctE6JZX4dLs72d2f0hk6iJ3KdhmhQbcYTh5Kt+jFheq/SoXU4h+rHxNeSKvgZw+OjKh33r3fPwsd2xB3ia0anOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LibYp0ee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LibYp0ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D554C43330;
	Wed, 21 Feb 2024 13:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522995;
	bh=NY7/hAYZTl4f5LGAK0m+EikhY0rq5q2jxn4I/uoc1CY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LibYp0eeAemyvg+YR2M9QfrEXKF6bRc3IPZyHRRBRzjFJeqPK0mN2m8TrDBvr+CZR
	 iMjPSXpPK8WUqb5UPmlq8foQjAvduD+LWNA5Dx61XwYMPULMC6FnfuPhm5YUeYLcMg
	 YxWs6xMY1lq3FSyLRdpKBi+D85A7z0hvwAWG0vOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 311/476] hwmon: (coretemp) Fix out-of-bounds memory access
Date: Wed, 21 Feb 2024 14:06:02 +0100
Message-ID: <20240221130019.521204233@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5b2057ce5a59..7f6615ef8c88 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -467,18 +467,14 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
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



