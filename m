Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF910C2E0;
	Mon, 23 Jun 2025 21:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714319; cv=none; b=Ee2uLZFWVnbq+WkCpxQz6WDcK1OTlydgiM39RVo+LfSNl19cj12j9ENkXJ3YPr3maFAOpak6YqE6MZikCun0/+INh+5X55UjmkNubi9XI3FPyvM5tW0g9aLc7vG4GLLBAl3pKPfCbAkTzfVDUjqc25n1yHvQHwc1xg3Uh+1bgWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714319; c=relaxed/simple;
	bh=13SSKrJr0/9GxJu0hnA0x8qWxF/x5uvejsM5bWmLGQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jst7qPSEoLq35jHzKf9WD6AjjPotfbPfJluChZjJncVXaBwbE9fvPqfx4mPwMZfc1+Jizcb/s4KbS6AJcyQU88ELp4cDzg5Z3V3F51uR/mlHmdAnyg/yo9GEbfCIw6+r5faOP7YBOURPlMy4nnzah0wj/LeaN2afXmnkzKFPJ5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVvQRX8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVvQRX8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CC4C4CEEA;
	Mon, 23 Jun 2025 21:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714318;
	bh=13SSKrJr0/9GxJu0hnA0x8qWxF/x5uvejsM5bWmLGQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVvQRX8BtFFltb8zku1e4V52nF4CRxUXkAAN6FmvqxT/X/lJ1QtT4FGkpk9U/YY3Z
	 tFX8Jx262TTrJi9u7KJ/utW770g3pnKnJtNf6via0zX/F/jnWZucneM+YQ8AAhbQfW
	 ggKKvZShVfJRqYQiJSVRiLOnEvutycsLQzDeXk58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 383/592] wifi: iwlwifi: pcie: make sure to lock rxq->read
Date: Mon, 23 Jun 2025 15:05:41 +0200
Message-ID: <20250623130709.552320909@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 102a6123bba0e..4cc7a2e5746d2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2942,6 +2942,8 @@ static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
 	for (i = 0; i < trans->num_rx_queues && pos < bufsz; i++) {
 		struct iwl_rxq *rxq = &trans_pcie->rxq[i];
 
+		spin_lock_bh(&rxq->lock);
+
 		pos += scnprintf(buf + pos, bufsz - pos, "queue#: %2d\n",
 				 i);
 		pos += scnprintf(buf + pos, bufsz - pos, "\tread: %u\n",
@@ -2962,6 +2964,7 @@ static ssize_t iwl_dbgfs_rx_queue_read(struct file *file,
 			pos += scnprintf(buf + pos, bufsz - pos,
 					 "\tclosed_rb_num: Not Allocated\n");
 		}
+		spin_unlock_bh(&rxq->lock);
 	}
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
@@ -3662,8 +3665,11 @@ iwl_trans_pcie_dump_data(struct iwl_trans *trans, u32 dump_mask,
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



