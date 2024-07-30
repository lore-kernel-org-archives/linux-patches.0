Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728E883A17;
	Tue, 30 Jul 2024 17:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359315; cv=none; b=atSEUEbUS+q/24SN0KRfNAAaMq+xjUKUuXRfOJWNMHcqNvBXtPOM08bJBVKmLBReXnMPTyVBJH9iqMpW6/XZ1c3Zp3rc9JJ93KAmJavjf4CNfMF+erT+NL3t6sov8iGIC7SVB10I6iO8AanitPuAiZwQZHUyIcj1o/el1pOhBKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359315; c=relaxed/simple;
	bh=o/5nrUtKEsG7fgjqOn6hf2btpX9z3vXa0Ui1fFG3LtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFLfblDkSzXEYXyO1M3+CMBI+WDSjaaA4f9LnpbBiO4ZFzSemXraXvB1VBsz0JzTRaargspbqmd1ZSWNuQWpfpQxvBIwW0lnBzZAm57Mr9I/LZy7WW0JmdzSWRJ0Z1VtqlZ6mEtiVox50OabEtfssaTzrA9v/n3INjaPqiTBS5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWZND7/G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWZND7/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B99C32782;
	Tue, 30 Jul 2024 17:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359315;
	bh=o/5nrUtKEsG7fgjqOn6hf2btpX9z3vXa0Ui1fFG3LtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWZND7/GMYk2MUQHKb6VW3z716x0CgNU1ezJqrppFHcwiDKXQq3Xcn8oGs5zbz8aF
	 8f+F7fAOifMuvN1X2x+ZGTKmHoK1fIJKCAq5/J+vtKKH0l0tXYuGKLuTcao2MJwT3/
	 G3Va7HYUA7ObRbTn1arA2AlEOBPOMi1qUCqoa+A4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 437/809] dm-raid: Fix WARN_ON_ONCE check for sync_thread in raid_resume
Date: Tue, 30 Jul 2024 17:45:13 +0200
Message-ID: <20240730151741.963550782@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 3199a34bfaf7561410e0be1e33a61eba870768fc ]

rm-raid devices will occasionally trigger the following warning when
being resumed after a table load because DM_RECOVERY_RUNNING is set:

WARNING: CPU: 7 PID: 5660 at drivers/md/dm-raid.c:4105 raid_resume+0xee/0x100 [dm_raid]

The failing check is:
WARN_ON_ONCE(test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));

This check is designed to make sure that the sync thread isn't
registered, but md_check_recovery can set MD_RECOVERY_RUNNING without
the sync_thread ever getting registered. Instead of checking if
MD_RECOVERY_RUNNING is set, check if sync_thread is non-NULL.

Fixes: 16c4770c75b1 ("dm-raid: really frozen sync_thread during suspend")
Suggested-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-raid.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index abe88d1e67358..b149ac46a990e 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4101,10 +4101,11 @@ static void raid_resume(struct dm_target *ti)
 		if (mddev->delta_disks < 0)
 			rs_set_capacity(rs);
 
+		mddev_lock_nointr(mddev);
 		WARN_ON_ONCE(!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery));
-		WARN_ON_ONCE(test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));
+		WARN_ON_ONCE(rcu_dereference_protected(mddev->sync_thread,
+						       lockdep_is_held(&mddev->reconfig_mutex)));
 		clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
-		mddev_lock_nointr(mddev);
 		mddev->ro = 0;
 		mddev->in_sync = 0;
 		md_unfrozen_sync_thread(mddev);
-- 
2.43.0



