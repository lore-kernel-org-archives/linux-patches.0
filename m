Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A8813AD2A;
	Tue, 14 May 2024 11:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684910; cv=none; b=HUtp/A08R0rFlYKhL5ikxURHkBBptTUQMgZspKFUWmLOT1Rqj04ZOTDs0vgenhhSMehcjIaDnDPzXWhvrJcF/Vd7p2UbjDxmffMZfiDJ+E4X9ob4SxCNAQ7q4I6hkIrrgy4060bU17JkEvDx6tG7PkDctNPrUg2wRKRvf23q4aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684910; c=relaxed/simple;
	bh=/D/DiiyMPHkDJ8Jqk0H6MoYxWrFueBIRfIf+BZM71jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUsyB7+gKRiZRHoBuiR9obrs6qerTcwTO4YPkbQG/+ayDBE5S48BFFcu7OIQCEKtPEsH38jRbcaqr7gYXf0PBM8Xl37qcbs5znW9ZzbggFMpcPUdEPDN76vXk9FkerstVsYae//K6r+32pWuur3DsAat7tEqHMxKd72s+7ZE7zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IseEooSN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IseEooSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB37C2BD10;
	Tue, 14 May 2024 11:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684910;
	bh=/D/DiiyMPHkDJ8Jqk0H6MoYxWrFueBIRfIf+BZM71jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IseEooSNaL7Ln87d+X06oREmdVPcOJXggyOoB1PPNu4/nQYivx8SR3dg6GlMn+MZS
	 fagu1tjvTrsaos5RDqDwDws/zwBwPPsl5Nz97X3ucM68vdaXKtbaHIDoz8Hqc0g0b4
	 CPwFdgGbBFumyz2m2aZ0hQVEExTuy/xD+1DhMeF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/301] wifi: iwlwifi: read txq->read_ptr under lock
Date: Tue, 14 May 2024 12:16:18 +0200
Message-ID: <20240514101036.291893385@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c2ace6300600c634553657785dfe5ea0ed688ac2 ]

If we read txq->read_ptr without lock, we can read the same
value twice, then obtain the lock, and reclaim from there
to two different places, but crucially reclaim the same
entry twice, resulting in the WARN_ONCE() a little later.
Fix that by reading txq->read_ptr under lock.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240319100755.bf4c62196504.I978a7ca56c6bd6f1bf42c15aa923ba03366a840b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/queue/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/queue/tx.c b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
index ca74b1b63cac1..0efa304904bd3 100644
--- a/drivers/net/wireless/intel/iwlwifi/queue/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
@@ -1588,9 +1588,9 @@ void iwl_txq_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 		return;
 
 	tfd_num = iwl_txq_get_cmd_index(txq, ssn);
-	read_ptr = iwl_txq_get_cmd_index(txq, txq->read_ptr);
 
 	spin_lock_bh(&txq->lock);
+	read_ptr = iwl_txq_get_cmd_index(txq, txq->read_ptr);
 
 	if (!test_bit(txq_id, trans->txqs.queue_used)) {
 		IWL_DEBUG_TX_QUEUES(trans, "Q %d inactive - ignoring idx %d\n",
-- 
2.43.0



