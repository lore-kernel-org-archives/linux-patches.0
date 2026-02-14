Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853F2309DB1;
	Sat, 14 Feb 2026 21:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104349; cv=none; b=HbMNuqMK+4gOf3o4tMf0wC94adidq8+K1YW/LXLGI3vYHMQ8TVMaoy3rC8gfLLaRyx/eKXmW1d1LhPfvAPMOFwNE+pQBYewXk9pjHQkutvPioU2MxpnBucwNFwAzi2rUmJL3dRL0hn/SrwtmKS1YW4DpxRztA+VavddSXgBLplk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104349; c=relaxed/simple;
	bh=T/Svm1QtSGSSE6CRxvQBI4rvnb10QfskCp22IKsKjFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=liAWTh2pi2spP2FY4vkEBJcdsUmW2nw7DPn2HZOYS7k7Cu6Xc+9ic6tc6F7l3/8m9wSJInDakBzZtJodN6v2AE3NgDO1AXN0lNy5P8dSVeALFJuns32gsBfS32rwpzX0o/YwNMPUpsJxzelQzwmCKufIGkUqNbWyr+aZb7OIVpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DSoyR4cO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DSoyR4cO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC1AC16AAE;
	Sat, 14 Feb 2026 21:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104349;
	bh=T/Svm1QtSGSSE6CRxvQBI4rvnb10QfskCp22IKsKjFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSoyR4cO50i33zaaZA2TvkLhh7mtK8Je01yodDnjvy4U+pe45Wiqu4+1O07oOt1If
	 yMOeknfTD5Am1v/npE+5efuwDpfnWtZUaEbeYZR0NZ67oK/rK6YQtoBufZNbp+IXVb
	 DFur27r2IjoO1uqrxDe59pnSz52G/LBHgUO8xrTZukhCjktWjcezMYnnanP76f32kG
	 osSpGYqahwoJHVyTpaVwfonza00sWxThd+s+f33xOOrOGrp6xc1Yq6ZT8gZOoJjFxU
	 tYaonZdjDxBul4Dz+Oas5WOIAQWEw+AWBDP0mFTPXnMBFmkdszJaagTV1tl9qA8Jvx
	 tlBWYlwwnBRgQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Roman Peshkichev <roman.peshkichev@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] wifi: rtw88: fix DTIM period handling when conf->dtim_period is zero
Date: Sat, 14 Feb 2026 16:22:56 -0500
Message-ID: <20260214212452.782265-31-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roman Peshkichev <roman.peshkichev@gmail.com>

[ Upstream commit 9f68fdcdc9dbf21be2a48feced90ff7f77d07443 ]

The function rtw_set_dtim_period() accepted an 'int' dtim_period parameter,
while mac80211 provides dtim_period as 'u8' in struct ieee80211_bss_conf.
In IBSS (ad-hoc) mode mac80211 may set dtim_period to 0.

The driver unconditionally wrote (dtim_period - 1) to
REG_DTIM_COUNTER_ROOT, which resulted in 0xFF when dtim_period was 0. This
caused delays in broadcast/multicast traffic processing and issues with
ad-hoc operation.

Convert the function parameter to u8 to match ieee80211_bss_conf and avoid
the underflow by writing 0 when dtim_period is 0.

Link: https://github.com/lwfinger/rtw88/issues/406
Signed-off-by: Roman Peshkichev <roman.peshkichev@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20251125180937.22977-1-roman.peshkichev@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

The commit message clearly describes a **bug fix** for an integer
underflow issue in the rtw88 WiFi driver. Key points:

- **Bug mechanism**: When `dtim_period` is 0 (which happens in IBSS/ad-
  hoc mode), the expression `dtim_period - 1` underflows. Since the
  parameter was `int`, `0 - 1 = -1`, and when written via
  `rtw_write8()`, this becomes `0xFF`.
- **Impact**: Writing `0xFF` to `REG_DTIM_COUNTER_ROOT` causes "delays
  in broadcast/multicast traffic processing and issues with ad-hoc
  operation."
