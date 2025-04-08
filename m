Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9A4267B6B;
	Tue,  8 Apr 2025 12:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115423; cv=none; b=Bb/JxVXkKzlS6rfD9Hmp3wZee39QgqX/pQWKBbsbZSnIcqE4x0QxjCRblzVEM8qxXXlFKj6c3bEbDiuTjL3gl3JtYHI8Z0bMBfWOqZnCUgPikdWZCX0g4SBTSgYg7Dyx2wA5SrH2G4/5pku6frbDrFwbKojEhGxUDj0UFzMM3YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115423; c=relaxed/simple;
	bh=kMEISixNm0286pbIXoA2IEYeFM8F9LHBtkGPtHGwYz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KpxKKTpyHTJZ3eXP9YY1xfy2X/IhBJwf5EP+5F3ZulH7NR21fRrgKp1mODpd/l4d2x+B9Ubys5ffUtEiztUIIzJ9baPrLcawdA68TqMza/sAC4xzCg9NYA8VlbEokH5RmbOUfTPxd2jXP7UmwBJ1vRgSvjKhw984VOgLioazAyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4So9aRY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4So9aRY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF11C4CEE5;
	Tue,  8 Apr 2025 12:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115423;
	bh=kMEISixNm0286pbIXoA2IEYeFM8F9LHBtkGPtHGwYz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x4So9aRYUixrQ2AVdoXg9NoRPaLPVBRghlfQngvKzHjOEdIFcuSYJ66U3A1adwIha
	 59jUUvBPJ3sCrJuLFYlGKcsLwIFP585SDm9pQmwADRenvU2MOlSl8U9EunaoBrXYfl
	 boO+4HIVWW5+7sSO32st5WwzK89mLOJPJycSKAJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nihar Chaithanya <niharchaithanya@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 420/499] staging: gpib: ni_usb: Handle gpib_register_driver() errors
Date: Tue,  8 Apr 2025 12:50:32 +0200
Message-ID: <20250408104901.700934408@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nihar Chaithanya <niharchaithanya@gmail.com>

[ Upstream commit 635ddb8ccdbde0d917b0a7448b0fd9d6cc27a2a9 ]

The usb_register() function can fail and returns an error value which
is not returned. The function gpib_register_driver() can also fail
which can result in semi-registered module.

In case gpib_register_driver() fails unregister the previous usb driver
registering function. Return the error value if gpib_register_driver()
or usb_register() functions fail. Add pr_err() statements indicating the
fail and error value.

Signed-off-by: Nihar Chaithanya <niharchaithanya@gmail.com>
Link: https://lore.kernel.org/r/20241230185633.175690-14-niharchaithanya@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a239c6e91b66 ("staging: gpib: Fix Oops after disconnect in ni_usb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/ni_usb/ni_usb_gpib.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
index 70b8b305e13b6..3c4132fd6de95 100644
--- a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
+++ b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
@@ -2619,12 +2619,23 @@ static struct usb_driver ni_usb_bus_driver = {
 static int __init ni_usb_init_module(void)
 {
 	int i;
+	int ret;
 
 	pr_info("ni_usb_gpib driver loading\n");
 	for (i = 0; i < MAX_NUM_NI_USB_INTERFACES; i++)
 		ni_usb_driver_interfaces[i] = NULL;
-	usb_register(&ni_usb_bus_driver);
-	gpib_register_driver(&ni_usb_gpib_interface, THIS_MODULE);
+
+	ret = usb_register(&ni_usb_bus_driver);
+	if (ret) {
+		pr_err("ni_usb_gpib: usb_register failed: error = %d\n", ret);
+		return ret;
+	}
+
+	ret = gpib_register_driver(&ni_usb_gpib_interface, THIS_MODULE);
+	if (ret) {
+		pr_err("ni_usb_gpib: gpib_register_driver failed: error = %d\n", ret);
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.39.5



