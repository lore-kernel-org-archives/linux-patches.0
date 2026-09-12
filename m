Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA86E4BEE43;
	Sat, 12 Sep 2026 18:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238833; cv=none; b=AOyMBTsH9iuWoRwO8D32j4z1WL2i3fovOUgeWI89nGuvHI4VSGy8sVLS1DTuXXYZ/m735wT6Ez2zi/SmcBQt6IWutXG/304+WlOK01YKeyjeMamq7++E+t5hijq2/dfy1HryiJeZr8YruD9sUR8Bzdk3XcyjLnq61pyBy7UtWSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238833; c=relaxed/simple;
	bh=qZwb5O00Xg3OjTbwkeUppyfy0Feu445Exct4+scaxo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V/cMMXF0wb0tKmlOl3SSOJQocy4t0NZO7xNZYgJSs/lIXcESw4b0++YMyoMi4+GwDm7Sia64OCjwVPVT49BgLin+tdi+eI6TBLhkLdoyEQSztPPdVzPCsF98hMZ4H1k/TRB2gE6iIJniFQ6o6QnQ3SrmOcqiWNpoNcwoBTbG3Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f30hJPac; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f30hJPac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1491F000FF;
	Sat, 12 Sep 2026 18:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238832;
	bh=aj3f7LiZ0ZjD6DBSyjjLIK2IktLWRhov7Cr1YRWvGd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f30hJPacPETIBOzdcidGtuS6CJVL2DDGxdtCYwr0rDcDUOh9PIQ1NkhbNKfsaRe4S
	 ZsNavCaeottXhi9b5hjkfHavOuOGlNNxT1nA3MzJDxT28DIoqyBXZKnhq8wSMlBorh
	 8/z6WR5iD1eLniUP0OiDsKBzdeTN/UWyBDNqQtTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 489/935] platform/mellanox: mlxbf-pmc: Check ACPI_COMPANION() against NULL
Date: Sat, 12 Sep 2026 08:58:39 +0200
Message-ID: <20260912065538.035039256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



