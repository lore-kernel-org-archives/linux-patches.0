Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C8E3BB138;
	Wed, 30 Sep 2026 18:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794735; cv=none; b=H4sXnAbaG2EUSs65V2IIg03q7mqPWQjY9krPSTkvovltFJO4JXlVF0fT8meocX8L5RR25E3oM1xE/KiMGFoaw81XVSN9SOxnnPtOoLxq0/qp5206MtODrjuhjnBrY2SPS0FMtE+aHbetHfCsj3sdPg26kkVAR2OcBCHXRGosjBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794735; c=relaxed/simple;
	bh=qChmVkU5HgfJJOmBxwcbzayFCHI9TAWze4Z4kWft/zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYcz4OQSBLFL1D4JOw9h2iHUxRS0Pg4Egw9P4DZskoI7tu/S3QfKGQ5U7+mq3zgC3aWjVTsODJYcm0kshShRsZJ6/hTjqmoL0ZMJwWWea9q1stSUYkTyId3cM8+HtRfM8Zj40wupSMl9tzgOzeNXxIkekzp0i3D2sl3KQT2SkPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x67pnF8B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x67pnF8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1111F000FF;
	Wed, 30 Sep 2026 18:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794734;
	bh=0AvGwiZDlIW8sEobO8bERtnC58YVU6DEJDwqzWqkVN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x67pnF8BZtajflS7xpey0ySHU6S9b7LBE645oNu5ay6t1laXvvmSd2hiBa0chaI++
	 mem/8HVaPw3chb85Trf9YGrec3ZSmmCJKyNvYf4OHTYlN7w1nCzunmzuNdrGkqKmb1
	 TkHkj767WyuM1zsw4K9V9EIed2MLpixOTpuUkzbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0314/1193] wifi: iwlwifi: mvm: fix out-of-bounds tid_data access in BA notif
Date: Wed, 30 Sep 2026 17:16:38 +0200
Message-ID: <20260930152441.115851584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 94d3982806c7f194b23484befde12934dda23064 ]

mvmsta->tid_data was indexed by the TFD loop counter 'i' instead of
the actual TID value 'tid'. This writes lq_color into a random tid_data
slot unrelated to the BA entry.
Since multi-TID blockack is not really in use, 'i' was always 0 and no
harm was done.
Add a out-of-bound check before accessing the array.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.919edee567eb.Ie85c350e3afe2b39709d0039072740d86660f8ae@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 6401030e66143..2594e8a977e94 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -2183,8 +2183,14 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 			if (tid == IWL_MGMT_TID)
 				tid = IWL_MAX_TID_COUNT;
 
+			if (IWL_FW_CHECK(mvm, tid >=
+					 ARRAY_SIZE(mvmsta->tid_data),
+					 "invalid TID %d in compressed BA\n",
+					 tid))
+				continue;
+
 			if (mvmsta)
-				mvmsta->tid_data[i].lq_color = lq_color;
+				mvmsta->tid_data[tid].lq_color = lq_color;
 
 			iwl_mvm_tx_reclaim(mvm, sta_id, tid,
 					   (int)(le16_to_cpu(ba_tfd->q_num)),
-- 
2.53.0



