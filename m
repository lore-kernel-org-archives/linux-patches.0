Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537EE8F5E;
	Tue,  8 Jul 2025 16:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993460; cv=none; b=reRZIwi2YnS66AVWyD6d3Tb10PGkaN5ClKhYHQd2Fka09X5ZmehIoMWy+tYLoi88yM08Zkw/OQL8NRs/8umxJuf3tdbTYIg59zjMVR+9uKwh6clnzFwYwH8Vshfn52Zbqn+H0g7xv+x3p2WrF7WJ9hvlCLqmZGZ/DfbP/MPzChw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993460; c=relaxed/simple;
	bh=++aSUM91gXIxqUG1gIBCRJwxNY1JagS84WKIfP9PWvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HxnTVsmlZoM1IjaRDQJi8WdNxcZOZIc7MdWCmWuAcCzZpSIBRYp/+k9g8bPRDvTcS+tr02suqPyZ0pEWVaT+A7cOm9+xqcBrLQbmGM1t3+9DhPa7MW/1I573P5sdJiDbSli2GttbTS8rPB2xjlMz61u5ly3xpdAWNhdgFlH3tXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LU23Pm34; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LU23Pm34"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF819C4CEED;
	Tue,  8 Jul 2025 16:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993460;
	bh=++aSUM91gXIxqUG1gIBCRJwxNY1JagS84WKIfP9PWvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LU23Pm343MDz+H1E7oiI+1EXLVez4OYSPQEezBRCWj483wK5hmq9wTaMLOnCfT7gX
	 piHezPUCCK23B2tptpnLSy6cUKgSJUyH7icf+Ygla9D0qJAc96K7WqfwfTcoL9X/lu
	 V40aDYlF/gwleTkP9qTRcEgifvgDowu0ez2X66W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 082/178] platform/x86: think-lmi: Fix class device unregistration
Date: Tue,  8 Jul 2025 18:21:59 +0200
Message-ID: <20250708162238.822498841@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kurt Borja <kuurtb@gmail.com>

[ Upstream commit 5ff1fbb3059730700b4823f43999fc1315984632 ]

Devices under the firmware_attributes_class do not have unique a dev_t.
Therefore, device_unregister() should be used instead of
device_destroy(), since the latter may match any device with a given
dev_t.

Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Signed-off-by: Kurt Borja <kuurtb@gmail.com>
Link: https://lore.kernel.org/r/20250625-dest-fix-v1-2-3a0f342312bb@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 00b1e7c79a3d1..28ce475f6c377 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -1554,7 +1554,7 @@ static int tlmi_sysfs_init(void)
 fail_create_attr:
 	tlmi_release_attr();
 fail_device_created:
-	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
+	device_unregister(tlmi_priv.class_dev);
 fail_class_created:
 	return ret;
 }
@@ -1781,7 +1781,7 @@ static int tlmi_analyze(struct wmi_device *wdev)
 static void tlmi_remove(struct wmi_device *wdev)
 {
 	tlmi_release_attr();
-	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
+	device_unregister(tlmi_priv.class_dev);
 }
 
 static int tlmi_probe(struct wmi_device *wdev, const void *context)
-- 
2.39.5



