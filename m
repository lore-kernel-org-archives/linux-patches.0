Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72645381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D84C433C8;
	Mon, 19 Jun 2023 10:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171024;
	bh=kk7G0JQ/GsMop0i9mZcn4FnLKX/wUXftZ9AoPDes9K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KB9RfzPeYONcaa9P26K9ayrFKhlcXaqm6Z0u4+GY28lZ/gsIwIjvTvTTV+5r3W6Tl
	 X5m9xb1I/Tj8j35t3AU7ZpsICggNpmN87QL+WxSn8fQ6r1iMtIX/apSpSn9/TuXhWl
	 7a2FkRukW/u/SAm0AbQNSNpXSvaEQOXF3Zw0hjtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Sunitha Mekala <sunithax.d.mekala@intel.com>
Subject: [PATCH 6.3 120/187] ice: Dont dereference NULL in ice_gnss_read error path
Date: Mon, 19 Jun 2023 12:28:58 +0200
Message-ID: <20230619102203.348810378@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Simon Horman <horms@kernel.org>

[ Upstream commit 05a1308a2e08e4a375bf60eb4c6c057a201d81fc ]

If pf is NULL in ice_gnss_read() then it will be dereferenced
in the error path by a call to dev_dbg(ice_pf_to_dev(pf), ...).

Avoid this by simply returning in this case.
If logging is desired an alternate approach might be to
use pr_err() before returning.

Flagged by Smatch as:

  .../ice_gnss.c:196 ice_gnss_read() error: we previously assumed 'pf' could be null (see line 131)

Fixes: 43113ff73453 ("ice: add TTY for GNSS module for E810T device")
Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_gnss.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index bd0ed155e11b6..75c9de675f202 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -96,12 +96,7 @@ static void ice_gnss_read(struct kthread_work *work)
 	int err = 0;
 
 	pf = gnss->back;
-	if (!pf) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-	if (!test_bit(ICE_FLAG_GNSS, pf->flags))
+	if (!pf || !test_bit(ICE_FLAG_GNSS, pf->flags))
 		return;
 
 	hw = &pf->hw;
@@ -159,7 +154,6 @@ static void ice_gnss_read(struct kthread_work *work)
 	free_page((unsigned long)buf);
 requeue:
 	kthread_queue_delayed_work(gnss->kworker, &gnss->read_work, delay);
-exit:
 	if (err)
 		dev_dbg(ice_pf_to_dev(pf), "GNSS failed to read err=%d\n", err);
 }
-- 
2.39.2