- **Link**: References a real user-reported issue on GitHub
  (lwfinger/rtw88#406).
- **Acked by**: Ping-Ke Shih, the Realtek maintainer, both acked and
  signed off, indicating this is a vetted fix.

### Code Change Analysis

The change is extremely small and surgical — only **2 lines of
functional change** plus **2 lines of declaration change**:

1. **Parameter type change**: `int dtim_period` → `u8 dtim_period` —
   matches the type in `struct ieee80211_bss_conf` (`u8`), which is
   correct alignment with mac80211's API.

2. **Underflow guard**: `dtim_period - 1` → `dtim_period ? dtim_period -
   1 : 0` — prevents the underflow when `dtim_period` is 0 by writing 0
   instead of 0xFF.

3. **Header declaration update**: Matching function signature change in
   `main.h`.

### Bug Classification

This is a clear **integer underflow bug** that causes real-world issues:
- The bug is triggered in IBSS (ad-hoc) mode, which is a legitimate and
  used WiFi mode
- The consequence is broken broadcast/multicast traffic — a real
  functional issue for users
- The fix is obviously correct: check for zero before subtracting

### Scope and Risk Assessment

- **Lines changed**: ~4 (2 functional + 2 declaration)
- **Files touched**: 2 (main.c and main.h, both in the same driver)
- **Risk**: Extremely low. The fix adds a simple conditional check and
  corrects a type mismatch. It cannot introduce regressions — the only
  behavior change is when `dtim_period == 0`, where the old behavior was
  clearly wrong (writing 0xFF).
- **Subsystem**: WiFi driver (rtw88) — widely used Realtek WiFi chipset
  driver

### Stable Kernel Criteria

1. **Obviously correct and tested**: Yes — trivial fix, acked by
   maintainer, addresses a clearly documented bug
2. **Fixes a real bug**: Yes — integer underflow causing broken ad-hoc
   WiFi operation
3. **Important issue**: Yes — broken WiFi functionality for ad-hoc mode
   users
4. **Small and contained**: Yes — 4 lines changed in one driver
5. **No new features**: Correct — pure bug fix
6. **Applies cleanly**: The rtw88 driver has been in the kernel since
   5.2, and this function is stable, so it should apply cleanly to
   recent stable trees

### User Impact

Users of rtw88 WiFi chipsets (Realtek 8822BE, 8822CE, 8723DE, 8821CE —
very common in laptops) who use ad-hoc/IBSS mode would experience broken
broadcast/multicast traffic without this fix.

### Dependencies

None. This is a self-contained fix with no dependencies on other
commits.

### Conclusion

This is a textbook stable backport candidate: a small, obvious, low-risk
fix for a real bug (integer underflow) that causes user-visible problems
(broken WiFi ad-hoc mode). It's acked by the subsystem maintainer and
has a linked bug report demonstrating real-world impact.

**YES**

 drivers/net/wireless/realtek/rtw88/main.c | 4 ++--
 drivers/net/wireless/realtek/rtw88/main.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index fa0ed39cb1992..361ce0d40956d 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -730,10 +730,10 @@ void rtw_set_rx_freq_band(struct rtw_rx_pkt_stat *pkt_stat, u8 channel)
 }
 EXPORT_SYMBOL(rtw_set_rx_freq_band);
 
-void rtw_set_dtim_period(struct rtw_dev *rtwdev, int dtim_period)
+void rtw_set_dtim_period(struct rtw_dev *rtwdev, u8 dtim_period)
 {
 	rtw_write32_set(rtwdev, REG_TCR, BIT_TCR_UPDATE_TIMIE);
-	rtw_write8(rtwdev, REG_DTIM_COUNTER_ROOT, dtim_period - 1);
+	rtw_write8(rtwdev, REG_DTIM_COUNTER_ROOT, dtim_period ? dtim_period - 1 : 0);
 }
 
 void rtw_update_channel(struct rtw_dev *rtwdev, u8 center_channel,
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index 43ed6d6b42919..1ab70214ce36e 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -2226,7 +2226,7 @@ enum nl80211_band rtw_hw_to_nl80211_band(enum rtw_supported_band hw_band)
 }
 
 void rtw_set_rx_freq_band(struct rtw_rx_pkt_stat *pkt_stat, u8 channel);
-void rtw_set_dtim_period(struct rtw_dev *rtwdev, int dtim_period);
+void rtw_set_dtim_period(struct rtw_dev *rtwdev, u8 dtim_period);
 void rtw_get_channel_params(struct cfg80211_chan_def *chandef,
 			    struct rtw_channel_params *ch_param);
 bool check_hw_ready(struct rtw_dev *rtwdev, u32 addr, u32 mask, u32 target);
-- 
2.51.0

