Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE45D2EAE6;
	Mon, 23 Dec 2024 16:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969744; cv=none; b=fNdKgTSEHMjXRAhJfmiiWmfogm6A4n71z+S++WEmHUadgFxO+fdk+vQY5oG4G7eQaEMUgSZPGDIb93nCGIHb/hSxzxA7e/jVkwtJmpoBqAMoeN1JwmXnAu7uEAqlSzvGFlaY5xA6a0v7WThuCXxE6nTXMpCygvNgOOqvlJH4kho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969744; c=relaxed/simple;
	bh=mXYEIM50RMXBAE+zTlSfrn2blwdvVa1vXuDS9BviHBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIPFv+Xs1SRSrYQx7jIYVms2QYCCqxszoyIFI9pFq1Gjyab4wAUeUZC55zeeoxrxLfBsQnW0ZhK+hrGn/PncDdGUVyu3g1f295ZR/+Q7G0jA5RtaYmTT6mnYzPIQFZUAN8OdT5fdet78DAM6LsLgAM7U/pMs9v9cQP7v+GSBpSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avcOoP6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avcOoP6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA7FC4CED3;
	Mon, 23 Dec 2024 16:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969744;
	bh=mXYEIM50RMXBAE+zTlSfrn2blwdvVa1vXuDS9BviHBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avcOoP6p6cZfhuuBUfRhtza+orS5uRRq6MR90MFZ/rc2VKhsmfEg1b1x0+Ci8prVm
	 RzGVhvxb1Q5ZiQf3RZEnNT57b0wNQL0SfSqeb/BsGGZhKQL0SW1KEcBR1yvpawP2mo
	 IK+K6t6IHozd1r1Xa1L3Wvv9o2w8zyZhcyw/ebY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/160] ionic: no double destroy workqueue
Date: Mon, 23 Dec 2024 16:57:32 +0100
Message-ID: <20241223155410.257427544@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 746e6ae2e202b062b9deee7bd86d94937997ecd7 ]

There are some FW error handling paths that can cause us to
try to destroy the workqueue more than once, so let's be sure
we're checking for that.

The case where this popped up was in an AER event where the
handlers got called in such a way that ionic_reset_prepare()
and thus ionic_dev_teardown() got called twice in a row.
The second time through the workqueue was already destroyed,
and destroy_workqueue() choked on the bad wq pointer.

We didn't hit this in AER handler testing before because at
that time we weren't using a private workqueue.  Later we
replaced the use of the system workqueue with our own private
workqueue but hadn't rerun the AER handler testing since then.

Fixes: 9e25450da700 ("ionic: add private workqueue per-device")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20241212213157.12212-3-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 9e42d599840d..57edcde9e6f8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -277,7 +277,10 @@ void ionic_dev_teardown(struct ionic *ionic)
 	idev->phy_cmb_pages = 0;
 	idev->cmb_npages = 0;
 
-	destroy_workqueue(ionic->wq);
+	if (ionic->wq) {
+		destroy_workqueue(ionic->wq);
+		ionic->wq = NULL;
+	}
 	mutex_destroy(&idev->cmb_inuse_lock);
 }
 
-- 
2.39.5



