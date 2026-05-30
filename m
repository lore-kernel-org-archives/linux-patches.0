Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6308931CA4E;
	Sat, 30 May 2026 16:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159658; cv=none; b=vCD7pnRqScDBspxHso/UWY4VdEtrtumjXjLLnJv+bZS6cfh8MlSkqnognnw/xVWlwD8sFQQxDM+p4pzljQjzm3W/PhMGAjQJymrU0m2Q+c++JQACJ4ECPgA2trAiU4OSEoOGNnNEyT87vG7AWzpBPPj8N3eEvvtYhZJ+cHnYjP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159658; c=relaxed/simple;
	bh=aaP28BiBPVjbi+NYGxdGMGJC0+FZxcZXGqK9R4+G1bE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwWU8DlXx/y/SIYwECgw8+vo9kn9mLh0NDBWhkSaLGqpizk1UwbNlbN2YPfSbSxlfuanyiSkwOuxQWZVF1EyJo4hql0gpBAsZOoxVHhYbh2eXrNrZIrYn43pqFPII/flHqRprsGGNSYEYBH0gm2TAD43viRhqXDs1O0BAI6+uIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnAa5Ds/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnAa5Ds/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85351F00893;
	Sat, 30 May 2026 16:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159657;
	bh=sn0mIHHLF983lAqDRHBp1/Z5SqX2PY2MwGQhJbOC8XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qnAa5Ds/eAQtI+DZigJEVvO2eOIgMBj7h9Y6pSNrZDfummKDlx6XOL+Wsvz5pmu8Z
	 j75adyDBLU186o6hxCGu4jNv41HOKbTZKQJAql/lGPqc+KVwuooVeNxb/KIcxDOiKZ
	 fGPIZebSokPXY/ML5w9kPu9G0uuqffNORMQ1fCkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 6.1 138/969] wifi: iwlwifi: read txq->read_ptr under lock
Date: Sat, 30 May 2026 17:54:22 +0200
Message-ID: <20260530160304.375923137@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit c2ace6300600c634553657785dfe5ea0ed688ac2 upstream.

If we read txq->read_ptr without lock, we can read the same
value twice, then obtain the lock, and reclaim from there
to two different places, but crucially reclaim the same
entry twice, resulting in the WARN_ONCE() a little later.
Fix that by reading txq->read_ptr under lock.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240319100755.bf4c62196504.I978a7ca56c6bd6f1bf42c15aa923ba03366a840b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ Change read_ptr definition according to commit
413be839bfca9("wifi: iwlwifi: add a validity check of queue_id in iwl_txq_reclaim"). ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/queue/tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/queue/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
@@ -1555,7 +1555,7 @@ void iwl_txq_reclaim(struct iwl_trans *t
 {
 	struct iwl_txq *txq = trans->txqs.txq[txq_id];
 	int tfd_num = iwl_txq_get_cmd_index(txq, ssn);
-	int read_ptr = iwl_txq_get_cmd_index(txq, txq->read_ptr);
+	int read_ptr;
 	int last_to_free;
 
 	/* This function is not meant to release cmd queue*/
@@ -1563,6 +1563,7 @@ void iwl_txq_reclaim(struct iwl_trans *t
 		return;
 
 	spin_lock_bh(&txq->lock);
+	read_ptr = iwl_txq_get_cmd_index(txq, txq->read_ptr);
 
 	if (!test_bit(txq_id, trans->txqs.queue_used)) {
 		IWL_DEBUG_TX_QUEUES(trans, "Q %d inactive - ignoring idx %d\n",


