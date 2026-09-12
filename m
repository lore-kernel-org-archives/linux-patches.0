Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDBF2C1586;
	Sat, 12 Sep 2026 11:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211894; cv=none; b=pc7FpL0XT0zmqC5PmGNC2kDLETGkTi+9K66EaPQG25sS75CxT7WCkqLrX1QJVOzisTL9+M71bjzp+DpLiK8waDhVOv/ZMMiZ61hkpwhv/EMwGzipwbozo0ggTuYUtB91AQqE5t0k5AwRpOkHHcdtoiHKO/R39RjQwAxH1gq6TPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211894; c=relaxed/simple;
	bh=xJZBcP1Uy2yfTgNyDcbgEzvfnD9agnRnkm0X2VRljAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dDNeyc12v0Us/KxUiIu2dxVuWNQIhvW1cAyl+q3jYEeGppEoPWrPkica6D5FhAVIUzbfGyc7F96V6u22hXmUfArzLgoB1CH/oLG/D5B0LQ/+z73gjwG6umCFMP9deM33tod2aymjJr5nddw2fE2B6tUMqMMkcZ8yd+N8FrPuOME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2yigl27; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2yigl27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCC41F00893;
	Sat, 12 Sep 2026 11:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211893;
	bh=ANkgfaMQOSCcSLC8GK4/CyQ3ggIveP1ayQ/cCavBVDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J2yigl273J7DDXubdeRJkItRGaToqT7RTr47VdTuTwE9y576p3MBOCWPBSrIaQRjI
	 Jx3xtV8QzPA8ihGaiGIszdl+lKi00puebjb/87rZ/0q1sJhW8H5L2g5uPlfgk3wCh0
	 n27QpbmAe1dm2AkY1KechtudX/u5VNglHpg414yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Kulikov <nikolayof23@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1288/1518] mlxbf-bootctl: fix the build error with FIELD_PREP()
Date: Sat, 12 Sep 2026 08:57:37 +0200
Message-ID: <20260912065652.650273921@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Kulikov <nikolayof23@gmail.com>

[ Upstream commit 46b14c6f11f558362391e308f4f184ee867ef58f ]

rsh_log_store() calls the FIELD_PREP() macro without including the
required header file, resulting a build error:

  CC      drivers/platform/mellanox/mlxbf-bootctl.o
drivers/platform/mellanox/mlxbf-bootctl.c: In function ‘rsh_log_store’:
drivers/platform/mellanox/mlxbf-bootctl.c:429:16: error: implicit declaration of function ‘FIELD_PREP’ [-Wimplicit-function-declaration]
  429 |         data = FIELD_PREP(MLXBF_RSH_LOG_TYPE_MASK, MLXBF_RSH_LOG_TYPE_MSG);
      |                ^~~~~~~~~~

Fix this by including the <linux/bitfield.h> file.

Fixes: e9d1b2d0f7d0 ("mlxbf-bootctl: Add sysfs file for BlueField boot log")
Signed-off-by: Nikolay Kulikov <nikolayof23@gmail.com>
Link: https://patch.msgid.link/20260810-mellanox_fix_implicit_declaration-v1-1-352e647b8f28@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-bootctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/mellanox/mlxbf-bootctl.c b/drivers/platform/mellanox/mlxbf-bootctl.c
index f67c7f56ab2b7..9ddc7fa1a9732 100644
--- a/drivers/platform/mellanox/mlxbf-bootctl.c
+++ b/drivers/platform/mellanox/mlxbf-bootctl.c
@@ -10,6 +10,7 @@
 
 #include <linux/acpi.h>
 #include <linux/arm-smccc.h>
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/if_ether.h>
 #include <linux/iopoll.h>
-- 
2.53.0



