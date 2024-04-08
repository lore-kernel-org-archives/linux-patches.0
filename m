Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6BE2DF73;
	Mon,  8 Apr 2024 13:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581598; cv=none; b=DtM630TsdRbGUO9AebyNPIKiO+NCT2jdxj2NM+PWcCGoA4n42r5RZrgS/q+xZ0lsXKhyZpIfDGz50W0JovJ3bqwGvswKIw6XubUdZPeYurxwz2JuWiMQLwqx+i4C+owj3pLEqvo2lFb2tqMLhaVO+b77IfrJktFu8FbJzH3pjro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581598; c=relaxed/simple;
	bh=X+PK2csvYoKKQGh53Ut0Hp1DE9NdPToPzUp8ueFvkrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpDWAIBdr9MH5xODf4eHWjwSIr5U9TgN+GE7ry52T/NO0XXyOayB3jH3T2+mJFoSnCKFwLMuaH43oi2UgDN6xI72M2oMT4nhUt4OzRiGo5FvTQihG/uEoaH4ofxvN/qywBPd9MNnNBy0aqJ/JyWHxp0YGiW4ecVM2+EzR2WePWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mOySOvlV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mOySOvlV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407F7C433C7;
	Mon,  8 Apr 2024 13:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581597;
	bh=X+PK2csvYoKKQGh53Ut0Hp1DE9NdPToPzUp8ueFvkrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mOySOvlVowd+g8kOUGmUlm05q1fP6yIH9VcXfUq/i4WXH7Ryzpd4vfaICTXJWbhs4
	 +hSoghbF5SzjvYd2C5d5EaCwQhfRvAyeaTJ51UHIEOHoAH0XBEHbdkiDyVqlk0ECHb
	 YEKCU/i/cUseqqYttnfAjsNOqx+BaC/ZD7ACYPsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/690] dm-raid: fix lockdep waring in "pers->hot_add_disk"
Date: Mon,  8 Apr 2024 14:48:52 +0200
Message-ID: <20240408125401.915058726@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 95009ae904b1e9dca8db6f649f2d7c18a6e42c75 ]

The lockdep assert is added by commit a448af25becf ("md/raid10: remove
rcu protection to access rdev from conf") in print_conf(). And I didn't
notice that dm-raid is calling "pers->hot_add_disk" without holding
'reconfig_mutex'.

"pers->hot_add_disk" read and write many fields that is protected by
'reconfig_mutex', and raid_resume() already grab the lock in other
contex. Hence fix this problem by protecting "pers->host_add_disk"
with the lock.

Fixes: 9092c02d9435 ("DM RAID: Add ability to restore transiently failed devices on resume")
Fixes: a448af25becf ("md/raid10: remove rcu protection to access rdev from conf")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240305072306.2562024-10-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 04769fb20cf7f..5d1006142aaed 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4049,7 +4049,9 @@ static void raid_resume(struct dm_target *ti)
 		 * Take this opportunity to check whether any failed
 		 * devices are reachable again.
 		 */
+		mddev_lock_nointr(mddev);
 		attempt_restore_of_faulty_devices(rs);
+		mddev_unlock(mddev);
 	}
 
 	if (test_and_clear_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
-- 
2.43.0



