Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB96F16F84F;
	Wed,  2 Oct 2024 13:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875367; cv=none; b=M84rcvjefrUFQJcv6fAmb8vhNs6+6hhzBwG1mEL4tcl3MvnsS2AgNLdE6GKEpsvv8ny+Ub3ypB5u6LXH2x24WGSPlx80LubJwC3tqvCTSXJYeQ1jxB+DQtHjmnW3TWX17135M8BasEyeZ8TukkNTpWcameEX/5K2ANXPoTeJNoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875367; c=relaxed/simple;
	bh=aXG/LVX7SrfbZ3VMc/FrEJuIZTGaOzyMT7AylcgZwVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IphoHFM9fbXtEAwfmNy3nWSOYNggKU8QafSYoUMEyYRz0kD/kxAfDeusdO/4ZIuRup7zKXKn7LyifHcQCYPSTMSvtXLsJ7/bt9CYtt4BS+evpE0t5lZUqJu4JmIljAeJVtEcW6J0dSL8M5t1DlEkrn6HfdPx/bt9cNrWQeMuL5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEFZcL3q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEFZcL3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551E4C4CEC5;
	Wed,  2 Oct 2024 13:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875367;
	bh=aXG/LVX7SrfbZ3VMc/FrEJuIZTGaOzyMT7AylcgZwVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEFZcL3qtkctktZYgF6gYSeMkSKnOOFStrORQ1zY6+fq0S/NFOKROA/hIuKb5f/9q
	 QHYMqPEKQvodfRuONQ3zxw2vz9ELUnkTjwnT0mfneT1B9ygHRJH4i1dltBUEHUfafZ
	 IlH8ezQI0XqoOTWQp4kLI8SGxORp1PffdwrL/G50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 051/695] wifi: mac80211: fix the comeback long retry times
Date: Wed,  2 Oct 2024 14:50:49 +0200
Message-ID: <20241002125824.525068745@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 1524173a3745899612c71d9e83ff8fe29dbb2cfb ]

When we had a comeback, we will never use the default timeout values
again because comeback is never cleared.
Clear comeback if we send another association request which will allow
to start a default timer after Tx status.

The problem was seen with iwlwifi where the tx_status on the association
request is handled before the association response frame (which is the
usual case).

1) Tx assoc request 1/3
2) Rx assoc response (comeback, timeout = 1 second)
3) wait 1 second
4) Tx assoc request 2/3
5) Set timer to IEEE80211_ASSOC_TIMEOUT_LONG = 500ms (1 second after
   round_up)
6) tx_status on frame sent in 4) is ignored because comeback is still
   true
7) AP does not reply with assoc response
8) wait 1s <= This is where the bug is felt
9) Tx assoc request 3/3

With this fix, in step 6 we will reset the timer to
IEEE80211_ASSOC_TIMEOUT_SHORT = 100ms and we will wait only 100ms in
step 8.

Fixes: b133fdf07db8 ("wifi: mac80211: Skip association timeout update after comeback rejection")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20240808085916.23519-1-emmanuel.grumbach@intel.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f9526bbc36337..0a4a25a10eaea 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7660,6 +7660,7 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
 	assoc_data->tries++;
+	assoc_data->comeback = false;
 	if (assoc_data->tries > IEEE80211_ASSOC_MAX_TRIES) {
 		sdata_info(sdata, "association with %pM timed out\n",
 			   assoc_data->ap_addr);
-- 
2.43.0



