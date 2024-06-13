Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1A014830B;
	Thu, 13 Jun 2024 11:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279764; cv=none; b=pynungVermJauJ+Wyy2ICfuNPUiX5eLVMFYJR4XqfEIoDJEQ8CxESoDoq7RowDqGGb3Df0J/8pfxw7QK2w70D4fC5Uble5RImzyia+gnhivdRYfg9Vgf9kSzpLmgwzD7g7OIFaWrGr1u9b+bboxBagFCimkQLqptJbEjrqg1i/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279764; c=relaxed/simple;
	bh=HtGEjCbjCnJOqQE9xhWuG1lNSaxRbq3SBuFfA4w7wKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAPUpxB2QIid7oCgVirJqYi2TqXVJpA2PeZg/X3N/jpthKOWSqN+wgAPtZyjR/KzKvmzv+DMm++TgrTpa2NW9MliEei3a+ZHqFvaF42NRsC7TddLGNMmnOmyBw7HdAZ1MA6NE9eSiHFG2VYpNHTDM3fmVrxqIm+nOc4qi8xuWh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQ+8OQJr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQ+8OQJr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31421C2BBFC;
	Thu, 13 Jun 2024 11:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279764;
	bh=HtGEjCbjCnJOqQE9xhWuG1lNSaxRbq3SBuFfA4w7wKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQ+8OQJrfApmez2OtnWvmZmbwDNvA/YgwiMbQzYO+AWdpvLba3/5bFYeivp6EQvRE
	 Gtmjqg9Qf7uqT5cEv0WYIyYlxOp0z32K5n5WWp1vYEkwFxC7WCmdJvpXUmD3EpAWCm
	 E7YI9g072NF0zHwSCm3esA7ywtSqKmi6hXIdE5Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/202] qed: avoid truncating work queue length
Date: Thu, 13 Jun 2024 13:32:07 +0200
Message-ID: <20240613113228.896594845@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 954fd908f177604d4cce77e2a88cc50b29bad5ff ]

clang complains that the temporary string for the name passed into
alloc_workqueue() is too short for its contents:

drivers/net/ethernet/qlogic/qed/qed_main.c:1218:3: error: 'snprintf' will always be truncated; specified size is 16, but format string expands to at least 18 [-Werror,-Wformat-truncation]

There is no need for a temporary buffer, and the actual name of a workqueue
is 32 bytes (WQ_NAME_LEN), so just use the interface as intended to avoid
the truncation.

Fixes: 59ccf86fe69a ("qed: Add driver infrastucture for handling mfw requests.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240326223825.4084412-4-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_main.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 1cbcc27602780..91ca2b706938f 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1177,7 +1177,6 @@ static void qed_slowpath_task(struct work_struct *work)
 static int qed_slowpath_wq_start(struct qed_dev *cdev)
 {
 	struct qed_hwfn *hwfn;
-	char name[NAME_SIZE];
 	int i;
 
 	if (IS_VF(cdev))
@@ -1186,11 +1185,11 @@ static int qed_slowpath_wq_start(struct qed_dev *cdev)
 	for_each_hwfn(cdev, i) {
 		hwfn = &cdev->hwfns[i];
 
-		snprintf(name, NAME_SIZE, "slowpath-%02x:%02x.%02x",
-			 cdev->pdev->bus->number,
-			 PCI_SLOT(cdev->pdev->devfn), hwfn->abs_pf_id);
+		hwfn->slowpath_wq = alloc_workqueue("slowpath-%02x:%02x.%02x",
+					 0, 0, cdev->pdev->bus->number,
+					 PCI_SLOT(cdev->pdev->devfn),
+					 hwfn->abs_pf_id);
 
-		hwfn->slowpath_wq = alloc_workqueue(name, 0, 0);
 		if (!hwfn->slowpath_wq) {
 			DP_NOTICE(hwfn, "Cannot create slowpath workqueue\n");
 			return -ENOMEM;
-- 
2.43.0



