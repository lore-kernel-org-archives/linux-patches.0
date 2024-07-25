Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01021DFF7;
	Thu, 25 Jul 2024 14:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919330; cv=none; b=PGqzQpGaMEn8MS5dVigmlzJF1oBq46Bpn1eK4xBO2I3WdpRtvMeuZju9D4ldTgQwUMIgJ8VQQ6pBXCUoCtZVfkILg9w/+hJrMubQ04YFqEurv8A6DWeQOFvgmLyfAh1Zvew7xlcTm0yoBSqQnxtOiddIV6JWyox0lwHaUov4Y8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919330; c=relaxed/simple;
	bh=zgU9N14XvQnfzHL5YCPMUWJHXpaH+MYPzzxLnDkVfxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4ozwPtNfMZdbrsmHnDiSwDO6tUtl4HwlCpGy/UCAJLzLRx8BMuiHIR0ulWgnbAPqxCxOqWOJ2gPcl+a2xuO02k4bqkfY1kZKdEORUaNgCrXd7DvJ5bpULza2eNTd4biyxT3lKzQsIFbRSNI5bpE8L469Y5hn93J2RdT7dzj1nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6/l/DtP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6/l/DtP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C99C116B1;
	Thu, 25 Jul 2024 14:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919329;
	bh=zgU9N14XvQnfzHL5YCPMUWJHXpaH+MYPzzxLnDkVfxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6/l/DtPaCxrP5rloiGpEFl8DHpCvm8DLVjkpmw3qWXnz2GohhM+dOk6fYlORGNE0
	 Wcj53++ucudEdSki5GRRGUhQrbABkk0WMbO3DIIGS1Wry5nqZLGMHHJGrPrEKrriEN
	 sW/apN40oCf/jQCp5lAVytn3dhYDk4ubpPjJ8UKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1d516edf1e74469ba5d3@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 72/87] wifi: mac80211: disable softirqs for queued frame handling
Date: Thu, 25 Jul 2024 16:37:45 +0200
Message-ID: <20240725142741.153382580@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

commit 321028bc45f01edb9e57b0ae5c11c5c3600d00ca upstream.

As noticed by syzbot, calling ieee80211_handle_queued_frames()
(and actually handling frames there) requires softirqs to be
disabled, since we call into the RX code. Fix that in the case
of cleaning up frames left over during shutdown.

Fixes: 177c6ae9725d ("wifi: mac80211: handle tasklet frames before stopping")
Reported-by: syzbot+1d516edf1e74469ba5d3@syzkaller.appspotmail.com
Link: https://patch.msgid.link/20240626091559.cd6f08105a6e.I74778610a5ff2cf8680964698131099d2960352a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/main.c |    1 +
 net/mac80211/util.c |    2 ++
 2 files changed, 3 insertions(+)

--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -220,6 +220,7 @@ u32 ieee80211_reset_erp_info(struct ieee
 	       BSS_CHANGED_ERP_SLOT;
 }
 
+/* context: requires softirqs disabled */
 void ieee80211_handle_queued_frames(struct ieee80211_local *local)
 {
 	struct sk_buff *skb;
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2146,7 +2146,9 @@ u32 ieee80211_sta_get_rates(struct ieee8
 
 void ieee80211_stop_device(struct ieee80211_local *local)
 {
+	local_bh_disable();
 	ieee80211_handle_queued_frames(local);
+	local_bh_enable();
 
 	ieee80211_led_radio(local, false);
 	ieee80211_mod_tpt_led_trig(local, 0, IEEE80211_TPT_LEDTRIG_FL_RADIO);


