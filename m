Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADFE1A00FF;
	Thu, 15 Aug 2024 13:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729475; cv=none; b=DcEblZypuxiyaLEZJico8DGdU05tZWv9QPOpreHA1a8Yta5E2soDT0tWi0ZzYnjCQh/PPhmyqKx3JVF4sjzWn34zyWOiHfntLJILmrXVzW5Zo8uBYvYufASIRpeV7zsKCydcCVdNAEaOHtnKmdnLjOmGALapNg5sOt4WlBSVe3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729475; c=relaxed/simple;
	bh=EFPmrhRQYEQbx8kBh6ZrHxLTyrNvOmJnc6sphUYVRS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgXkRrIYJpLn3omwQNkFtzKO+5FNFrO+jDiAS9BZmA5DnOoWmGQsAR06iXsxX7xxQSD7VjwlDG6lfRwB74ZEC23s1kGAJGdXNR6DwkMeL/RKnOMNwJ/qa/9BcNxhPvjINV3TECjGU7DEdv7DC7QRIbIkrlT8swmfrUaMGj+VDmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jr6QM0ip; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jr6QM0ip"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60BCC32786;
	Thu, 15 Aug 2024 13:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729475;
	bh=EFPmrhRQYEQbx8kBh6ZrHxLTyrNvOmJnc6sphUYVRS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jr6QM0ippJsEf5uNKTuzdxTgdDmexC2Qi5BaD0MsxcrWI5+2NSTr2S+Qi0CU9tD49
	 i5SaLDWqSuIJasKe30g2T4yDthyNMVg56aIu2GpZvFrl0MNTQJNaGUnQ9+8MkNTedI
	 hTl9MjfEmgGL30A426aTmj8z9YUCAILBeyi1FUio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/484] mfd: rsmu: Split core code into separate module
Date: Thu, 15 Aug 2024 15:19:28 +0200
Message-ID: <20240815131945.542416830@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c879a8c39dd55e7fabdd8d13341f7bc5200db377 ]

Linking a file into two modules can have unintended side-effects
and produces a W=1 warning:

scripts/Makefile.build:236: drivers/mfd/Makefile: rsmu_core.o is added to multiple modules: rsmu-i2c rsmu-spi

Make this one a separate module instead.

Fixes: a1867f85e06e ("mfd: Add Renesas Synchronization Management Unit (SMU) support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240529094856.1869543-1-arnd@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Makefile    | 6 ++----
 drivers/mfd/rsmu_core.c | 2 ++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 2ba6646e874cd..aa0d439142691 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -274,7 +274,5 @@ obj-$(CONFIG_MFD_INTEL_M10_BMC)   += intel-m10-bmc.o
 obj-$(CONFIG_MFD_ATC260X)	+= atc260x-core.o
 obj-$(CONFIG_MFD_ATC260X_I2C)	+= atc260x-i2c.o
 
-rsmu-i2c-objs			:= rsmu_core.o rsmu_i2c.o
-rsmu-spi-objs			:= rsmu_core.o rsmu_spi.o
-obj-$(CONFIG_MFD_RSMU_I2C)	+= rsmu-i2c.o
-obj-$(CONFIG_MFD_RSMU_SPI)	+= rsmu-spi.o
+obj-$(CONFIG_MFD_RSMU_I2C)	+= rsmu_i2c.o rsmu_core.o
+obj-$(CONFIG_MFD_RSMU_SPI)	+= rsmu_spi.o rsmu_core.o
diff --git a/drivers/mfd/rsmu_core.c b/drivers/mfd/rsmu_core.c
index 29437fd0bd5bf..fd04a6e5dfa31 100644
--- a/drivers/mfd/rsmu_core.c
+++ b/drivers/mfd/rsmu_core.c
@@ -78,11 +78,13 @@ int rsmu_core_init(struct rsmu_ddata *rsmu)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(rsmu_core_init);
 
 void rsmu_core_exit(struct rsmu_ddata *rsmu)
 {
 	mutex_destroy(&rsmu->lock);
 }
+EXPORT_SYMBOL_GPL(rsmu_core_exit);
 
 MODULE_DESCRIPTION("Renesas SMU core driver");
 MODULE_LICENSE("GPL");
-- 
2.43.0



