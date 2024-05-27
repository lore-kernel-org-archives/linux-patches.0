Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5385168C4;
	Mon, 27 May 2024 19:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837889; cv=none; b=fKhQ36OvGYYw01YohEfVbO+NacKfAtaDHrwK40beq/bf67U9VXRQmNGVJo8dxQW+SL0Lw8UU7j7K2CdGGttQpAvYLgFvKxWEvRHRjFcEWThJ1aHwT1hPHydKvpKu6xW0Xiwup/btLJqa+UjhETF5jEK8jPye2l0MVkLmZE4ySOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837889; c=relaxed/simple;
	bh=q3qGDg5DvP/5yvy45q0Gud8XgwFmfTDuAq/SSt52ApU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrjCHe4AuXURc2J9JqmpFcB2OmtXYIWJ/zu2HPVzzgn62uG3ROjgtGJisbVYkGt2NQMNOEZUiGU3l9+2yYo43H4+6/ztZKgbLpyzhMD2i2QT2+9BRWwUkOkNJaZC2zLMtZFVy/i7zsocAr6cX5HjoHOApyHVRIsKpmGCbzIgsbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCvZ66Wl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCvZ66Wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76686C2BBFC;
	Mon, 27 May 2024 19:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837888;
	bh=q3qGDg5DvP/5yvy45q0Gud8XgwFmfTDuAq/SSt52ApU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCvZ66Wl6ljPtMkxd7MRnjLif2FYW0LKrXTqY+itKdvHxKeOPy8WZUxgQOOcqE7xw
	 ejIX8NveuFhsp2hItGKsrZqAfajucEhxgDKRJULhNJ8G0Kf6S9+s142WiT92dNxcQX
	 J70QztcHqhUvfhx2VBuDvoD5q36xRqnG2KXWugLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 185/493] qed: avoid truncating work queue length
Date: Mon, 27 May 2024 20:53:07 +0200
Message-ID: <20240527185636.402646890@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index c278f8893042b..8159b4c315b5d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1206,7 +1206,6 @@ static void qed_slowpath_task(struct work_struct *work)
 static int qed_slowpath_wq_start(struct qed_dev *cdev)
 {
 	struct qed_hwfn *hwfn;
-	char name[NAME_SIZE];
 	int i;
 
 	if (IS_VF(cdev))
@@ -1215,11 +1214,11 @@ static int qed_slowpath_wq_start(struct qed_dev *cdev)
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



