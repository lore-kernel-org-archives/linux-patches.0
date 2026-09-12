Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C405246BCD;
	Sat, 12 Sep 2026 10:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207700; cv=none; b=el0f4EcrOF32Pf4KCMrfQu3afeZOM3aMHrYXRahisvGpXWfWG0DAfzqzgKeOfW9m1oAvhrRUybLey7+me8Xhfo9ylbxT2jlLwlfNQboOVpP20fFXWfsHP/+4Da5WxXq905WxCudVKh97Jg0N+FEba/D8fBCv9tFskWTc8oZAEjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207700; c=relaxed/simple;
	bh=LOvNPOnNtSKmwk0O2Wbt8mzWirSuNo4V8ROiJcArMkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNq3wgqhmm/eHixdo2tzn+qnxkwdO0we4zs+6DGNDXhQoF5gExj0Rr8KH/EONWzB0GXuZHwn1FfK2AdGxT+I826APCbgdjFYuP1/OAE+ICpZV5GvKYyVhuMyI37mSiVKKc7iMHl0JSRK9VKIWTYYFu1uUn0VMvVUNo+XVKAAydw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwrzV2EP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwrzV2EP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58591F000FF;
	Sat, 12 Sep 2026 10:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207698;
	bh=yj6yd0bEvM5Q65WW8jRUh29AN/2TeKrkwi6i0W+4isU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vwrzV2EPlUmCcSD1R3aVfRXgHyLgVZL5RPxSShq0j0exV0gKpinWrTDmAXF5d2TB6
	 JYs37ULTO0jduyJujV/0H5dZKT9z0pV3yUiiIMx9KWfo/w9oLGjG0DSZjHPGMcWMSp
	 TwFf4E5TPZJrW9WZGtENUBv2XA3VMNLBy1JZmNeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0459/1518] char: xilinx_hwicap: unregister class on init errors
Date: Sat, 12 Sep 2026 08:43:48 +0200
Message-ID: <20260912065633.831908438@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit e7e12b4cc0f0c3a2782aea084d4215e23f5512b3 ]

hwicap_module_init() registers icap_class before reserving the
character-device region and registering the platform driver.  If either
of those later steps fails, the init path must undo the successful class
registration before returning an error.

Route the chrdev registration failure through a class unwind label, and
let the platform-driver registration failure fall through the existing
chrdev unwind before unregistering the class.  The normal module exit path
is unchanged.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: ef141a0bb0dc ("[POWERPC] Xilinx: hwicap driver")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://patch.msgid.link/20260623085604.89284-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/xilinx_hwicap/xilinx_hwicap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index 34a345dc5e724..9bb5fa642fd88 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -760,7 +760,7 @@ static int __init hwicap_module_init(void)
 					HWICAP_DEVICES,
 					DRIVER_NAME);
 	if (retval < 0)
-		return retval;
+		goto failed_class;
 
 	retval = platform_driver_register(&hwicap_platform_driver);
 	if (retval)
@@ -771,6 +771,9 @@ static int __init hwicap_module_init(void)
  failed:
 	unregister_chrdev_region(devt, HWICAP_DEVICES);
 
+ failed_class:
+	class_unregister(&icap_class);
+
 	return retval;
 }
 
-- 
2.53.0



