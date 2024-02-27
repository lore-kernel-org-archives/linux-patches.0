Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A188C78B61;
	Tue, 27 Feb 2024 14:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043409; cv=none; b=q8rNYCDzuvg6+wneMwzfqRbqgJfWpDvhNuBdfEh5hHmDNzn9V9zm4SMITAKl1J52n1FtQK/IuJjE6FR6oOubTHYXnhVIeKw6J1joizGKIwXIOkE1uMEvtXJNIqo+TLQPoW9tECZDkL/ulegbdvKMIUQuIzS5wnB4QPks+ugdSGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043409; c=relaxed/simple;
	bh=ZTVqOIxtOTqNJu27RlxU0ZYJxSQVNKeAHXCRC2H1lLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiLgA413jMT2bRJwmGN41Wd4XutSSb5jcGNEB9yhHqGBoWYlb7qDRp8Y1idu08b6QdWq8T1LZFAFqKy9v/7OliksslqQLP4c196jKND/5E3yBDnl6MalUEjBA0ipm+T98RfUo+dHoyL2vxtClBtgtD/qkO2ngFgHXjYaYnR+12A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+eAjhlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+eAjhlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D22EC433C7;
	Tue, 27 Feb 2024 14:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043409;
	bh=ZTVqOIxtOTqNJu27RlxU0ZYJxSQVNKeAHXCRC2H1lLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+eAjhlNx5V26j/t+MU3TjV4SU2vVsyHOGGf/vS1lfIEjEsJy2Q0lGh9cZiiQ8v6Y
	 JMjfZSLEnb4xtkXlpGRWvLAcf1EAjDIBlTUfhZFuEPVaEHGTIOgqBPpJWyQkrkPPr+
	 H4uJZrG40o9DnFINm6t1hmFcD/XkQAXtVnzDh06Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/195] hwmon: (coretemp) Enlarge per package core count limit
Date: Tue, 27 Feb 2024 14:25:31 +0100
Message-ID: <20240227131612.810854894@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 59344ad62822d..c0aa6bfa66b24 100644
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



