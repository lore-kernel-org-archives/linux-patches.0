Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB6E259CB2;
	Tue, 26 Aug 2025 13:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213820; cv=none; b=b5l5CN1/yj2+sCKYWKy/lU02qWvnuVwDOsC/+czUBKG+jWMNU+xJy2hAFoU6JTYKcK5jMfUnKjetYSmPmKwyr2E6Ml+E0WcfJ+L9l9G6e3w6iGwh70FwjaweR5K2HWAT3atRj4fzZolptfo8Hs9HbS98b+Zvfx1S5wUvGjzBFTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213820; c=relaxed/simple;
	bh=8s9mtIb9dRPlilnfmTVjxQejICMyfRy92plaPnX9kpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHD7eCPZ53dREhYDqJLY7VeEQSeVSoMOSiFlphYtiChG7iVB+ygVzqtNk2MjsJCj2c/AMlHPcn32MIqnebCBK8GHO5ZS+nf0PrYKpqWlG0MOxevVCveJ5OksFsOH0vQpDyt90Z1iRnkFD4ZqtdmIlHu6dkgV5LRqkqCG1LcFMEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbeBDq3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbeBDq3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1B4C4CEF1;
	Tue, 26 Aug 2025 13:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213819;
	bh=8s9mtIb9dRPlilnfmTVjxQejICMyfRy92plaPnX9kpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbeBDq3UGPP4eW87y2I4SenPJ/boBaieA2KhnS1jctmmmvts83m1rpIgOdm0Kvf6h
	 w/PVoujoyAHuH7st3oyCZndzA2T4JBS5jS3e0nF0UXgJQs1ZtrMb1uAMoiEwRJDFJa
	 Xr8ehS6JqA+kftTiDVQ7RBTdq3cGbUC5X/MtB7Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 492/587] soc: qcom: mdt_loader: Fix error return values in mdt_header_valid()
Date: Tue, 26 Aug 2025 13:10:41 +0200
Message-ID: <20250826111005.492485933@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 9f35ab0e53ccbea57bb9cbad8065e0406d516195 upstream.

This function is supposed to return true for valid headers and false for
invalid.  In a couple places it returns -EINVAL instead which means the
invalid headers are counted as true.  Change it to return false.

Fixes: 9f9967fed9d0 ("soc: qcom: mdt_loader: Ensure we don't read past the ELF header")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/db57c01c-bdcc-4a0f-95db-b0f2784ea91f@sabinyo.mountain
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/mdt_loader.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/soc/qcom/mdt_loader.c
+++ b/drivers/soc/qcom/mdt_loader.c
@@ -32,14 +32,14 @@ static bool mdt_header_valid(const struc
 		return false;
 
 	if (ehdr->e_phentsize != sizeof(struct elf32_phdr))
-		return -EINVAL;
+		return false;
 
 	phend = size_add(size_mul(sizeof(struct elf32_phdr), ehdr->e_phnum), ehdr->e_phoff);
 	if (phend > fw->size)
 		return false;
 
 	if (ehdr->e_shentsize != sizeof(struct elf32_shdr))
-		return -EINVAL;
+		return false;
 
 	shend = size_add(size_mul(sizeof(struct elf32_shdr), ehdr->e_shnum), ehdr->e_shoff);
 	if (shend > fw->size)


