Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E9413B295;
	Tue, 27 Feb 2024 13:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040791; cv=none; b=LXGiVT9fYjTm1eH2Y1XDuOW+SWk6YtHKPBAL3tPK4SWITgOvueCi4xrOs9rEfCjOBli9hB9RU/KjMqDjeUjSva6OaTnaQwps6ZjzEoakHx0jUjKFHkrA53Gi8wJDwQKrBka0VO52ZNUmov+28wPhCSGNfSyKojLrAC72YaAnQoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040791; c=relaxed/simple;
	bh=M8lt0V/lOiAAjG8R0udZ4Uu/b68DpS3lLQuN3XpVAfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yvkm0HAeg9sD5inZDO1wdsKvO1gRgk2aGQ574jzXnOXQVZTY544FMYy/NFi/3khvwVpDy7/dGpZdE7abkMnidEwBg4HpnjvZUxGhrnS6w2q919K14x2WTinlRaTBfi+pAxtIRqaE/UVbz4D41BBXJsTwJBluWTxEFvaFpswszOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ENlnFdoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ENlnFdoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E02FC433F1;
	Tue, 27 Feb 2024 13:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040790;
	bh=M8lt0V/lOiAAjG8R0udZ4Uu/b68DpS3lLQuN3XpVAfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENlnFdoHiFdAJpnLW7Vuj3K/wgUQvT13Z+EOo7eckAi711tmILQ/6NFxvczGFUuNr
	 tpL3AkGn5Au6lao6FdVyoa98FMVT71j2cDVHtdt7kSAUfFLeS6c15A+ZxyB9azMkh3
	 FZ2O36niahH5aZZU7rpJa2GEPhuSZNzg3gmoyz0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 109/334] hwmon: (coretemp) Enlarge per package core count limit
Date: Tue, 27 Feb 2024 14:19:27 +0100
Message-ID: <20240227131633.996772536@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

[ Upstream commit 34cf8c657cf0365791cdc658ddbca9cc907726ce ]

Currently, coretemp driver supports only 128 cores per package.
This loses some core temperature information on systems that have more
than 128 cores per package.
 [   58.685033] coretemp coretemp.0: Adding Core 128 failed
 [   58.692009] coretemp coretemp.0: Adding Core 129 failed
 ...

Enlarge the limitation to 512 because there are platforms with more than
256 cores per package.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Link: https://lore.kernel.org/r/20240202092144.71180-4-rui.zhang@intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 95f4c0b00b2d8..b8fc8d1ef20df 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -41,7 +41,7 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 
 #define PKG_SYSFS_ATTR_NO	1	/* Sysfs attribute for package temp */
 #define BASE_SYSFS_ATTR_NO	2	/* Sysfs Base attr no for coretemp */
-#define NUM_REAL_CORES		128	/* Number of Real cores per cpu */
+#define NUM_REAL_CORES		512	/* Number of Real cores per cpu */
 #define CORETEMP_NAME_LENGTH	28	/* String Length of attrs */
 #define MAX_CORE_ATTRS		4	/* Maximum no of basic attrs */
 #define TOTAL_ATTRS		(MAX_CORE_ATTRS + 1)
-- 
2.43.0



