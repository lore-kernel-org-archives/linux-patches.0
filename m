Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B863D092F;
	Wed, 30 Sep 2026 19:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795249; cv=none; b=C7RyeUSMptn4RVZaC+Ej+gvaaNLp5aYtPFAoou2+amoFVJ1OTJqYsGOv0wA+/J6jAI0I9N/simG3FMUBQqxgOgM0vkdtrFxCx1zIO+Hz+eAHor7waPyv9/sUXIYMaesd58U9gRezEkxnsPOQt7jjIXlgDq8TqTVmdKGFceIU99Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795249; c=relaxed/simple;
	bh=LdIB3YtGiP9IU5ESubaOfgqizMe012iF6ngkNeIqZXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFhvI2AatXL/gjlUF1fvLHic1Lk/375EcvUeHu7/C0PbiFzyvhTFww6cbfBGTMtcHyPPVTV2sTAgwGhKKWzBaMvp4gWfWlr2qF3JlMxL2mr1///d20DJ1IB2wRlzxA+cLU7VTTHsdKl+TG86G0x3yaiQITzFWjpBPg8Z8l4F9jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8naSKxw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8naSKxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8255D1F000FF;
	Wed, 30 Sep 2026 19:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795248;
	bh=vPyLfJmgivtR67r4GfLJcIg2PNm+r2Zenvf648zfFoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y8naSKxwkUqe3rwwwW3BHThY/jehkexz1WOYc0DrVYWUckFX1XoP8UYwZ9RNIrnDr
	 CKEV71ZWWr4edEALEK51ISIdlOkXTVhNeRPXHE6TYE76nJW3ow7C0nkE2nvFO3MZg6
	 rY414FfrMxzYhsV78aihC+hO/uvf9Ev5a+Uk6bi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0495/1193] s390/ism: folio_put() after error
Date: Wed, 30 Sep 2026 17:19:39 +0200
Message-ID: <20260930152445.151149760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit 907a56ab3eb8a58500a58daa76087f17bb2b6826 ]

dmb->cpu_addr was allocated via folio_alloc(). Use folio_put() instead of
kfree() in the error exit of ism_alloc_dmb() to avoid slab allocator
corruption.

While at it, reset dmb->cpu_addr after folio_put to avoid unintentional UAF
by future callers.

Fixes: 83781384a96b ("s390/ism: Properly fix receive message buffer allocation")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Link: https://patch.msgid.link/20260902143733.433574-1-wintera@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/ism_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/net/ism_drv.c b/drivers/s390/net/ism_drv.c
index 76ba36c83e522..950f45ff8217b 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -296,6 +296,7 @@ static void ism_free_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 	dma_unmap_page(&ism->pdev->dev, dmb->dma_addr, dmb->dmb_len,
 		       DMA_FROM_DEVICE);
 	folio_put(virt_to_folio(dmb->cpu_addr));
+	dmb->cpu_addr = NULL;
 }
 
 static int ism_alloc_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
@@ -339,7 +340,8 @@ static int ism_alloc_dmb(struct ism_dev *ism, struct ism_dmb *dmb)
 	return 0;
 
 out_free:
-	kfree(dmb->cpu_addr);
+	folio_put(folio);
+	dmb->cpu_addr = NULL;
 out_bit:
 	clear_bit(dmb->sba_idx, ism->sba_bitmap);
 	return rc;
-- 
2.53.0



