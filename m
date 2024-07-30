Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647191A6160;
	Tue, 30 Jul 2024 16:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356871; cv=none; b=Og0f2Y7S9TkbM6nP4n0pVWfa96UgrYZyaScyslczSn83odSuIQGfki+o1L8bbe3MLrNuCfAiJ9vEKthCVq6Z/epCDiefTtmA1KHzGu39qSvnCb7PxWoUV6WsuxITpzP9C2Vaq4bKZy+TaFgfo5YLY4HP+6KUjtRj+A/ZRqsriGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356871; c=relaxed/simple;
	bh=vdPXYl0FIZEFtijsPQzHT4W6f8JqHpv56PGFL9Er3nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGudK+Rc0zuGO+kFZyCRKC60jIAXllhCOcqw5fa8SCOn1T60WXcg8c2VQL9fdvRr+djrmlneMlzdzxrwheOrEnvG+qgjPv5wJB1TrI5/XV58bdraCRaa30scYZvTUnSWMamZCFJbxyPFZre9ydMphZFoqcUo55cXH+V3yEDbUGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbLBlURD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbLBlURD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB76FC32782;
	Tue, 30 Jul 2024 16:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356871;
	bh=vdPXYl0FIZEFtijsPQzHT4W6f8JqHpv56PGFL9Er3nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RbLBlURD20WUdopWPXnbhc4JhFvuHHCGupCl148Z+eLAXFhAn43w1PJPKYXRkk8Ih
	 6999WvEwzmNB6S/izlL8rEqR1ss668Mc8/W8WNu4Py1Q3eGgFc4GspGdRUitUlGmFa
	 hPR1j+9XvKiDmMaigdg9MR/nMLaut19oGFGPtwbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 195/809] wifi: iwlwifi: mvm: fix re-enabling EMLSR
Date: Tue, 30 Jul 2024 17:41:11 +0200
Message-ID: <20240730151732.309928579@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit bd40215b19d255b433a91a8bb8088937e5db4284 ]

When EMLSR gets unblocked, the current code checks if the last exit was
due to an EXIT reason (as opposed to a BLOCKING one), and if so, it
does nothing, as in this case a MLO scan was scheduled to run in 30
seconds.

But the code doesn't consider the time that passed from the last exit,
so if immediately after the exit a blocker occurred (e.g. non-BSS
interface), and lasts for more than 30 seconds, then the MLO scan and the
following link selection will decide not to enter EMLSR, and when the
unblocking event finally happens, the reason is still set to the EXIT one,
so it will do nothing, and we will not have the chance to re-enable EMLSR.

Fix this by checking also the time that has passed since the last exit,
only if it is less than 30 seconds, we can count on the scheduled MLO
scan.

Note that clearing the reason itself can't be done since it is needed
for the EMLSR prevention mechanism.

Fixes: 2f33561ea8f9 ("wifi: iwlwifi: mvm: trigger link selection after exiting EMLSR")
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://msgid.link/20240605140327.58556fc4cfa9.I4c55b3cd9f20b21b37f28258d0fb6842ba413966@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/link.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/link.c b/drivers/net/wireless/intel/iwlwifi/mvm/link.c
index b4a4d25b31cd2..92ac6cc40faa7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/link.c
@@ -1082,8 +1082,10 @@ static void iwl_mvm_esr_unblocked(struct iwl_mvm *mvm,
 
 	IWL_DEBUG_INFO(mvm, "EMLSR is unblocked\n");
 
-	/* We exited due to an EXIT reason, so MLO scan was scheduled already */
-	if (mvmvif->last_esr_exit.reason &&
+	/* If we exited due to an EXIT reason, and the exit was in less than
+	 * 30 seconds, then a MLO scan was scheduled already.
+	 */
+	if (!need_new_sel &&
 	    !(mvmvif->last_esr_exit.reason & IWL_MVM_BLOCK_ESR_REASONS)) {
 		IWL_DEBUG_INFO(mvm, "Wait for MLO scan\n");
 		return;
-- 
2.43.0



