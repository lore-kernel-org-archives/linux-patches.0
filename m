Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3826423F42D;
	Tue,  6 Jan 2026 17:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721914; cv=none; b=EkmKLJ6xD5it+lvoj9a4jcTkIuPNUcT3CLZdQA8lhrEEYxmY9GUbx8/QYpp7qLVN9IlVECSpKXeQbM37Mtj8hHGMmt0RAHj51Ec5R3A7xTNLBQ803pTLqUroYUCxWAR5UWsQL5exbSlZwyyf6AfxapBsqrCCMVzTwzvj1U0ayGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721914; c=relaxed/simple;
	bh=1yMZ/442irs62YVRl4oOMjEFKk550rE4r6Ww6FwZJB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEY/nuIn6onSCqboaByIaC4cId1CelcQ8kfpFTwxso3Y8bHZf7Yk7Ei3wmH3qEKMP0dFCfz/rQWGGccODlN3xRQh/srOI9bJNbuQMtApohdlOurtG6GLMIbkrrQTrC9d8d2B+JeQ9NUWn3bns5xuv45S02fvKsbNM0oeO9GipAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CzChU7db; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CzChU7db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD53C116C6;
	Tue,  6 Jan 2026 17:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721914;
	bh=1yMZ/442irs62YVRl4oOMjEFKk550rE4r6Ww6FwZJB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CzChU7dbvOZT0uPm47j6lZAv6veMADCjAnm1SeC0gYMXbr8XELD3Iyypx2+Tgtfcu
	 wVDc3g1xJF2AL6BkDmD5QTV5QvXozTO5bTnblBigH67UQy+ikASyGnGyJ9eyA20B0o
	 MhWSrFuA/hu+cNPBqvVKQilhwUSCQwy1S9NdE/S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinhui Guo <guojinhui.liam@bytedance.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 109/312] iommu/amd: Propagate the error code returned by __modify_irte_ga() in modify_irte_ga()
Date: Tue,  6 Jan 2026 18:03:03 +0100
Message-ID: <20260106170551.779300441@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Jinhui Guo <guojinhui.liam@bytedance.com>

commit 2381a1b40be4b286062fb3cf67dd7f005692aa2a upstream.

The return type of __modify_irte_ga() is int, but modify_irte_ga()
treats it as a bool. Casting the int to bool discards the error code.

To fix the issue, change the type of ret to int in modify_irte_ga().

Fixes: 57cdb720eaa5 ("iommu/amd: Do not flush IRTE when only updating isRun and destination fields")
Cc: stable@vger.kernel.org
Signed-off-by: Jinhui Guo <guojinhui.liam@bytedance.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/amd/iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3354,7 +3354,7 @@ static int __modify_irte_ga(struct amd_i
 static int modify_irte_ga(struct amd_iommu *iommu, u16 devid, int index,
 			  struct irte_ga *irte)
 {
-	bool ret;
+	int ret;
 
 	ret = __modify_irte_ga(iommu, devid, index, irte);
 	if (ret)


