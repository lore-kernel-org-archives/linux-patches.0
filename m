Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B066A7BB12;
	Wed, 21 Feb 2024 13:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521579; cv=none; b=TBcvMvzHxqCfDgOTIzQfrOSIH+LRJCr750CXJ/sFLtndoRJ5IShbGid648VfunObhMJwTeg8Zc8MIu+yaxdIQZJm934MXyPftIzAe9sDGrVsVWgAozsmR/aA5V1AZ1LZCqZ1Ja5WhNHfWIiff0iZwvLvV7MjMluJu4MKqUWbenM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521579; c=relaxed/simple;
	bh=Ih0qyMy0n6m6BdzQ8sd7zz2Z/9jrsC9wa9wGvFjIVaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htyy8KS341WRluCowP/3pjJnGX521sRTnKEObN5tCiUx/Ru41eRemkPcn3v0FklGe8jeeoIGmaOzlLgZM1C75YrofuoWl8LVoYCGgCcOx3fzKjiklAByHm7Xs28SPGB8q49CXxypBrbvocl+U2l+0SePwDDThutiwB+1WcTniAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMHaLnEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMHaLnEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9DCC433F1;
	Wed, 21 Feb 2024 13:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521579;
	bh=Ih0qyMy0n6m6BdzQ8sd7zz2Z/9jrsC9wa9wGvFjIVaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMHaLnEkSWGw7le+H4+I9nHuCT/+zcKgJtmLRP9xn6ezXY6OOwmsqE0caCSQ6FdfX
	 WXmrQAElzNoxC0yUVvfDNl7o52C9oaAGC9PhvlzmoesXBwbWKggDRxAXS7Ao9+Ho+W
	 On5H3AP5Obho0lGomnhdhk7g3en6DJcnbJdt/kzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 150/202] hwmon: (coretemp) Fix out-of-bounds memory access
Date: Wed, 21 Feb 2024 14:07:31 +0100
Message-ID: <20240221125936.546066126@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 33371f7a4c0f..6832569c9bac 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -480,18 +480,14 @@ static int create_core_data(struct platform_device *pdev, unsigned int cpu,
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



