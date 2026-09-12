Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5D019D8BC;
	Sat, 12 Sep 2026 09:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207028; cv=none; b=jM4UWt+of0DunVQlTUMeoxIGQhlYP4bX+qAwQ4IWbFL2lsZ9vHv8SGXb/E1bqRG6VZYHyoaMncVv3kHWkmaxpXbNaz9tRXHaBB6WzRUUitqXgoKISQNypCUIT5EMop8RKWBmyP16FveQ4yr062ouqvLm+aqwELF98c1wnklQi0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207028; c=relaxed/simple;
	bh=DMpTiCpdKBKix9kQ1gp7UN8h96Dk26evpWoE9rdaL/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ol0GSWOcteME7r+FbItDsj+cfINtTjezTJy9cZEaB6BE43woqGfqbpaAOUNnkG8n44CNHcuAId0LCjcNlqghXkDUMunFbj6zEeEfsyq8pb/9rp23o5Deq0nWjSdS97IU9RuapQzaYUviUZH5wNfJlRJIE8/ggrHIA1ObMOHq4RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bzhYVsHv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bzhYVsHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325481F000FF;
	Sat, 12 Sep 2026 09:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207027;
	bh=pfVJ1D/9PpA24ZkaQJrCg3n2qD2p4Kh7GD3qH02CT7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzhYVsHvAz1mnUervtwzLjZhjL1AZRc8ExR53O4Cem37ycGwi4juygKD5lECZs+6D
	 m7VGXQZA3L1w6FiTKH2rjHI/hnpPCfUKnhdlf51CcQzA1fSt7FZyN+Hp1dfUyf14TZ
	 K1lCcxodjpuH1q9DY1ro3VlXHbYtJO3iz1aNeC4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0321/1518] platform/surface: acpi-notify: Check ACPI companion before use
Date: Sat, 12 Sep 2026 08:41:30 +0200
Message-ID: <20260912065630.738389644@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 2b3a5dabe89e330413af403246b648c1890f368f ]

Since every platform driver can be forced to match a device that doesn't
match its list of device IDs because of device_match_driver_override(),
platform drivers that rely on the existence of a device's ACPI companion
object should verify its presence.

san_probe() dereferences the result of ACPI_COMPANION() when installing
the GSBUS address space handler, so force-binding the driver to a device
without an ACPI companion leads to a NULL pointer dereference.  The
dereference was introduced when the probe function was switched from
ACPI_HANDLE() to ACPI_COMPANION().

Check the ACPI companion against NULL and return -ENODEV when it is
missing, like commit e4865a56d013 ("ACPI: driver: Check ACPI_COMPANION()
against NULL during probe") does for the core ACPI platform drivers.

Fixes: a9e10e587304 ("ACPI: scan: Extend acpi_walk_dep_device_list()")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260706012512.524359-2-lilinmao@kylinos.cn
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/surface_acpi_notify.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/surface/surface_acpi_notify.c b/drivers/platform/surface/surface_acpi_notify.c
index 3b30cfe3466b8..3bad4e689f5ce 100644
--- a/drivers/platform/surface/surface_acpi_notify.c
+++ b/drivers/platform/surface/surface_acpi_notify.c
@@ -777,12 +777,16 @@ static int san_consumer_links_setup(struct platform_device *pdev)
 
 static int san_probe(struct platform_device *pdev)
 {
-	struct acpi_device *san = ACPI_COMPANION(&pdev->dev);
 	struct ssam_controller *ctrl;
+	struct acpi_device *san;
 	struct san_data *data;
 	acpi_status astatus;
 	int status;
 
+	san = ACPI_COMPANION(&pdev->dev);
+	if (!san)
+		return -ENODEV;
+
 	ctrl = ssam_client_bind(&pdev->dev);
 	if (IS_ERR(ctrl))
 		return PTR_ERR(ctrl) == -ENODEV ? -EPROBE_DEFER : PTR_ERR(ctrl);
-- 
2.53.0



