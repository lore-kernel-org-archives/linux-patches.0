Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC8B6FAF;
	Tue,  5 Dec 2023 03:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMddeXP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9557C433C8;
	Tue,  5 Dec 2023 03:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746896;
	bh=1df9k+/0Z7ORTLHjfloUrcSM3V6ZbuY98JRPgbgXC5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMddeXP2lzC0DOe0dqK/L1vPDd1FRG6Y1vKRAZaVBmgx7wLIihCqiFomLzEWtcxJ4
	 niDQ+uzhGq9ww4Hbr3WkdIZ1mnqGFGeYheBlvtf1YutBDqN0fxDy2b3FJavB0gTULj
	 Q6kOPQFEGU3nOOcbwMiaoJMVDCkP9xMSCCEFwU/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 59/71] mtd: cfi_cmdset_0001: Support the absence of protection registers
Date: Tue,  5 Dec 2023 12:16:57 +0900
Message-ID: <20231205031521.307663963@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
User-Agent: quilt/0.67
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

[ Upstream commit b359ed5184aebf9d987e54abc5dae7ac03ed29ae ]

The flash controller implemented by the Arm Base platform behaves like
the Intel StrataFlash J3 device, but omits several features. In
particular it doesn't implement a protection register, so "Number of
Protection register fields" in the Primary Vendor-Specific Extended
Query, is 0.

The Intel StrataFlash J3 datasheet only lists 1 as a valid value for
NumProtectionFields. It describes the field as:

	"Number of Protection register fields in JEDEC ID space.
	“00h,” indicates that 256 protection bytes are available"

While a value of 0 may arguably not be architecturally valid, the
driver's current behavior is certainly wrong: if NumProtectionFields is
0, read_pri_intelext() adds a negative value to the unsigned extra_size,
and ends up in an infinite loop.

Fix it by ignoring a NumProtectionFields of 0.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Tested-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Stable-dep-of: 565fe150624e ("mtd: cfi_cmdset_0001: Byte swap OTP info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/chips/cfi_cmdset_0001.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index 6e8e7b1bb34b6..e5cf4911a714a 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -420,8 +420,9 @@ read_pri_intelext(struct map_info *map, __u16 adr)
 		extra_size = 0;
 
 		/* Protection Register info */
-		extra_size += (extp->NumProtectionFields - 1) *
-			      sizeof(struct cfi_intelext_otpinfo);
+		if (extp->NumProtectionFields)
+			extra_size += (extp->NumProtectionFields - 1) *
+				      sizeof(struct cfi_intelext_otpinfo);
 	}
 
 	if (extp->MinorVersion >= '1') {
@@ -695,14 +696,16 @@ static int cfi_intelext_partition_fixup(struct mtd_info *mtd,
 	 */
 	if (extp && extp->MajorVersion == '1' && extp->MinorVersion >= '3'
 	    && extp->FeatureSupport & (1 << 9)) {
+		int offs = 0;
 		struct cfi_private *newcfi;
 		struct flchip *chip;
 		struct flchip_shared *shared;
-		int offs, numregions, numparts, partshift, numvirtchips, i, j;
+		int numregions, numparts, partshift, numvirtchips, i, j;
 
 		/* Protection Register info */
-		offs = (extp->NumProtectionFields - 1) *
-		       sizeof(struct cfi_intelext_otpinfo);
+		if (extp->NumProtectionFields)
+			offs = (extp->NumProtectionFields - 1) *
+			       sizeof(struct cfi_intelext_otpinfo);
 
 		/* Burst Read info */
 		offs += extp->extra[offs+1]+2;
-- 
2.42.0



