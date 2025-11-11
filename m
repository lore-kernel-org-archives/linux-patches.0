Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9A3244693;
	Tue, 11 Nov 2025 00:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822769; cv=none; b=tNraua53LonvvD0I7fWKFZBedHP9/QXQX6Q6OgRkeU7ptVa31z+EWa6LkBQWM05HF+WejbkxKwYR140cA+ZGdeU6nSnOan8riKeqSvMpXskYf/48XOyWb4ct/KiURyq+xwEQmPaheltwmSaftApaC5G+ASGEXrPZQeNqggyGUsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822769; c=relaxed/simple;
	bh=8Sjm/58tXU6rHHJSb+cunhSoO5QLiml58nUqGMx5REY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHXir56NIgoRXxoU35t+i2ru4wQuTptdk7liLgCAkDDovl/i6RDj64nZZYvQ+767N4USK9JN4TZqvwlcn5m98dp0vyMgvta79NrhI+Y7HB+kBxi1DYLuowvzwoFg65IpY5IJ/OzhT6aJ9sQZc7UcmO0oX0yVKDDPtSwUIP9EgvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZbjQWi8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZbjQWi8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DECCC4AF09;
	Tue, 11 Nov 2025 00:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822769;
	bh=8Sjm/58tXU6rHHJSb+cunhSoO5QLiml58nUqGMx5REY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZbjQWi8OCadv605c2GVJNBWJGXGJjrPaCLCrnT2u+sCNf1e6YuRh1aXAYVqZuJJY4
	 sSn2ujizOv6IAMu4Ei+o49PZX+p8ZinK81fakZUnZGVTiIg69RGgUxKiwV2SBo1Jof
	 Vm2SpP5qVjQyBCoRw8/Ghin30PQVxpqJaalNGFq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Reidel <adrian@mainlining.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 120/849] soc: qcom: smem: Fix endian-unaware access of num_entries
Date: Tue, 11 Nov 2025 09:34:50 +0900
Message-ID: <20251111004539.300003232@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index cf425930539e4..c4c45f15dca4f 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -898,7 +898,7 @@ static u32 qcom_smem_get_item_count(struct qcom_smem *smem)
 	if (IS_ERR_OR_NULL(ptable))
 		return SMEM_ITEM_COUNT;
 
-	info = (struct smem_info *)&ptable->entry[ptable->num_entries];
+	info = (struct smem_info *)&ptable->entry[le32_to_cpu(ptable->num_entries)];
 	if (memcmp(info->magic, SMEM_INFO_MAGIC, sizeof(info->magic)))
 		return SMEM_ITEM_COUNT;
 
-- 
2.51.0



