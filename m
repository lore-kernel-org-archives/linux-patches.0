Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BA3420496;
	Sat, 12 Sep 2026 12:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215241; cv=none; b=Y7TFoFmDukj6o7MeI/ftq25SVvmYyBXcENfPNmN5XaFIt9t6HK1aYn7ehuvWuxQNxh6U8uhfEOGDKf87sowxTor+pO0vBlP0F1aWwqd+4BMJrWvJV5QCbcHihMgCkhYpdGlM9T2pESbx+xu4CoKkMj5WXrQuhioj+ICn0DLVqoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215241; c=relaxed/simple;
	bh=1gl3W82dC1oOrqNPmlvExB4NBNzmYuQ+iKmGtmBe0B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FTtKv7lfsNTyJ7F8JIivkAOg1e3RjTEK+Vtd88IYVOePhu89d8DnGs+rLOzZUhqPsnZc0nIaE+/9ASDA8pVPE9g2t4aVJ1OCh6pcppBbbyBzF0ud9V0JZUU1yZROxEqz43prqxZOsriNzzi44Pby1CIMk1ZXo400tt1WLL87hLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZtF4hAFl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZtF4hAFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4871F000FF;
	Sat, 12 Sep 2026 12:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215240;
	bh=dGeDA3A11UmytuHHEZiIGzCyOL6pmfZ7ztrm6oArtSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZtF4hAFl9xNaOI73Lc17i/fMfNhfKMdtQ0fhraOYxiiaREsVwtMt0WeYXAbgrS4U3
	 Dvb+dv2gjP8FCcHrqXTi9127kPrnON+AwS12qFKawCNg3oLLDrXn577h/BZDPOUFY5
	 QGY2Wx+f7L6UhVs3rG5Zc4WwH49Xmf7lSf2wS9Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0491/1376] platform/mellanox: mlxbf-pmc: Check ACPI_COMPANION() against NULL
Date: Sat, 12 Sep 2026 08:48:37 +0200
Message-ID: <20260912065618.480517255@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 67d9b19731edf..fcc8d9eaf37c1 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -2021,13 +2021,19 @@ static int mlxbf_pmc_map_counters(struct device *dev)
 
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



