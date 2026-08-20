Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0C235C1A6;
	Thu, 20 Aug 2026 15:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238944; cv=none; b=sFZOkvJw/WkY22iWGELS523q24NE7ukigOkcsoc3UNui4ji7+XuJyhO9OppbhaGpjjVwhVitpljwwhOm2mhIphN95KRB+wmPXkFAbryaQZUCqaT9ljboxqm5bmWs7AEJgAQSNVUwQHERRyOiRmaz2HAui9SHfMqJOGLIK8xkAJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238944; c=relaxed/simple;
	bh=KCNmKG2hsrCvT8OqO2N19UCUa4dfUHLUfbUcXYZsjH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaGYyeqB5OvjT1thzZ/ffUI0/OoNrY+JgD9ZvD7uvrQc7glhAowuGRk0y6WJHXF/QDIUkLyO8+zeQCFjKeaSVxE5cdB9GHjazLI8r7YwkdKLDIoKypdJHd80fInMIYvj6Bog90VeYkBImB7bdI2+XTRubWsl0vTS8SNi8GWwuhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0iLENBy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0iLENBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4001F000E9;
	Thu, 20 Aug 2026 15:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238943;
	bh=iW+SXSxbMD6MobZI40CT0U456Y/kisVRoy75edPIMHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k0iLENByEpo3mNq6/sNSxfPw2+kMjt9eFg02ptpATZ90usr6tVTjZJr0HXDZJQg2B
	 NjtmTwRV6ylJqVsk2Xj/FeZLPeXhuk2GY5QklkiQhkuwf/glVqZmc/nUHh1J7MHCsI
	 zfnWSBPYODwM+BLDXpKmXBSlHf27yp36ysyG4lG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 6.18 078/217] eth: bnxt: make sure we populate the qcfg defaults on old FW/HW
Date: Thu, 20 Aug 2026 16:54:06 +0200
Message-ID: <20260820145239.974845361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

commit 3cf48c04966e1945de6c89bc9c0746ace2e7ddec upstream.

The driver now depends on the core to tell it what the rx page size
should be for the agg ring. We must populate the ndo_default_qcfg
callback even if we don't support any queue ops.

This fixes:
  Oops: divide error: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN
  RIP: 0010:bnxt_alloc_rx_page_pool (drivers/net/ethernet/broadcom/bnxt/bnxt.c:3852)

with fw version 225.1.109.0.

Link: https://lore.kernel.org/20250421222827.283737-20-kuba@kernel.org
Fixes: f96e1b35779e ("eth: bnxt: support qcfg provided rx page size")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260128193258.125274-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Max Kellermann <max.kellermann@ionos.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16326,6 +16326,7 @@ static const struct netdev_queue_mgmt_op
 };
 
 static const struct netdev_queue_mgmt_ops bnxt_queue_mgmt_ops_unsupp = {
+	.ndo_default_qcfg	= bnxt_queue_default_qcfg,
 };
 
 static void bnxt_remove_one(struct pci_dev *pdev)


