Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F374FDA63;
	Thu, 17 Sep 2026 17:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664913; cv=none; b=nvCfi7hbM5P9DLckJEhkLu24W6YgF6L9T3MpbiUUmhTUAmqs4+6fXs0xqJQykxGjeO4RTtsdivnfQyis4/P3/tXFffJKJmlckJxv45ye6sYP3o0GufFETdBOZVtf0jU7rVEKv1zMxrf62d/Nysu+AVJ4Nimc6HoTcSS5uekQcQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664913; c=relaxed/simple;
	bh=gQFvfeZfKAlHvn9vdZIxqDFSanVvrz8vKkwkHwft3tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENgAMSsJCLM0XqrLvIFgcefA6f+CkIZvJRKaTA4PVoov1QwpqKG3o65/ErTYaFzLpjYTrxJiGi8oj2XeLz3l5PtHpPeZz6xLsMD3KnOvXZvDWwqYLC4Z2Ay8K6NzKXATYfXx4zXxQnO/UbvEC3ioWO70pD83dqCPLGYHTJqXAOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVwsvVcm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVwsvVcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E3C1F000FF;
	Thu, 17 Sep 2026 17:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664912;
	bh=VZR9zQ43DZtEGhH0fjj8cf52V7VxoZgwqK6SrUBmeV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVwsvVcmlvj8xFlnjb3fyMZgHGxA2pW8k+KlKWrWfEntPFYNCh3ox71JEorRrGycM
	 IizvCzrW21WRNbQt0mFEcb5uVT1ETtz+wimbzGqS3IrxWtz/WcsY1h9nLXo5XHSWVc
	 DuyAvQ/H0+CN6sllEpBhhdowT94mZaeK34BSGKVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0531/1250] wifi: iwlwifi: mvm: fix out-of-bounds tid_data access in BA notif
Date: Thu, 17 Sep 2026 16:05:26 +0100
Message-ID: <20260917151606.333060202@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ebb201bd23d85..eab3f7184b49b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -2171,8 +2171,14 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
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



