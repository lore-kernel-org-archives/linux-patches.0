Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83DF53A7;
	Fri,  6 Dec 2024 15:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497617; cv=none; b=T5bilmSzXeI0D7yndowrgxGd8Ypq2E8Gz/OCA+Nj/plbHvR6XgG0z4Stp01MUW+zHEMPYl7du47UaDWU5aa6a+9BFaZyJ4AluXu3KAcw5RFSnz+W0TbbdwLg7yh5scDyWarqwKr24fTaRDxA3FG7kZWO5VTg/OxAC2MQeLlw6W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497617; c=relaxed/simple;
	bh=rPm1jrmVXU5a+rWVVfD8ArKWq4H8AGMa5tpIHZNGjNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwdlnjYstDHCFtYAsZm7+DyY+ZLqb/llbuEIhKfsuav/ElIA4O1awp3dtz82Z/uPVPa3tI3zRplGGqPSin5NZgyXaXqcvp/npob/PijYgNAgY1rBtoYxoGP1wkeMceyaUVMp307qw15cNSCJ7e3Gq+YBM9XNsjvS4qzesZzC96U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcmK7YxH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcmK7YxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D3FC4CED1;
	Fri,  6 Dec 2024 15:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497617;
	bh=rPm1jrmVXU5a+rWVVfD8ArKWq4H8AGMa5tpIHZNGjNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcmK7YxHlR6MZ9ZhvSJEsKAbJihypghSncz3SGTkmLYX8jxFoe3ZnOAuLlXs5EO2k
	 fDiXutgqMfvhKx2uZPLtso3f9lpBNwVg1gMlw1l95fjyJdebovfLO3hCfRsQyLmLWd
	 zpUIBwGMabr9+KZgt8BEAkeow37YhOdae4lNYdcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Kjos <tkjos@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 341/676] PCI: Fix reset_method_store() memory leak
Date: Fri,  6 Dec 2024 15:32:40 +0100
Message-ID: <20241206143706.669847097@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 93f2f4dcf6d69..830877efe5059 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5444,7 +5444,7 @@ static ssize_t reset_method_store(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	char *options, *name;
+	char *options, *tmp_options, *name;
 	int m, n;
 	u8 reset_methods[PCI_NUM_RESET_METHODS] = { 0 };
 
@@ -5464,7 +5464,8 @@ static ssize_t reset_method_store(struct device *dev,
 		return -ENOMEM;
 
 	n = 0;
-	while ((name = strsep(&options, " ")) != NULL) {
+	tmp_options = options;
+	while ((name = strsep(&tmp_options, " ")) != NULL) {
 		if (sysfs_streq(name, ""))
 			continue;
 
-- 
2.43.0



