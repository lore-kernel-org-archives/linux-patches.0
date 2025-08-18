Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F18335BBE;
	Mon, 18 Aug 2025 13:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525225; cv=none; b=VyxpbNQQU3eWKTcSfK7b6r8gMDhgHTw5KKaAh1kCnIGgQ3fXr664F496kNdXqsUN/CMQ5HJdKmlvAzxfSQQ+fxc+Z3zarmIRJ7vsRxTr/Rj+4seWod3wOeIt2TIuuYPt/wdoZWh7wO+F6YWWAvdXd3DGFJHi/ZaBO0VcyxdASJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525225; c=relaxed/simple;
	bh=BvaUTPG4u5OLH7sceZGFNTL6XUL4bMtsUROPmGKXrCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gf8T4uPyU2ktKVE04Xx3X3lseT+W0DCmhn1mkhBzF+47V090AU3Z8puDoZExPqEW/DQvjfHROeD2WdUlLc36t/KCmdT9X65/QRqUWMALPAZruPwLUCMrP2n4sdw2nRJH5kjQVji3yRUbHX2wOhLMISUbhZRymKfo3+wuVJreyt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gjNVsP3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gjNVsP3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A2BC4CEEB;
	Mon, 18 Aug 2025 13:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525225;
	bh=BvaUTPG4u5OLH7sceZGFNTL6XUL4bMtsUROPmGKXrCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjNVsP3viUD1qSCV1s1ZaEjWwejDY0wIC6KMhzUiwQ9Jud1TT6NyiF/g9i5VK++TN
	 CCxB8a1XpEiJ0nxCYJgrJSBUYDJXJpQA0fmtYFxmxq7HwvYwbtuqtW3VPkcB4RD8NN
	 Dy8Kf5RO2Hv0S30awBBLKlaiSTYkpmA4p+s0Eg80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 196/570] soc: qcom: mdt_loader: Actually use the e_phoff
Date: Mon, 18 Aug 2025 14:43:03 +0200
Message-ID: <20250818124513.350976306@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index b2c0fb55d4ae..44589d10b15b 100644
--- a/drivers/soc/qcom/mdt_loader.c
+++ b/drivers/soc/qcom/mdt_loader.c
@@ -83,7 +83,7 @@ ssize_t qcom_mdt_get_size(const struct firmware *fw)
 	int i;
 
 	ehdr = (struct elf32_hdr *)fw->data;
-	phdrs = (struct elf32_phdr *)(ehdr + 1);
+	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);
 
 	for (i = 0; i < ehdr->e_phnum; i++) {
 		phdr = &phdrs[i];
@@ -135,7 +135,7 @@ void *qcom_mdt_read_metadata(const struct firmware *fw, size_t *data_len,
 	void *data;
 
 	ehdr = (struct elf32_hdr *)fw->data;
-	phdrs = (struct elf32_phdr *)(ehdr + 1);
+	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);
 
 	if (ehdr->e_phnum < 2)
 		return ERR_PTR(-EINVAL);
@@ -215,7 +215,7 @@ int qcom_mdt_pas_init(struct device *dev, const struct firmware *fw,
 	int i;
 
 	ehdr = (struct elf32_hdr *)fw->data;
-	phdrs = (struct elf32_phdr *)(ehdr + 1);
+	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);
 
 	for (i = 0; i < ehdr->e_phnum; i++) {
 		phdr = &phdrs[i];
@@ -270,7 +270,7 @@ static bool qcom_mdt_bins_are_split(const struct firmware *fw, const char *fw_na
 	int i;
 
 	ehdr = (struct elf32_hdr *)fw->data;
-	phdrs = (struct elf32_phdr *)(ehdr + 1);
+	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);
 
 	for (i = 0; i < ehdr->e_phnum; i++) {
 		/*
@@ -312,7 +312,7 @@ static int __qcom_mdt_load(struct device *dev, const struct firmware *fw,
 
 	is_split = qcom_mdt_bins_are_split(fw, fw_name);
 	ehdr = (struct elf32_hdr *)fw->data;
-	phdrs = (struct elf32_phdr *)(ehdr + 1);
+	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);
 
 	for (i = 0; i < ehdr->e_phnum; i++) {
 		phdr = &phdrs[i];
-- 
2.39.5



