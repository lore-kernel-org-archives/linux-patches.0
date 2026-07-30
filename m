Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40BB44162B;
	Thu, 30 Jul 2026 14:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423510; cv=none; b=jSMd/nuwja3iLmCUDyOLzQujMRzpcGt21vBuohCBA+AWfzJT8hzF3FGdiQpBqW+kOBazL7ArwX2SWrbTZ2DONaap82XU7DJ5Lt/SvjM3KRUKX5K2LdU7/UDb2VJLAkWjaUOS60idEFKScI8JuSDNwgd9iPYfPh4I8wI34Y1O+nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423510; c=relaxed/simple;
	bh=MgniQOL9DPQvO89ItYSQ4jteEikRg4XZmVPB9ThpunI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USu+WnCNfkmD3oJm8Y+U4kQaPrUsKv2ybNrd8+iAk0HX5/72+XOVy3KbUsgkGJwuikLKqk5BVJeulNh9AojKLu7CjK3Z5CIyCv6OF4abnlQs/1KZ5A/Bu3OR/7uyzy/9vWfOIdY1+jlycFKhoQyLLr8zdHKYlTtbWZnwWFxXJqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwzawN2G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwzawN2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8291F000E9;
	Thu, 30 Jul 2026 14:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423509;
	bh=VBJ9cH+EfkZYpgeWZD3T87eChQUJclXSBpfMsDzL5c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XwzawN2GcFkJ7N2ipvLnhYT2CQphT9T3OJszgQSb1qmCB9OTqNNIE1ExEMGJLPrPV
	 nSPbFirDsDWahXCK2fq8bjHZDgByYqqIVZGPChmvsAB2Wt18XewnxsBjmY0wZjfenp
	 k1Sh+5B48HWlpSWE71LeAw+ivmB16Yl5eXy8bAlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/675] wifi: cfg80211: Fix an error handling path in cfg80211_wext_siwscan()
Date: Thu, 30 Jul 2026 16:06:37 +0200
Message-ID: <20260730141446.550210096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c6659f66d4ee4841aafae5659d2ef5e4c5c63cb6 ]

If the test against IEEE80211_MAX_SSID_LEN fails, then 'creq' leaks.
Use the existing error handling path to fix it.

Fixes: 2a5193119269 ("cfg80211/nl80211: scanning (and mac80211 update to use it)")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/a1be7eea4da0da18f90589af252bb76a18a61978.1781984889.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 2f2104bb0d52ff..27d5f99dbb2289 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3627,8 +3627,10 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	/* translate "Scan for SSID" request */
 	if (wreq) {
 		if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
-			if (wreq->essid_len > IEEE80211_MAX_SSID_LEN)
-				return -EINVAL;
+			if (wreq->essid_len > IEEE80211_MAX_SSID_LEN) {
+				err = -EINVAL;
+				goto out;
+			}
 			memcpy(creq->req.ssids[0].ssid, wreq->essid,
 			       wreq->essid_len);
 			creq->req.ssids[0].ssid_len = wreq->essid_len;
-- 
2.53.0



