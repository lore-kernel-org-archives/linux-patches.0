Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5660515964;
	Thu, 17 Sep 2026 16:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664094; cv=none; b=MeDhEUcKuS+y5kGDZF9G+aB9rf6hnTaqDAvg0ScRIWhKHsLqTlpH33ILXTgOi4bXn7D2WK6qmLqmvXUoMMugRjgY45662Pv3erh5oEWv+K+UCsVEQxmJeH34vuF+YJC2M71bI+lpJ4KT1ajev2h/hH+9HyAM7kCy8GyErMnBTxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664094; c=relaxed/simple;
	bh=7r73sb0ozwCGBJiuOSkVNGpOOaKv1QHXnFTxLGIdBts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dYklD4ewLrgHLjRX0orVuA03p0RwQXtOIAVLtmwsAwoJfP3Ri5/3OKIVUjkCoomTIQHbiUM8+aD/9Sger0PA8fhyED1R8tZ2VIbzJgJ29HbEW8tRYcwsrhtj6Pij3NlkIFcoZ83pBgefqfpHLE6n1WtyB1YfOWjKt4wt1lSFV+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/IZ8Iuk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/IZ8Iuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096201F000FF;
	Thu, 17 Sep 2026 16:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664093;
	bh=IyYRu20TQA8/ujyS+z0rvuZ9O1QM1SRmzaw9ghhpM5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T/IZ8IukmlGx6ntJk/eRxQlbuGuppfQNs33+0h1Tm/jIS3qOy05yZD5NV3Om0SxKP
	 CgFsvb4PzHz3uI2PUEYKc2JPjF0vsGSPDcB2U0FAjDoYTb9+/EW+F1SNkcvysZUzfl
	 vA7fRFGFka2fTOCHfC+STvUHl0QVp4Co3nhGe1RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avinash Bhatt <avinash.bhatt@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0219/1250] wifi: iwlwifi: mld: keep healthy link on EMLSR missed beacon exit
Date: Thu, 17 Sep 2026 16:00:14 +0100
Message-ID: <20260917151558.073061738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avinash Bhatt <avinash.bhatt@intel.com>

[ Upstream commit 4b6d725ff01cb92becda6e805143e331fdf1d73e ]

When EMLSR exits due to beacon loss on the current link, the driver
should keep the link that is still receiving beacons. The previous
code always called get_primary_link(), keeping the primary link
regardless of which link is actually losing beacons. If the primary
link is the one losing beacons, the driver exits EMLSR onto the
degraded link and the connection is lost eventually.

When both links lose beacons, keep the primary link. When only the
current link loses beacons -- whether due to signal loss or a BSS
parameter change -- keep the other link.

Signed-off-by: Avinash Bhatt <avinash.bhatt@intel.com>
Link: https://patch.msgid.link/20260517100550.b2d700f7775e.I8e9189ce6cf4388878beab14e56341becd5f427c@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/link.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/link.c b/drivers/net/wireless/intel/iwlwifi/mld/link.c
index e67ba3a24d025..49e3d97f286f9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/link.c
@@ -600,15 +600,20 @@ void iwl_mld_handle_missed_beacon_notif(struct iwl_mld *mld,
 	 * OR more than IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_BSS_PARAM_CHANGED
 	 * on current link and the link's bss_param_ch_count has changed on
 	 * the other link's beacon.
+	 *
+	 * When both links lose beacons, keep the primary (symmetric failure).
+	 * When only the current link is sick, keep the other link.
 	 */
-	if ((missed_bcon >= IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_2_LINKS &&
-	     scnd_lnk_bcn_lost >= IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_2_LINKS) ||
-	    missed_bcon >= IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH ||
-	    (bss_param_ch_cnt_link_id != link_id &&
-	     missed_bcon >=
-	     IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_BSS_PARAM_CHANGED)) {
+	if (missed_bcon >= IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_2_LINKS &&
+	    scnd_lnk_bcn_lost >= IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_2_LINKS) {
 		iwl_mld_exit_emlsr(mld, vif, IWL_MLD_EMLSR_EXIT_MISSED_BEACON,
 				   iwl_mld_get_primary_link(vif));
+	} else if (missed_bcon >= IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH ||
+		   (bss_param_ch_cnt_link_id != link_id &&
+		    missed_bcon >=
+		    IWL_MLD_BCN_LOSS_EXIT_ESR_THRESH_BSS_PARAM_CHANGED)) {
+		iwl_mld_exit_emlsr(mld, vif, IWL_MLD_EMLSR_EXIT_MISSED_BEACON,
+				   iwl_mld_get_other_link(vif, link_id));
 	}
 }
 EXPORT_SYMBOL_IF_IWLWIFI_KUNIT(iwl_mld_handle_missed_beacon_notif);
-- 
2.53.0



