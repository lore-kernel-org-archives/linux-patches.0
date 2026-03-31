Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6192EE262;
	Tue, 31 Mar 2026 16:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974662; cv=none; b=BZHNWp02KU4PiRpDlaEuAgFGm9m/2ewV4adkXaPiKhkEAznAlJorjYQiFBFPEMJZuAFVwC1TlvAsjHLJiHVaHPDhw2UJh7qV/U+ja0ofa1Mvg8Nq6wFgBa8IkPNhPWAqeGBZKogAjUfDND30dkBWFE0FBe44nRhAwYGqlrDDcEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974662; c=relaxed/simple;
	bh=Gb/wc2QVodlRqeQpDWDY6geFskVz+eqb4edX05Xikgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXJ+DGIbBg9kamHnsGph4Scfvg1b/Va5GdforhLV22S5CXfsw+ZwoHYX6ZPv914UDQTf6zIjhRpuMZiy0duafMhaS0ek9oK8ag5mkoledInIg4sZNaKc0/blBl/ZJ/eFEtZkMyMjzspJ4IhucE5wFII6lv0zwuWkGSo+0J97sec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+GqgPHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+GqgPHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B829DC19423;
	Tue, 31 Mar 2026 16:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974662;
	bh=Gb/wc2QVodlRqeQpDWDY6geFskVz+eqb4edX05Xikgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+GqgPHDgunxz2gWg4mNd2mW/Nr2OXWLgrLYNd3Nt2ISYXuLa6xZ2sjfuq9t7M0wY
	 hkvFGn08KJSJwVyDFTjOFHguTHgCRTvz/zalUtuVnlgm68M36k9ncXBf5SxV074Obf
	 xCWYQHaX9Mh0spyXofqOcSdgg/zlf69y9e8Xv1JA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/175] btrfs: fix lost error when running device stats on multiple devices fs
Date: Tue, 31 Mar 2026 18:22:35 +0200
Message-ID: <20260331161736.076871405@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 23756f1464013..f5e4b8f3dcb7f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7641,8 +7641,9 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans)
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



