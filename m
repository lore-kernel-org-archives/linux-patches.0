Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51FA1DF258;
	Tue, 11 Nov 2025 00:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822710; cv=none; b=QkK8LEejzzTSVu/mUN+3QdfSkSXGs3LqbYJ47fMI2tPSPJHM9HDxBYrs6unPDCoHbtWjWGLaeyA7M/qN8m2pMQ/xLKSXLhMV9eW3L70GPaEvStE2eLUGhpRc8LKZA+u440JXSzgoR3QAOlfKPIHJTDfVDM7siM0+Z8TmFfNlPPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822710; c=relaxed/simple;
	bh=Gd+Xq+b/mUsKXNg9TJRG4jCbJnhRggjjQrVGqrMcrJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCobu72HR82IcFJ0THOyB1RC9mw9olE6zpJYHIYMyiJ8uJhDvHHqwxdCsxGCbIf2VhRCpROI0bQbqNcmTyLpBflNWb1Tsy+LiiubwdkBS2oPq1Yg0FVZd1EmVtX6NbqcVBnihS1bxTDD1WEFoO2Pgi264nYF7SHakJC0wQg/B2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFywcQ1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFywcQ1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A07C19424;
	Tue, 11 Nov 2025 00:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822710;
	bh=Gd+Xq+b/mUsKXNg9TJRG4jCbJnhRggjjQrVGqrMcrJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFywcQ1OK0zQzGEn8pRvEvSh9qQ9BKtMDLVVSyr6kaHT79bxyHsb/pYbTr/e/jTIH
	 NEcK32/VoP+ePM5Ju0SilghJx72GmskIlDwTkmF6/Cy3xLJ8E6bB1SUwJij/bYTU3P
	 ksb4fIeOEY+ayM3YPWktiCEIw56sZB+9kefghv9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Reidel <adrian@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/565] soc: qcom: smem: Fix endian-unaware access of num_entries
Date: Tue, 11 Nov 2025 09:39:06 +0900
Message-ID: <20251111004528.992267550@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Jens Reidel <adrian@mainlining.org>

[ Upstream commit 19e7aa0e9e46d0ad111a4af55b3d681b6ad945e0 ]

Add a missing le32_to_cpu when accessing num_entries, which is always a
little endian integer.

Fixes booting on Xiaomi Mi 9T (xiaomi-davinci) in big endian.

Signed-off-by: Jens Reidel <adrian@mainlining.org>
Link: https://lore.kernel.org/r/20250726235646.254730-1-adrian@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
index e4411771f482f..db77642776f93 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -892,7 +892,7 @@ static u32 qcom_smem_get_item_count(struct qcom_smem *smem)
 	if (IS_ERR_OR_NULL(ptable))
 		return SMEM_ITEM_COUNT;
 
-	info = (struct smem_info *)&ptable->entry[ptable->num_entries];
+	info = (struct smem_info *)&ptable->entry[le32_to_cpu(ptable->num_entries)];
 	if (memcmp(info->magic, SMEM_INFO_MAGIC, sizeof(info->magic)))
 		return SMEM_ITEM_COUNT;
 
-- 
2.51.0



