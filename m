Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CE8BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D96C433EF;
	Tue,  7 Mar 2023 17:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211311;
	bh=3SFzK4ThqB2p2K+QiLL72N9vSkMVILJ7cqcgws5JYKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nN0q3P/3tDr6yeEu4aKK071/LMrBpaGht1Kcib+YJprRhGMx4Bq87ks6dqvoQEPn5
	 aVvqQh8J9t4/Zoqo1rdTI6gf8ycsPlrj9COsycNCTMkFCJwGJYbe46aCb9EI/WybLC
	 gTpHmdNGN1MjwfPWE46QT+q8ovzLYxSK4HXyJHb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.2 0820/1001] md: dont update recovery_cp when curr_resync is ACTIVE
Date: Tue,  7 Mar 2023 17:59:52 +0100
Message-Id: <20230307170057.341065333@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hou Tao <houtao1@huawei.com>

commit 1d1f25bfda432a6b61bd0205d426226bbbd73504 upstream.

Don't update recovery_cp when curr_resync is MD_RESYNC_ACTIVE, otherwise
md may skip the resync of the first 3 sectors if the resync procedure is
interrupted before the first calling of ->sync_request() as shown below:

md_do_sync thread          control thread
  // setup resync
  mddev->recovery_cp = 0
  j = 0
  mddev->curr_resync = MD_RESYNC_ACTIVE

                             // e.g., set array as idle
                             set_bit(MD_RECOVERY_INTR, &&mddev_recovery)
  // resync loop
  // check INTR before calling sync_request
  !test_bit(MD_RECOVERY_INTR, &mddev->recovery

  // resync interrupted
  // update recovery_cp from 0 to 3
  // the resync of three 3 sectors will be skipped
  mddev->recovery_cp = 3

Fixes: eac58d08d493 ("md: Use enum for overloaded magic numbers used by mddev->curr_resync")
Cc: stable@vger.kernel.org # 6.0+
Signed-off-by: Hou Tao <houtao1@huawei.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9030,7 +9030,7 @@ void md_do_sync(struct md_thread *thread
 	mddev->pers->sync_request(mddev, max_sectors, &skipped);
 
 	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
-	    mddev->curr_resync >= MD_RESYNC_ACTIVE) {
+	    mddev->curr_resync > MD_RESYNC_ACTIVE) {
 		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
 			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
 				if (mddev->curr_resync >= mddev->recovery_cp) {


