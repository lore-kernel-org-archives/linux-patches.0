Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79D23043C4;
	Tue, 30 Sep 2025 14:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244153; cv=none; b=N4wI5Svz10hHQ5ESUMWWaL8ohXHqKSGoG8Pn9NeSWlJAJ14KZ/oiGwwRDShPR7LkUWdJob+xfo/afTIBrs6lPUtzyq7NIHYAEYcnhoZN54docph8/kIJEzd2T4VfA/lC4XpDU+fD+CMTz3348XTMbZZwi20DX9vp4LARzu9Y/m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244153; c=relaxed/simple;
	bh=i80ERf2LCQuJKs0c32oFCrampMaRQ0mszFoPzgzICiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2AUurW6Ysw1BIaDa26NKb5PLOElVcEb6hxhJbPDWYtO2uUwqZ60iB+W/pyVC+eKB5+tRuJi/uIFUkfGg7QSBGbWFlV69GjwGw8nGK8cwhRfAQ0IVyxM/pu8laMeufSEsxtTeunEy3PSjOQzHiLq9iFVJgNJZagv0TNXPDBPBQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jFB0sOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jFB0sOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D572C4CEF0;
	Tue, 30 Sep 2025 14:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244153;
	bh=i80ERf2LCQuJKs0c32oFCrampMaRQ0mszFoPzgzICiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jFB0sOzvA7eR7pW0X93DZVb6SOYG2ZU+tPli3pFWcHg7VcLN/1LnfWG2eyTIZ15m
	 +5wZiupWySKlCvTS2eiPnDPqgAR4CIR97ZQrY0mSHxTlJwaje4mmRcZc2M7sFbN+aJ
	 m9rfTQ3QDIktotW36CinqNdI+a6mguzxGmhPUXyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Yongqin Liu <yongqin.liu@linaro.org>
Subject: [PATCH 5.10 043/122] soc: qcom: mdt_loader: Deal with zero e_shentsize
Date: Tue, 30 Sep 2025 16:46:14 +0200
Message-ID: <20250930143824.762145901@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

commit 25daf9af0ac1bf12490b723b5efaf8dcc85980bc upstream.

Firmware that doesn't provide section headers leave both e_shentsize and
e_shnum 0, which obvious isn't compatible with the newly introduced
stricter checks.

Make the section-related checks conditional on either of these values
being non-zero.

Fixes: 9f9967fed9d0 ("soc: qcom: mdt_loader: Ensure we don't read past the ELF header")
Reported-by: Val Packett <val@packett.cool>
Closes: https://lore.kernel.org/all/ece307c3-7d65-440f-babd-88cf9705b908@packett.cool/
Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
Closes: https://lore.kernel.org/all/aec9cd03-6fc2-4dc8-b937-8b7cf7bf4128@linaro.org/
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Fixes: 9f35ab0e53cc ("soc: qcom: mdt_loader: Fix error return values in mdt_header_valid()")
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250730-mdt-loader-shentsize-zero-v1-1-04f43186229c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Cc: Yongqin Liu <yongqin.liu@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/mdt_loader.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/soc/qcom/mdt_loader.c
+++ b/drivers/soc/qcom/mdt_loader.c
@@ -39,12 +39,14 @@ static bool mdt_header_valid(const struc
 	if (phend > fw->size)
 		return false;
 
-	if (ehdr->e_shentsize != sizeof(struct elf32_shdr))
-		return false;
+	if (ehdr->e_shentsize || ehdr->e_shnum) {
+		if (ehdr->e_shentsize != sizeof(struct elf32_shdr))
+			return false;
 
-	shend = size_add(size_mul(sizeof(struct elf32_shdr), ehdr->e_shnum), ehdr->e_shoff);
-	if (shend > fw->size)
-		return false;
+		shend = size_add(size_mul(sizeof(struct elf32_shdr), ehdr->e_shnum), ehdr->e_shoff);
+		if (shend > fw->size)
+			return false;
+	}
 
 	return true;
 }


