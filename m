Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E28222D66;
	Thu, 12 Dec 2024 16:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019766; cv=none; b=QVXk64VEpolIbWwB0Tv5AVsgX5RduRW9fYampmW2+NwN7Vl1EyMbbyXUvpHHDK7G6m4YJuQ0Pg3acKE/UrG+iw4FGlHPQPsT8n+47n1SRTNheFGnS4RAzcdtU90p2iNbBYOOHlOmedJZO3NOTiZmBbav2OUEIdwTX00sHiw2hng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019766; c=relaxed/simple;
	bh=MrFd7Gtb7tRkB4nCJ/WULXUG9p7qnt2uFFm/NJ13lO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Su0s/KPPAGm7BLlBwoP6eaWpi8qw8S4dG3c443KiBNTVw6lvvI9gu05AUKZBgE1EH+d9bOF73+TWfPSrm5IxXTsm/yUsltQJPqiHFiQbBOHXGKZWWJohS2If5OBRpuR7AiK7p7Qlw9FQiLdgdtpvfFzEkjycnpyM94thmwIYnUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5llCGA+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5llCGA+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F02C4CECE;
	Thu, 12 Dec 2024 16:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019765;
	bh=MrFd7Gtb7tRkB4nCJ/WULXUG9p7qnt2uFFm/NJ13lO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5llCGA+5E+vZUfTrSl8vT/1xPXnpxfeEFkuFKH0lNOu8JUHJxnwVDToevEGW9GEh
	 SAbmQbRHF8aNWvGx7+yVs7kIuNHy0/eukgc/GaGLqJSnPqVh8igUe4vR2FvTK3N0Ky
	 VtDjLn9TsX8afzwQnPna9ORtKfdR85OxDstGCMuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Kjos <tkjos@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 262/772] PCI: Fix reset_method_store() memory leak
Date: Thu, 12 Dec 2024 15:53:27 +0100
Message-ID: <20241212144400.742118084@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Todd Kjos <tkjos@google.com>

[ Upstream commit 2985b1844f3f3447f2d938eff1ef6762592065a5 ]

In reset_method_store(), a string is allocated via kstrndup() and assigned
to the local "options". options is then used in with strsep() to find
spaces:

  while ((name = strsep(&options, " ")) != NULL) {

If there are no remaining spaces, then options is set to NULL by strsep(),
so the subsequent kfree(options) doesn't free the memory allocated via
kstrndup().

Fix by using a separate tmp_options to iterate with strsep() so options is
preserved.

Link: https://lore.kernel.org/r/20241001231147.3583649-1-tkjos@google.com
Fixes: d88f521da3ef ("PCI: Allow userspace to query and set device reset mechanism")
Signed-off-by: Todd Kjos <tkjos@google.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 0baf5c03ef4cb..e08354b811073 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5308,7 +5308,7 @@ static ssize_t reset_method_store(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	char *options, *name;
+	char *options, *tmp_options, *name;
 	int m, n;
 	u8 reset_methods[PCI_NUM_RESET_METHODS] = { 0 };
 
@@ -5328,7 +5328,8 @@ static ssize_t reset_method_store(struct device *dev,
 		return -ENOMEM;
 
 	n = 0;
-	while ((name = strsep(&options, " ")) != NULL) {
+	tmp_options = options;
+	while ((name = strsep(&tmp_options, " ")) != NULL) {
 		if (sysfs_streq(name, ""))
 			continue;
 
-- 
2.43.0



