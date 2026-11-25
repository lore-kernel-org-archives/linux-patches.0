Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625908;
	b=IXjEufxzeIYXdovNOROTzTkrlAjByINHiGrqWF5OZ3mRpUKNcFvcoeq4leerDlsV3/TM
	 kwrGRkXek18k5+E4zdKgT5vyllX5+mUBx4iacITdo8HPpJ2Tbjbpc2ltVJizhbz/53Mew
	 vlNWOskP4IudV0LhVCFcCNpNkb0da3GYqJE8DRHXHR6JTuPRZ2a805Nbzbv/aCSHsNIn4
	 x7uv8yK69qSd88H4NpfYRKgIwSEO5DAd7tJ89JNxVy6TxDAeAnR8Q9ULwy0lGU7WRYRXw
	 nLpUTsAw0h8TcwB8uOXKB8Ce9hzH4vSxnA7U+vxJUfpgSs6Xz7CldYW9oIppoMnF7FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qv4iNTJ+AQQDCUtT0wwzHAerAX8Bxk2K/rcnN4Ixj2k=;
	b=oUkOF9Bhicr0845Etvv7aU/5CccdsCd+QO/U4BA+P3+/zJisT1ZrWsEg16L7vu6W3AOm
	 bAbD/wusH7UvlbI+7wWSpQ17oheTbFrbT1eSTx+DY10JXhQfqlrY3WTmLHhD9xW9Mzbpt
	 RksNgV6OWfsf9mZAajWNzyHxeenCCdaPWsPn7Nib3JLoaA10T9NEuchvW84M4gclcK71w
	 2BfTs0vP5uvSMO+9icOxMNETTbNiMJEJw7dJA8G0uxY7j5HFShd36OjhCS8o3pWHkGAp3
	 5R4Etja5H2un4QCOiS3PyRR3nWNmQ4dBdh7Oa7phrEK8k2QjftXWZEUHVKpmpjPWX9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IAjfBBi9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9A9606A31E;
	Wed, 25 Nov 2026 16:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IAjfBBi9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C621F000C6;
	Wed, 25 Nov 2026 16:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625907;
	bh=qv4iNTJ+AQQDCUtT0wwzHAerAX8Bxk2K/rcnN4Ixj2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IAjfBBi9Cdlo7oRyazJ5YkQMxvi5woKNgXdFbl4AooZpHvakKb6S6dj/2aAIMaEW7
	 QAv/bewekrPw3ha3lzOMDjyzWYk9hT12dRbo34J8sf4DYDfflu5y/qArrTzChqdTaa
	 No9mKeQIeRKNQooHdCU0CIhWUkRftJVZAvA/uCMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 670/816] wifi: mac80211: bound pending IBSS station allocations
Date: Wed, 25 Nov 2026 15:36:58 +0100
Message-ID: <20261125143904.686990817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit 3029ca2112d7bee4d3e3eadd02decdb3eddb9485 upstream.

Delaying the IBSS station worker while frames arrive from new peers can
retain an unbounded number of station allocations.

The receive-side limit counts installed stations, while new allocations
wait on incomplete_stations until process context inserts them. The list
lock does not cover the interval between allocation and list insertion.

Reserve one of 128 pending slots per interface before allocation. Release
the reservation on allocation failure, after the worker inserts or frees
the station, and when disconnect frees the pending list.

LLM assistance was used to find the bug and review.

Fixes: 8bf11d8d0811 ("mac80211: delay IBSS station insertion")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142235.15428-3-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ibss.c        |   13 ++++++++++++-
 net/mac80211/ieee80211_i.h |    1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -698,6 +698,7 @@ static void ieee80211_ibss_disconnect(st
 		spin_unlock_bh(&ifibss->incomplete_lock);
 
 		sta_info_free(local, sta);
+		atomic_dec(&ifibss->incomplete_sta_count);
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
@@ -1213,9 +1214,18 @@ void ieee80211_ibss_rx_no_sta(struct iee
 	band = chanctx_conf->def.chan->band;
 	rcu_read_unlock();
 
+	if (!atomic_add_unless(&ifibss->incomplete_sta_count, 1,
+			       IEEE80211_IBSS_MAX_STA_ENTRIES)) {
+		net_info_ratelimited("%s: No room for a new IBSS STA entry %pM\n",
+				     sdata->name, addr);
+		return;
+	}
+
 	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
-	if (!sta)
+	if (!sta) {
+		atomic_dec(&ifibss->incomplete_sta_count);
 		return;
+	}
 
 	/* make sure mandatory rates are always added */
 	sband = local->hw.wiphy->bands[band];
@@ -1668,6 +1678,7 @@ void ieee80211_ibss_work(struct ieee8021
 			ieee80211_ibss_finish_sta(sta);
 			rcu_read_unlock();
 		}
+		atomic_dec(&ifibss->incomplete_sta_count);
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -634,6 +634,7 @@ struct ieee80211_if_ibss {
 
 	spinlock_t incomplete_lock;
 	struct list_head incomplete_stations;
+	atomic_t incomplete_sta_count;
 
 	enum {
 		IEEE80211_IBSS_MLME_SEARCH,


