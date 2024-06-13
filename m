Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CDC142E83;
	Thu, 13 Jun 2024 11:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278672; cv=none; b=mxRDYQRCGrwIp0H5STXXycAVg9hH8xCJTJoT0bD6g1zuO0qArqeBsNBG6Aj5/AoQCOsBmGDHATlPEfZpgpGDP3iKwVfptCUTzactuBoB7GsBWetVzEg1jc0rdzjAYKzAvaBSBtB46BU8GR3W6VmtSH03hm8ZJBqnUB3r2Q5fghc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278672; c=relaxed/simple;
	bh=zGkkU419yhEROKUgevD2YYshLhqMQW3deKl5ZwgVdA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZdKXSk10HywBVq27WbEnvTvv5SQzNHSKk/X1nDQY1YsqjaNRvb5R7dhLnKCPrTBDQo2BAXuYm0b/U0+bg18fuQLHtTuFwlORu7vG3I7mQcqrpDedqbivAZ27bR20S7vhfYzF2BcZdS07bTQ8HGl9hnRVB0jcUP+a1df2xWlhmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IuL1i1Ep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IuL1i1Ep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E14C4AF1A;
	Thu, 13 Jun 2024 11:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278672;
	bh=zGkkU419yhEROKUgevD2YYshLhqMQW3deKl5ZwgVdA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IuL1i1EpdDfHL0VknXHHnKQ1GlS8RE3d7lP99GLlXkUr4O1Gj5DztdjEUFr4xgstE
	 fgy9PNjfwY0xh2N//N04fwTmEmKXhpGZ7bACxC8wqrVBSDLskcOL2OYRdV3rbQysY6
	 cKjGn5tPmStQ7pmuCYuqKUtANLbMG3zF8k4btLIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 031/213] qed: avoid truncating work queue length
Date: Thu, 13 Jun 2024 13:31:19 +0200
Message-ID: <20240613113229.199320216@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 43c85e584b6fe..d0441bd1944a4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1007,7 +1007,6 @@ static void qed_slowpath_task(struct work_struct *work)
 static int qed_slowpath_wq_start(struct qed_dev *cdev)
 {
 	struct qed_hwfn *hwfn;
-	char name[NAME_SIZE];
 	int i;
 
 	if (IS_VF(cdev))
@@ -1016,11 +1015,11 @@ static int qed_slowpath_wq_start(struct qed_dev *cdev)
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



