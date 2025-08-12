Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89662FF176;
	Tue, 12 Aug 2025 18:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024026; cv=none; b=SbTD/qGIgi8zP3mA7MrGXsG5KQV+TJSLsnbLJfuaK7p2YHGrXXyt+OaN8hkkt0zG7OTMBhFwjh+4vz+Nepr2eQwq8PzALZaFJ6xcT+bpLvaJMyuAxq+yEHPEHbMrPWTmMAsG5XuDepLtHnyszwuXVlN/ZkH7Ffx//wZZmJSqLEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024026; c=relaxed/simple;
	bh=FiMMplwRC0hv/SN1NZLscmS2+Tr0Hc96DvYLd/P+/kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kp1VautsC+KDneaLp5GG03Ca1WTk7jDcb72Hn8IAEg9/8g2TuwRFS8U/jHPtrUmCSxNnOAOQAjOlyWuyiN/7g/vdyGrn3gH6ZwLQWaFku5Y52OVxgrt17HgNAAyYMqHFd5efT+1d2VYSn7HUYTI2kz/UuXjPxaho5NkUWm3wcN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvUJ0l/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvUJ0l/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23727C4CEF6;
	Tue, 12 Aug 2025 18:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024026;
	bh=FiMMplwRC0hv/SN1NZLscmS2+Tr0Hc96DvYLd/P+/kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvUJ0l/LOQQSQsVDvKXEMNAOM1sgT92dS6lRPYbDMd8ukF4NNnqJ8FDqRYnGYt0ae
	 Zjzn/OhHF+OgDA+0e+WWUwX+ENwjbsuEltQmgSI8K0rbN6Jidy8HtfyEkJWFpaIc+m
	 rpGoTLoz5wzrMOrvkzXKIleieEjzd1yVFOAkc+1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	Daniel Gabay <daniel.gabay@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 252/627] wifi: iwlwifi: mld: decode EOF bit for AMPDUs
Date: Tue, 12 Aug 2025 19:29:07 +0200
Message-ID: <20250812173428.899750700@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit bc404dfddbf6817cae9b170c34556dc72ea975e5 ]

Only the EOF bit handling for single frames was ported to the MLD
driver. The code to handle AMPDUs correctly was forgotten. Add it back
so that the bit is reported in the radiotap headers again.

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Reviewed-by: Daniel Gabay <daniel.gabay@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250723094230.195be86372d5.I4db4abf348f7b6dfc75f869770dd77655a204bc7@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/rx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/rx.c b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
index ce0093d5c638..185c1a0cb47f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/rx.c
@@ -1039,6 +1039,15 @@ static void iwl_mld_rx_eht(struct iwl_mld *mld, struct sk_buff *skb,
 			rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT;
 	}
 
+	/* update aggregation data for monitor sake on default queue */
+	if (!queue && (phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD) &&
+	    (phy_info & IWL_RX_MPDU_PHY_AMPDU) && phy_data->first_subframe) {
+		rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT_KNOWN;
+		if (phy_data->data0 &
+		    cpu_to_le32(IWL_RX_PHY_DATA0_EHT_DELIM_EOF))
+			rx_status->flag |= RX_FLAG_AMPDU_EOF_BIT;
+	}
+
 	if (phy_info & IWL_RX_MPDU_PHY_TSF_OVERLOAD)
 		iwl_mld_decode_eht_phy_data(mld, phy_data, rx_status, eht, usig);
 
-- 
2.39.5



