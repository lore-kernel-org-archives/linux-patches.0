Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D8121C9E4;
	Tue,  8 Jul 2025 17:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994162; cv=none; b=f7h62LTM0fFdMaCUmrOXMP+zha5QGUP3whXhM6HYZKa/1A9LtdygvD3Ukmx8NA+ixjWBw0RQ94rczlO/3cW9kYMDi16GAc/D+5fCEsll31v4wQRHu3hG6f8wQuvSSp7Zs8RxwsKb2TP9uwq9CmdqKmDszxHaOFKaegM9Jv5FsPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994162; c=relaxed/simple;
	bh=WuPLYc2b26IGGa6KAenewDaStBOeJSyQVHD07KXXiQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rck9WIw8an35vJaMuJ+c3ujcxvEgWPIqDaiLlbDRPLnDTuoS26V1ohBWK4oCXMxzi/W6yOzWLeZ6IbbL7xLXCpBdHcjyS3jcSzJsdZYgXUbaJP7suwZQrAlc3dW1WjTO7MoIMFy7M/xe1jT1qAGPAWM5t1YgAbxnf2tZahpEHzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZBJBE0Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZBJBE0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49654C4CEED;
	Tue,  8 Jul 2025 17:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994162;
	bh=WuPLYc2b26IGGa6KAenewDaStBOeJSyQVHD07KXXiQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZBJBE0ZCML7RUu5qpDjBrn1crNZvQLtmiUH//OGQUXSep1N0H0a8wB0XxcpouGx6
	 7R9V5e+7oE85fQulwwbUig8S4z1VjLA/lR1rFUSnCNYmOaPJ93+cdub41exBgCmYPX
	 uBlcPOiHuWVJU1MsJLr+9G058o/qjeFBjZdgcPnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kurt Borja <kuurtb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/160] platform/x86: think-lmi: Fix class device unregistration
Date: Tue,  8 Jul 2025 18:23:04 +0200
Message-ID: <20250708162235.407748976@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 154b1b26d03f8..462f7779daaa6 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -892,7 +892,7 @@ static int tlmi_sysfs_init(void)
 fail_create_attr:
 	tlmi_release_attr();
 fail_device_created:
-	device_destroy(fw_attr_class, MKDEV(0, 0));
+	device_unregister(tlmi_priv.class_dev);
 fail_class_created:
 	fw_attributes_class_put();
 	return ret;
@@ -1055,7 +1055,7 @@ static int tlmi_analyze(void)
 static void tlmi_remove(struct wmi_device *wdev)
 {
 	tlmi_release_attr();
-	device_destroy(fw_attr_class, MKDEV(0, 0));
+	device_unregister(tlmi_priv.class_dev);
 	fw_attributes_class_put();
 }
 
-- 
2.39.5



