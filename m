Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8B713DBBC;
	Tue, 27 Feb 2024 14:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044139; cv=none; b=j/I+lbjG82hD5T/MLgH7II4MDOkVVamnjf2mF94o1NhQ1NKH8j/wD85P5lGPZWE6FXjFI9aw06PwUhPkuYla+SsnaeNTIklA2xqTKiiMwEEDskxvVOz3FPlIVPrlEC4k3PQIyavTvAlp86fKNuTfD/+NVdTOX7QPmaLcBL9rJBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044139; c=relaxed/simple;
	bh=iJJ/2oQAJNxzBO3TTUbUbIZuxlke6LTJUpGwIFS8DC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXTLpCUN/DVgqfwQe5xGndo8+xw24WkXIko/x68kvdMV/LgEUqr+Hz6kHOqp7CrKyEP76Zhojp14PF4nXQ8brONUXdmBTgmtadXXBSY8F5owT8WZEksou5cKOHTyfi0FgB4GGVLmBm7SeBMZ2hNCQVHVUc8AdFjNuORTjhtp/rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsZDWwcB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsZDWwcB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0718C433F1;
	Tue, 27 Feb 2024 14:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044139;
	bh=iJJ/2oQAJNxzBO3TTUbUbIZuxlke6LTJUpGwIFS8DC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsZDWwcBBdQ2d+VBvJIrGjDTrA1/Ushw1npCZGGyRzj9WcuOfffUNExi+cPsKqik6
	 94yPG73FUkjDtYVGH/0pPkXjT8B7N3uBOs4wEQaDwLfyZXlqbPip+KiMn/zNMclfi1
	 t+CNStE7QiUkMIKheooRO4OKJ1w3mndQ4zCjhPWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/122] hwmon: (coretemp) Enlarge per package core count limit
Date: Tue, 27 Feb 2024 14:26:39 +0100
Message-ID: <20240227131559.953796775@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d67d972d18aa2..cbe2f874b5e2f 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -40,7 +40,7 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 
 #define PKG_SYSFS_ATTR_NO	1	/* Sysfs attribute for package temp */
 #define BASE_SYSFS_ATTR_NO	2	/* Sysfs Base attr no for coretemp */
-#define NUM_REAL_CORES		128	/* Number of Real cores per cpu */
+#define NUM_REAL_CORES		512	/* Number of Real cores per cpu */
 #define CORETEMP_NAME_LENGTH	28	/* String Length of attrs */
 #define MAX_CORE_ATTRS		4	/* Maximum no of basic attrs */
 #define TOTAL_ATTRS		(MAX_CORE_ATTRS + 1)
-- 
2.43.0



