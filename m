Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A854B4F5DF0;
	Thu, 17 Sep 2026 17:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665730; cv=none; b=gRvOnNZvxNdTWqtKw0ltlwo4Jik9WUHaRoqIt84zWu1TPTCyS4pzjKc26q7W6mPcshpolW2UQIpbualekYr6ddxxA+MOV7w6YQ7fuYVWZuqWnfdB9G6PP3Jl70wjkKG8bKfmv9Eh4TmEnAdrmJ8PMfgjvDXpxPulRrgHucShqX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665730; c=relaxed/simple;
	bh=2t9cib7hYDU34gIigHWP/XP5EXnU7yyDOKD+ePsVHuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUanIchsf8pb+2Whq2lkfbyoMHiobGfIuCe4fEhuXfe8lmQY4yHMrxHwYu+W4mXMxa0w2+KCSbrngZ4DM7iCj7XKtyxlA8i5j3wnJD5Apv6XtJTwb7/H/sIBCGJAA4X7r5U/hhH1IYK4676vozin7cHX4omZOOVbKHVfrDfn/qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4riz4GJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4riz4GJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3091F000FF;
	Thu, 17 Sep 2026 17:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665729;
	bh=dQ0xtvw/+i5BumwAozQGuvNrAa7n67mKu7NKFJqn0/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4riz4GJLj5e2y82EY0sMyDK9Cwttbs8hvYXmvDPYqv9qRyWGECvrrBLF29NO84WG
	 KOWsO1ZkdtcOi3mqpkTeG/X5MW3s0VxjRP9ajTFXYZ7SNu9GDLCCFHHqDHJbzovauU
	 IRy6mYTKqsfQisJNlnLKz/4M6DPYu7VxLKY3JyK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0801/1250] s390/ism: folio_put() after error
Date: Thu, 17 Sep 2026 16:09:56 +0100
Message-ID: <20260917151613.618178172@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index b842410cf41cc..da1e0baacc067 100644
--- a/drivers/s390/net/ism_drv.c
+++ b/drivers/s390/net/ism_drv.c
@@ -232,6 +232,7 @@ static void ism_free_dmb(struct ism_dev *ism, struct dibs_dmb *dmb)
 	dma_unmap_page(&ism->pdev->dev, dmb->dma_addr, dmb->dmb_len,
 		       DMA_FROM_DEVICE);
 	folio_put(virt_to_folio(dmb->cpu_addr));
+	dmb->cpu_addr = NULL;
 }
 
 static int ism_alloc_dmb(struct ism_dev *ism, struct dibs_dmb *dmb)
@@ -275,7 +276,8 @@ static int ism_alloc_dmb(struct ism_dev *ism, struct dibs_dmb *dmb)
 	return 0;
 
 out_free:
-	kfree(dmb->cpu_addr);
+	folio_put(folio);
+	dmb->cpu_addr = NULL;
 out_bit:
 	clear_bit(dmb->idx, ism->sba_bitmap);
 	return rc;
-- 
2.53.0



