Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78AD4BEE43;
	Sat, 12 Sep 2026 16:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229959; cv=none; b=unDeOHIscBRXIWz6JxxjPaEeuhrw/gl7YzDpc8w2vAqNFmis5XGgF+KM92d6hMgBrb1Gv5MFhr7R1lpXhfTx3cixINlyDTNUH9DUljxVf9IrZD8tFhFOm5v3u+XuromNDMQk1yQvGf0eKaNUNLG9vKX8+DsTnCtcJAegCTXSP4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229959; c=relaxed/simple;
	bh=pSCaYTCO5xyMGj/OlZCYykURjoniy0bvAaMWmsh0A/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1FHWIb2ZnqH481DwD0QE6mmb5PoIS1ycwTCp7M/bv33cj2OwTj8sV+eNj8hDBjxLgJMKEFjpDTD1fpeHkVKeNVk3/iIUT/kOB/GyK2KW69t4v+/V3hJeWmQFBz+LsSRySXlJG8JRYlQ4PCbxdRBTkntEXSQM384KGjNmlcOyZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wqor5tgq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wqor5tgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B981F000FF;
	Sat, 12 Sep 2026 16:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229957;
	bh=U+2EA2uIJcUj7ulqGMyIAuBrvHgGrwsYhds7mUEFbeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wqor5tgqrDdxmwYwDjFMcgZ26M1uRGioME2bz25SAVSqLdxzHk95l/xFi4DbCCOix
	 jCiUb741Gez54xBi9WIRz3AbZiTIuEQlgcj5GLb+THHZSuu6KZdk4O+OmGPAAMjOlo
	 /0y1c76a7A7QU88s3yTLJvukx/WnGE2Drtleo5GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0653/1191] char: xilinx_hwicap: unregister class on init errors
Date: Sat, 12 Sep 2026 08:56:21 +0200
Message-ID: <20260912065602.923597337@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 74a4928aea1d3..b691eba3912bb 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -864,7 +864,7 @@ static int __init hwicap_module_init(void)
 					HWICAP_DEVICES,
 					DRIVER_NAME);
 	if (retval < 0)
-		return retval;
+		goto failed_class;
 
 	retval = platform_driver_register(&hwicap_platform_driver);
 	if (retval)
@@ -875,6 +875,9 @@ static int __init hwicap_module_init(void)
  failed:
 	unregister_chrdev_region(devt, HWICAP_DEVICES);
 
+ failed_class:
+	class_unregister(&icap_class);
+
 	return retval;
 }
 
-- 
2.53.0



