Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D0979DD;
	Sat, 30 Dec 2023 12:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFAGiOx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B96DC433C8;
	Sat, 30 Dec 2023 12:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937684;
	bh=w2XkgjI2UCWTEkZpIiOv8ImcVprJMXP1R4lSrBso2dE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFAGiOx321gl5Entxuz8sLO+HhhjoCHVTZJFb8Wch0r4utGp/dfIsDU99CK2rprCm
	 RSlcvknbGiBD6WDR3f4VxxqOO/d3G+K9WjCnwzodBAvuq+nLBJx/+S7+gqtXlsACjI
	 3Hr+GMiXUMvG+Ym/yBRqrD5+sbgObV4eCiF3Mhek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Norris <briannorris@chromium.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/156] wifi: iwlwifi: pcie: add another missing bh-disable for rxq->lock
Date: Sat, 30 Dec 2023 11:57:56 +0000
Message-ID: <20231230115813.095597190@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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
index 583d1011963ec..2e23ccd7d7938 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3088,7 +3088,7 @@ static u32 iwl_trans_pcie_dump_rbs(struct iwl_trans *trans,
 	struct iwl_rxq *rxq = &trans_pcie->rxq[0];
 	u32 i, r, j, rb_len = 0;
 
-	spin_lock(&rxq->lock);
+	spin_lock_bh(&rxq->lock);
 
 	r = le16_to_cpu(iwl_get_closed_rb_stts(trans, rxq)) & 0x0FFF;
 
@@ -3112,7 +3112,7 @@ static u32 iwl_trans_pcie_dump_rbs(struct iwl_trans *trans,
 		*data = iwl_fw_error_next_data(*data);
 	}
 
-	spin_unlock(&rxq->lock);
+	spin_unlock_bh(&rxq->lock);
 
 	return rb_len;
 }
-- 
2.43.0



