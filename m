Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A32313298;
	Mon, 13 Apr 2026 16:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099021; cv=none; b=OUgz70RQp0XVUMcepJ7Q5fqejgNlFqKYtHfghBuAwyD2XB0XEnSLQA1PbaGacQtOKh7lsEwUh1iQHqviGs4aMTRX5+kfyZevh4ZI+rSofgsMyqGKCbD0blp5s4hEStutNGEU1Yb8lH/IXpqnC9UjZ3s9WF2blyFTRI/ehFx/ruA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099021; c=relaxed/simple;
	bh=eeXQc0Xs36KsCJ+myTKNyOqBo/VeeTDRDchysJQqh8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYZZkPtnp7FyA0o4nfbIfE4sCMI02GtmP0eljQEpDB2JxhH4E/QKcbK6t11uxJM1T8zglSQx7QYGGA8DBEleMf0ubpGiPuNPRES/M0MdP1G0E+5YbLJc//FozoNkVaUd0qS907PpFH4Wyroy4W6zgVNlWpUorCCXZKn0IcFvzbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHp0JdCX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHp0JdCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B3FC2BCAF;
	Mon, 13 Apr 2026 16:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099021;
	bh=eeXQc0Xs36KsCJ+myTKNyOqBo/VeeTDRDchysJQqh8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHp0JdCXUU7ov/qmfa8I8YRye+9i5bSJECq1vxJswczP2WfwJS1Eb9r0epXziQARu
	 n9EVj/hqxujb8IugZpBc0QBw/QEtvNLICt4Xl06PZo4Ve7lNLCdtG1xmgF8hQjOkxt
	 Summz74i7hUq8AFoful5y/Xhyn5MMdepLDL2nkLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5.10 147/491] iommu/vt-d: Fix intel iommu iotlb sync hardlockup and retry
Date: Mon, 13 Apr 2026 17:56:32 +0200
Message-ID: <20260413155824.537570895@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanghui Feng <guanghuifeng@linux.alibaba.com>

commit fe89277c9ceb0d6af0aa665bcf24a41d8b1b79cd upstream.

During the qi_check_fault process after an IOMMU ITE event, requests at
odd-numbered positions in the queue are set to QI_ABORT, only satisfying
single-request submissions. However, qi_submit_sync now supports multiple
simultaneous submissions, and can't guarantee that the wait_desc will be
at an odd-numbered position. Therefore, if an item times out, IOMMU can't
re-initiate the request, resulting in an infinite polling wait.

This modifies the process by setting the status of all requests already
fetched by IOMMU and recorded as QI_IN_USE status (including wait_desc
requests) to QI_ABORT, thus enabling multiple requests to be resubmitted.

Fixes: 8a1d82462540 ("iommu/vt-d: Multiple descriptors per qi_submit_sync()")
Cc: stable@vger.kernel.org
Signed-off-by: Guanghui Feng <guanghuifeng@linux.alibaba.com>
Tested-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Link: https://lore.kernel.org/r/20260306101516.3885775-1-guanghuifeng@linux.alibaba.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Fixes: 8a1d82462540 ("iommu/vt-d: Multiple descriptors per  qi_submit_sync()")
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/dmar.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1243,7 +1243,6 @@ static int qi_check_fault(struct intel_i
 	if (fault & DMA_FSTS_ITE) {
 		head = readl(iommu->reg + DMAR_IQH_REG);
 		head = ((head >> shift) - 1 + QI_LENGTH) % QI_LENGTH;
-		head |= 1;
 		tail = readl(iommu->reg + DMAR_IQT_REG);
 		tail = ((tail >> shift) - 1 + QI_LENGTH) % QI_LENGTH;
 
@@ -1252,7 +1251,7 @@ static int qi_check_fault(struct intel_i
 		do {
 			if (qi->desc_status[head] == QI_IN_USE)
 				qi->desc_status[head] = QI_ABORT;
-			head = (head - 2 + QI_LENGTH) % QI_LENGTH;
+			head = (head - 1 + QI_LENGTH) % QI_LENGTH;
 		} while (head != tail);
 
 		if (qi->desc_status[wait_index] == QI_ABORT)


