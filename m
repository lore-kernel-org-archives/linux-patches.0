Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012CF1A6195;
	Tue, 30 Jul 2024 16:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358458; cv=none; b=cNvFzCUXzHH7s4B0/3/lvxSuN6nqs+gHF0++rmuXjYfnJ7gEeMRnqEiMo8rCUMG1NCZkkrgBC00MJ4dQQFjirF+Q1ag4oSiIXY4CQvhG552OgDzU4GihZLr58pJ5C+qbnrLDHG9+gPyLEi8R8tTm3i4RcQo8V5RwiQA/QkYQk6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358458; c=relaxed/simple;
	bh=X/Jlp0LBfmcc3CG+NlO5lXUXid4hIB7qHw9D6jDC3t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuJG9KUbuJ8d9P6RQLwmK8Oy/Cc+tyz0p8cj2PRHSVkxDwpsN2zgmFWnuRttUGaBc481nNPgvPGOb76du7HDEH7BXNbCUe/+PSjyK78/SyYOTEs6Zto1+hO6WcKRcJa0thF/wG3x5X/YpzukwIygD/H3QoJrbrHwkZPjl0wyTu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxi8a0Sb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxi8a0Sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75653C32782;
	Tue, 30 Jul 2024 16:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358457;
	bh=X/Jlp0LBfmcc3CG+NlO5lXUXid4hIB7qHw9D6jDC3t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxi8a0SbYQtQMuFCZ8P5uGS2sWH8hdjjFLP09hW8SKoPo6ah2zqD976mux6THHONk
	 dXoekg1iQKqtcyQK/p5wYZPNIAhrP2ZAwC4sAPE66UkjXa26WsLm0xbowJfLAnke9N
	 LAv978A+eIzxYpbV2ozNsUVmvne4t0k7wuiyRYOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	syzbot+07bee335584b04e7c2f8@syzkaller.appspotmail.com,
	Vincenzo Mezzela <vincenzo.mezzela@gmail.com>
Subject: [PATCH 6.1 392/440] wifi: mac80211: check basic rates validity
Date: Tue, 30 Jul 2024 17:50:25 +0200
Message-ID: <20240730151631.116892046@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit ce04abc3fcc62cd5640af981ebfd7c4dc3bded28 upstream.

When userspace sets basic rates, it might send us some rates
list that's empty or consists of invalid values only. We're
currently ignoring invalid values and then may end up with a
rates bitmap that's empty, which later results in a warning.

Reject the call if there were no valid rates.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reported-by: syzbot+07bee335584b04e7c2f8@syzkaller.appspotmail.com
Tested-by: syzbot+07bee335584b04e7c2f8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=07bee335584b04e7c2f8
Signed-off-by: Vincenzo Mezzela <vincenzo.mezzela@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2577,6 +2577,17 @@ static int ieee80211_change_bss(struct w
 	if (!sband)
 		return -EINVAL;
 
+	if (params->basic_rates) {
+		if (!ieee80211_parse_bitrates(sdata->vif.bss_conf.chandef.width,
+					      wiphy->bands[sband->band],
+					      params->basic_rates,
+					      params->basic_rates_len,
+					      &sdata->vif.bss_conf.basic_rates))
+			return -EINVAL;
+		changed |= BSS_CHANGED_BASIC_RATES;
+		ieee80211_check_rate_mask(&sdata->deflink);
+	}
+
 	if (params->use_cts_prot >= 0) {
 		sdata->vif.bss_conf.use_cts_prot = params->use_cts_prot;
 		changed |= BSS_CHANGED_ERP_CTS_PROT;
@@ -2600,16 +2611,6 @@ static int ieee80211_change_bss(struct w
 		changed |= BSS_CHANGED_ERP_SLOT;
 	}
 
-	if (params->basic_rates) {
-		ieee80211_parse_bitrates(sdata->vif.bss_conf.chandef.width,
-					 wiphy->bands[sband->band],
-					 params->basic_rates,
-					 params->basic_rates_len,
-					 &sdata->vif.bss_conf.basic_rates);
-		changed |= BSS_CHANGED_BASIC_RATES;
-		ieee80211_check_rate_mask(&sdata->deflink);
-	}
-
 	if (params->ap_isolate >= 0) {
 		if (params->ap_isolate)
 			sdata->flags |= IEEE80211_SDATA_DONT_BRIDGE_PACKETS;


