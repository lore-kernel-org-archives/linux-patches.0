Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625899;
	b=B2N0BqZXhPm8rzklMMhP4SiK/Vt2qOWRqZWx/AyTk1UECSYVVRQZ7UhdYkTHzC3RZPCF
	 wIW/fjHTwsLvxwJ9nelEBb5hpLvY2PeDYAZwL29OMeSeqHPAuvkxZ6qF8IGnHY3Wy8bjB
	 s3a9J39Ykmj3teiV4GNms1gPT77mP2ubzo3Izcncjv+jZAE08DGj+pIZYP7bwIKh49ZvD
	 5BFV1YrY4235pcP704W/X96i8qlGOJY5l9aEvTPgkPgiQxh1lxNzKzIhfz+xZTez6c4VA
	 L78UffVXWN/rZs1O+4uonqdmy0of0vXIljLb0zh2lK4s2s3BM2nNo152nEyPVKbfgOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K8aG2QAGEq+9+dNhiZ5J7LH80PyQA/e867PDTxTHDcY=;
	b=wqt05hFPQAAcfENyFe+bUvKRx3YIa+MxKLXItzH0Anwb8p5Flo7SYXsOhegWBPDwLAI6
	 8NiqdEaZk/MrKNwVUU/Ep4Oz7EhqvcC4zhILlwCCiskCqfkT7JSgC2Eq+iS4z/CHSzdL/
	 KfFOKT+qg7To0dNrYpccDINBSy5seBeoVT2bOqfK5/CbW7Y7zYJ38pOzu3doI1yDtDjRG
	 DrOwai0PnUugzplr5PWYpnuiS76VgqVUXaPR/mbAZ8qcwxQ4oznzMRg/16xbqLHcgubjw
	 TlyRzcWnZHhHrybOOcWQlokgth8Nam32MU+k+yOsHdVJ2aue3pqrxI9XHiReTG1YRqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ATeSgstr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0829F606A323;
	Wed, 25 Nov 2026 16:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ATeSgstr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F281F000D3;
	Wed, 25 Nov 2026 16:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625898;
	bh=K8aG2QAGEq+9+dNhiZ5J7LH80PyQA/e867PDTxTHDcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ATeSgstrZIa2/SivmYeDzDgtr2ODZNBia1zUeX5sAQIQ6sxQA3LxUS/w6XH5Oz7+S
	 2nTLD2kpaQ7cY563CxfcLWDIgudeFvxxGy2XVO3iaQqicZr7yiJg/fVMAGL/gsaeIZ
	 3ESqS1OHfqFlIzsikvfm6CT6HyfU6g4KKhTtgSV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 667/816] wifi: mac80211: recheck the OCB station limit before insertion
Date: Wed, 25 Nov 2026 15:36:55 +0100
Message-ID: <20261125143904.617860754@linuxfoundation.org>
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

commit 27e29a077b4887d0e0a813337f8b7e06bd020c81 upstream.

Frames from successive unknown OCB peers can make the deferred worker
install more than 128 stations.

The receive path checks local->num_sta before allocating each station,
but pending stations are not included in that count. Several allocations
can therefore pass before the worker inserts any of them, and the worker
then drains the list without rechecking the limit.

Recheck the installed-station limit in the worker under the wiphy mutex
and free entries that no longer fit.

LLM assistance was used to find the bug and review.

Fixes: 239281f803e2 ("mac80211: 802.11p OCB mode support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142302.16634-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ocb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -136,8 +136,12 @@ void ieee80211_ocb_work(struct ieee80211
 		list_del(&sta->list);
 		spin_unlock_bh(&ifocb->incomplete_lock);
 
-		ieee80211_ocb_finish_sta(sta);
-		rcu_read_unlock();
+		if (sdata->local->num_sta >= IEEE80211_OCB_MAX_STA_ENTRIES) {
+			sta_info_free(sdata->local, sta);
+		} else {
+			ieee80211_ocb_finish_sta(sta);
+			rcu_read_unlock();
+		}
 		spin_lock_bh(&ifocb->incomplete_lock);
 	}
 	spin_unlock_bh(&ifocb->incomplete_lock);


