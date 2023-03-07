Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBC2BA44
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1D8C433D2;
	Tue,  7 Mar 2023 17:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211573;
	bh=LJhnb9MBHdPu93ufgQtRq6eOAG5j3TVbHLI/pJGV3qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wdXZGMXqnNnEGCeNGb+/eThU+SGQE0VKAR+tLWo2Ii/A8jLh2gWql8M3lk7i3BuWm
	 L8ctsSaHDTxwBnwbpCOH3IEQyEJuQ4RLGmWQpwCDr0HAHAvAphCkTiM4z/9EIrOHpT
	 z5P09fG8/Wq8zkIZFk2cxJUoN4tQRNt0VdXfFuoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yohan Prodhomme <kernel@zoddo.fr>,
	Marc Bornand <dev.mbornand@systemb.ch>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.2 0907/1001] wifi: cfg80211: Set SSID if it is not already set
Date: Tue,  7 Mar 2023 18:01:19 +0100
Message-Id: <20230307170101.384125107@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Bornand <dev.mbornand@systemb.ch>

commit c38c701851011c94ce3be1ccb3593678d2933fd8 upstream.

When a connection was established without going through
NL80211_CMD_CONNECT, the ssid was never set in the wireless_dev struct.
Now we set it in __cfg80211_connect_result() when it is not already set.

When using a userspace configuration that does not call
cfg80211_connect() (can be checked with breakpoints in the kernel),
this patch should allow `networkctl status device_name` to output the
SSID instead of null.

Cc: stable@vger.kernel.org
Reported-by: Yohan Prod'homme <kernel@zoddo.fr>
Fixes: 7b0a0e3c3a88 (wifi: cfg80211: do some rework towards MLO link APIs)
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216711
Signed-off-by: Marc Bornand <dev.mbornand@systemb.ch>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/sme.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -736,6 +736,7 @@ void __cfg80211_connect_result(struct ne
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	const struct element *country_elem = NULL;
+	const struct element *ssid;
 	const u8 *country_data;
 	u8 country_datalen;
 #ifdef CONFIG_CFG80211_WEXT
@@ -895,6 +896,22 @@ void __cfg80211_connect_result(struct ne
 				   country_data, country_datalen);
 	kfree(country_data);
 
+	if (!wdev->u.client.ssid_len) {
+		rcu_read_lock();
+		for_each_valid_link(cr, link) {
+			ssid = ieee80211_bss_get_elem(cr->links[link].bss,
+						      WLAN_EID_SSID);
+
+			if (!ssid || !ssid->datalen)
+				continue;
+
+			memcpy(wdev->u.client.ssid, ssid->data, ssid->datalen);
+			wdev->u.client.ssid_len = ssid->datalen;
+			break;
+		}
+		rcu_read_unlock();
+	}
+
 	return;
 out:
 	for_each_valid_link(cr, link)


