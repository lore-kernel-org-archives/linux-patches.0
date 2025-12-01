Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E171430AACF;
	Mon,  1 Dec 2025 11:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588370; cv=none; b=Zg0vjoyq77LIU+UImexyCgxZQrKRp1N9wfFiHzcdigK4i9Ep6MYlx8kYAdKy1aFUT6re+8fXVcOjs0DHdQUB/XdTb1CcTaYdI33oa5DFV2DQrCgs6F6ISC56F3hEuyVG2yeQMUgny3iSZgc/z4cAYj6DvecSfxwJ50E2kQhEq5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588370; c=relaxed/simple;
	bh=oo84+Die5erF60CRDIzLauDU0l1emw7HpCJFPw1VJa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+gTEFyXxcVL9XajMbaJYTCxTEi7ZsNQNUubbDS2gZYRKAFP6kdmNX4NhlFZzw1qmRLx85MsBdgv7xsR5ZXEMBu07fs6oztHvWtNoGMhxEQaswK10fiqZudi+Z5Fv4DUomxvCIqgpYF/CaM+t8em2wtjaiQRmoeGkitAKITLAzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LWl7tIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LWl7tIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE6DC4CEF1;
	Mon,  1 Dec 2025 11:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588369;
	bh=oo84+Die5erF60CRDIzLauDU0l1emw7HpCJFPw1VJa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LWl7tIRlZKSGbo9qnjroqA8J7hLKvbq++/KH0zYmzsd5QVPbDrxT3D9syc1mlW0P
	 UEAmLpXHGJHeeKIPVD6vgnaFZB8lMkQLXg1faLbzXXjj33BJkLHa54a6sVFx914NOy
	 qBgqcUkG+K5WcMXvtyTaeWc8LylB/XmeRPU1UjZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Reidel <adrian@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/187] soc: qcom: smem: Fix endian-unaware access of num_entries
Date: Mon,  1 Dec 2025 12:22:13 +0100
Message-ID: <20251201112242.164759525@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 28c19bcb2f205..d2d62d2b378b4 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -709,7 +709,7 @@ static u32 qcom_smem_get_item_count(struct qcom_smem *smem)
 	if (IS_ERR_OR_NULL(ptable))
 		return SMEM_ITEM_COUNT;
 
-	info = (struct smem_info *)&ptable->entry[ptable->num_entries];
+	info = (struct smem_info *)&ptable->entry[le32_to_cpu(ptable->num_entries)];
 	if (memcmp(info->magic, SMEM_INFO_MAGIC, sizeof(info->magic)))
 		return SMEM_ITEM_COUNT;
 
-- 
2.51.0



