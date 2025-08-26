Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318E414883F;
	Tue, 26 Aug 2025 12:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212941; cv=none; b=dp9ZoY2P+cvp5FHWwkO6C3q0/0WaEqWX4mz5SfmgorERTchd0i/sb18lMS4bqlqS/3pnYVG8JMgbwdLjNKhYuAEw07gr0PRCTP3UtFpmDsvERdYRdK44Yr8sN33g7Z6TcPNRaH5bV1olLldrn7xuC8lBESbMucObECfpKPcIiUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212941; c=relaxed/simple;
	bh=O0+T5/f65bXMiNyTs9su2pRr6au5cyjTA+8d3l0J/28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l51xrgju67hST1GWBaMhm1HuEPqmELqb1YrU9xJ9KzsFqQnEUbaI6W68hOY3LBlWJGGn9MUWs/A+pCVPqGsB2MDpgViN4iecgciJWxRrq893mb4yonkAChs6FIpmqNOVfL4jlojXochPK3Aqe7vmC80bHNpwSrtxyK/bnbOYT88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mkZpAg0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mkZpAg0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46FBC4CEF1;
	Tue, 26 Aug 2025 12:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212941;
	bh=O0+T5/f65bXMiNyTs9su2pRr6au5cyjTA+8d3l0J/28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkZpAg0CQ5ro0U6kYbGn9aG2dt75cgeWnJICg3YSeeuummxqaGPrEFJJ9d7Z22l/C
	 jsdmssjWFkm14JBFJOYcx/b2plOkbwK8oI/nBXQgpUKTAm155kenAa7tDsotUWqHIR
	 BPAnY4wo5ZQfHqpfGTbnCJA0ca5brRWJSdNU1JqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/587] soc: qcom: mdt_loader: Actually use the e_phoff
Date: Tue, 26 Aug 2025 13:04:39 +0200
Message-ID: <20250826110956.263813162@linuxfoundation.org>
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

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit 47e339cac89143709e84a3b71ba8bd9b2fdd2368 ]

Rather than relying/assuming that the tools generating the firmware
places the program headers immediately following the ELF header, use
e_phoff as intended to find the program headers.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250610-mdt-loader-validation-and-fixes-v2-3-f7073e9ab899@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/mdt_loader.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/qcom/mdt_loader.c b/drivers/soc/qcom/mdt_loader.c
index 6f177e46fa0f..8de1d478bec2 100644
--- a/drivers/soc/qcom/mdt_loader.c
+++ b/drivers/soc/qcom/mdt_loader.c
@@ -85,7 +85,7 @@ ssize_t qcom_mdt_get_size(const struct firmware *fw)
 	int i;
 
 	ehdr = (struct elf32_hdr *)fw->data;
-	phdrs = (struct elf32_phdr *)(ehdr + 1);
+	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);
 
 	for (i = 0; i < ehdr->e_phnum; i++) {
 		phdr = &phdrs[i];
@@ -137,7 +137,7 @@ void *qcom_mdt_read_metadata(const struct firmware *fw, size_t *data_len,
 	void *data;
 
 	ehdr = (struct elf32_hdr *)fw->data;
-	phdrs = (struct elf32_phdr *)(ehdr + 1);
+	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);
 
 	if (ehdr->e_phnum < 2)
 		return ERR_PTR(-EINVAL);
@@ -217,7 +217,7 @@ int qcom_mdt_pas_init(struct device *dev, const struct firmware *fw,
 	int i;
 
 	ehdr = (struct elf32_hdr *)fw->data;
-	phdrs = (struct elf32_phdr *)(ehdr + 1);
+	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);
 
 	for (i = 0; i < ehdr->e_phnum; i++) {
 		phdr = &phdrs[i];
@@ -272,7 +272,7 @@ static bool qcom_mdt_bins_are_split(const struct firmware *fw, const char *fw_na
 	int i;
 
 	ehdr = (struct elf32_hdr *)fw->data;
-	phdrs = (struct elf32_phdr *)(ehdr + 1);
+	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);
 
 	for (i = 0; i < ehdr->e_phnum; i++) {
 		/*
@@ -314,7 +314,7 @@ static int __qcom_mdt_load(struct device *dev, const struct firmware *fw,
 
 	is_split = qcom_mdt_bins_are_split(fw, fw_name);
 	ehdr = (struct elf32_hdr *)fw->data;
-	phdrs = (struct elf32_phdr *)(ehdr + 1);
+	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);
 
 	for (i = 0; i < ehdr->e_phnum; i++) {
 		phdr = &phdrs[i];
-- 
2.39.5



