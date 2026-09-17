Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9909C4FDA67;
	Thu, 17 Sep 2026 17:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664904; cv=none; b=qpwd6PnwbCl2pvStl/OHvmLoA0RtJAwlpeigOEzImRlzzsa8JrE1Q8OHNGXXYmcveAr6W/kdL9hrf7MzcRoyv/H6j2AFz2dp4Nvg7PE1Hrh5DB8Bpimamcb43RpyyCEToLC23D66n3Rp3i0jWxc1gv2wwNKrYmmN8WnyPHfT/a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664904; c=relaxed/simple;
	bh=zvRuMjH2v/lxYsjGIfbf3tnAO2XQofSNUgcCBMk02s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUfD2jkn1x2Plqb8FPBaeghTFexHi8SpXkTsPQIcelKsYcvs6p0cruAcUXKW7MGneJocdjNt5rVI2JLwg2cmE0XYABVHb0ycA8WTdcNmUqYp1RsRM9U5Hy/mYHmRSi0NDatZ1R0wcED7INqij3BkIumxDHoejbyWhxFmT+/T2go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WcGaAoSO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WcGaAoSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF881F000FF;
	Thu, 17 Sep 2026 17:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664903;
	bh=SOqBgR0nd/lqloM09dRVWg+gf7ztTnuUh1ZqeOsBMwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WcGaAoSOKzRG9EcsJmNHFvaE6PFdIKqgm4LZm1XSc1cm9X4N1oje2sUEdr7AjcEyv
	 X0c2zdQz/VMUrNoVzsOHvt6GWAQhhu3toL9V0VMdqkmotP3AZ6UPFG6O/VhrvpRQxS
	 gA0/UOmivLn2RYiyU9Sp5OTjhkYVZYMgHPREiIV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0528/1250] wifi: iwlwifi: mvm: fix a possible underflow
Date: Thu, 17 Sep 2026 16:05:23 +0100
Message-ID: <20260917151606.254228108@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 0cb5260a1027a43f8cdb961e128f2ddd42e46832 ]

We shouldn't trust the firmware about the length of the wowlan packet.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.fbd989cc85e2.If68de403bfa4943732c025961154c20b01b09e83@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 46e95e25dcd44..163f124149aa5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1516,6 +1516,10 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 		if (WARN_ON_ONCE(truncated < 0))
 			truncated = 0;
 
+		/* this would be a firmware bug */
+		if (WARN_ON_ONCE(pktsize < sizeof(*hdr)))
+			return;
+
 		if (ieee80211_is_data(hdr->frame_control)) {
 			int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 			int ivlen = 0, icvlen = 4; /* also FCS */
@@ -1524,10 +1528,6 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 			if (!pkt)
 				goto report;
 
-			skb_put_data(pkt, pktdata, hdrlen);
-			pktdata += hdrlen;
-			pktsize -= hdrlen;
-
 			if (ieee80211_has_protected(hdr->frame_control)) {
 				/*
 				 * This is unlocked and using gtk_i(c)vlen,
@@ -1553,6 +1553,17 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 				truncated = 0;
 			}
 
+			if (IWL_FW_CHECK(mvm,
+					 pktsize <= hdrlen + ivlen + icvlen,
+					 "pktsize is too small %d\n",
+					 pktsize)) {
+				kfree_skb(pkt);
+				return;
+			}
+
+			skb_put_data(pkt, pktdata, hdrlen);
+			pktdata += hdrlen;
+			pktsize -= hdrlen;
 			pktsize -= ivlen + icvlen;
 			pktdata += ivlen;
 
-- 
2.53.0



