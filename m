Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD83629D26A;
	Tue, 26 Aug 2025 11:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208638; cv=none; b=frSk+LqSzoAWoyuY/r/zyAtUz9hgzxXOlCqqtxT1/6vzZMwwcFFCkLIaOTzl1F4ST2fQfOrnQa4TV3mkMgcM5HhKMlj2IDdZKWAe4AckFdIcIgjjPeirs3p2c+iPSDTTiLcx09bcaklbvAQouZe33IeyTXPCCMe0EdN7IHU8zX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208638; c=relaxed/simple;
	bh=DavwPM8GgYuB7zbEftNdc0rYs+VZ6PWv5/ZAwSGyIsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcqAbaRTJZ/qA0GPf/dedUtRjUnekPGcGjYut4DjSyatMPv5BynORQRsCxHSnu10drfJF2fVpwQGi5GOOGNtXTanztpw7mMm90lSW16EuQMf7fi+IVFUXKCgP2dVhPwqYLNlkUTvmRtzHPuTif7ccVWgCBMgTmHo7TSOiPfw/cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xP5A1o5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xP5A1o5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B85C116B1;
	Tue, 26 Aug 2025 11:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208638;
	bh=DavwPM8GgYuB7zbEftNdc0rYs+VZ6PWv5/ZAwSGyIsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xP5A1o5IQG1mRIno0ANS5KjkXzPPIT0AVI+UCSWWa6mNgm8P2IGFhwmwl2Q2gFogD
	 1G5d4ca4xivpEY7Gd9GArBqmqq0Nicwci3wBxL05isW6zCXkCNaGlK+kdeyzW2043H
	 bmcn1rw/AOeuNACLEIGS/FN88/gBCOFd7EWONWME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.12 189/322] soc: qcom: mdt_loader: Fix error return values in mdt_header_valid()
Date: Tue, 26 Aug 2025 13:10:04 +0200
Message-ID: <20250826110920.532708978@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -33,14 +33,14 @@ static bool mdt_header_valid(const struc
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


