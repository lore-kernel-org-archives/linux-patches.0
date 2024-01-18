Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D713C22323;
	Thu, 18 Jan 2024 10:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575418; cv=none; b=pG/kDwfLqilmVuqvQn+13m5iWl7bBVrae174Babx4sNmNySs2pAGMfpXEqHwY8Gf80CXypkHAKG1fl2zig/eksJOenJQYa50DjJ+Nv8oWWKGEpiHXFrUS+5/Bb21wM7jdd9YBMlW4VymHn7LQRw9OCZXO0ybZErJSBzqFKFxhIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575418; c=relaxed/simple;
	bh=ygnpirTk+AdLC0aPZaTD/TeIUVbGAfgwDlZeRfRky1M=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=dOGCePN4j2xfGS0OoKlA2BEDiOcU8SRRrwaMacLGPfjwd69D29Frvjuhzv3g1VWyVTqX5viWhRF+fe2NvKgyYsAsoiwlGeVlSl5Zh8Ldt86L4/B335kyMTYZoP3DO5b101zK1vj5MaavJ5BnHsojVNDJXbcrYsHczlGRlB6Z9lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTNtEOk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTNtEOk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A90DC433F1;
	Thu, 18 Jan 2024 10:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575418;
	bh=ygnpirTk+AdLC0aPZaTD/TeIUVbGAfgwDlZeRfRky1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTNtEOk6oNMbQJ7SYmBcWW2t5otZlxYrTCWJTpU26YYlHWAmsojD883oXRE6ibvkw
	 8tzPTFk+CM361gCBaOQA2YrnNbn+2TdH7AJ//Q4uAnN+xi/CMjGm/qnaWXXfvjBDep
	 BGFY9adufGyG2URfekyalIzEaCmpmL15W3olrK8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/150] wifi: iwlwifi: pcie: avoid a NULL pointer dereference
Date: Thu, 18 Jan 2024 11:48:38 +0100
Message-ID: <20240118104324.393185827@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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
index a9415d333490..63091c45a576 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1385,7 +1385,7 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		 * if it is true then one of the handlers took the page.
 		 */
 
-		if (reclaim) {
+		if (reclaim && txq) {
 			u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 			int index = SEQ_TO_INDEX(sequence);
 			int cmd_index = iwl_txq_get_cmd_index(txq, index);
-- 
2.43.0



