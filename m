Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86312216E14;
	Thu, 12 Dec 2024 16:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022444; cv=none; b=qMsWWVZYP6zsTQ1SCUYY1r5ya4aFTL3zwL/ZnhyodVcRaN6pX3nvRLfvlu0MfuH02q5ecpeetg/ZoAVoRoqqnmDEeos1RH6zIas42Zv9IF9FQxBy2tWAoqjAArYUGr+bG1kbd6LlullipErnmeD9BePwYphF6JYNWqZPiY2YE5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022444; c=relaxed/simple;
	bh=fwrOdF1q3ItXED9f9JZDdusB3cghkRFrdc1yJRI0pk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FS2Bu0hu+4MSXbm6wKt27oIulsYnIzv0VSQqIY1Tjj/y7PRP8D+PIAuIh2dX/ezmy4JKRr1840TIT/CRQsr4zZBksDy1/FnxmHUzAw9zxW28TP2oqfSXenFfZOpyXvn1+IwCG1TT1KNKAxzBEBhUcXW0CGVKy523M5KTt48nNwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uk191Bw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uk191Bw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73531C4CECE;
	Thu, 12 Dec 2024 16:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022444;
	bh=fwrOdF1q3ItXED9f9JZDdusB3cghkRFrdc1yJRI0pk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uk191Bw/f7PZ7TL5BgQO+ACQZ+KOF4mV6hgTcrvG6V3LAHI70ba5uTbRgXqUzS+Ko
	 nVAh5wgB3DZcrBtv7/pPoZloIeRgJlSyl2uQctGt0B4Czcyn+RKYKTNCc10QkNbpsN
	 3Jp/nZ0emBqZmpV86HZsHHs34Gd5BBPX4xDItC3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Kjos <tkjos@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/565] PCI: Fix reset_method_store() memory leak
Date: Thu, 12 Dec 2024 15:57:17 +0100
Message-ID: <20241212144321.044066016@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ee1d74f89a05f..09d1b69746602 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5214,7 +5214,7 @@ static ssize_t reset_method_store(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	char *options, *name;
+	char *options, *tmp_options, *name;
 	int m, n;
 	u8 reset_methods[PCI_NUM_RESET_METHODS] = { 0 };
 
@@ -5234,7 +5234,8 @@ static ssize_t reset_method_store(struct device *dev,
 		return -ENOMEM;
 
 	n = 0;
-	while ((name = strsep(&options, " ")) != NULL) {
+	tmp_options = options;
+	while ((name = strsep(&tmp_options, " ")) != NULL) {
 		if (sysfs_streq(name, ""))
 			continue;
 
-- 
2.43.0



