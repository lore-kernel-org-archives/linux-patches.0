Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E1630BF69;
	Sat, 12 Sep 2026 14:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223049; cv=none; b=I0DBR+kgj173GMXUR95Xs/egqfP5hVgPN32hCC3rFuHXmjGmII9EApIWph+Z1bL7BNG1G5D2qQMrqCXOsPoIfaj6idwdLim6zAybLRg3vag1OSCiWLLSrv/JyNq6xFV1q1DDWEOopTl3Genq5lO99by2ljA6DVhMyoyMnbshDRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223049; c=relaxed/simple;
	bh=OBnVO1eXajKNvd6w8mCowBI8lb8aKUlt73HlGCD8FsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gjKjE1lvvwwnH0sK5BVTbxmFj5bNg3KLtgxR/AGf6UNIxWCv55dnMEfjRY/8+qzJtWwCaAwzgVemJQGEGXCBou4PphR1/zLXEr5utecMfIufFtfeRa4PiEhDkBkDIX/P/DVf72ZstM3+kwnIt77tzJD/JRGjDlWw2zP3B8ETAf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H+9+1/1H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H+9+1/1H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EB01F000FF;
	Sat, 12 Sep 2026 14:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223048;
	bh=Sfsxnx1jPEvGSdulBPB7aBlxGcuWUciXyYSo8JDxDzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H+9+1/1HG2dz2tPiRXrPqY2ooFlIwRtKyda5XLLWql7ZpA5rFLf1bvVxdPCgzKWB6
	 B2/4SXLutoxfVi7tjFOLlvwlXhG0b1P9NP3YJyO9dnBuSfo1O26TJpLcG21gj/LUy1
	 1xg3BSpYUbUXZ8H0ASr/O477uAa3wjHWi2tLhyoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0709/1424] platform/mellanox: mlxbf-pmc: Check ACPI_COMPANION() against NULL
Date: Sat, 12 Sep 2026 08:52:21 +0200
Message-ID: <20260912065623.176707910@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit c38cce70adef874c2a7b5132c14d6c221401deff ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

mlxbf_pmc_probe() passes the result of ACPI_COMPANION() to
acpi_device_hid(), which dereferences it, so force-binding the driver to
a device without an ACPI companion leads to a NULL pointer dereference.

Accordingly, add a requisite ACPI_COMPANION() check against NULL to the
mlxbf-pmc driver and return -ENODEV when the companion is missing.

Fixes: 1a218d312e65 ("platform/mellanox: mlxbf-pmc: Add Mellanox BlueField PMC driver")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260706012056.524096-1-lilinmao@kylinos.cn
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-pmc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/mellanox/mlxbf-pmc.c b/drivers/platform/mellanox/mlxbf-pmc.c
index db7a1d360cd2c..25e12b337565c 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -1385,13 +1385,19 @@ static int mlxbf_pmc_map_counters(struct device *dev)
 
 static int mlxbf_pmc_probe(struct platform_device *pdev)
 {
-	struct acpi_device *acpi_dev = ACPI_COMPANION(&pdev->dev);
-	const char *hid = acpi_device_hid(acpi_dev);
 	struct device *dev = &pdev->dev;
+	struct acpi_device *acpi_dev;
 	struct arm_smccc_res res;
+	const char *hid;
 	guid_t guid;
 	int ret;
 
+	acpi_dev = ACPI_COMPANION(&pdev->dev);
+	if (!acpi_dev)
+		return -ENODEV;
+
+	hid = acpi_device_hid(acpi_dev);
+
 	/* Ensure we have the UUID we expect for this service. */
 	arm_smccc_smc(MLXBF_PMC_SIP_SVC_UID, 0, 0, 0, 0, 0, 0, 0, &res);
 	guid_parse(mlxbf_pmc_svc_uuid_str, &guid);
-- 
2.53.0



