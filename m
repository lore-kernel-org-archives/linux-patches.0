Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF3E12CDA5;
	Tue, 26 Aug 2025 13:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213488; cv=none; b=tDN2kO6UjdixKbQoOpde1zFy9XmVfCIFjZbPpof9AUMr2f/bWIQuDzw1tB71fP0FJq1s2qvMOjpb0/xhpT+9c55PSJmB4pSK1isssBioaVTSJOmKbFpqKKqnsUvagRE/9dPxZCzFDW7uxtlaMlVXNgRAGMGvdDrFdyR5bGt3wS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213488; c=relaxed/simple;
	bh=odxyQEG8f2M6hDOeXxvSa9lXsy0A7eKceb7Hpg4GKhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTq+HYPDSSAum5k/cgkEFTSi/2rOCBr4YjL1+NNGuLN3KEW2aOQ9IQ+L7ghvSw/AMGrdou2rQ1BvRcM+y9jAHwcUTOcwfAuTGc6sggcSMssvDBIHiSsG0eAUIxRouk6yNXTXhGVO3mv3rLRNaX34azOD4RHNONL7N5px/yY5wNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4yZoKVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4yZoKVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9630EC4CEF1;
	Tue, 26 Aug 2025 13:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213487;
	bh=odxyQEG8f2M6hDOeXxvSa9lXsy0A7eKceb7Hpg4GKhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4yZoKVevf6YnD7opllfRbEBF1J9zcZVfj/bTQBRjZGSpO8l61bP7rwK7m/6hCXD8
	 7Q4OyUrsi+y5iiMjNAE3od2xHUb+fFBoNBH0WVp7NJondF0TIjW8FlTwLiVPIiTZ+2
	 ZYgK4nTG4epJ1FPu/g1Nl9q0u197MiJ1nrjIvF6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Anderson <dianders@chromium.org>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 365/587] soc: qcom: mdt_loader: Ensure we dont read past the ELF header
Date: Tue, 26 Aug 2025 13:08:34 +0200
Message-ID: <20250826111002.194495235@linuxfoundation.org>
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

commit 9f9967fed9d066ed3dae9372b45ffa4f6fccfeef upstream.

When the MDT loader is used in remoteproc, the ELF header is sanitized
beforehand, but that's not necessary the case for other clients.

Validate the size of the firmware buffer to ensure that we don't read
past the end as we iterate over the header. e_phentsize and e_shentsize
are validated as well, to ensure that the assumptions about step size in
the traversal are valid.

Fixes: 2aad40d911ee ("remoteproc: Move qcom_mdt_loader into drivers/soc/qcom")
Cc: stable@vger.kernel.org
Reported-by: Doug Anderson <dianders@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250610-mdt-loader-validation-and-fixes-v2-1-f7073e9ab899@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/mdt_loader.c |   43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

--- a/drivers/soc/qcom/mdt_loader.c
+++ b/drivers/soc/qcom/mdt_loader.c
@@ -17,6 +17,37 @@
 #include <linux/slab.h>
 #include <linux/soc/qcom/mdt_loader.h>
 
+static bool mdt_header_valid(const struct firmware *fw)
+{
+	const struct elf32_hdr *ehdr;
+	size_t phend;
+	size_t shend;
+
+	if (fw->size < sizeof(*ehdr))
+		return false;
+
+	ehdr = (struct elf32_hdr *)fw->data;
+
+	if (memcmp(ehdr->e_ident, ELFMAG, SELFMAG))
+		return false;
+
+	if (ehdr->e_phentsize != sizeof(struct elf32_phdr))
+		return -EINVAL;
+
+	phend = size_add(size_mul(sizeof(struct elf32_phdr), ehdr->e_phnum), ehdr->e_phoff);
+	if (phend > fw->size)
+		return false;
+
+	if (ehdr->e_shentsize != sizeof(struct elf32_shdr))
+		return -EINVAL;
+
+	shend = size_add(size_mul(sizeof(struct elf32_shdr), ehdr->e_shnum), ehdr->e_shoff);
+	if (shend > fw->size)
+		return false;
+
+	return true;
+}
+
 static bool mdt_phdr_valid(const struct elf32_phdr *phdr)
 {
 	if (phdr->p_type != PT_LOAD)
@@ -84,6 +115,9 @@ ssize_t qcom_mdt_get_size(const struct f
 	phys_addr_t max_addr = 0;
 	int i;
 
+	if (!mdt_header_valid(fw))
+		return -EINVAL;
+
 	ehdr = (struct elf32_hdr *)fw->data;
 	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);
 
@@ -136,6 +170,9 @@ void *qcom_mdt_read_metadata(const struc
 	ssize_t ret;
 	void *data;
 
+	if (!mdt_header_valid(fw))
+		return ERR_PTR(-EINVAL);
+
 	ehdr = (struct elf32_hdr *)fw->data;
 	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);
 
@@ -216,6 +253,9 @@ int qcom_mdt_pas_init(struct device *dev
 	int ret;
 	int i;
 
+	if (!mdt_header_valid(fw))
+		return -EINVAL;
+
 	ehdr = (struct elf32_hdr *)fw->data;
 	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);
 
@@ -312,6 +352,9 @@ static int __qcom_mdt_load(struct device
 	if (!fw || !mem_region || !mem_phys || !mem_size)
 		return -EINVAL;
 
+	if (!mdt_header_valid(fw))
+		return -EINVAL;
+
 	is_split = qcom_mdt_bins_are_split(fw, fw_name);
 	ehdr = (struct elf32_hdr *)fw->data;
 	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);


