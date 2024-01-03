Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914301BDEC;
	Wed,  3 Jan 2024 17:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1qGIjRcu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F135C433C8;
	Wed,  3 Jan 2024 17:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301420;
	bh=bP0H18zVQ9hZ4k+ggaB9p4krsajKTsWtVoKjEC+Og5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1qGIjRcuZ0okFde3J4UNU6abTsCruxq16h1o6sSuh5q9kZ2dl/9RhRR15msHNTR80
	 2ax5i3/FGwTgCc2KMWVyVeGkIxGciP8KGeUb6Zc9yhGoAEgNpPnYXOPP7MfrG7oVTC
	 hwML1sW3PUXhlsHbufFe4fWI42pUhGn11LGviMRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 05/95] wifi: iwlwifi: pcie: add another missing bh-disable for rxq->lock
Date: Wed,  3 Jan 2024 17:54:13 +0100
Message-ID: <20240103164854.686787751@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit a4754182dc936b97ec7e9f6b08cdf7ed97ef9069 ]

Evidently I had only looked at all the ones in rx.c, and missed this.
Add bh-disable to this use of the rxq->lock as well.

Fixes: 25edc8f259c7 ("iwlwifi: pcie: properly implement NAPI")
Reported-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20231208183100.e79ad3dae649.I8f19713c4383707f8be7fc20ff5cc1ecf12429bb@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index b7b2d28b3e436..8a19463bc81c1 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2960,7 +2960,7 @@ static u32 iwl_trans_pcie_dump_rbs(struct iwl_trans *trans,
 	struct iwl_rxq *rxq = &trans_pcie->rxq[0];
 	u32 i, r, j, rb_len = 0;
 
-	spin_lock(&rxq->lock);
+	spin_lock_bh(&rxq->lock);
 
 	r = le16_to_cpu(iwl_get_closed_rb_stts(trans, rxq)) & 0x0FFF;
 
@@ -2984,7 +2984,7 @@ static u32 iwl_trans_pcie_dump_rbs(struct iwl_trans *trans,
 		*data = iwl_fw_error_next_data(*data);
 	}
 
-	spin_unlock(&rxq->lock);
+	spin_unlock_bh(&rxq->lock);
 
 	return rb_len;
 }
-- 
2.43.0



