Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BEB11720;
	Sat,  3 Feb 2024 04:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933946; cv=none; b=nbm4Tbb8JdzMOcQhM+XP4EMPg1Hj4fHGCMUAL81q+/EOxPNyFo7X0Xv+tb/Oy4ARCxi3nM6WFzWpVkblm7RYP/IvGxzlR63uwrEE2E2Vyh2a1SfCs4KUQIrnIuoXAALSABCSzNEryWx6O9kN2Rbqav16Rhk7bSXzfimtj/swbQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933946; c=relaxed/simple;
	bh=P04Lhglh09JisJAP1Cc/YKt/dowaJTvj5+nC0VeJuyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pn1euQaGgGYQNUKhrMliZT5rf6Pk47v6PZ9DCKYcWmeFTgZ8yTdiL5PiM8CMyhsORomEH0J3b9hUAc6Y+AtsYb+P3KVBAQTlbn7olJ0ZXIYMNkSbv3ZqfSUz9Mq1pQREaxFITtzCdFbbPlYRby+ve2Fa3Etb3Xku4kk8iz+Uh6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2zkWsPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2zkWsPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AC4C433F1;
	Sat,  3 Feb 2024 04:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933945;
	bh=P04Lhglh09JisJAP1Cc/YKt/dowaJTvj5+nC0VeJuyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2zkWsPqmoQYH2b4guxRbv4w3PJ+Dsb4DwNvbKANBQtIQc1+085gQck9qmRHhdauP
	 QN64T5LNNxhpm/3549zsUjVJ9VG+LKKaLJNS/22m53Fmy+cytxsMffKavvkN8D7thm
	 XRvcCO63aTFtye01IuJmgyyKixznPTDvSEBoB/a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+864a269c27ee06b58374@syzkaller.appspotmail.com
Subject: [PATCH 6.7 288/353] wifi: cfg80211: fix RCU dereference in __cfg80211_bss_update
Date: Fri,  2 Feb 2024 20:06:46 -0800
Message-ID: <20240203035412.896026208@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 1184950e341c11b6f82bc5b59564411d9537ab27 ]

Replace rcu_dereference() with rcu_access_pointer() since we hold
the lock here (and aren't in an RCU critical section).

Fixes: 32af9a9e1069 ("wifi: cfg80211: free beacon_ies when overridden from hidden BSS")
Reported-and-tested-by: syzbot+864a269c27ee06b58374@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Link: https://msgid.link/tencent_BF8F0DF0258C8DBF124CDDE4DD8D992DCF07@qq.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 082f0bd4ebdd..b9da6f5152cb 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1865,7 +1865,7 @@ __cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 					 &hidden->hidden_list);
 				hidden->refcount++;
 
-				ies = (void *)rcu_dereference(new->pub.beacon_ies);
+				ies = (void *)rcu_access_pointer(new->pub.beacon_ies);
 				rcu_assign_pointer(new->pub.beacon_ies,
 						   hidden->pub.beacon_ies);
 				if (ies)
-- 
2.43.0



