Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB1632ABC0;
	Thu, 28 May 2026 20:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999052; cv=none; b=WzKP+d9/EarP+eCEuoaNH/HCFInGN5xDDgjfgsHfYQAQ2T0m0eLZNGSxjb0S8IgG2ANijmamZpWR+Vk+jclJwXBD1moX4iJ85Prvuw3ZRQzbhUfUptwk8WtrG+aRmeIW0ONsdKkGUzDpRwOMYFTu7GmzSApWFn7mY2XyfVObr/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999052; c=relaxed/simple;
	bh=seAMQmWOVVDiN70W4Ok060ruD6Tv1F3Sqy8z+xCkHQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUL31Uq4pYlSMtoEr1In+M97i47qrHMGPLQnJ7ZjfwsteQRnXTQTLfleoU5kqIAQheQG4OxKeHAoAQTdnm9tVA80es4AaIfg6grzx4LM6/Yo3Hd7QVAJBSMQiUWorawnQOrxvVmZB+qc1F41c6blwtRRX86XJbdD/foz7cWYwCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTxpgGxQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTxpgGxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E971F1F000E9;
	Thu, 28 May 2026 20:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999051;
	bh=78xSl7Y4rggPM9z3Ah9eEw1bis2YfjFpPsBtt9lstuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LTxpgGxQ9Ybl2jWblHdqPzGQcRIM2WCbqbuYlkV61SwOvMUpjvh40oD7WStzQokTL
	 2wNHA1AM9sl/oDNoqfnmYAFGSeSCfrj5kbR9UnNDA5Ond+IApgp6Pmy8YF9Iw5iLEs
	 2rWpicYWnmGo9XPwainXo8+gMroyjYYDqquFcKo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Cole Leavitt <cole@unwrap.rs>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 355/461] wifi: iwlwifi: mld: fix TSO segmentation explosion when AMSDU is disabled
Date: Thu, 28 May 2026 21:48:04 +0200
Message-ID: <20260528194657.696138343@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cole Leavitt <cole@unwrap.rs>

[ Upstream commit 92cee08dc4f00e77fd1317e4343c5d458b0abab7 ]

When the TLC notification disables AMSDU for a TID, the MLD driver sets
max_tid_amsdu_len to the sentinel value 1. The TSO segmentation path in
iwl_mld_tx_tso_segment() checks for zero but not for this sentinel,
allowing it to reach the num_subframes calculation:

  num_subframes = (max_tid_amsdu_len + pad) / (subf_len + pad)
                = (1 + 2) / (1534 + 2) = 0

This zero propagates to iwl_tx_tso_segment() which sets:

  gso_size = num_subframes * mss = 0

Calling skb_gso_segment() with gso_size=0 creates over 32000 tiny
segments from a single GSO skb. This floods the TX ring with ~1024
micro-frames (the rest are purged), creating a massive burst of TX
completion events that can lead to memory corruption and a subsequent
use-after-free in TCP's retransmit queue (refcount underflow in
tcp_shifted_skb, NULL deref in tcp_rack_detect_loss).

The MVM driver is immune because it checks mvmsta->amsdu_enabled before
reaching the num_subframes calculation. The MLD driver has no equivalent
bitmap check and relies solely on max_tid_amsdu_len, which does not
catch the sentinel value.

Fix this by detecting the sentinel value (max_tid_amsdu_len == 1) at the
existing check and falling back to non-AMSDU TSO segmentation. Also add
a WARN_ON_ONCE guard after the num_subframes division as defense-in-depth
to catch any future code paths that produce zero through a different
mechanism.

Suggested-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Signed-off-by: Cole Leavitt <cole@unwrap.rs>
Link: https://patch.msgid.link/20260405054145.1064152-3-cole@unwrap.rs
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/tx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.c b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
index 0d2d059ac4e3e..0bcb1ae694687 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
@@ -834,7 +834,7 @@ static int iwl_mld_tx_tso_segment(struct iwl_mld *mld, struct sk_buff *skb,
 		return -EINVAL;
 
 	max_tid_amsdu_len = sta->cur->max_tid_amsdu_len[tid];
-	if (!max_tid_amsdu_len)
+	if (!max_tid_amsdu_len || max_tid_amsdu_len == 1)
 		return iwl_tx_tso_segment(skb, 1, netdev_flags, mpdus_skbs);
 
 	/* Sub frame header + SNAP + IP header + TCP header + MSS */
@@ -846,6 +846,9 @@ static int iwl_mld_tx_tso_segment(struct iwl_mld *mld, struct sk_buff *skb,
 	 */
 	num_subframes = (max_tid_amsdu_len + pad) / (subf_len + pad);
 
+	if (WARN_ON_ONCE(!num_subframes))
+		return iwl_tx_tso_segment(skb, 1, netdev_flags, mpdus_skbs);
+
 	if (sta->max_amsdu_subframes &&
 	    num_subframes > sta->max_amsdu_subframes)
 		num_subframes = sta->max_amsdu_subframes;
-- 
2.53.0



