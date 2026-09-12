Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46ADD35F191;
	Sat, 12 Sep 2026 09:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203739; cv=none; b=mNcpuf3kymtBjsifTvUPqXREmUVLBr7IaY/o3RsQhrvfoXl9OMi10ACw+3THCdkoCjD1jZHLSM/YXWkPCjd87BWSpE1sSPh7Zl1aPuKMR3wTMRY9NLJYppHoICr4QgU/OzKWPz9APWeL3+S5NeyX2W50bG9+zOhXlCMpzmXAqTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203739; c=relaxed/simple;
	bh=eeMy5bYGewZHKXfWp48NGb2i/0dXjtRHgnzNP3kOUWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTpyDyP22XjitOECz5dP6opgi74/zVIZxohgson6iKHVVfijqFwP6IrTdrfv9tmsl6Tkodiq8TLn1YmxK653QBso7+mXO8E4hIc0ruSJ805jwbni43W/GwUMaUuW7Y+0kLA5UnHY41ICoiuHLgPRtZ+UMdTqKwm/m0BhSgGAP8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0wYMe0nY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0wYMe0nY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153341F000FF;
	Sat, 12 Sep 2026 09:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203738;
	bh=xRyErewXP0fA3MhqAtYiqkZtuVnZpHmwsw928ohzAxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0wYMe0nYhD3kDoc/OLHOgcRb/g3sa32YQJ2NUBIkSJZxQpwnQD+XadUItO401BLGS
	 g0f2FEa91wfytQcslbeZiSvFvJJoG/n3mvef8FmdAPDWTVt4hKBdJXnMT26PbjxJ39
	 6+GKuLq5rfU5F39C7bzTYG0rmk+xgY57fIhnirxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1462/1815] ACPI: scan: Use acpi_bus_get_primary_device()
Date: Sat, 12 Sep 2026 08:53:32 +0200
Message-ID: <20260912065723.333432571@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 87ee7d704f69f303c86b2dcf617e33764371fe7b ]

The acpi_get_first_physical_node() usage in acpi_create_video_bus_device()
is generally unsafe because in theory the device returned by it may be
freed at any time.

Address this issues by using acpi_bus_get_primary_device() instead of
acpi_get_first_physical_node() and dropping the device reference
acquired by it after registering the child.

Fixes: 6ab3532b4c98 ("ACPI: video: Switch over to auxiliary bus type")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/10906414.nUPlyArG6x@rafael.j.wysocki
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index f8450f7ea097c..99af95f338652 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -2213,29 +2213,27 @@ static void acpi_create_video_bus_device(struct acpi_device *adev,
 	struct auxiliary_device *aux_dev;
 	static unsigned int aux_dev_id;
 
+	struct device *phys_parent __free(put_device) = acpi_bus_get_primary_device(parent);
+	if (!phys_parent)
+		return;
+
 	aux_dev = kzalloc_obj(*aux_dev);
 	if (!aux_dev)
 		return;
 
 	aux_dev->id = aux_dev_id++;
 	aux_dev->name = "video_bus";
-	aux_dev->dev.parent = acpi_get_first_physical_node(parent);
-	if (!aux_dev->dev.parent)
-		goto err;
-
+	aux_dev->dev.parent = phys_parent;
 	aux_dev->dev.release = acpi_video_bus_device_release;
 
-	if (auxiliary_device_init(aux_dev))
-		goto err;
+	if (auxiliary_device_init(aux_dev)) {
+		kfree(aux_dev);
+		return;
+	}
 
 	ACPI_COMPANION_SET(&aux_dev->dev, adev);
 	if (__auxiliary_device_add(aux_dev, "acpi"))
 		auxiliary_device_uninit(aux_dev);
-
-	return;
-
-err:
-	kfree(aux_dev);
 }
 
 struct acpi_scan_system_dev {
-- 
2.53.0



