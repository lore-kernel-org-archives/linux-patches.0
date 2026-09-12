Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE6C2E718B;
	Sat, 12 Sep 2026 07:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198448; cv=none; b=CoycicYBC6tjqSahGzQszldnX/bovnNad046D8Xoyaygp4khCD4mcECFOM9KwnV2OJ8XdQgQna4sUqRxMl7Yb8EsT3PpzwnXSc/RTlkzLOyeMQqp1yMO+HZq+xL2mBsyMFQGGgy6MPQeji5tOtfFc1CTJtaHYYvHvW131hgTT94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198448; c=relaxed/simple;
	bh=tQWi2iamtsoX7igyLmba+XTsJ/j7s9JTGnXMgMg/VDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YduTuQA1ch1WJdTyEODlp9H5NThGm1GZH9h5fNNE8z8w74dDz0VjLqEo2KulfQaLTSfUVEeD2UEU/+zOXOV3H2KAXcXzS7MjbSM+Tp/5KvZb23OYQcrsnNWdBUxrqgtHG7zXmmXZlgrC1sz4Vx4Qccs7fSxNUJjCOUv/TAhPEEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1imCsku4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1imCsku4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E5B1F000FF;
	Sat, 12 Sep 2026 07:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198447;
	bh=4b9ipL1W9HxnQ9SdQHicAQy2e8gDL/6pzd1slwiCBkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1imCsku4gv9METr3DDOhVo1tKylfuYtB8frjLYslTt8G4P9nCC2G7U5RN3jDqYwPx
	 h7S2M8VzG7tCwSESONJITloypvg+LRNBVP3Ao4XCfExWtCph7yLNSp7Qy28BROpwyN
	 7H7c52WwOodvKXvWBC50gp+N1QnZCrY+SVU1A5W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guzebing <Guzebing1612@gmail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0382/1815] cxl/memdev: Fix firmware upload exact-fit handling
Date: Sat, 12 Sep 2026 08:35:32 +0200
Message-ID: <20260912065657.865343378@linuxfoundation.org>
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
index 33a3d2e7b13af..45e7d2be17e09 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -921,7 +921,7 @@ static enum fw_upload_err cxl_fw_prepare(struct fw_upload *fwl, const u8 *data,
 	if (!size)
 		return FW_UPLOAD_ERR_INVALID_SIZE;
 
-	mds->fw.oneshot = struct_size(transfer, data, size) <
+	mds->fw.oneshot = struct_size(transfer, data, size) <=
 			    cxl_mbox->payload_size;
 
 	if (cxl_mem_get_fw_info(mds))
-- 
2.53.0



