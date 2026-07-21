Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7AB224B05;
	Tue, 21 Jul 2026 22:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674660; cv=none; b=nweJXJeKKaXex1BQAzAzW5voKQzVymyMonh4tf7WxJjKWDOXY7auDaBHbIoHdUafPd0StAmk4hTvGKHjvUOJQoyF1XO829KgWSOIbs22m+m5NjX6OZNXjH+y5N4K6JfWrnE+mSTXMldAPVVer+yj/f4p3EyKHeDZ4Res8p+FXac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674660; c=relaxed/simple;
	bh=OmR5qBBdgYAmGFHLuJ9h0TDsXlNYiUzwBBnv3TsoVZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYpp1xlOfYJju8JfygWwg/w5QWrBz2pXWCfdKa9y4N56KQ7mAb1kMU+Th9uu1cHi3XszScK4bKN0XR8D7qhZ+pS3+gJUDIycUBvJLXYFM7QV+vdu4L2Lu8baH/j1Y/W59ktk5cY7qqOlqrtGR38IO2eOGKefHxmuB72Cw0RYvac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BeZAEsBn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BeZAEsBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7491F000E9;
	Tue, 21 Jul 2026 22:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674658;
	bh=h4DqTAnONVI3ei4YeQuJbI0LNiOD4l1tZnXu/Y+f668=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BeZAEsBntbz95Yy1I775zae/Y6N1hZqOKJFLUYnDUn6qyhec0D9EB1sUg77MaiB8n
	 /JPiPGmLUwEY/ocCGZu5SrU8FvsiV1Vz5i8gRi0Q75Pg0RM8ii+5jWuTfmHlpKDhcQ
	 hJcak2lne/JZc+l3u5+bPaJ9TsGD3t3FpePISB/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Luka Gejak <luka.gejak@linux.dev>,
	Alexandru Hossu <hossu.alexandru@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 623/699] staging: rtl8723bs: fix heap buffer overflow in rtw_cfg80211_set_wpa_ie()
Date: Tue, 21 Jul 2026 17:26:22 +0200
Message-ID: <20260721152409.798253581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandru Hossu <hossu.alexandru@gmail.com>

[ Upstream commit 5a752a616e756844388a1a45404db9fc29fec655 ]

supplicant_ie is a 256-byte array in struct security_priv. The WPA and
WPA2 IE copy paths use:

    memcpy(padapter->securitypriv.supplicant_ie, &pwpa[0], wpa_ielen + 2);

where wpa_ielen is the raw IE length field (u8, 0-255). When a local user
supplies a connect request via nl80211 with a crafted WPA IE of length 255,
wpa_ielen + 2 equals 257, overflowing the 256-byte buffer by one byte into
the adjacent last_mic_err_time field.

rtw_parse_wpa_ie() does not prevent this: its length consistency check
compares *(wpa_ie+1) against (u8)(wpa_ie_len-2), which is (u8)(255) == 255
when wpa_ie_len = 257, so the check passes silently.

Add explicit bounds checks for both the WPA and WPA2 paths before the
memcpy, rejecting any IE whose total size (wpa_ielen + 2) exceeds the
supplicant_ie buffer.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable <stable@kernel.org>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Signed-off-by: Alexandru Hossu <hossu.alexandru@gmail.com>
Link: https://patch.msgid.link/20260522004531.1038924-4-hossu.alexandru@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -1818,6 +1818,10 @@ static int rtw_cfg80211_set_wpa_ie(struc
 
 	pwpa = rtw_get_wpa_ie(buf, &wpa_ielen, ielen);
 	if (pwpa && wpa_ielen > 0) {
+		if (wpa_ielen + 2 > sizeof(padapter->securitypriv.supplicant_ie)) {
+			ret = -EINVAL;
+			goto exit;
+		}
 		if (rtw_parse_wpa_ie(pwpa, wpa_ielen + 2, &group_cipher, &pairwise_cipher, NULL) == _SUCCESS) {
 			padapter->securitypriv.dot11AuthAlgrthm = dot11AuthAlgrthm_8021X;
 			padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeWPAPSK;
@@ -1829,6 +1833,10 @@ static int rtw_cfg80211_set_wpa_ie(struc
 
 	pwpa2 = rtw_get_wpa2_ie(buf, &wpa2_ielen, ielen);
 	if (pwpa2 && wpa2_ielen > 0) {
+		if (wpa2_ielen + 2 > sizeof(padapter->securitypriv.supplicant_ie)) {
+			ret = -EINVAL;
+			goto exit;
+		}
 		if (rtw_parse_wpa2_ie(pwpa2, wpa2_ielen + 2, &group_cipher, &pairwise_cipher, NULL) == _SUCCESS) {
 			padapter->securitypriv.dot11AuthAlgrthm = dot11AuthAlgrthm_8021X;
 			padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeWPA2PSK;


