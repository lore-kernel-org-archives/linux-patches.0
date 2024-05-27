Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA0E168C4;
	Mon, 27 May 2024 19:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837927; cv=none; b=Drcm5Kdx1LTHpt6FOV+piq6KkfDeE8ifwjOdT3o07Cwu3z/LWh7NFM+MlYzJx758vLXZOn7APBMcCIRJ3KpYxwRlViq+VDjwqGDpWfH3do7roPLYAhMgQ4sNGEPqY20UwJOd3ZCjnKd4pEwNLdrbsOIeTaFn++eqKvOaZZOI8dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837927; c=relaxed/simple;
	bh=Rxaapfwkl+98FrWVwy0tSXvKAWuvUP0hvDeWxIFBoHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0sTyQsIR8hGuy+U5qnwUj2Yn72UST1azv1aMutwdidVWaBGm391mwPEv6vg2iOWaQGiMJ4lTl/5v7sIYjBHiPGu8xzBRM9EtEul2cfmbNsDu9AVSwW5Wzon/OK9WjF8gB/OSj/KZvgoCPjBRzM8otf/I1vouzNFRd3S0+o8pt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iY6PMzOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iY6PMzOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 153AEC2BBFC;
	Mon, 27 May 2024 19:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837927;
	bh=Rxaapfwkl+98FrWVwy0tSXvKAWuvUP0hvDeWxIFBoHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iY6PMzOGTcFD8KXPe3lJqpGExvUYW25VTPPpB3G7LpSHURhrULke2AY8cxLrCnFjY
	 HrTJzcdW33Nih0eOps/caWqvXZxbCdOFs/loKS0J/kQRoYHCbD6Jy7hFXbNS4KvKbd
	 cK89tydcNltCkkNVVXYEh3NJaEgjhy/zJBx8OJjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 199/493] scsi: ufs: cdns-pltfrm: Perform read back after writing HCLKDIV
Date: Mon, 27 May 2024 20:53:21 +0200
Message-ID: <20240527185636.851435614@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Halaney <ahalaney@redhat.com>

[ Upstream commit b715c55daf598aac8fa339048e4ca8a0916b332e ]

Currently, HCLKDIV is written to and then completed with an mb().

mb() ensures that the write completes, but completion doesn't mean that it
isn't stored in a buffer somewhere. The recommendation for ensuring this
bit has taken effect on the device is to perform a read back to force it to
make it all the way to the device. This is documented in device-io.rst and
a talk by Will Deacon on this can be seen over here:

    https://youtu.be/i6DayghhA8Q?si=MiyxB5cKJXSaoc01&t=1678

Let's do that to ensure the bit hits the device. Because the mb()'s purpose
wasn't to add extra ordering (on top of the ordering guaranteed by
writel()/readl()), it can safely be removed.

Fixes: d90996dae8e4 ("scsi: ufs: Add UFS platform driver for Cadence UFS")
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
Link: https://lore.kernel.org/r/20240329-ufs-reset-ensure-effect-before-delay-v5-6-181252004586@redhat.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/cdns-pltfrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/cdns-pltfrm.c b/drivers/ufs/host/cdns-pltfrm.c
index bb30267da4711..66811d8d1929c 100644
--- a/drivers/ufs/host/cdns-pltfrm.c
+++ b/drivers/ufs/host/cdns-pltfrm.c
@@ -136,7 +136,7 @@ static int cdns_ufs_set_hclkdiv(struct ufs_hba *hba)
 	 * Make sure the register was updated,
 	 * UniPro layer will not work with an incorrect value.
 	 */
-	mb();
+	ufshcd_readl(hba, CDNS_UFS_REG_HCLKDIV);
 
 	return 0;
 }
-- 
2.43.0



