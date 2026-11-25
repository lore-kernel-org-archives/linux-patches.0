Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623316;
	b=RyAWruoj6dYHHXyjJCUHKnd0K49RHz50chZ+zxM0YLdNoEyyWGBt91yn5+wosEg8mAv4
	 R9m73kJrNTiocop2YHBeWP782+j81/eiBJ1KvjRaQtywO8Mz9LRaNeIO9HvOrMfDxXI4c
	 Dk94BYBwirTzw+VOO92OCpxoBbpYKmYu5eYnu5jBf7ETviDZKIggzLGviaSKJVA3+R7yb
	 O1IPOfa43NMlu2F1f0X7IIKmwbUGC1E2faG5XSTQG6I1ipD4tzj9gjqlllpybbxYcfiAO
	 ETz93zb5xLgQfY3GwmlJNqn/UF+vkZAyebzc/2EhmT2Km6TPMXNqvFIjC0+VVpfiCrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p9nCSvlQyBEp9vyV+qYDHxiFBqhNZVINJU4JHeU0/qw=;
	b=18DOHMERC5LHTbj42JdIRTbAJY2ln1oM4HZYIVBIvXfwsclUYhKPDCt/32V6KXhkbjGI
	 8X6xcv87YQFwyILgrZycURx1OFMlR5RUdgQC7x+UOzowX82Rn86BrF93mnKwd7pOq+jbP
	 50OyWujOPEQmWW75VYdU9fn1OzcjcKAJ4O1aF5F2+P2rH3/hU02b7i3V8gJWltrVkjbZQ
	 1r3FKBovyMkA8Tb8EVInn3nlO02rJG2ZEJJ8j/NptQNmjrUpzM97boBVfP07lch/Llugj
	 6mckVinAPhsEHyMLgOrbi7ttcIXNNWVMtuMeNSPbLAsq4fUuMhUM4mVPPKDPw69nkRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o3SqITp4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC1A606A32E;
	Wed, 25 Nov 2026 16:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o3SqITp4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471D81F000E1;
	Wed, 25 Nov 2026 16:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623315;
	bh=p9nCSvlQyBEp9vyV+qYDHxiFBqhNZVINJU4JHeU0/qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o3SqITp44lxipo6s4yre3CliiW4v4Inm+cHHc1PHPu/YE0jPjQV8EzvzRy6J0YZvy
	 snuVDxmuHz+vfSeWKsuof8HbObf3V3v9CHsCzBJCk3mG5koJhnVFDo1U9F/AFHT5T2
	 tVf7j0MTP/TV4JIZ8xwUByqWrXvtvjhwSiHq8O2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 818/990] wifi: mac80211: recheck the OCB station limit before insertion
Date: Wed, 25 Nov 2026 15:36:25 +0100
Message-ID: <20261125143841.201389565@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


