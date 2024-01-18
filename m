Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866A72375A;
	Thu, 18 Jan 2024 10:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575580; cv=none; b=nrBIud5H7mgtjtjKuP8Y7lUdfFWjMxBGYVFatJLpBfHViKxoC/CiurBEseywlM7Pm934SkNMaSdXeUio0JXKJldoYEX7TN6Ezn377+1vwbVFKbNpjptkqPV0y09PQ4zZWbTJNBe2kAp2eDtt2rECdX0BJ3jWp9G0iAS+b+o3/5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575580; c=relaxed/simple;
	bh=xFgvBljBDWV3pTu2+gUpyJ6e/WQGHlGuTyPOJ879JrI=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=gcuCZK7/p8bs57g9HWKTKX6Hk+oYiJVc86U6dqABXm3q5/fsWq+bhlJ21pYEo8c3+x+osyrFaxxo8b894p7EoJnNp8dq8JrhdzrM2yAwYJoD/8aQui1/JEIVM1NjUDtiSxtixMhrg/mnB/MfSZPkgIwsR2O1dcadZv1uXaDQ80Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nweo2lAm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nweo2lAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09968C433C7;
	Thu, 18 Jan 2024 10:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575580;
	bh=xFgvBljBDWV3pTu2+gUpyJ6e/WQGHlGuTyPOJ879JrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nweo2lAmVY4osf0bdzjVZnHiQmFcKja9XskEd1GpLXig1kz/e6icmbF/m9wGz1LmM
	 Eq1ZEVmZ4RCwCjayEsZZHt9ddZ0jeMC9s0Hs5mmXNv8+qs19RUnltn+c8PIfMLi4ty
	 fD8kGJP+xrwq6mRlP+SyCOkwzqURPFHdb5ZSFJX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7e59a5bfc7a897247e18@syzkaller.appspotmail.com,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/100] wifi: cfg80211: lock wiphy mutex for rfkill poll
Date: Thu, 18 Jan 2024 11:48:13 +0100
Message-ID: <20240118104311.105766830@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8e2f6f2366219b3304b227bdd2f04b64c92e3e12 ]

We want to guarantee the mutex is held for pretty much
all operations, so ensure that here as well.

Reported-by: syzbot+7e59a5bfc7a897247e18@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 63d75fecc2c5..8809e668ed91 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -216,7 +216,9 @@ static void cfg80211_rfkill_poll(struct rfkill *rfkill, void *data)
 {
 	struct cfg80211_registered_device *rdev = data;
 
+	wiphy_lock(&rdev->wiphy);
 	rdev_rfkill_poll(rdev);
+	wiphy_unlock(&rdev->wiphy);
 }
 
 void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
-- 
2.43.0



