Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C35047127D;
	Tue, 21 Jul 2026 18:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657927; cv=none; b=atosRuucaU2ly0Iog+jccTTCwjbytuxzIM2OmJH0+0ctLS12VQBvTUaCsn25S1SBIFBCxcnc7xvjHCezcKTVzqeVnYjOk4Q66hATNHerkJrJFr8lJ89sIeXOHD81H5z5bmo52a4lRtiC9ODS8BTnS3Z0xkKWXvjErdOjjF13vwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657927; c=relaxed/simple;
	bh=ZYH7e1GDfE3G/rGcU4/f6rTm2ie+qXqyhzZTwB/p9GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SV/IvU8QHNQc+Rqg2JWTKpBw4F2ijy5/kl89Z09gs7keFV3+tq9Fuuhl/nSqWxlMaOVGdeK+ToOwugYC1X1kdzeWaGNWmv+z5PrMeq9dOJdA+cR321eZeZJrcH4szW2WPEmpAZEglQiFN4QanKlFZCVRhk/Vu9uoYHX52FPwhkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezfVV7tV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezfVV7tV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E4D1F000E9;
	Tue, 21 Jul 2026 18:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657926;
	bh=UXr0dzDs6jYV/kVbh9ZUFdK6TBnwwQeE4XwdJCJ8Mpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ezfVV7tVW+QSEKu+iUnUb+YCVaahSwXKgIctzxQCl1B+lzZxVCMOV80yOsTEyNdw/
	 zHYRvMsLxzEKW+QAjP3fl+rqBTM26a44AXen/s5SPmmJfKIGh9JJKnqXH8gaKBLrov
	 MoYrt4w1nuYqVRO2zbqyzVtgl9EYfzaeaJiex3HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yang.yicong@picoheart.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0950/1611] ACPI: RIMT: Only defer the IOMMU configuration in init stage
Date: Tue, 21 Jul 2026 17:17:46 +0200
Message-ID: <20260721152536.759148815@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yicong Yang <yang.yicong@picoheart.com>

[ Upstream commit b8f62414fa05144924257db283c5c35f74d21121 ]

The IOMMU configuration will be deferred if the IOMMU driver
isn't probed by the time. Make this deferral only in the
initialization stage with driver_deferred_probe_check_state().
Otherwise the devices depends on IOMMU will be deferred forever
in case the IOMMU device probe failed or it doesn't appear in
the ACPI namespace.

Fixes: 8f7729552582 ("ACPI: RISC-V: Add support for RIMT")
Signed-off-by: Yicong Yang <yang.yicong@picoheart.com>
Link: https://patch.msgid.link/20260625094702.11558-1-yang.yicong@picoheart.com
[pjw@kernel.org: added Fixes line]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/riscv/rimt.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/riscv/rimt.c b/drivers/acpi/riscv/rimt.c
index 8eaa8731bddd6c..4c0962e68c94ca 100644
--- a/drivers/acpi/riscv/rimt.c
+++ b/drivers/acpi/riscv/rimt.c
@@ -9,6 +9,7 @@
 
 #include <linux/acpi.h>
 #include <linux/acpi_rimt.h>
+#include <linux/device/driver.h>
 #include <linux/iommu.h>
 #include <linux/list.h>
 #include <linux/pci.h>
@@ -257,11 +258,11 @@ static int rimt_iommu_xlate(struct device *dev, struct acpi_rimt_node *node, u32
 	rimt_fwnode = rimt_get_fwnode(node);
 
 	/*
-	 * The IOMMU drivers may not be probed yet.
-	 * Defer the IOMMU configuration
+	 * The IOMMU drivers may not be probed yet. Defer the IOMMU
+	 * configuration if it's still in initialization stage.
 	 */
 	if (!rimt_fwnode)
-		return -EPROBE_DEFER;
+		return driver_deferred_probe_check_state(dev);
 
 	/*
 	 * EPROBE_DEFER ensures IOMMU is probed before the devices that
-- 
2.53.0



