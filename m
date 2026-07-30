Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC9B4052DC;
	Thu, 30 Jul 2026 14:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423547; cv=none; b=SymsBy1rB1QB4zcrKYhMj4kCVRco4oCH0JnvkB/k8h+sCqX9o5/oS5kzSieOnu1SIUpUH8+aDgNQAUEROgq85svO5FbebxZJD+GqzhnZN4aQCUqikcsmmmVEhpx1NrMK6oKWmUVhA8vzIdjOkcPFaZyco39bypJOiluroIgGbRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423547; c=relaxed/simple;
	bh=NxyQKZ+2NAiFRrrxICCaL8Ab1mZ0p/V7UJ4mh6huk3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJfrzsHNbdxuJa0SlkzcQrutw7rgZJq42vQRJn/RzVuPzwRFy9jW68XNphqTnu0TslxAVHYfIpi1R00eMXiEHMhRsSsjPM1+Q0Z9Tq8R1kyCU2oOEyiWjnmPyvlevwNdXgLmCyA27ua+fGV4fYtkGCoaybHWdahE/uvNZNJFtVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyguegLC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyguegLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9FA1F00A3A;
	Thu, 30 Jul 2026 14:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423546;
	bh=7hamBEvohwauUT0gnFcj3i3JI60UjfYuMyMPXYpCeeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eyguegLC016tF8h5cZvFPG9tAhyD1lRycjc8ihTTZZqVdr4XfqZp9w+MMRCdCqr2O
	 yS1qdRT0pL8yHRtkvFgKodptOtcWwiLKLw/Ewx9hjxIDCH4VUwtZjgcALPUh/0ceao
	 FWANiJTc4e0DXuO9pwkOjXxgUx5eW9BpWF9+VKt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 075/675] wifi: nl80211: free RNR data on MBSSID mismatch
Date: Thu, 30 Jul 2026 16:06:45 +0200
Message-ID: <20260730141446.722946786@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6e41a4269e1c57..e765c992eb20e4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6232,8 +6232,10 @@ static int nl80211_parse_beacon(struct cfg80211_registered_device *rdev,
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



