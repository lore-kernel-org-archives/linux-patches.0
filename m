Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B91629DB8F;
	Tue, 31 Mar 2026 16:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976181; cv=none; b=hQmMxwn2DxQdCKdsmKqCaFB9e0R0ffynlN8Ob3vnNCtjveb5adNapPKiNvzId96McpZ6g5oDMib33Ou0uI69eZ91J4+X/MDjsqPP7HqXd9vOzwbsznOPcA2xSKy7Hd9+25Wgwp3fLs5DguiKTRs43E6/B3OZGpaGvHkIIBrH6wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976181; c=relaxed/simple;
	bh=12eEWAp9BJ02WL8/ghRtxxJdoJbmhWYC8JugjO4ncHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4dKTiQ1uGV5+xqgxcY/HEVAYN/e85TO3IBaQq6Jv1kQiZRxPEtJ8Gm4Zpd2svJxVICcZNK6FIoi9V19eyyGycikxbp5HzrcE6kQBS23c984J3LbY0Kg4e2icOIuAsX+wiYzQJvJkHJohrU5d0co6F/AxsLSs/whlUWaVKsltfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0qOct40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0qOct40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3135AC19423;
	Tue, 31 Mar 2026 16:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976181;
	bh=12eEWAp9BJ02WL8/ghRtxxJdoJbmhWYC8JugjO4ncHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0qOct403S4xv21hIkBTsYDHwA1VOPCYXv2Vtz7V7Zm4HNdDaCqQ++lrS/0wA0QDA
	 FVxqP0UPjN1VY73kGR477mdKWuPdpatBm4mifpUCIdAalfYPII4SSj+/gHHysjoqDO
	 NLvP+8owSPJCxF5jUYUn0QwG8hGr9jYV+s5NfS0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 238/244] btrfs: fix lost error when running device stats on multiple devices fs
Date: Tue, 31 Mar 2026 18:23:08 +0200
Message-ID: <20260331161750.549981766@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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
index b723e860e4e9e..c53e7e5c9d426 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7738,8 +7738,9 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans)
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



