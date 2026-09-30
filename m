Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0522E7386;
	Wed, 30 Sep 2026 18:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794732; cv=none; b=XI6purwMjNBXzce/kJxZAg/yEdW7KWd+yl8cTzYqxzt9jKgIRABn47FG9dPHK46gX6xPF06nPdUFNcPOvLbR9dYFQp8s+woNvuiDk71gFBjxMSAROIhJz0RyrGZb4UnpM60RwXaE3RU06u1gqOFfy0H9dRY5hRlm90n+VIbs+3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794732; c=relaxed/simple;
	bh=755TetYcmnmmUqbQeM2/abjQpBTUQHD+xhU5ZFLNUL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhZBKfiR4lxk85VcPIeO1/zSzPqCwnoDbuPtxmI3pXOJp+hNNpXBhXJc2AprxCp4mPEu7aMm93Xyq0USAlb4tvHsr7Uy22hlsIv6sRORCCAG83WawoPLsgNNWfhc6yxGMPalQrhYFp7ucX2NEpV++fWwOeXfpcqvecXDAobtQx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJhz78PV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJhz78PV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935421F000FF;
	Wed, 30 Sep 2026 18:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794731;
	bh=1NhsZlRjWyOSDdIGjCG8X6A0EcyGlwvy4PKtIszCBb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJhz78PVLQA5EulqJ24OC+VaO6h6yI6PtTX5h9YyA+cbbYm+qcq5Yd1r6aMkJ/lMa
	 /ESXYYz7XNrqdF6N6ZbwM7NtUhBQXKAzCIjlJMj4SfVRdvWeZnN4sUcveQO2kiTKvU
	 v3nrxNmHWGeUNIkYNYcItebM2WBblLzK63Zw3Kgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0313/1193] wifi: iwlwifi: mvm: add a check on the tid coming from the firmware
Date: Wed, 30 Sep 2026 17:16:37 +0200
Message-ID: <20260930152441.094405383@linuxfoundation.org>
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

[ Upstream commit 0e4c0d83267261cf67ec9690856edf4a56bb7dfc ]

ba_notif->tid is a firmware-controlled u8 that is used directly
as an array index into tid_data[] without any validation. Add a
bounds check against IWL_MAX_TID_COUNT before dereferencing the
array.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.d7c3e75d47af.If88948108cfc8b5fb3ce5531d927855d1b3b6b30@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index ce5f2bdde1388..6401030e66143 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -2209,6 +2209,9 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	ba_notif = (void *)pkt->data;
 	sta_id = ba_notif->sta_id;
 	tid = ba_notif->tid;
+	if (IWL_FW_CHECK(mvm, tid >= ARRAY_SIZE(mvmsta->tid_data),
+			 "invalid TID %d in BA notif\n", tid))
+		return;
 	/* "flow" corresponds to Tx queue */
 	txq = le16_to_cpu(ba_notif->scd_flow);
 	/* "ssn" is start of block-ack Tx window, corresponds to index
-- 
2.53.0



