Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1373A22259B;
	Tue,  8 Jul 2025 16:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992389; cv=none; b=RGotWG+B1VSChnG5cMJrHiCBvuZvogV3If0PnApV0eNp0QC5AhmSEGlag/2FGBTmWLGpbnvMuDQU/iHwoU8xbRoaqmqjLCxU1t2fEdTS3KPHx5DmbWGqhTs725cXBtgu2F/NLP36eBUItChMfMsD6ROryVVKY7ikvU/79KMCgls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992389; c=relaxed/simple;
	bh=2LhqSEvsptVznKJdrZENxFqgSSw4ANpYtVoK1za29W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QkjFNtC+7Us6u7auyXIbCoL6t4f/S7hWJuUriHepn5W+OlbLmxpnE9TewZqMszLH6+80qjPIeHggeNfD037ix4jLk1WS9b0rGH+oCGazR81gm1W3eBm2NaKgi/sn67xj/JHkA+BYfd232TNkARH66Xc2Rfgp+ZB8hKq+uLYlyLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ax09Ct9f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ax09Ct9f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4A8C4CEED;
	Tue,  8 Jul 2025 16:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992389;
	bh=2LhqSEvsptVznKJdrZENxFqgSSw4ANpYtVoK1za29W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ax09Ct9fho4D7bGgFDYwWIlLOediXYkYZOTMUwm4lPE3AmOgYIxNlgtjX6EZ9SzF6
	 mHeaMBEP13rOePykVZnnw3kc3AHvGByBH7xEpMmmkdvZvesdcCDqKfz2NglpSE2c8A
	 nv5axjo7Arj4cuq/p4pL4PJPMzfdXv8sNIu+T0qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/132] platform/x86: think-lmi: Fix class device unregistration
Date: Tue,  8 Jul 2025 18:22:38 +0200
Message-ID: <20250708162232.042577109@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f0efa60cf8ee2..626990d103e36 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -1380,7 +1380,7 @@ static int tlmi_sysfs_init(void)
 fail_create_attr:
 	tlmi_release_attr();
 fail_device_created:
-	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
+	device_unregister(tlmi_priv.class_dev);
 fail_class_created:
 	return ret;
 }
@@ -1604,7 +1604,7 @@ static int tlmi_analyze(void)
 static void tlmi_remove(struct wmi_device *wdev)
 {
 	tlmi_release_attr();
-	device_destroy(&firmware_attributes_class, MKDEV(0, 0));
+	device_unregister(tlmi_priv.class_dev);
 }
 
 static int tlmi_probe(struct wmi_device *wdev, const void *context)
-- 
2.39.5



