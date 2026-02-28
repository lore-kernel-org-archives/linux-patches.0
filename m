Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDA144B686;
	Sat, 28 Feb 2026 17:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301281; cv=none; b=Zw8E+nbSrshq8cFd1lrfKtAALERMBPPh7vDXtff5C64JlSQnVPEV44P99nsGqL6lvf3tt/BKqCGv2ttDWzYX4C3OMpy9js/qaTEOPkPG3qSbl3+vD1ocndIYaDHicxPPq2ynINkKZrT5wjSs9hl1MkXFuHV6oFwtMkoM04x0JOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301281; c=relaxed/simple;
	bh=gFiBiJN5gHtn8/5nUyXBJeb3LWUklhye6VF7SCOesm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8Rz69vmnczIXWe01/d2BzE9YKl1qnXJ2pkiJcWXETHJC5aFazSN6HVBPBbUVkUijy8Q1hva1cFLxo6CvN1WdkUGjNey/mnULdhsd9aVYGWRJGDfxqF9llpwXrYMatQHFuA+qsVnWTdl7hMIqY/WYCqzdrbYK1BbgTlQ4IYynic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z6x73Zz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z6x73Zz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17F2C19424;
	Sat, 28 Feb 2026 17:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301281;
	bh=gFiBiJN5gHtn8/5nUyXBJeb3LWUklhye6VF7SCOesm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6x73Zz8MHMz5nKTRFVV2p/LixENzvb8lhwrMEbdgUexOp1+/WL3wrLQHTEgVthVW
	 +wWQSUZdSpixhvnLjtajfF/SxDiT9DQ4PtYRsmhTBrGo/4dl0zRw1O2Ct6zHvpGMwF
	 fFMx6o/s33WblxBPw4CdO47bAfRBqowQa8pbBCGhAxOZgOld/pF8hr/G4dGMRT71yi
	 Ei/KibbB8C5HXevt6iCCj6Ax5ErHcE4Re/nhHLcB1g9VUVBhvLvtZR7TXrqnTh3C/3
	 1KVAhEEEkpgdtS2ODv/pTCgpptijd6/nUwqecvd90BFKbesZbleTfEhPz9R2Uxd6cJ
	 QcmrHrwMAk0Ag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	stable@vger.kernel.org,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 465/752] fpga: dfl: use subsys_initcall to allow built-in drivers to be added
Date: Sat, 28 Feb 2026 12:42:56 -0500
Message-ID: <20260228174750.1542406-465-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit 267f53140c9d0bf270bbe0148082e9b8e5011273 ]

The dfl code adds a bus. If it is built-in and there is a built-in driver
as well, the dfl module_init may be called after the driver module_init,
leading to a failure to register the driver as the bus has not been added
yet.

Use subsys_initcall, which guarantees it will be called before the drivers
init code.

Without the fix, we see failures like this:

[    0.479475] Driver 'intel-m10-bmc' was unable to register with bus_type 'dfl' because the bus was not initialized.

Cc: stable@vger.kernel.org
Fixes: 9ba3a0aa09fe ("fpga: dfl: create a dfl bus type to support DFL devices")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Link: https://lore.kernel.org/r/20251215-dfl_subsys-v1-1-21807bad6b10@igalia.com
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/dfl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fpga/dfl.c b/drivers/fpga/dfl.c
index 7022657243c0a..449c3a082e232 100644
--- a/drivers/fpga/dfl.c
+++ b/drivers/fpga/dfl.c
@@ -2018,7 +2018,7 @@ static void __exit dfl_fpga_exit(void)
 	bus_unregister(&dfl_bus_type);
 }
 
-module_init(dfl_fpga_init);
+subsys_initcall(dfl_fpga_init);
 module_exit(dfl_fpga_exit);
 
 MODULE_DESCRIPTION("FPGA Device Feature List (DFL) Support");
-- 
2.51.0

