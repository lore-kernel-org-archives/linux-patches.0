Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694E3325705;
	Tue, 31 Mar 2026 17:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976986; cv=none; b=uPSGN3Tq3NpLS+3HC3O8YOaKItwFocWvSJ6ANhswjE5UGxIpPuL/kfzOrBgZrzeVdbb0GNhzirjZqhV5OBDk1zCsBNP0syG+NvUih2PLIDUf6ZeRYsYeNYPVCrHRi05OXeP9gJKz+IerZ9WjJcv3zS1cmckGVVGNxhrP020JWpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976986; c=relaxed/simple;
	bh=uAAht5baR/iZ+ONUY7h2DwyEZSVCOiOTAIdn78RMn1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7WDiHoZQNsLmP5/hV/g7wDDS4xrq9AmW665eHzN1PlRUp+pLTYbZ/bujx1JL20s9Mrl8K+pID8wWly0141mFO5nNj5ew7hz+f9d9tjJJjKDTk0aOG2b3ztol5WYuxbZLeomyq2oX7n82zG5MjuLWmkh4626XMAp44TUYtyoJss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtIcZ0WF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtIcZ0WF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85A2C19423;
	Tue, 31 Mar 2026 17:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976986;
	bh=uAAht5baR/iZ+ONUY7h2DwyEZSVCOiOTAIdn78RMn1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtIcZ0WFMaKGwEVjN+NtfP723X6HBRQNsubIaaZFdNjVCbN9tSWt8nGj4ItG7HcPN
	 rcZmsxqgMtfvkXwIYUCXQR9iqWDZcQEXlJKQtjb7tYi9gVrT4Iap/yY4oQFldmHNt1
	 iXNF2fWWBh12jeT7UyPBSW4GRs3vbIpmNldV+1rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 303/309] btrfs: fix lost error when running device stats on multiple devices fs
Date: Tue, 31 Mar 2026 18:23:26 +0200
Message-ID: <20260331161804.718191906@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 1c37d896b12dfd0d4c96e310b0033c6676933917 ]

Whenever we get an error updating the device stats item for a device in
btrfs_run_dev_stats() we allow the loop to go to the next device, and if
updating the stats item for the next device succeeds, we end up losing
the error we had from the previous device.

Fix this by breaking out of the loop once we get an error and make sure
it's returned to the caller. Since we are in the transaction commit path
(and in the critical section actually), returning the error will result
in a transaction abort.

Fixes: 733f4fbbc108 ("Btrfs: read device stats on mount, write modified ones during commit")
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 3fe3a6c7da4e9..ef9f24076ccae 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7929,8 +7929,9 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans)
 		smp_rmb();
 
 		ret = update_dev_stat_item(trans, device);
-		if (!ret)
-			atomic_sub(stats_cnt, &device->dev_stats_ccnt);
+		if (ret)
+			break;
+		atomic_sub(stats_cnt, &device->dev_stats_ccnt);
 	}
 	mutex_unlock(&fs_devices->device_list_mutex);
 
-- 
2.53.0



