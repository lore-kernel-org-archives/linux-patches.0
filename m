Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F003819D8BC;
	Sat, 12 Sep 2026 07:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198184; cv=none; b=Qi250h78HqurwpP0ObNKbUvCt79fHYYdOdZELsduBb5OBbOQzZGE00YBY3eoDiyZNsT7j3t5z3Gr8Ab7SnlAeQR837StiTYbFqDsmJw9CBAxrI3X+Lvz2y7L0ZCcI7641EYl8wDocXJWWIux6TM0Qsz5mU0DBECYU++6eqsXTIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198184; c=relaxed/simple;
	bh=gn4WdO/J7smx+ZO47TXQ60Tz0NzybT58MUIN+QJKbUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g9bJoy6GwFpL629gOX5T5B1KkVDSIheha3bzV6w02hFXTkYvRYPqQkC0kDN+ji9ySK+Ok4SfGnrGK/eAzoPmvUAD30UiqmH2YAuW/9r7cwzULphbQXNAqg77wPnBb6owfek535p50Yi7yyURb5EZ7x9Dt6hTnhOIug5QLQv90J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vf6YeVQg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vf6YeVQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68481F000FF;
	Sat, 12 Sep 2026 07:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198178;
	bh=ydmPkfW9KGW3NNhtGlNYrBa7HoLfeVh2i8pZrsMHWUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vf6YeVQgrKo3TDc3SQ8UR6v4TiVr17nVep7Wi/NfPMJg3FiTjHWPDSv85S0gPlDB2
	 SZqNS0rzT+GYETJ4TBYyfDZHd36d2Okxtbcz/tXEdlkOkRIDdNwCSw4zEzdSSCZurf
	 TKveSuspKdDJWc64i2SeJzJ3tbr+/C2RO+jhdomg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0328/1815] platform/mellanox: mlxbf-pmc: Check ACPI_COMPANION() against NULL
Date: Sat, 12 Sep 2026 08:34:38 +0200
Message-ID: <20260912065656.630342343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 5ec1ad4716967..2ad9e2b0493c4 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -2262,13 +2262,19 @@ static int mlxbf_pmc_map_counters(struct device *dev)
 
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



