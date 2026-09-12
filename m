Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BEACA6F;
	Sat, 12 Sep 2026 14:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223509; cv=none; b=egmhNUCHNSn0/yRW8KBDvjVE8+bVeWtSR75EXdvXQ0JB/C9y4pzarRdxU/fnpgM2nEW96saI40VXQh2FwdqIPsY+H93tTpz3kjyaf+tHbZj0UrbqAmf0CkVK4+7YJs5hnXb7fjENPAE5QJw39uUsRP7kOL8mQO9+bn/p5TdGWOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223509; c=relaxed/simple;
	bh=/AmI/PWQfEIFSbZIqPzG2R6ju4tGmAkvQEIWcwRhsaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=da6eDD17/VyA7TOZSKIcwogE6ByD8FiApheeJewd+etdOYrJBjNVCvSpQewnevdWSIpPA8d6dHT6Hc1PXkUoSravpyJsWjC6gUlNprodyza7mMQk3/94itaOo/yUwKSfPLzi/OAXLahbyUh6QucGbBYt9dx92yrxio7GWs2ggew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HnMD98uZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HnMD98uZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F54F1F000FF;
	Sat, 12 Sep 2026 14:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223507;
	bh=rSCXUlS7gHQzTJ1QZ71gDYZ/C9w3v6S4pwW/UP23Tjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HnMD98uZmmYuT7VGYlTNFcc/PUJt5K0IxFG7Yub3REAsJHX3+l5teThB+zLT9ExWt
	 a+8GNSsTr10oDoc7ojc+xGbaER8CdcP3EkYGaeb73LUcEcERqbQq3Qj1wg+stTsOPw
	 N/aI47Xl9IoEN6dovxF7bRZOmcsg5S8zPgAaNnoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0803/1424] char: xilinx_hwicap: unregister class on init errors
Date: Sat, 12 Sep 2026 08:53:55 +0200
Message-ID: <20260912065625.277278040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f60bb6151402f..0eddd759ed410 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -860,7 +860,7 @@ static int __init hwicap_module_init(void)
 					HWICAP_DEVICES,
 					DRIVER_NAME);
 	if (retval < 0)
-		return retval;
+		goto failed_class;
 
 	retval = platform_driver_register(&hwicap_platform_driver);
 	if (retval)
@@ -871,6 +871,9 @@ static int __init hwicap_module_init(void)
  failed:
 	unregister_chrdev_region(devt, HWICAP_DEVICES);
 
+ failed_class:
+	class_unregister(&icap_class);
+
 	return retval;
 }
 
-- 
2.53.0



