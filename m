Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD4C4315A;
	Mon, 23 Jun 2025 21:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714946; cv=none; b=kKu/5s99wzm3TLFlwJtM/DVOecAe38+wlIh+qRXXf8ZBWZ3GePz6tBrOKk36V9nL298B+XKTA75O+BdYnymxbRqJ4n1EPVggEcSh3kTCCpOnhz9vbjKxxZd53Uxr/HqcEoStGnH05/tZH9YPxm1KT10ec5LnTajvMlBIIaBIs2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714946; c=relaxed/simple;
	bh=svCL+OTkgEEzgFO1anx3htOtiNuXJNnIIKtYtFJHFCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrXDZRMmIhUNZmIlncBFunv2BpmMRVvxKJqLIKmL2YJvt7cgplI+Wz8s0nDPGKFtsm3MbfPmFTWvXRJkkGxGuC5OVeCWWZLR7tCElnRkx7/tLl7w7ofiivQ580IjlHSXBwEcFQjNC2ZuUzl1cwwpWjyQmtX3ThhgmZSmjC5cjJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a86uD0Q5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a86uD0Q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8501C4CEEA;
	Mon, 23 Jun 2025 21:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714946;
	bh=svCL+OTkgEEzgFO1anx3htOtiNuXJNnIIKtYtFJHFCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a86uD0Q59iu4yRmEi8HSdx4hWzB5QQmPW4nGbz1NGhQkz2hr8zUQpzXbksSpJ86OS
	 WOWJ67X7gWcH0/UrR6cg1TQEzvKcjTzicCC+F//egskWfICwwRG9AgQVx9D4cDqzQc
	 TR119rOI+s/NfuGcrVtTqL+gKkI45ASgbbPSN+uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/290] wifi: iwlwifi: pcie: make sure to lock rxq->read
Date: Mon, 23 Jun 2025 15:07:11 +0200
Message-ID: <20250623130632.006060708@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 1cc2c48c4af81bed5ddbe9f2c9d6e20fa163acf9 ]

rxq->read is accessed without the rxq->lock in a few places,
Make sure to have the lock there.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Tested-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20250424153620.73725f207aaa.I1a3e4b6c5fd370e029fdacfcdc9ee335788afa98@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index e9807fcca6ad1..5c2e8d2883976 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2701,6 +2701,8 @@ static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
 	for (i = 0; i < trans->num_rx_queues && pos < bufsz; i++) {
 		struct iwl_rxq *rxq = &trans_pcie->rxq[i];
 
+		spin_lock_bh(&rxq->lock);
+
 		pos += scnprintf(buf + pos, bufsz - pos, "queue#: %2d\n",
 				 i);
 		pos += scnprintf(buf + pos, bufsz - pos, "\tread: %u\n",
@@ -2721,6 +2723,7 @@ static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
 			pos += scnprintf(buf + pos, bufsz - pos,
 					 "\tclosed_rb_num: Not Allocated\n");
 		}
+		spin_unlock_bh(&rxq->lock);
 	}
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
@@ -3385,8 +3388,11 @@ iwl_trans_pcie_dump_data(struct iwl_trans *trans,
 		/* Dump RBs is supported only for pre-9000 devices (1 queue) */
 		struct iwl_rxq *rxq = &trans_pcie->rxq[0];
 		/* RBs */
+		spin_lock_bh(&rxq->lock);
 		num_rbs = iwl_get_closed_rb_stts(trans, rxq);
 		num_rbs = (num_rbs - rxq->read) & RX_QUEUE_MASK;
+		spin_unlock_bh(&rxq->lock);
+
 		len += num_rbs * (sizeof(*data) +
 				  sizeof(struct iwl_fw_error_dump_rb) +
 				  (PAGE_SIZE << trans_pcie->rx_page_order));
-- 
2.39.5



