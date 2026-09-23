Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0852151EE1A;
	Wed, 23 Sep 2026 14:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172853; cv=none; b=U1tnWKJZyXZLF/sqoj6QCACPpkgbrCEJCSwCai2r0z5yX1yDFJ/hf0F2H1pLAP0D77puASz6Oqa9YjXgqenkwmcd1/9V7O3uOXxpOlrVzzF4HT+j7guWFtCvHsXZMvd/3ZKFywLRkBIuiefECCN0DE7zwoYNYGNstU8ZtlE65d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172853; c=relaxed/simple;
	bh=D+1JLxuwgeigUgR2bpmTKuuC6RVgS9Q7NxNwPAowDFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ql9gS81SzCCYS2YfCWaRaSQ9iFBnLQ2bZqQh4js8DE7nhCVUThDaKRI0CXuOjpmgkLGPT1epqU3TRgR7gcjzWLV17itl0AJmcpHxgQQgKcx0Y3h/3oD1hPbyY+JagGjuCv2C/CMfmHXQ7eRuGz56JIYJik5U+PKbsR2//fYbCnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vl7MmbCE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vl7MmbCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B961F000FF;
	Wed, 23 Sep 2026 14:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172851;
	bh=bxEVtMy011GsuaHWwyAq5pLlSw5Gmdlsj8SYFIIN2ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vl7MmbCEZDUEAJtGrSe6TRIkcqUsvZH3CN6LCW/D6VDgCpdp5Eh9hWAWY/ctoSqo9
	 PVjsdlidH2DIk3ou+oxVFyISuWqo9tqBOhk7mTqCVII2r4vBLPYpx/yGINq74CIzFx
	 S6UEQbzzIsYnGeyz/WEnt9repioVb+UILlWtvuws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 077/438] wifi: cfg80211: restore netns_immutable on failures
Date: Wed, 23 Sep 2026 16:01:38 +0200
Message-ID: <20260923140646.781802280@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit eeee52cfd1d639774c9812e8890631404a057dd2 ]

Switching a wiphy's netns has to clear netns_immutable before moving
interfaces, but then if any of the interfaces fails to move, it gets
netns_immutable cleared forever. Then userspace can move it by itself,
breaking the assumption that they all move together.

Fix the order here and always reset netns_immutable after attempting
the move.

Assisted-by: LLM
Fixes: 463d018323851 ("cfg80211: make aware of net namespaces")
Link: https://patch.msgid.link/20260904170220.7ea88157dcbc.Id868585a790be8b9ece9b39b0db464a5963faaf3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 8bb2cbd66b488..6c0c97e57ebb2 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -167,9 +167,9 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			continue;
 		wdev->netdev->netns_immutable = false;
 		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
+		wdev->netdev->netns_immutable = true;
 		if (err)
 			break;
-		wdev->netdev->netns_immutable = true;
 	}
 
 	if (err) {
-- 
2.53.0



