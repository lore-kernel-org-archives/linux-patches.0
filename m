Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59144319858;
	Tue, 26 Aug 2025 11:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207160; cv=none; b=rEiwLUDpT80+o4UuYjc1/N7KQO+a4wPPpUmUg3rQAT9RgYIPafWX3JBTQIBnSClB9NWA1In+R/NqZmft7QvLz0B/m7KYI7BbPJKZ1QcZJeoQkdOZi2ZSRc0WzQzz+24xK53gtJuZDyJ9vSds7lp/lGsgwlJOHYKOTfc4nPrpnU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207160; c=relaxed/simple;
	bh=JdBPwEhmHzyRTkRpVZUa2mqp1Z6qBWLUUg774w3AoCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h+UPIxSecXXvkHMFW4W4uewqd8cg4utR6n/m48X7PzTPH9nfJjHl7T2jilTJzgHtmVyilVOjmK77OWPHTN9kpD3m7/FH5gw3Wg24bIql13CTG6pWxZbU/usIqHfR1OqIMekZNIeu9DoX0zeQRZGaqPPZ9w9WYAn6yWi94oZFlCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2yy9Wss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2yy9Wss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C803C4CEF4;
	Tue, 26 Aug 2025 11:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207159;
	bh=JdBPwEhmHzyRTkRpVZUa2mqp1Z6qBWLUUg774w3AoCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2yy9WssXdaLGwsU6heV6LiQmCeaWOIAEe0Utq8UsMogBt65SyTpWOVCHb2SDNntX
	 ANhqtLEexaYZxoaEgRaMyGbLJki2/1ccoREX7R34yAjtS/haKXSVcJYSHzkKlrJ5tf
	 TUBpsHTTZ4ZyE45PEw4FuA/zseVq9jyflPscNGy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Anderson <dianders@chromium.org>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.16 073/457] soc: qcom: mdt_loader: Ensure we dont read past the ELF header
Date: Tue, 26 Aug 2025 13:05:57 +0200
Message-ID: <20250826110939.176951489@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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
@@ -18,6 +18,37 @@
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
@@ -82,6 +113,9 @@ ssize_t qcom_mdt_get_size(const struct f
 	phys_addr_t max_addr = 0;
 	int i;
 
+	if (!mdt_header_valid(fw))
+		return -EINVAL;
+
 	ehdr = (struct elf32_hdr *)fw->data;
 	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);
 
@@ -134,6 +168,9 @@ void *qcom_mdt_read_metadata(const struc
 	ssize_t ret;
 	void *data;
 
+	if (!mdt_header_valid(fw))
+		return ERR_PTR(-EINVAL);
+
 	ehdr = (struct elf32_hdr *)fw->data;
 	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);
 
@@ -214,6 +251,9 @@ int qcom_mdt_pas_init(struct device *dev
 	int ret;
 	int i;
 
+	if (!mdt_header_valid(fw))
+		return -EINVAL;
+
 	ehdr = (struct elf32_hdr *)fw->data;
 	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);
 
@@ -310,6 +350,9 @@ static int __qcom_mdt_load(struct device
 	if (!fw || !mem_region || !mem_phys || !mem_size)
 		return -EINVAL;
 
+	if (!mdt_header_valid(fw))
+		return -EINVAL;
+
 	is_split = qcom_mdt_bins_are_split(fw, fw_name);
 	ehdr = (struct elf32_hdr *)fw->data;
 	phdrs = (struct elf32_phdr *)(fw->data + ehdr->e_phoff);


