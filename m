Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1E41DE8A5;
	Tue,  3 Dec 2024 16:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241636; cv=none; b=ZJUZ1qsi4i3ZhSCuEmJfNA9JhHaUqRPWXgXog2Usmt0e5/b86y5UWnYU2jQX/dbX9PUz4eopf4uIwN0b8174Kwng3Tl5xE1NrNCrA5EVL4xpPumzXqTxLQPgrlSbTG/FxD8XKMzFVW5kKOf3Am+YKp2/y30XRj3sLEWBUIQvRW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241636; c=relaxed/simple;
	bh=rOBF4vZdgtHBC2gPWPDy2jg/9bWlyC0HRwf88BUj5Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xnb/+tE1cAzQSspz2ax3KxOMaQWGwqlbUtxsIzG/ZhOcdr3coaJ7xxHocRukvuEI3dntzkENY5TwxhZYfKz/QnZ258mrFwdB+SJf1qcsZWauypWD/n3JS+D76mwlzlicwRfqZjaK6MfFKrE8+vP4xUdOv7fu4seAYLNBIQyssHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OuSNV3op; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuSNV3op"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E01C4CECF;
	Tue,  3 Dec 2024 16:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241636;
	bh=rOBF4vZdgtHBC2gPWPDy2jg/9bWlyC0HRwf88BUj5Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OuSNV3opMZlt76eWRK5JP1MJ1yWTDqFsl4iZGgR3bxeXTdxwnE40xdtIsjk5d4sKB
	 nIbSCEG2ZMLcAObzMg4xNQrjg7h3UwE4JRJGaNfT74TKhJKU3na848IEZp7EMwhbYu
	 4ypxP1LU4yJmVYUDdZA2CqlboGxvK+082Y/h/FzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Kjos <tkjos@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 473/826] PCI: Fix reset_method_store() memory leak
Date: Tue,  3 Dec 2024 15:43:20 +0100
Message-ID: <20241203144802.213553135@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 225a6cd2e9ca3..08f170fd3efb3 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5248,7 +5248,7 @@ static ssize_t reset_method_store(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	char *options, *name;
+	char *options, *tmp_options, *name;
 	int m, n;
 	u8 reset_methods[PCI_NUM_RESET_METHODS] = { 0 };
 
@@ -5268,7 +5268,8 @@ static ssize_t reset_method_store(struct device *dev,
 		return -ENOMEM;
 
 	n = 0;
-	while ((name = strsep(&options, " ")) != NULL) {
+	tmp_options = options;
+	while ((name = strsep(&tmp_options, " ")) != NULL) {
 		if (sysfs_streq(name, ""))
 			continue;
 
-- 
2.43.0



