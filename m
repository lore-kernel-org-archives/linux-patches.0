Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2BB33E372;
	Tue, 31 Mar 2026 16:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975495; cv=none; b=F5DSmn+EbOskyVCjjft/FaDHadBUfVcm81yssQqMTPVw72SWsE5TyaXG4JDCn5uPhEoSugWkwt+GEbP0jcWlq+TkQhGHH6lXoJZjkG/dXTqmViANRRdHn6fjiL7YeOK6MV0VzLuspOFlUY77YJXAe/oZ0z+9MqlaUxvOKQF5YcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975495; c=relaxed/simple;
	bh=12eDt66OUjnvm+frkEYHjz4jt/theeMsKqo0RdjxJvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+O8JfUyfVncUfxI2ZuboFHfVBXmwzNM4iCf8088Jg+9bxP1OAKTylYsu0zVn+H+6mX1Zmp+2bGCqiyEJS+uq1wLfNlWmlqbVo84LTUCjScJtpJAkYbW/GBGE0yLVFgRUKs5pJKRNZMHjgOQnpm+PYtTcrZrtKKCkW3KYYJ93KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlxyBvL8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlxyBvL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21444C19423;
	Tue, 31 Mar 2026 16:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975495;
	bh=12eDt66OUjnvm+frkEYHjz4jt/theeMsKqo0RdjxJvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlxyBvL8R5mMbWo+2m6tNwCmo68yO7RFmGsmwuQjE01DJkFBBLxrCdSknaPUupXHA
	 O2fzJ6UM4X8uYBX/mVL5Tbsta1pdqLeyph9Ji4NCemkeZrJuo5Ki4DbOSDSTie9pUZ
	 Q+2rqjiYkKLK/9tAiEPjIE1CvSbnRkuoP9U8MPCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 318/342] dmaengine: idxd: Fix leaking event log memory
Date: Tue, 31 Mar 2026 18:22:31 +0200
Message-ID: <20260331161810.619438719@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit ee66bc29578391c9b48523dc9119af67bd5c7c0f ]

During the device remove process, the device is reset, causing the
configuration registers to go back to their default state, which is
zero. As the driver is checking if the event log support was enabled
before deallocating, it will fail if a reset happened before.

Do not check if the support was enabled, the check for 'idxd->evl'
being valid (only allocated if the HW capability is available) is
enough.

Fixes: 244da66cda35 ("dmaengine: idxd: setup event log configuration")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://patch.msgid.link/20260121-idxd-fix-flr-on-kernel-queues-v3-v3-10-7ed70658a9d1@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index a7ecc17442354..4013f970cb3b2 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -833,10 +833,6 @@ static void idxd_device_evl_free(struct idxd_device *idxd)
 	if (!evl)
 		return;
 
-	gencfg.bits = ioread32(idxd->reg_base + IDXD_GENCFG_OFFSET);
-	if (!gencfg.evl_en)
-		return;
-
 	mutex_lock(&evl->lock);
 	gencfg.evl_en = 0;
 	iowrite32(gencfg.bits, idxd->reg_base + IDXD_GENCFG_OFFSET);
-- 
2.53.0



