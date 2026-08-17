Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD05444161B;
	Mon, 17 Aug 2026 14:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977022; cv=none; b=l1ejPjHXzq5aNEotlvi5vxvdQqmX7HZM1V3mSIjkHXIAmt97YoMyyxbhlLZxWfeBWxoMO2qNy5jcQAzr4Hun4612VvJDZG0P3TXT/96x4gJSdBoMAbq+x8hm2VMxEL5X5irXZik85ilA5yKFf3WDPzOV/JyVpwtbRd33sW4iTNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977022; c=relaxed/simple;
	bh=cKAkZLbHZZhRHNF6B3/ROuWvHeeN74oqcU+dFFcjPY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmIpNymOWpBjgeTJyvoxhJLfw9Is6gipu1g8OtKB0e5KcCNbRf4B9odMLuvq5r2YkRso7HAnY/AX9NF6tdq0VUlsDuiVauzgyGtNItT/NRdtNWJq9rjYrG5XDpuWQPCnqO/1yfj2rr4OhoTDcth+354a1Es2NkGtOKaVb5qBMTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qY4NlxgY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qY4NlxgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425361F000E9;
	Mon, 17 Aug 2026 14:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977020;
	bh=ekcMdLfGnp+r6Aby/TqqgIvjKsXga9Hd9/3uHR/YgmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qY4NlxgY4TodaC5PsyB9IvyxbgikMVeH5ItHAFV98zf2O7bDQnSVlmZgf+97lFsbK
	 1SO/b8ligdpgi5xbsc+zxplUkATSUFvakw3xh5WYP7RkMmD3RGx50eIOJ8jw3P0skz
	 YJnf/X6t6hfsyKw6Kvr71BeSD4XyW6+4jPh0FqN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MinJea Kim <qndkdrnl@gmail.com>
Subject: [PATCH 5.15 183/456] staging: rtl8723bs: fix inverted HT40 secondary channel offset
Date: Mon, 17 Aug 2026 15:29:33 +0200
Message-ID: <20260817132547.285441155@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: MinJea Kim <qndkdrnl@gmail.com>

commit 30d49cba27f8905bc288cef5846963f0004f644c upstream.

rtw_get_chan_type() maps the driver's channel offset to nl80211 channel
types the wrong way around.

In this driver HAL_PRIME_CHNL_OFFSET_LOWER means the primary channel is
the lower 20 MHz half of the 40 MHz pair, i.e. the secondary channel is
above the primary one: rtw_get_center_ch() computes the center channel
as "channel + 2" for OFFSET_LOWER, and bwmode_update_check() sets
OFFSET_LOWER when the AP's HT operation IE announces SCA (secondary
channel above). In nl80211 terms that is NL80211_CHAN_HT40PLUS, not
HT40MINUS.

Because of the inversion, cfg80211_rtw_get_channel() reports an HT40+
association as HT40-. For an HT40+ AP on a low channel (e.g. channel 3)
the resulting chandef spans below the 2.4 GHz band edge and is invalid,
so the regulatory core tears the connection down 60 seconds
(REG_ENFORCE_GRACE_MS) after the AP's country IE triggers a regdomain
change: reg_check_chans_work() considers the reported chandef unusable
and calls cfg80211_leave(). The supplicant then reconnects, the country
IE changes the regdomain again, and the cycle repeats, causing a
disconnect/reconnect loop every ~65 seconds for as long as the link is
up.

Observed on a TECLAST X80 Power tablet (RTL8723BS) associated to an
HT40+ AP on channel 3 with a KR country IE; a kprobe trace showed
cfg80211_disconnect() being invoked from reg_check_chans_work(). With
the mapping fixed, "iw dev wlan0 info" reports the correct
"width: 40 MHz, center1: 2432 MHz" and the periodic disconnects stop.

Fixes: 5402cc178c5d ("staging: rtl8723bs: add get_channel cfg80211 implementation")
Cc: stable@vger.kernel.org
Assisted-by: Claude-Code:claude-fable-5 bpftrace
Signed-off-by: MinJea Kim <qndkdrnl@gmail.com>
Link: https://patch.msgid.link/20260714131421.3980-1-qndkdrnl@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -1996,7 +1996,7 @@ static u8 rtw_get_chan_type(struct adapt
 		else
 			return NL80211_CHAN_NO_HT;
 	case CHANNEL_WIDTH_40:
-		if (mlme_ext->cur_ch_offset == HAL_PRIME_CHNL_OFFSET_UPPER)
+		if (mlme_ext->cur_ch_offset == HAL_PRIME_CHNL_OFFSET_LOWER)
 			return NL80211_CHAN_HT40PLUS;
 		else
 			return NL80211_CHAN_HT40MINUS;


