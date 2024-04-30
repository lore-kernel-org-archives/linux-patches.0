Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D5712C46E;
	Tue, 30 Apr 2024 11:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475390; cv=none; b=Zlw2jIjWU+Cq+DMGvWhgaDcqw3rOfhWU1qz/fR/SSHsXACg/IYLKFuQ8c37TDs/C8BN5Va8Z1mUVTZkDaGr4zFzs5sCrZLzS2RNofyx0wJArksCCu7RE6o+1HpUoOvi+WhUmMppIc0DYI4a2JM29S60/x9PLy0Ih5MjF0w/uPB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475390; c=relaxed/simple;
	bh=xbJ+sHg+osYjlahyUMe81TPHzxl/4YkDOW8acq11ioE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Da9f9LKYl+Wt4SdbdXE/IZPpiYQBH8gVZaty5dlOanqkXo89kGbMhKuTg7nqKl5+2pgJh3+KDNPgaPpUiKay/W9bNtdBltEQs/tLGqUARi6LL4woRO3LUvbsAegtKw+T3Nx6Y5YhsCOHV8lob3CxZiPlyuyjFDC+w2ywEaYLiaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tk0Sj4rc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tk0Sj4rc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E325C2BBFC;
	Tue, 30 Apr 2024 11:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475389;
	bh=xbJ+sHg+osYjlahyUMe81TPHzxl/4YkDOW8acq11ioE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tk0Sj4rc6JJi85MFyMQpj3K2sP6N6SSPdOCkpsV8z9tKHBrk0erCj1pEm4FTT/7dc
	 1dVBoAa3yCIsyqsmRkdZ7QjxkW+5GwGIBT47xrM8Ts4x6Tgu9Glye7P9zSqpUAhNqC
	 0+2yjDs30AMolE3EOo/zYKVzb63bAz7Rkjs7NRco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/186] wifi: mac80211: remove link before AP
Date: Tue, 30 Apr 2024 12:38:14 +0200
Message-ID: <20240430103059.254400255@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit cb55e08dba3526796e35d24a6d5db4ed6dcb8a4b ]

If the AP removal timer is long, we don't really want to
remove the link immediately. However, we really should do
it _before_ the AP removes it (which happens at or after
count reaches 0), so subtract 1 from the countdown when
scheduling the timer. This causes the link removal work
to run just after the beacon with value 1 is received. If
the counter is already zero, do it immediately.

This fixes an issue where we do the removal too late and
receive a beacon from the AP that's no longer associated
with the MLD, but thus removed EHT and ML elements, and
then we disconnect instead from the whole MLD, since one
of the associated APs changed mode from EHT to HE.

Fixes: 8eb8dd2ffbbb ("wifi: mac80211: Support link removal using Reconfiguration ML element")
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240418105220.03ac4a09fa74.Ifb8c8d38e3402721a81ce5981568f47b5c5889cb@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c6044ab4e7fc1..e3e769b2f2ef1 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5884,8 +5884,11 @@ static void ieee80211_ml_reconfiguration(struct ieee80211_sub_if_data *sdata,
 			continue;
 		}
 
-		link_delay = link_conf->beacon_int *
-			link_removal_timeout[link_id];
+		if (link_removal_timeout[link_id] < 1)
+			link_delay = 0;
+		else
+			link_delay = link_conf->beacon_int *
+				(link_removal_timeout[link_id] - 1);
 
 		if (!delay)
 			delay = link_delay;
-- 
2.43.0



