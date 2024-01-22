Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769AD14A4CE;
	Tue, 23 Jan 2024 01:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972107; cv=none; b=iSLiq7A3XdvkLoJ4v287qWDaOUgYdAL/7jMMPmRiRzzhPsqeFqQFk/nL3EMZRUTmHMa1LnqoDDx8kAq+29gD0IGMtS+Ghox7wo0NhBNyAAjwpSgtHRCvy2rlsoid7fVP3dvjsGntw0g3EuE2fWbGYwq528ssGYdNPSOuWtMkoVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972107; c=relaxed/simple;
	bh=p4ZsLaD5TmqdnVMr1V2vNCwAcZHhJKJ8sD4vd+FclRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8wo35sSa60uA9vd4hDWpKBSC5FPnzW8xePz7VKC6s2w1yHnCuvPnztlycvQsSSyB2QvVtuHcCbmRpMwGNXYoN/SWL1hG4GtoJjiuLZnbqNvlK87gUxOLfF6cmcbMQfbezKkOGSisDDz7Yjk8Qq6xeYdohgiUawrzNdLgbdEaM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=te3hL8Wt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="te3hL8Wt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C244C433F1;
	Tue, 23 Jan 2024 01:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972106;
	bh=p4ZsLaD5TmqdnVMr1V2vNCwAcZHhJKJ8sD4vd+FclRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=te3hL8WtvmYH6Mkfx0lsBzXUtXYUDJ/2KByEkmGeJDEasdnAavO9RyZBG/Wf/7+V/
	 quOwgjAo5IHrhwhsxKtpaNV+CjXWajQ7rPPfBVRyitHAt7agLJcA9zxSeOhrs7y8nf
	 4L3W6hU1ZtrzfqcUxcl1LWLrlW2N6O7ft8gkiNaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/374] wifi: iwlwifi: pcie: avoid a NULL pointer dereference
Date: Mon, 22 Jan 2024 15:54:58 -0800
Message-ID: <20240122235746.084755054@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit ce038edfce43fb345f8dfdca0f7b17f535896701 ]

It possible that while the rx rb is being handled, the transport has
been stopped and re-started. In this case the tx queue pointer is not
yet initialized, which will lead to a NULL pointer dereference.
Fix it.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231207044813.cd0898cafd89.I0b84daae753ba9612092bf383f5c6f761446e964@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 29be7ed76894..17e53c7eb62d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1380,7 +1380,7 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		 * if it is true then one of the handlers took the page.
 		 */
 
-		if (reclaim) {
+		if (reclaim && txq) {
 			u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 			int index = SEQ_TO_INDEX(sequence);
 			int cmd_index = iwl_txq_get_cmd_index(txq, index);
-- 
2.43.0



