Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62142402435;
	Tue, 31 Mar 2026 16:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975490; cv=none; b=Ijfmhc3rktc87kKcvvmQ2jbPy5QmaXiEWOtYHOXIVcyXfnpgCKSiztEgjiV8ALTcc2fZi4wXD4f8GPCo3kdAjlGU1B6ic7pLmDFwV8laFpiS4u0GSLVKv5tk75yDOrGpQFg8PpP5nMPEW9a096WfDq3X2uwWsXHYS5yp56JhRpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975490; c=relaxed/simple;
	bh=TNFZXlzJ6zxy+UlFJ6gEdCgTXZH7yBxFVlRV1O+HceE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOCCWTudJ/n8EmQyhVSLUbwXerEq5NmVikhrIc9dhYKgOlmGwNlYygl3eJmYkRts/D4sksoelJ7wu5n9sM6t6Rstxqk0TbE+pw6vmyga+h9V13q8h7nfH5MTk/6SW66LAC7wNZuFNJAVisP8PxYI/MDWRk54WoJAm/1RzcgBNLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHXo2cJH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHXo2cJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17F4C2BCB1;
	Tue, 31 Mar 2026 16:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975490;
	bh=TNFZXlzJ6zxy+UlFJ6gEdCgTXZH7yBxFVlRV1O+HceE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHXo2cJH3OT6b281Ek5bYJLSBnviz4QqfhClc4UOkg/KwIr1KcQRuuDK9r1Dzo2St
	 TjJqyJ0LQf+i8gsqFPXsPbPuZWccWPKp+n3YfDfMfmq5pa8JO+Hj6ZjRqu8IqNFfgW
	 WNUFDeJnWUXl08NKR/uXW7nKGwm54DJ1ZlSqAexo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 316/342] dmaengine: idxd: Fix memory leak when a wq is reset
Date: Tue, 31 Mar 2026 18:22:29 +0200
Message-ID: <20260331161810.548876183@linuxfoundation.org>
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

[ Upstream commit d9cfb5193a047a92a4d3c0e91ea4cc87c8f7c478 ]

idxd_wq_disable_cleanup() which is called from the reset path for a
workqueue, sets the wq type to NONE, which for other parts of the
driver mean that the wq is empty (all its resources were released).

Only set the wq type to NONE after its resources are released.

Fixes: da32b28c95a7 ("dmaengine: idxd: cleanup workqueue config after disabling")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Link: https://patch.msgid.link/20260121-idxd-fix-flr-on-kernel-queues-v3-v3-8-7ed70658a9d1@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/device.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index f9e49c5545f65..a7ecc17442354 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -175,6 +175,7 @@ void idxd_wq_free_resources(struct idxd_wq *wq)
 	free_descs(wq);
 	dma_free_coherent(dev, wq->compls_size, wq->compls, wq->compls_addr);
 	sbitmap_queue_free(&wq->sbq);
+	wq->type = IDXD_WQT_NONE;
 }
 EXPORT_SYMBOL_NS_GPL(idxd_wq_free_resources, "IDXD");
 
@@ -382,7 +383,6 @@ static void idxd_wq_disable_cleanup(struct idxd_wq *wq)
 	lockdep_assert_held(&wq->wq_lock);
 	wq->state = IDXD_WQ_DISABLED;
 	memset(wq->wqcfg, 0, idxd->wqcfg_size);
-	wq->type = IDXD_WQT_NONE;
 	wq->threshold = 0;
 	wq->priority = 0;
 	wq->enqcmds_retries = IDXD_ENQCMDS_RETRIES;
@@ -1531,7 +1531,6 @@ void idxd_drv_disable_wq(struct idxd_wq *wq)
 	idxd_wq_reset(wq);
 	idxd_wq_free_resources(wq);
 	percpu_ref_exit(&wq->wq_active);
-	wq->type = IDXD_WQT_NONE;
 	wq->client_count = 0;
 }
 EXPORT_SYMBOL_NS_GPL(idxd_drv_disable_wq, "IDXD");
-- 
2.53.0



