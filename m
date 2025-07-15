Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81612DEA72;
	Tue, 15 Jul 2025 13:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587015; cv=none; b=hAir7rZA5Wa/C3cwyykxaN0U82zuvLLu6ad98xzO0J8slBMBR2V1dW42dQX9jQfByBXg7zPAnNcHoiwl7mC9pl95CzActJkG8JpAs2T06IKqM+AiGi+0gRAVKpEs/nQ2uWy0ZN72NcPD6iGZF9rb1eOEEW6ZxnMFkx1PTOr/5cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587015; c=relaxed/simple;
	bh=j/r4JdAr0wOqxqZWrBIA2yN/iGXFKL1YQr35TxPNbDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrmYVYGSuti9ZXWTgeeH2opBjSmu+LSL1Fc9Sd2sanPVa5VZW67UU3/NsFclvxNpw7P1mk2zxSE68hPjrrPLdIdPZQu9dLM1Q33om3NVaUlvkU8vl3PMLgNcsSzvONEmtWOuK/9a6eadJCYEhV7iK/wEoFW2hPUiiI2pUHn3cPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PsQRBUl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PsQRBUl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5E5C4CEE3;
	Tue, 15 Jul 2025 13:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587015;
	bh=j/r4JdAr0wOqxqZWrBIA2yN/iGXFKL1YQr35TxPNbDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PsQRBUl4ZsFLtVCKCpq2ZRRseG7Du2VfkHVGVoVE6z0NLQREozLI5a3Gqdedf3EEZ
	 /8Dm5fsSK8dnSanIqIKT4TiSe/q+o5c91GTi3vok0E6ALzP7SDPRqsZXuhgjM0mjTh
	 +LRDD2GpOTHtYc3EK352Sr/VAjz0xqNKth8m/eaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ededba317ddeca8b3f08@syzkaller.appspotmail.com,
	Moon Hee Lee <moonhee.lee.ca@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 135/192] wifi: mac80211: reject VHT opmode for unsupported channel widths
Date: Tue, 15 Jul 2025 15:13:50 +0200
Message-ID: <20250715130820.321473588@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moon Hee Lee <moonhee.lee.ca@gmail.com>

[ Upstream commit 58fcb1b4287ce38850402bb2bb16d09bf77b91d9 ]

VHT operating mode notifications are not defined for channel widths
below 20 MHz. In particular, 5 MHz and 10 MHz are not valid under the
VHT specification and must be rejected.

Without this check, malformed notifications using these widths may
reach ieee80211_chan_width_to_rx_bw(), leading to a WARN_ON due to
invalid input. This issue was reported by syzbot.

Reject these unsupported widths early in sta_link_apply_parameters()
when opmode_notif is used. The accepted set includes 20, 40, 80, 160,
and 80+80 MHz, which are valid for VHT. While 320 MHz is not defined
for VHT, it is allowed to avoid rejecting HE or EHT clients that may
still send a VHT opmode notification.

Reported-by: syzbot+ededba317ddeca8b3f08@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ededba317ddeca8b3f08
Fixes: 751e7489c1d7 ("wifi: mac80211: expose ieee80211_chan_width_to_rx_bw() to drivers")
Tested-by: syzbot+ededba317ddeca8b3f08@syzkaller.appspotmail.com
Signed-off-by: Moon Hee Lee <moonhee.lee.ca@gmail.com>
Link: https://patch.msgid.link/20250703193756.46622-2-moonhee.lee.ca@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index acfde525fad2f..4a8d9c3ea480f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1942,6 +1942,20 @@ static int sta_link_apply_parameters(struct ieee80211_local *local,
 	ieee80211_sta_init_nss(link_sta);
 
 	if (params->opmode_notif_used) {
+		enum nl80211_chan_width width = link->conf->chanreq.oper.width;
+
+		switch (width) {
+		case NL80211_CHAN_WIDTH_20:
+		case NL80211_CHAN_WIDTH_40:
+		case NL80211_CHAN_WIDTH_80:
+		case NL80211_CHAN_WIDTH_160:
+		case NL80211_CHAN_WIDTH_80P80:
+		case NL80211_CHAN_WIDTH_320: /* not VHT, allowed for HE/EHT */
+			break;
+		default:
+			return -EINVAL;
+		}
+
 		/* returned value is only needed for rc update, but the
 		 * rc isn't initialized here yet, so ignore it
 		 */
-- 
2.39.5



