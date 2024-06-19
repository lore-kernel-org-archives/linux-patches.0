Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8761A143C43;
	Wed, 19 Jun 2024 13:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802783; cv=none; b=M0Oe+EEIhRhGH/bpRngA+m0qRficNazZD3weRgWPGCY5iH0/1EZAI6Uc4XnVJNo1uyA8KW34kh2psLW2ykWGr0gpKxzhinl56ibViyVQrQFSSjz8UEiuE/0A9+fZ7t6H6LOnd/6hoFRFrWE4t4PYiYMEKBRD5IUTcxkEruoJoVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802783; c=relaxed/simple;
	bh=YJZsW+ybk08kQPtAGb/8Tpz58N7iz1eoWjg/vhHlZI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kPfW6P8eU4L1VllVw6tBIQsxpe+pOux+J3QMWwsLy7+JDlRuzMhrlDDyDWHeV3JqBbSMfrFb2uX6xyPnSttQ3jXS0hxEJmTXvAbFRBNCsx4i4L5b1ppLe0FEgG2hQ6elGqXkGv2bSsCi1F+BXTPX9SZIycc1J2MXkEUXl9V95iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pP5lYIDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pP5lYIDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4A0C2BBFC;
	Wed, 19 Jun 2024 13:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802783;
	bh=YJZsW+ybk08kQPtAGb/8Tpz58N7iz1eoWjg/vhHlZI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pP5lYIDajoJziyiypYexbb6F2MMFbxshwInJZCYNA4qX4G1BAyyHoYlZKY6XH9l9P
	 ce0iJj/lKCsbNYlK70ZkL+INgqhqz4R/aAjQ7dZ8pu5ihUzMZ6E3zHz1qcaHtfBznz
	 8NTaSkbkBUDBA9HV3y++TuO4Cc4MTdf4nDwG4wwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mordechay Goodstein <mordechay.goodstein@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 014/281] wifi: iwlwifi: mvm: set properly mac header
Date: Wed, 19 Jun 2024 14:52:53 +0200
Message-ID: <20240619125610.396174974@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit 0f2e9f6f21d1ff292363cdfb5bc4d492eeaff76e ]

In the driver we only use skb_put* for adding data to the skb, hence data
never moves and skb_reset_mac_haeder would set mac_header to the first
time data was added and not to mac80211 header, fix this my using the
actual len of bytes added for setting the mac header.

Fixes: 3f7a9d577d47 ("wifi: iwlwifi: mvm: simplify by using SKB MAC header pointer")
Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240510170500.12f2de2909c3.I72a819b96f2fe55bde192a8fd31a4b96c301aa73@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index ce8d83c771a70..8ac5c045fcfcb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -2456,8 +2456,11 @@ void iwl_mvm_rx_monitor_no_data(struct iwl_mvm *mvm, struct napi_struct *napi,
 	 *
 	 * We mark it as mac header, for upper layers to know where
 	 * all radio tap header ends.
+	 *
+	 * Since data doesn't move data while putting data on skb and that is
+	 * the only way we use, data + len is the next place that hdr would be put
 	 */
-	skb_reset_mac_header(skb);
+	skb_set_mac_header(skb, skb->len);
 
 	/*
 	 * Override the nss from the rx_vec since the rate_n_flags has
-- 
2.43.0



