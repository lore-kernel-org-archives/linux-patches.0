Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0EA3090C7;
	Mon, 13 Oct 2025 15:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369439; cv=none; b=cm6wC1W07OBJnMDKYZRTs+72iW0CyooglFLAXqRlVrPfJFrmu97ucrTG4a2GjBDzWb8MGySK3dk+zL8bscJM3Fbyaeh0Ou9pQYovGnHoSrFnU5ExvQSn/n+aREALBTjaEY6KkEfO9zLoJEaORCuMvdiCFa2rc7FRdrFQZKF2ZdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369439; c=relaxed/simple;
	bh=b+mFJqJlfo/QlNOF5C8JIrv9FWvtrUDEgjdDpB20heY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnf8ehlhDsuwQEQ45MJEZkSOE92yKWanqeqOVVg5jFF/s5pAyt8Bg5lwBNxQyQiOAlvgdkVDGQ1ggFSMa0TJbPMhs8hbMVw/IBqqJgLotLvLjgG3xtld6kCq7tBBoyvIdR7QmVUZKUs5uW2OPlsdWDHIM54yVXiyYQ50pmlanU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ya5yLks/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ya5yLks/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BABFC4CEE7;
	Mon, 13 Oct 2025 15:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369438;
	bh=b+mFJqJlfo/QlNOF5C8JIrv9FWvtrUDEgjdDpB20heY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ya5yLks/Fm/5EvcBy9W9OSoXw++cFHQEHg04RavL4lEsKuPd3urJddqAJElEQIg/8
	 +O1TLGwJ8WqZO41lPsXld/qP3zGWUgJFKtFDK7z/AXa+fdxoJ82c98elMg7q5fk0/a
	 FV21oaz2FmqsFu+ip7SgA7S+zz56dH0SPNVaCKo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 247/563] scsi: libsas: Add dev_parent_is_expander() helper
Date: Mon, 13 Oct 2025 16:41:48 +0200
Message-ID: <20251013144420.231919306@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit e5eb72c92eb724aa14c50c7d92d1a576dd50d7e6 ]

Many libsas drivers check if the parent of the device is an expander.
Create a helper that the libsas drivers will use in follow up commits.

Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20250814173215.1765055-15-cassel@kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: ad70c6bc776b ("scsi: pm80xx: Fix pm8001_abort_task() for chip_8006 when using an expander")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_expander.c | 5 +----
 include/scsi/libsas.h              | 8 ++++++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 869b5d4db44cb..d953225f6cc24 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -1313,10 +1313,7 @@ static int sas_check_parent_topology(struct domain_device *child)
 	int i;
 	int res = 0;
 
-	if (!child->parent)
-		return 0;
-
-	if (!dev_is_expander(child->parent->dev_type))
+	if (!dev_parent_is_expander(child))
 		return 0;
 
 	parent_ex = &child->parent->ex_dev;
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ba460b6c0374d..8d38565e99fa1 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -203,6 +203,14 @@ static inline bool dev_is_expander(enum sas_device_type type)
 	       type == SAS_FANOUT_EXPANDER_DEVICE;
 }
 
+static inline bool dev_parent_is_expander(struct domain_device *dev)
+{
+	if (!dev->parent)
+		return false;
+
+	return dev_is_expander(dev->parent->dev_type);
+}
+
 static inline void INIT_SAS_WORK(struct sas_work *sw, void (*fn)(struct work_struct *))
 {
 	INIT_WORK(&sw->work, fn);
-- 
2.51.0



