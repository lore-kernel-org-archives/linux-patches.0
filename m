Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2342D0C7E;
	Mon, 13 Apr 2026 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098097; cv=none; b=KhnSt49bamHm3bmKUGa11p/70QMleqPmOqucly6WlLHyvsCO0JJrimjmL6w4AKdmByHpYJhPfTPkChayXpxnov3o6DbZ3nThb0jIY1b44dc+r1oHo+TjForAjGAzLUpJ4GhD8vSasGs6F+gGI9u1Jm/sMW1XccLH0KuhfErkLtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098097; c=relaxed/simple;
	bh=UEjifrbcA+F5UtPi8cGIRuIHOzPC+D3G8vngpQUC4wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkbfpC8r2n9W38AeS+LaA0oU9AGH7tPiiUNMuOUSEumBN1VEgSAO6+72KG9oZ3dbUfO0FtTx7/PVHH4igRPa/IRX7wm8YlRcbaqOblQDcDbblNqo1j8GW3FY/4ickKcAJV412BSEDb+K80w+lROc38Iw4iDdiz8+0uVpEZzq7Hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKe+jU5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKe+jU5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79D4C2BCAF;
	Mon, 13 Apr 2026 16:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098097;
	bh=UEjifrbcA+F5UtPi8cGIRuIHOzPC+D3G8vngpQUC4wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BKe+jU5/BUIZmZ03dkvu8Mdlycv6SWEl3zqLewlKWxRluApElMOMVYATqI++qd7yC
	 5eNte67NU0PsZFiRkcnZ3IpnBx/OmaX96SX7owHwmYCIYsYUQvbOBLR4umpxznwHA0
	 Jfj8RWNAD7Lnu9UNAgOCoQDOjNRwq3ynIFT/AnEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 392/570] btrfs: fix lost error when running device stats on multiple devices fs
Date: Mon, 13 Apr 2026 17:58:43 +0200
Message-ID: <20260413155845.158112715@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 839ee01827b26..9ab226814cfde 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8016,8 +8016,9 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans)
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



