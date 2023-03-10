Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB0E848C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5568EC433EF;
	Fri, 10 Mar 2023 14:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458132;
	bh=Rh7fL2Qmc8rknp2a3KDZSel1NvQS2vn4Ppl6mSTT7bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AMrSbbS98Z2jgF62GI1Z8HXjHtTyanrkx/iYoWynKjoRS+oqQX1C4ZphcVwB3sYOF
	 Nuft7yIdNd2C4ZtLyceUcmF4QDzxjVT2QoCfXmiWsDlZh2I6Xuqs/9JDLcV0umx5cr
	 OJLF39RlDZS763PaK81bOhtp7sSPsYr10G9QV3Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <alexander@wetzel-home.de>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 174/252] wifi: cfg80211: Fix use after free for wext
Date: Fri, 10 Mar 2023 14:39:04 +0100
Message-Id: <20230310133724.126178009@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Wetzel <alexander@wetzel-home.de>

commit 015b8cc5e7c4d7bb671f1984d7b7338c310b185b upstream.

Key information in wext.connect is not reset on (re)connect and can hold
data from a previous connection.

Reset key data to avoid that drivers or mac80211 incorrectly detect a
WEP connection request and access the freed or already reused memory.

Additionally optimize cfg80211_sme_connect() and avoid an useless
schedule of conn_work.

Fixes: fffd0934b939 ("cfg80211: rework key operation")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230124141856.356646-1-alexander@wetzel-home.de
Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/sme.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -269,6 +269,15 @@ void cfg80211_conn_work(struct work_stru
 	rtnl_unlock();
 }
 
+static void cfg80211_step_auth_next(struct cfg80211_conn *conn,
+				    struct cfg80211_bss *bss)
+{
+	memcpy(conn->bssid, bss->bssid, ETH_ALEN);
+	conn->params.bssid = conn->bssid;
+	conn->params.channel = bss->channel;
+	conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
+}
+
 /* Returned bss is reference counted and must be cleaned up appropriately. */
 static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 {
@@ -286,10 +295,7 @@ static struct cfg80211_bss *cfg80211_get
 	if (!bss)
 		return NULL;
 
-	memcpy(wdev->conn->bssid, bss->bssid, ETH_ALEN);
-	wdev->conn->params.bssid = wdev->conn->bssid;
-	wdev->conn->params.channel = bss->channel;
-	wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
+	cfg80211_step_auth_next(wdev->conn, bss);
 	schedule_work(&rdev->conn_work);
 
 	return bss;
@@ -568,7 +574,12 @@ static int cfg80211_sme_connect(struct w
 	wdev->conn->params.ssid_len = wdev->ssid_len;
 
 	/* see if we have the bss already */
-	bss = cfg80211_get_conn_bss(wdev);
+	bss = cfg80211_get_bss(wdev->wiphy, wdev->conn->params.channel,
+			       wdev->conn->params.bssid,
+			       wdev->conn->params.ssid,
+			       wdev->conn->params.ssid_len,
+			       wdev->conn_bss_type,
+			       IEEE80211_PRIVACY(wdev->conn->params.privacy));
 
 	if (prev_bssid) {
 		memcpy(wdev->conn->prev_bssid, prev_bssid, ETH_ALEN);
@@ -579,6 +590,7 @@ static int cfg80211_sme_connect(struct w
 	if (bss) {
 		enum nl80211_timeout_reason treason;
 
+		cfg80211_step_auth_next(wdev->conn, bss);
 		err = cfg80211_conn_do_work(wdev, &treason);
 		cfg80211_put_bss(wdev->wiphy, bss);
 	} else {
@@ -1207,6 +1219,15 @@ int cfg80211_connect(struct cfg80211_reg
 	} else {
 		if (WARN_ON(connkeys))
 			return -EINVAL;
+
+		/* connect can point to wdev->wext.connect which
+		 * can hold key data from a previous connection
+		 */
+		connect->key = NULL;
+		connect->key_len = 0;
+		connect->key_idx = 0;
+		connect->crypto.cipher_group = 0;
+		connect->crypto.n_ciphers_pairwise = 0;
 	}
 
 	wdev->connect_keys = connkeys;


