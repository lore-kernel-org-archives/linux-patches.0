Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D400646;
	Tue,  3 Dec 2024 15:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239056; cv=none; b=aXvu0X11msAb/OB2OHb4t76VtiCTXvcyO0Vhq9wHoRedOf7gfujZuMuthvOSHv+A0WtAQDyeebaIXtAoZtz1iAE6ZOG5UurVbzCE8M+dMWufkiJiGHOsyLzuh2Lks4hSPpAxEDgqEnaCbEHRLRgDkXX7cTF7Q/Xc+Ca7E6HVCz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239056; c=relaxed/simple;
	bh=YzOxTzHLuly8saaU/2bDvODXWjLvO0plTdjEM3R3AXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfQu/pdvuDwWWn+QjlhSTl24QWC8WEscjSDNgTnnM+c5zipfvyfdRH7nAlE5IayJRrwD1TprGzK1ZBgy1qSN20Ajo8h9xR3GgHMrXso7a7F1Q9wrWh8lFqgmB5pkJ2YYmBgx4CU6fsmR7CssAhar1s1GYzIIRwiYNPLhE8FcJdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nz2uIxUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nz2uIxUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7147C4CED9;
	Tue,  3 Dec 2024 15:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239056;
	bh=YzOxTzHLuly8saaU/2bDvODXWjLvO0plTdjEM3R3AXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nz2uIxUyxjuEQ2jeD3rnMznZWLCsWgRwHKKZ0zzIMhGixkKhfPDG7SfCQjrRCkwAJ
	 QzYeeSYrmfAfVj8dl2uNSZpmvVxbS8V9kD+dGdUjA+hXxuOkqt7fXznPgOpeXTot2m
	 Lhlg2ONzMyCXJWvyAKk/ocAmP/OMF9eQVp9zfsrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Kjos <tkjos@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 488/817] PCI: Fix reset_method_store() memory leak
Date: Tue,  3 Dec 2024 15:41:00 +0100
Message-ID: <20241203144014.921245566@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 51407c376a222..1a720cae37a1e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5233,7 +5233,7 @@ static ssize_t reset_method_store(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	char *options, *name;
+	char *options, *tmp_options, *name;
 	int m, n;
 	u8 reset_methods[PCI_NUM_RESET_METHODS] = { 0 };
 
@@ -5253,7 +5253,8 @@ static ssize_t reset_method_store(struct device *dev,
 		return -ENOMEM;
 
 	n = 0;
-	while ((name = strsep(&options, " ")) != NULL) {
+	tmp_options = options;
+	while ((name = strsep(&tmp_options, " ")) != NULL) {
 		if (sysfs_streq(name, ""))
 			continue;
 
-- 
2.43.0



