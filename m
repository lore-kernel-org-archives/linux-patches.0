Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C04938DC50;
	Thu, 30 Jul 2026 14:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422919; cv=none; b=DZ7b2XI4M8vOJ4oVXLKIwtDbaVtrmElHXDkJPAURaV80PwPdY0Tx80ySj+NV/OXNetNA78fXLwV65aphGGrkqZr1/1dEdeZjrC31h/Svvl/I3L3ieAVks0cX2UTw3ylGKu8QuQpNUKLKCIUv9h9HRw1kEfVEPPykDF4qqe7bnd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422919; c=relaxed/simple;
	bh=zkT8olvV4478eG7s7gKskc9Og5mOmtiHmbMmt1iPLC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Akvs4M9I92NintWNloo+/A+omJQMBd7SqMoA2dnde7RZnwublqgRbqLb4NzX8dGr622PtA2ReSCAvguaYHTbmv4l1ZvQhuydhKEzYjsya3zaLP+JjrXU1nRhI6QLBCip8k24m6U592XTKFNC/XD7IMtvICL74Go5MTHHBSRfM/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+mkzO8R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+mkzO8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7DAE1F000E9;
	Thu, 30 Jul 2026 14:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422918;
	bh=5R+0KNz2ppXdLZqppq3TjywntgazohIDOu+5+Q6z8BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f+mkzO8RwEZTPegIQhOTGva/Bb+/EeQ8p9UDl/VABCFJ2aRbI2QAaHUU/oOaSl8NJ
	 lP5fLMFUGfaEjBTiKZ5QJWZh11W/kw0WOtIQJNGaV1xijoTiqqn9v4Z3DSSnXv8T2A
	 jmaRcqTlb9ewCJOuqmj4MnDLFYuqjl+AOzaBAbtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MinJea Kim <qndkdrnl@gmail.com>
Subject: [PATCH 7.1 557/744] staging: rtl8723bs: fix inverted HT40 secondary channel offset
Date: Thu, 30 Jul 2026 16:13:50 +0200
Message-ID: <20260730141456.120441679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1956,7 +1956,7 @@ static u8 rtw_get_chan_type(struct adapt
 		else
 			return NL80211_CHAN_NO_HT;
 	case CHANNEL_WIDTH_40:
-		if (mlme_ext->cur_ch_offset == HAL_PRIME_CHNL_OFFSET_UPPER)
+		if (mlme_ext->cur_ch_offset == HAL_PRIME_CHNL_OFFSET_LOWER)
 			return NL80211_CHAN_HT40PLUS;
 		else
 			return NL80211_CHAN_HT40MINUS;


