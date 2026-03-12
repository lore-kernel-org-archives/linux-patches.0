Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80D1344DB5;
	Thu, 12 Mar 2026 20:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346865; cv=none; b=BMoL+x9vBm5HBA+m2rLiRsJA4wWgoxUEIEnG1v3qnKX5UehLjHuB2XYWQ/q1Rd/XT4n2pw08lBHF0azhD0PkcOuwOMr6NhIAZbdc82G+5bwkuuMi+l+xkrVo1XRCZ4ggf3Bsswry4Cbo78hpusu3iY+hGEFxZfiMWE2T37bNdWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346865; c=relaxed/simple;
	bh=6UDmoesoA+SqxQr3ccP/+3eUoEh0P/E7kvJZgaHVv68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNPOTwtg8JKwMGEBHQTabAWduU6ngO8L184oXoxORXoKCs6uTCh0nBHPI1uo/hVn3mjSpbo12TwzsDEbGZX6Rdm2KF30GCdhZttUenTpchsTdvtzSLbl/jqsm6Wj/zpDtsG3euXhopx+nQabssOycgLr50VKyqY9LFeYVCjBWBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HgWp2gQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgWp2gQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DABC4CEF7;
	Thu, 12 Mar 2026 20:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346865;
	bh=6UDmoesoA+SqxQr3ccP/+3eUoEh0P/E7kvJZgaHVv68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HgWp2gQQz9o+uarOW4o9TNHuaHJ0zwr7HSXOCWhRPLTge77qw7cusYgkbA08gUF17
	 6CQCO6U+Qa+2UWLMbVl9zGo+hluV/fMb1c5onOAu9aLDqYKAkh19/bFgCbIOYbDa3d
	 uGwmE4uGOEOzXKeCrihXeAEItO5h438EhI2TwqGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ariel Silver <arielsilver77@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 146/265] wifi: mac80211: bounds-check link_id in ieee80211_ml_reconfiguration
Date: Thu, 12 Mar 2026 21:08:53 +0100
Message-ID: <20260312201023.533178103@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ariel Silver <arielsilver77@gmail.com>

commit 162d331d833dc73a3e905a24c44dd33732af1fc5 upstream.

link_id is taken from the ML Reconfiguration element (control & 0x000f),
so it can be 0..15. link_removal_timeout[] has IEEE80211_MLD_MAX_NUM_LINKS
(15) elements, so index 15 is out-of-bounds. Skip subelements with
link_id >= IEEE80211_MLD_MAX_NUM_LINKS to avoid a stack out-of-bounds
write.

Fixes: 8eb8dd2ffbbb ("wifi: mac80211: Support link removal using Reconfiguration ML element")
Reported-by: Ariel Silver <arielsilver77@gmail.com>
Signed-off-by: Ariel Silver <arielsilver77@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260220101129.1202657-1-Ariel.Silver@cybereason.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mlme.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6256,6 +6256,9 @@ static void ieee80211_ml_reconfiguration
 		control = le16_to_cpu(prof->control);
 		link_id = control & IEEE80211_MLE_STA_RECONF_CONTROL_LINK_ID;
 
+		if (link_id >= IEEE80211_MLD_MAX_NUM_LINKS)
+			continue;
+
 		removed_links |= BIT(link_id);
 
 		/* the MAC address should not be included, but handle it */


