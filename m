Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C00279C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11FFC433D6;
	Wed, 30 Nov 2022 18:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833224;
	bh=EOEbAUBC9oY0+jjwQpj5atG/TX43ekcl7mzK0U0e+H0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bqv7JhV9ChkRUdoaQLlWIjgrwA6LTy613a6Ga2+01l/k/59a/g1cOONj4V5oUIBuF
	 sPfwYZS7s26voX0YwjYtLPRJeJvRN4Ksjmy9pJySKOBw+GIXD2X4yWDepmLkQHyn3i
	 maT2fOcuTdFOIPqB1YFw+w+HdN+UkeYqSWxWZ8qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	taozhang <taozhang@bestechnic.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/206] wifi: mac80211: fix memory free error when registering wiphy fail
Date: Wed, 30 Nov 2022 19:21:23 +0100
Message-Id: <20221130180533.784970964@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: taozhang <taozhang@bestechnic.com>

[ Upstream commit 50b2e8711462409cd368c41067405aa446dfa2af ]

ieee80211_register_hw free the allocated cipher suites when
registering wiphy fail, and ieee80211_free_hw will re-free it.

set wiphy_ciphers_allocated to false after freeing allocated
cipher suites.

Signed-off-by: taozhang <taozhang@bestechnic.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5311c3cd3050..9617ff8e2714 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1357,8 +1357,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	ieee80211_led_exit(local);
 	destroy_workqueue(local->workqueue);
  fail_workqueue:
-	if (local->wiphy_ciphers_allocated)
+	if (local->wiphy_ciphers_allocated) {
 		kfree(local->hw.wiphy->cipher_suites);
+		local->wiphy_ciphers_allocated = false;
+	}
 	kfree(local->int_scan_req);
 	return result;
 }
@@ -1426,8 +1428,10 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 	mutex_destroy(&local->iflist_mtx);
 	mutex_destroy(&local->mtx);
 
-	if (local->wiphy_ciphers_allocated)
+	if (local->wiphy_ciphers_allocated) {
 		kfree(local->hw.wiphy->cipher_suites);
+		local->wiphy_ciphers_allocated = false;
+	}
 
 	idr_for_each(&local->ack_status_frames,
 		     ieee80211_free_ack_frame, NULL);
-- 
2.35.1



