Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1596A18FDBD;
	Wed, 17 Sep 2025 13:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114225; cv=none; b=N3DnpM/XA7tkkfwejoeCQUNNX4ra+ceEnWfMp/9zLSZzoE04lnKPOPzeIrsycYFtL+JY12uOTSwQSa6NfRGY8onhWZU1ry5mJv27qhCDNOnuv/ZGcnfzCtH/hWnJdbJ+XEFsIMZBuO2fN6WBUyDMo0uvI0hdjxSiSutg1eccXfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114225; c=relaxed/simple;
	bh=Apj+ir5Mc7Wcap8CyYwqRre8Ej4SnNmAi8zZU3G9NAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYTeZh8eGelub6KWQu1oJVBDGpMtIGc25Myd7Qv1RWTa1k6POC+lxpgP3qQaGp3yul+ITG4A4M+Pw3IfZmlnf9h32At+aM6qICyvFjkWA88qRhUIDd2Plvk/5Id7J9gAyG7k2S6FtdRmRxOT1OLkB4fGNWnHPRTsjmqupW9CHDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHYwypJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHYwypJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8530BC4CEF0;
	Wed, 17 Sep 2025 13:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758114225;
	bh=Apj+ir5Mc7Wcap8CyYwqRre8Ej4SnNmAi8zZU3G9NAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yHYwypJmB2TU4K+SDpDjBApyPltnanx4qijPwMLG08RWyCCg037AHuSF1EW44GgzY
	 ID2luOdAXmpJ4FqS8v0RIXyUIVGN50GgRkDJ6WFeFjUDgauTmpYS0+jM3Q9qbzhIP9
	 4vWLynOn3AZqmlTgtzsSicyhX1Qb7phn4OAlPBtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Yongqin Liu <yongqin.liu@linaro.org>
Subject: [PATCH 6.1 77/78] soc: qcom: mdt_loader: Fix error return values in mdt_header_valid()
Date: Wed, 17 Sep 2025 14:35:38 +0200
Message-ID: <20250917123331.468487259@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123329.576087662@linuxfoundation.org>
References: <20250917123329.576087662@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Yongqin Liu <yongqin.liu@linaro.org>
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


