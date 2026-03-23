Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D27923D288;
	Mon, 23 Mar 2026 14:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277166; cv=none; b=h/o0plxNUWmf3XySSz/XtJk3zXqsnK67KIIKf2+NxT9jAzb2bRdyJM5g/6g79wIbcYvxoijbgoP8I9S3RfXKPGU0KOoowzFwAeH7gjK7k0aMw55MpO8Kgzryqf+mzxPDKhb9E5jyPqk2pUbSDs+pm9qzNHENEsvVs7ETU7NzrxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277166; c=relaxed/simple;
	bh=FEwdjA4xqf46dkA04vW9tctU0IS2OefHOmv3mv65hrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qix1W4FD4wRuHrqtsCWZPw/dRBRxXvggBcIQK0rmM73CGSlUfa0dQjyZiLQgMzhuqVjRICzRWupxsrv6BLryoHjEsiCgFYcDox1wfEaoPrYjoDXQsIMA2hlM0vxeGXrfdxylSaFbPGdbZk+bMTGv4++3QVU4mCW0EpgWhsLdY/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aAduL9oJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aAduL9oJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C836AC2BCB1;
	Mon, 23 Mar 2026 14:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277166;
	bh=FEwdjA4xqf46dkA04vW9tctU0IS2OefHOmv3mv65hrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aAduL9oJbFCLv/lxOaIyR44W8IpIiejXplw9Dr3rmybhFe4D4CYTR8GiXSdbP8Tzy
	 +iEAsbV7sYp4j6NAzpFJAnHjx7VZx5BIsk93/7gmVRr3DJkCZeetJyWj4ih8NY8TLQ
	 lcJUa4v8dwTWPej2Bgl5hgLDJH5L1ne6vnkxVm5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanghui Feng <guanghuifeng@linux.alibaba.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.12 343/460] iommu/vt-d: Fix intel iommu iotlb sync hardlockup and retry
Date: Mon, 23 Mar 2026 14:45:39 +0100
Message-ID: <20260323134534.967686282@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1313,7 +1313,6 @@ static int qi_check_fault(struct intel_i
 	if (fault & DMA_FSTS_ITE) {
 		head = readl(iommu->reg + DMAR_IQH_REG);
 		head = ((head >> shift) - 1 + QI_LENGTH) % QI_LENGTH;
-		head |= 1;
 		tail = readl(iommu->reg + DMAR_IQT_REG);
 		tail = ((tail >> shift) - 1 + QI_LENGTH) % QI_LENGTH;
 
@@ -1330,7 +1329,7 @@ static int qi_check_fault(struct intel_i
 		do {
 			if (qi->desc_status[head] == QI_IN_USE)
 				qi->desc_status[head] = QI_ABORT;
-			head = (head - 2 + QI_LENGTH) % QI_LENGTH;
+			head = (head - 1 + QI_LENGTH) % QI_LENGTH;
 		} while (head != tail);
 
 		/*


