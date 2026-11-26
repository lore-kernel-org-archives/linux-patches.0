Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705543;
	b=e6x6+Od6Xo+9NVXobvGoZzHSF+ec2Z6RZZMLosn3sF1Oda9++AcRi4TwX0O0wkWiikKB
	 AgeseTc+nIUBsREWdVfb/AHQVPQ4QvPIvCNgGFdB+RNdDY/3axU7a2NCwiRlLK55fyQ3S
	 m0eBIrsPhCHbAqTz2TCtmZewKQHxnnCN2BGDLOP+EbzxBi/BeQpCgKSfWHqh4oYFOtrtO
	 OahpzDXMZQ6wRWnQz8UWkccEgVDP3W/8WXvt5Y9vgueDKnzrPFa8cAMyaRY+f8fHQktdT
	 ChDhRFhbZ05ZQBfvf2uVkHjmGkpoptTmkZe4A5vdTyzmtRJXLrghKNYOUcR6wZB+Aaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mn8OgfmM2NXh21EWUMzlRrkSArOBTm7kA0mlBoykZ0w=;
	b=nxHpJnW8vJ8EsaZEr60X3wF+jmpa8AUXAYUbVtftu/nDiy6IyuLlSRtd6jCdnulFUFNP
	 6p95EE6CdlC1+vTvtzFY7UOgxzLv/q8Lwro+NaPxZCOa2TeiZo8uRZWdN5pJUbiXLc2v2
	 Hc/cZpR8982v4MXdLabzm1QRRv3nM6P4MnnQGU9uXrOm8fplVl3q5cO1aB+4nJ/v9rd4D
	 gJchUO/HVxFEOldC6fLJs/SIf1D1pM1XCNtn7zwMwqsZFUDfWoTrdMhEaQRc4vl6Keafj
	 fgX9BQlD/SqoF05E1Wsl2Y0ypkVMli7oPTkVXjJf85b6fX6ocmTXj6K6TfVxvGcpGdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kOp6jx6D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B054606A31E;
	Thu, 26 Nov 2026 15:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kOp6jx6D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EAC1F000C0;
	Thu, 26 Nov 2026 15:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705543;
	bh=Mn8OgfmM2NXh21EWUMzlRrkSArOBTm7kA0mlBoykZ0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kOp6jx6DXPwuNyhGZoYMFEMVvAq8s3he08+4vrPks5crPEsqrb6aeiboqDkFqUprs
	 W/YXmI3PRd9NQG0mZe7kzlgf/MTeHO/I0bRjzgWyQug9dbjS6TiDHcGzp6wDq309Bj
	 xVcVuGB8RzMO/l5EY56xYP5IkDAHcwKSG1KHwC84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 234/319] wifi: mac80211: recheck the OCB station limit before insertion
Date: Thu, 26 Nov 2026 15:40:02 +0100
Message-ID: <20261126144012.029812091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -138,8 +138,12 @@ void ieee80211_ocb_work(struct ieee80211
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


