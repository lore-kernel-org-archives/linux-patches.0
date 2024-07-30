Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291151A76AE;
	Tue, 30 Jul 2024 17:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360109; cv=none; b=onwxsQJXALarDADgbC5thYLPJTwCaAmcoCQKsFyk9ePcLNRRoFFLqkZXtrk+tku5e7NfmyrZTEiMryuIsN878owpihub4YMQEsCIQIeSeo9O1BMOAKOF1w21MU7/drKNVE+wiUA/1FqQtAxEOCg8woAy8oLL8QqPXSM6MMfY7ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360109; c=relaxed/simple;
	bh=xyYPyAMdRmyx8kaTnYGQZiAtKq1KyAtVStohmTwy4GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pn51pHSXsEt5TGOpsQUtMG4svczCC4Ruo5Fo49izw+9EBqgrBy09ObV90dHMP5+FqrP1DJRuFceai7hXqFluzlXg1RlejGXR08oq/kYdUs1gFjF7DxISje2exkjHYK2NKs1wpxzN71S6FdbfCrs0jpq6m6aCTJuSBJfpb9FPoXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SS2o+cK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SS2o+cK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DBF9C32782;
	Tue, 30 Jul 2024 17:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360109;
	bh=xyYPyAMdRmyx8kaTnYGQZiAtKq1KyAtVStohmTwy4GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SS2o+cK5+FteDtVcIH8e2OynXw/fTuOAAGHvSf4eYJvU7OlgZWFGeJSNjpYGFLCwk
	 JxBaYODaMsKfbuc1L5gV+HBIFJm0fv0Cs8P4CdWqAJPOQteVDhLe/2iT9S18iuB4PA
	 8LpC3bS3BpopE1e5bkv7e/nlb66Syi5LA88CMR/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Kang Chang <gary.chang@realtek.com>,
	Po-Hao Huang <phhuang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.10 600/809] wifi: rtw89: fix HW scan not aborting properly
Date: Tue, 30 Jul 2024 17:47:56 +0200
Message-ID: <20240730151748.528011438@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Po-Hao Huang <phhuang@realtek.com>

commit 669b692247d4516e252c898c0e7366a09d84d1be upstream.

There is a length limit on the commands we send to firmware, so
dividing to two commands is sometimes required when scanning.
When aborting scan, we should not send second scan command to
firmware after the first one is finished. This could cause some
unexpected errors when we cannot receive firmware events
(e.g. in suspend).

Another case is scan happens before suspending, ieee80211_do_stop() is
called to abort scan and driver indicate scan completion by
ieee80211_scan_completed(), which queues event to scan work. But scan work
might be late to execute after ieee80211_do_stop(). To correct this, driver
indicates ieee80211_scan_completed() before returning, so that
ieee80211_do_stop() can flush scan work properly.

Fixes: bcbefbd032df ("wifi: rtw89: add wait/completion for abort scan")
Cc: stable@vger.kernel.org
Co-developed-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://msgid.link/20240517013350.11278-1-pkshih@realtek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c  |    9 ++++++++-
 drivers/net/wireless/realtek/rtw89/mac.c |    5 ++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -6245,7 +6245,14 @@ void rtw89_hw_scan_abort(struct rtw89_de
 
 	ret = rtw89_hw_scan_offload(rtwdev, vif, false);
 	if (ret)
-		rtw89_hw_scan_complete(rtwdev, vif, true);
+		rtw89_warn(rtwdev, "rtw89_hw_scan_offload failed ret %d\n", ret);
+
+	/* Indicate ieee80211_scan_completed() before returning, which is safe
+	 * because scan abort command always waits for completion of
+	 * RTW89_SCAN_END_SCAN_NOTIFY, so that ieee80211_stop() can flush scan
+	 * work properly.
+	 */
+	rtw89_hw_scan_complete(rtwdev, vif, true);
 }
 
 static bool rtw89_is_any_vif_connected_or_connecting(struct rtw89_dev *rtwdev)
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -4757,6 +4757,9 @@ rtw89_mac_c2h_scanofld_rsp(struct rtw89_
 		}
 		return;
 	case RTW89_SCAN_END_SCAN_NOTIFY:
+		if (rtwdev->scan_info.abort)
+			return;
+
 		if (rtwvif && rtwvif->scan_req &&
 		    last_chan < rtwvif->scan_req->n_channels) {
 			ret = rtw89_hw_scan_offload(rtwdev, vif, true);
@@ -4765,7 +4768,7 @@ rtw89_mac_c2h_scanofld_rsp(struct rtw89_
 				rtw89_warn(rtwdev, "HW scan failed: %d\n", ret);
 			}
 		} else {
-			rtw89_hw_scan_complete(rtwdev, vif, rtwdev->scan_info.abort);
+			rtw89_hw_scan_complete(rtwdev, vif, false);
 		}
 		break;
 	case RTW89_SCAN_ENTER_OP_NOTIFY:


