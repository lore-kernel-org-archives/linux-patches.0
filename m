Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501FA2F7F17;
	Sat, 12 Sep 2026 16:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229420; cv=none; b=o3mdwCCE0R2Z/7vEgcNshduYOiyfLNqWNt3EvjuCA1JPmlbxLO4Ensk2u2TQqHMzB9rdB4utsx+LAhqEKay7Wj5r2OBcSgZguNkHIqX11hUy+C+kKA9iiCTM0H7xBiL9TN7n1Tp4GtGREdkPDQ5eZPpwNOOUQ3hsXujfSlK82CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229420; c=relaxed/simple;
	bh=ai636bAkeTEZKynZrCeMQklxJj/aR8FtEwz5Fc21gfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aRlRXC7XDQPL6IXjkAhZbuhxflcwBal6ynRCrpR/U6sUOm0iQ/+icWNdkaukIFjHVYP5G3q79KOfHiEDFOmYhoW2jkd6REXNMUootES5N/aqG8De2Jwh2JFGaSzN/W43PwO1o2WLYkV6l8/hCG14JdgnoKsD2It+6StJ594OhCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6lkfsFk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6lkfsFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217031F000FF;
	Sat, 12 Sep 2026 16:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229419;
	bh=m9G86wgrxjjY4jWWSsj2fNq91YjV4z9o4yxb5O/Uxoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6lkfsFkU3C5ZdHxIOCZJKCdx5cvF+txiK90KPxHwG5nO40F0dezBq17yX5engCkY
	 CMjKttm0ZJ6XYotWp3Csd5nHqWw8hkW234NmuHVp3YLuLNx94NsqjiLq3ZdljcoToY
	 bx3h6fkTqaeMHGXPHAg7742DBy6IFoT4L7Y7h3hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0585/1191] platform/surface: acpi-notify: Check ACPI companion before use
Date: Sat, 12 Sep 2026 08:55:13 +0200
Message-ID: <20260912065601.386086973@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 50500e562963d..c0ff86383cd47 100644
--- a/drivers/platform/surface/surface_acpi_notify.c
+++ b/drivers/platform/surface/surface_acpi_notify.c
@@ -801,12 +801,16 @@ static int san_consumer_links_setup(struct platform_device *pdev)
 
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



