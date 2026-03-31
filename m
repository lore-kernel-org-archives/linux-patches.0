Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CE133E372;
	Tue, 31 Mar 2026 16:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975485; cv=none; b=o4jkAwLDT9rj9UvJZXHOAYe0MKdzc38I4gbq4dN5JdQcHUeUXLNp4xgM9k0FAGxIBcO+YwDhbmOJg2O1nJrmXRt5+DRmZWn9vw2CltDDXvWffg+MoKnNco5JUYQJIBu7CrW7FeV3WkXKTTEiqD/oJG7sVdzFi1HgCFCNlTwYNYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975485; c=relaxed/simple;
	bh=TgpmOkgM9Yeuf5ZR93+sqYvyd/O4YAnduhgx7BHAQA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l938riLcFBI9Mb6OdviN/XN96d7tl4ysTWs6+0DyrkbO1ha1AqGpRmrDxqRmRXRyCm6gVomdVwXGA8+gQUPMyLF4pSoOTBSvu7Q8HLvv8m3LePQDQ6N4bxwSmi/TiLpGIyvV7WZNdWytZEv1C37KqlHScdeW6uJ4GdouZ6dnBv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFo+7NdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFo+7NdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3187C19423;
	Tue, 31 Mar 2026 16:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975485;
	bh=TgpmOkgM9Yeuf5ZR93+sqYvyd/O4YAnduhgx7BHAQA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFo+7NdHQ779hBw1lNZGYyz1Z1nl1Rv4QkI7iByBdNp4YGASm2Y0u5Tmb8dwIF4A/
	 I4gajQt3QhjE3Emt/xHmBQ/L044QrEdVA4rSEyiAEDiMAGoSu+NYLllNmOJgEm4Bxn
	 bym+XAKNhfRj3zngMdWgMyrmGF9tX2QU4Wk/NztI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 314/342] dmaengine: idxd: Fix possible invalid memory access after FLR
Date: Tue, 31 Mar 2026 18:22:27 +0200
Message-ID: <20260331161810.477764172@linuxfoundation.org>
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

[ Upstream commit d6077df7b75d26e4edf98983836c05d00ebabd8d ]

In the case that the first Function Level Reset (FLR) concludes
correctly, but in the second FLR the scratch area for the saved
configuration cannot be allocated, it's possible for a invalid memory
access to happen.

Always set the deallocated scratch area to NULL after FLR completes.

Fixes: 98d187a98903 ("dmaengine: idxd: Enable Function Level Reset (FLR) for halt")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://patch.msgid.link/20260121-idxd-fix-flr-on-kernel-queues-v3-v3-3-7ed70658a9d1@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 449424242631d..f2b37c63a964c 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -1137,6 +1137,7 @@ static void idxd_reset_done(struct pci_dev *pdev)
 	}
 out:
 	kfree(idxd->idxd_saved);
+	idxd->idxd_saved = NULL;
 }
 
 static const struct pci_error_handlers idxd_error_handler = {
-- 
2.53.0



