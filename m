Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24EB3B7B98;
	Sat, 17 Oct 2026 17:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258058; cv=none; b=AYd+dxnzF/9LZB00lpAFe3znWhPA9W26gel9zbTAN96golYK8p7kFxXE1IItBLCPFxcEbEhmCSz1er+wU5z8RTQdRj4HAjtJLYc+hCnjDIeJm4w+di3vjlPzlKfHpTg2JH5sH6Qo0e4BWeiZ5TSA973xe5M+b5JlsRMjRRxhvL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258058; c=relaxed/simple;
	bh=EvSxdVQmNE2krcyp1vhORRrIaamgwDkoYlbtDudRrVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=co2UonaojXQ4vrvjSzCpvlQqJcNnU0EiVWLguPUK5k4rpYNUk8Uzt330WpDJ+aT0YN9vfJhDyfhwLiVQtqCwouupVe8vjDIa5NLmnBMs8COv2dMbyv44q+8qWfAeN/mGOXc1180ONzSZbjCdR2q6882dqX+KNEOJJiZRv83PO0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TV6zm77B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TV6zm77B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AC41F000C4;
	Sat, 17 Oct 2026 17:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258057;
	bh=KCc3/w0sS8+gdG7vTNDO3hARKrJ9cqBxx7D2Dv3OA7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TV6zm77BlZiCs5ag5XWpOgNhKzj5HaU3+gQILTphdooZkMJUxsx5fGuzun0sj2wMw
	 cD3klbkhBCi4KyDkNIM8dCqPueTaRFPbPiYDXIwJq2urLYaZEXaUH2WrrO5fhJ+h5w
	 Xy2uhD0Iz299UdxvTF9KCITq/D1hg80/XFcs1oLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0751/1674] wifi: iwlwifi: dont warn when if there is a FW error
Date: Sat, 17 Oct 2026 17:50:23 +0200
Message-ID: <20261017160450.380288579@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit c7f50d0433a016d43681592836a3d484817bfb34 ]

iwl_trans_reclaim is warning if it is called when the FW is not alive.
But if it is called when there is a pending restart, i.e. after a FW
error, there is no need to warn, instead - return silently.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308231427.ba3d90b22c25.I9332506af1997faefcf0bdb51d98d5e874051722@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index e8f48cb8d2da1..8c0762d2dc000 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -1276,6 +1276,9 @@ static inline void iwl_trans_reclaim(struct iwl_trans *trans, int queue,
 				     int ssn, struct sk_buff_head *skbs,
 				     bool is_flush)
 {
+	if (unlikely(test_bit(STATUS_FW_ERROR, &trans->status)))
+		return;
+
 	if (WARN_ON_ONCE(trans->state != IWL_TRANS_FW_ALIVE)) {
 		IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
 		return;
-- 
2.53.0



