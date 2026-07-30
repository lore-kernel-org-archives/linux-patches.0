Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B5C382F23;
	Thu, 30 Jul 2026 15:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425433; cv=none; b=iZ3yJt41nTmxOK/HcphHzA7bssup6scjAZRfgflcnSG5PxCk0ZvHXnig3+BuZFWzsQiozKT6+uTUf4YWYjPfGXEyDpDGt3JNQJrUKfOZUf7auyi9RkdZRJ46u4pNug6KQu6uu9qeqXtxqe5AHOIlYc5Z05vHAgWk5Y9VsrZbnxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425433; c=relaxed/simple;
	bh=aiatluYeyXCaG8WIRjSfbCWe9QbTf/L8Jbgfgb3gcYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTUanxLt/1nlh/+w0EfS9zH28dEu3IN8kco7reQvU2oQpYN3PjXCZhM8u1Csl7CwSr2qTD6NIvMuZcFHqu438WDKmCwVFyz63gfcheq3qvzfniZ7xxwVL+C1d7xL3rjPqEPxcqtxMaa2lVwbC3TXq/RgP9TqQ/OP8nV8IOsveOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M2XsYghd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M2XsYghd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D141F00A3A;
	Thu, 30 Jul 2026 15:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425426;
	bh=J6SjM40HtdnLGQzN8jGCd+cAJ1iEY8Ads12yroXjhGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2XsYghdBn74LsdLZ8izG5c2pgeKL92gA33YgKFleMh/9lkP+yWt4k8bNVBN+ONzx
	 EP4Egy2m/dJBqu25d47lgL4wIAlOR11WJvNltm4jXMfhzU8vuWWrsuLfewx+IbUn94
	 QEShXEPJBmew/NQYJ6tpWmfBiI6xnd+4yikR7eC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/602] wifi: nl80211: free RNR data on MBSSID mismatch
Date: Thu, 30 Jul 2026 16:07:37 +0200
Message-ID: <20260730141437.369216620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0af78812e38efe..60e00a24bc249a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5711,8 +5711,10 @@ static int nl80211_parse_beacon(struct cfg80211_registered_device *rdev,
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



