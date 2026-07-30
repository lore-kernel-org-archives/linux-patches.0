Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC18A43C7AB;
	Thu, 30 Jul 2026 14:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421809; cv=none; b=WfmLmAVGlT72YmwK2PXDqjdB7qG88mv4zZqNs24y7f2eldZz36v4DfxAfWXB1In/yIbqLnsb0UR3PXazuyO18LOVdVq0d3KXAsxCqdBDvG2jFEL2FLg6tNTTjLOZmMdPj+MidGPHzEm4GBAnzRMJxUlKDZJAn+vKaYToWS675Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421809; c=relaxed/simple;
	bh=83lDVXGJsOzg20oCmR3htASQhdbNO2fG27bzinAK9Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdxUR33A7e0Ii8arzqDBirgadG4jJDRgZ5raoh4/AdPQT46ha1rMS0mnLtJeyY3NYbljbV/fcUH/dpWWS450kNihp8HfCiZAJn8pRW2fCPbrFva94r13MVDniyPDTqdmSdFa/s1Kb5bVmegZ6aXLZPxm9mT1Z1ncv3gNosTRByk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oErYGWMB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oErYGWMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CC31F000E9;
	Thu, 30 Jul 2026 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421807;
	bh=MpgPmwqGXMGOEA0rnrJlxmTEN0EgMvmoXDjMMF/STtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oErYGWMBEEC2Iq7lO4WCponYGYXoAc2llAH89QXzTlB2VzTnweRl2uYgQXy01xx2A
	 VmIDVMjJUqNsigTZp359x2Dk/mSKy0v0drvPdMe7/EBW1CdOq/Juoht/mk2HuTCWgW
	 lxAmL5mAkSGypZu9rS/rn9bJW2lHuVxFCL7gHuKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 172/744] hwmon: (corsair-cpro) Stop device IO before calling hid_hw_stop
Date: Thu, 30 Jul 2026 16:07:25 +0200
Message-ID: <20260730141447.945819304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 94c87871b051d7ad758828a805215a2ec194512a ]

Calling hid_hw_stop() does not stop the device IO.
This results in a race condition between hid_input_report() and the point
immediately following the execution of hid_device_io_start() within
the driver probe function. If the probe operation fails after "io start"
has been initiated, this race condition will result in a UAF vulnerability.

Fix the problem by calling hid_device_io_stop() before calling
hid_hw_stop().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 40c3a44542257 ("hwmon: add Corsair Commander Pro driver")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-cpro.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/corsair-cpro.c b/drivers/hwmon/corsair-cpro.c
index b6e508e43fa17f..8354a002f4c5e1 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -645,6 +645,7 @@ static int ccp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 out_hw_close:
 	hid_hw_close(hdev);
+	hid_device_io_stop(hdev);
 out_hw_stop:
 	hid_hw_stop(hdev);
 	return ret;
-- 
2.53.0



