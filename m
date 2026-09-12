Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90EB38B7D2;
	Sat, 12 Sep 2026 10:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207411; cv=none; b=iUV7h5TNHjkrLGBGtf37atV3PrxjA/DdcyOV+GnTHldEEnEXH5qdWYjZ612M/5YNtADkEIes78ZqV1WC6/HDzIFmTn8OwNPphVTFNiVoNZE3e1zaANeQGnfmk29dAdjyw2T99B+AlDAfG4+Kcv+XJ3L0k3ITEdFd4MSE95NkYYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207411; c=relaxed/simple;
	bh=TEpcq+0ENPsyv7oyPD3ue4KhbCduywRjUxa41fr8ar0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/Pum6WKN+sHfT0yAKgD2zzsSiZ/3QKbDrVnNqH15EURrS0LmznECnC9PfgQhyuusT/x2jV63k+OEEmPKApIMaxKAE/TRaxo6iTW2S/RhSiyXmPnCqSEmy/9bzY6EwZZ1JSA60lK5audOZr/+8Uq8nDI2n9TM3KFEc2UPyBI4cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EaS6YUn1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EaS6YUn1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41031F000FF;
	Sat, 12 Sep 2026 10:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207409;
	bh=sR4brNPWMJjmXnJIhum3KDrbGJFjAZkh14UNJl4eH34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EaS6YUn1mQMyxI5HHUBsNFssoJbrdF+QptOG2vQJq9ta39eh2PBRGVlPHMVHt/NuH
	 k9NaosL8Gq92NcSYL34/c4iwc5Opx81d0iFImWnI8dS+M5wHjqnC75Xh2Z83FSE2fA
	 4WZkozPI3aSiw0CE39iz/KnjZVxOphjtB2h2QnnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guzebing <Guzebing1612@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0370/1518] cxl/memdev: Fix firmware upload exact-fit handling
Date: Sat, 12 Sep 2026 08:42:19 +0200
Message-ID: <20260912065631.838293899@linuxfoundation.org>
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

From: Guzebing <Guzebing1612@gmail.com>

[ Upstream commit af5035e1b3e400067bb003975936e5407377e7a3 ]

cxl_fw_prepare() classifies a firmware image as a one-shot transfer
only when its Transfer FW input payload is smaller than the mailbox
payload size. An image that exactly fills the payload is therefore
treated as a multi-part transfer.

The firmware loader invokes cxl_fw_write() only once for that image.
Since both offset == 0 and remaining == 0, the multi-part action
selection sends INITIATE, never sends END, and then attempts to activate
the target slot.

Include equality in the one-shot classification so exact-fit images use
the FULL action.

Fixes: 9521875bbe00 ("cxl: add a firmware update mechanism using the sysfs firmware loader")
Signed-off-by: Guzebing <Guzebing1612@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260713112744.2543829-1-guzebing1612@gmail.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/memdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 4dff7f44d908e..3bb5835aa548e 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -870,7 +870,7 @@ static enum fw_upload_err cxl_fw_prepare(struct fw_upload *fwl, const u8 *data,
 	if (!size)
 		return FW_UPLOAD_ERR_INVALID_SIZE;
 
-	mds->fw.oneshot = struct_size(transfer, data, size) <
+	mds->fw.oneshot = struct_size(transfer, data, size) <=
 			    cxl_mbox->payload_size;
 
 	if (cxl_mem_get_fw_info(mds))
-- 
2.53.0



