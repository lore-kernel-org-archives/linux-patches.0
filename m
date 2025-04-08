Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE5726561C;
	Tue,  8 Apr 2025 11:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111151; cv=none; b=YMvgbkDjvd7xsRTgSj5LBaEM6aulEmAo9+Yezj/k7FOFq2kmsupkR24HkjU5EcGP5/+u+Nnce6g8cnQ8LNthlNxeA2QTSxNrzZhQyRyRDTI19OGkqpEmbQ6Ja58IkefHYHh/Pc0AJd/GBzUX52GcAbWfQvmI15l9Rs8x0TvOPcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111151; c=relaxed/simple;
	bh=C2P47ynFAUBzlDVA/VQ8mqrwyyQZKe0MO6vTb5De+ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bedrj7M6fA9eO2vi+HN7sjsWD9QjgUvG6AbIrA0qVAymLwB9910admwmzTm2NW1tSfT+59nlsFgAOVGfe4YDLs42/oElHufD0JcaaEMWdc8hRp3XV65/JQH9NVlPrhwEzpZUpgatpzE0wPhcFQnJGTRqLt3FYHjBU3Abbs/L8ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j02MiYtv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j02MiYtv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C69CC4CEE5;
	Tue,  8 Apr 2025 11:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111151;
	bh=C2P47ynFAUBzlDVA/VQ8mqrwyyQZKe0MO6vTb5De+ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j02MiYtvq+pDUa1HwJag5tHdd18vw7RKOJrDm6GPi7FAmQ3TPT3nQHlVmMYvDRz7L
	 Ff529SDmIWCNTLmEJYZAJjepMsGfwnSMSuMO+HH/G0WCUalV8wKdP0gq2fgShMa34c
	 ktrND1RuAp/OTp49LM+2yGp7fruMdQZm6riqlUXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Frank Li <Frank.Li@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 326/731] misc: pci_endpoint_test: Handle BAR sizes larger than INT_MAX
Date: Tue,  8 Apr 2025 12:43:43 +0200
Message-ID: <20250408104921.858799606@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 7962c82a6e648d07bf0067796e4a0e69ba1fc702 ]

Running 'pcitest -b 0' fails with "TEST FAILED" when the BAR0 size
is e.g. 8 GB.

The return value of the pci_resource_len() macro can be larger than that
of a signed integer type. Thus, when using 'pcitest' with an 8 GB BAR,
the bar_size of the integer type will overflow.

Change bar_size from integer to resource_size_t to prevent integer
overflow for large BAR sizes with 32-bit compilers.

In order to handle 64-bit resource_type_t on 32-bit platforms, we would
have needed to use a function like div_u64() or similar. Instead, change
the code to use addition instead of division. This avoids the need for
div_u64() or similar, while also simplifying the code.

Fixes: cda370ec6d1f ("misc: pci_endpoint_test: Avoid using hard-coded BAR sizes")
Co-developed-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250124093300.3629624-2-cassel@kernel.org
[mani: added fixes tag]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pci_endpoint_test.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index 7584d18768598..9dac7cbe8748c 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -272,9 +272,9 @@ static const u32 bar_test_pattern[] = {
 };
 
 static int pci_endpoint_test_bar_memcmp(struct pci_endpoint_test *test,
-					enum pci_barno barno, int offset,
-					void *write_buf, void *read_buf,
-					int size)
+					enum pci_barno barno,
+					resource_size_t offset, void *write_buf,
+					void *read_buf, int size)
 {
 	memset(write_buf, bar_test_pattern[barno], size);
 	memcpy_toio(test->bar[barno] + offset, write_buf, size);
@@ -287,10 +287,11 @@ static int pci_endpoint_test_bar_memcmp(struct pci_endpoint_test *test,
 static int pci_endpoint_test_bar(struct pci_endpoint_test *test,
 				  enum pci_barno barno)
 {
-	int j, bar_size, buf_size, iters;
+	resource_size_t bar_size, offset = 0;
 	void *write_buf __free(kfree) = NULL;
 	void *read_buf __free(kfree) = NULL;
 	struct pci_dev *pdev = test->pdev;
+	int buf_size;
 
 	if (!test->bar[barno])
 		return -ENOMEM;
@@ -314,11 +315,12 @@ static int pci_endpoint_test_bar(struct pci_endpoint_test *test,
 	if (!read_buf)
 		return -ENOMEM;
 
-	iters = bar_size / buf_size;
-	for (j = 0; j < iters; j++)
-		if (pci_endpoint_test_bar_memcmp(test, barno, buf_size * j,
-						 write_buf, read_buf, buf_size))
+	while (offset < bar_size) {
+		if (pci_endpoint_test_bar_memcmp(test, barno, offset, write_buf,
+						 read_buf, buf_size))
 			return -EIO;
+		offset += buf_size;
+	}
 
 	return 0;
 }
-- 
2.39.5



