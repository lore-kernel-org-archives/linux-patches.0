Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D0B3C2785;
	Thu, 30 Jul 2026 14:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421313; cv=none; b=HembFJ02cvbCm/zC0ypU/QMJPCBGGgz8JUKiWfTxw+eV0skAnEdJ6AnowU3O6mcs1ROA2C1El2vRULNbcuMa5SbbN5CAJp68/LOObAiCQdHMl346xvgilIgJgyPsqJy5gi0ifFih51VB7uCZqz9m3U/wSjGwxpaHBsmBAP74odI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421313; c=relaxed/simple;
	bh=XAkY/dWmsT/8v3tPmnf6V8UcFuZjI9K7gUUk4SnzT4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INABy5LlHoDsP7CCZ3WvwqT+sfg511Y51rHSKH/nsoGSt8Lhzz2X1+z4iS1M4Ye+LnPzJ/7AHi+dSs43wR9OkEwbdiP9LJNNOIiV6J+LXuCjyeGcQl3Ekk7B3DFTFld4KzLzHy0OUsCZuGJwQYV+HoLL5oghSrvj9FyLNdR1ruo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SHnTY8uq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SHnTY8uq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891321F000E9;
	Thu, 30 Jul 2026 14:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421312;
	bh=0EJtJJV8i/rD7/5wP/TOUDMAfE1cVxIhJEosbERR8xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHnTY8uqT96Q5pcBNcpcMPjXp6s64N35s9Tc1vtuL60bak5q5MEy8I9bpW4BA5ABp
	 MUIRYR9e2LOD8WYn+e6+cYW7rbDgBJRKBIJiMln6fxWpujEyS/1PoxQG1oE2ErVokk
	 C/PRYnnxV18Pvw+fp3Yurr2guSkyjCep/hnZZDQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 060/744] wifi: nl80211: free RNR data on MBSSID mismatch
Date: Thu, 30 Jul 2026 16:05:33 +0200
Message-ID: <20260730141445.552812114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 07a95ec2b54774201fdf4ef7ffb0ca2ab19ed29c ]

nl80211_parse_beacon() rejects EMA RNR data when there are fewer RNR
entries than MBSSID entries.

The rejected RNR allocation has not been attached to the beacon data yet,
so free it before returning the error.

Fixes: dbbb27e183b1 ("cfg80211: support RNR for EMA AP")
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260610112208.1308-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 21e43e08b5d795..c7edaea9873e0a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6519,8 +6519,10 @@ static int nl80211_parse_beacon(struct cfg80211_registered_device *rdev,
 			if (IS_ERR(rnr))
 				return PTR_ERR(rnr);
 
-			if (rnr && rnr->cnt < bcn->mbssid_ies->cnt)
+			if (rnr && rnr->cnt < bcn->mbssid_ies->cnt) {
+				kfree(rnr);
 				return -EINVAL;
+			}
 
 			bcn->rnr_ies = rnr;
 		}
-- 
2.53.0



