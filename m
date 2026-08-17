Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0A92773EC;
	Mon, 17 Aug 2026 15:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978919; cv=none; b=Ta7Fs+Kuy3izWakgxZFP/cUWotpb0WVfGFW5pYfDSfG559PZDbUaG6enkXoJM7bNQntB6um4lYmxMflC4PPUWqcLK2hdd18Bb2EUEGeSmCKwCSNBSiAS+PqnZZnm1VMyILKdBZFRJT9y3mJBD3QNVWGNgZmDPp0Mxfr1LERht7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978919; c=relaxed/simple;
	bh=7pmqhBqVw61tyF6qbBR7qY6OGd9UhjgEV0dXhKSukk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkvmH8PPD18hl51J/L2IsM8XPDnmdHP+iPyiiKg2rLqYc8FMDnk4wdRx/s46Uv4LH/rhwqpBM9ORwufUQ5jMk++egjTw8QMOdZwnm/yl996tVbUi4kjT39QlgRyytEvPrINosSHMdA1CfJ+5yop93aNLtXQEI0RLVgC0BNobpb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KifAA2Ic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KifAA2Ic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EC21F000E9;
	Mon, 17 Aug 2026 15:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978918;
	bh=OdT24ZX+s9++5Vy94G0yn9BCGsPpYUUmIaex+WVfPkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KifAA2IcTAHTFuDD/sQHjXyQ4/XFfopsNBvO4Y1KPXEkFko+kTEa+h7pQIDtpshMQ
	 38OIVArjcpGV/IoLkwo+ccQCVvDjwdGSW8C5/IrJF4Mw6HLHKsoy8U06V3JIxtbLen
	 2Ra//Y4tcn5kAWMIQwOiuKbyGM7YFGIZ9kyK6OMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/609] wifi: nl80211: free RNR data on MBSSID mismatch
Date: Mon, 17 Aug 2026 15:25:41 +0200
Message-ID: <20260817132544.847348093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 36a7b9707eabd2..0146d837b8320e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5631,8 +5631,10 @@ static int nl80211_parse_beacon(struct cfg80211_registered_device *rdev,
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



