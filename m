Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63132347503;
	Wed,  8 Apr 2026 18:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671946; cv=none; b=OPXMW1ADK12Z3YeXrCEWsLDgP0g/8NyxG5ftnbWChREmL067zoWqWU52cs+IE2jA1+L442VQvo81ggXnaX+OvZ8bLeOJimjtUZho7k9MLulFBOfFUUYTnWKbowv2XsTVlbss6syBEDwzrFOu5ZX++KGLwCL95rAAFAvN2hvR8hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671946; c=relaxed/simple;
	bh=79lFCDsLAwfIoZOyFaBmXIizf+4lnaD6bBlEcMq7Ivo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcpGTN7vUlyC4GJQ+OvNlcy9wRCSlDrVLPAoP+pRedZRfOH8Sl5qQ7FeZbURO8kSpJvZ1z2h75kLqOX2pez9jKZO4aSwlgDvb+H9YwmOdhtUyCaV7/0m/X9RUT88zF55SyxDTFtFcY/ovKVOc1v+/Z/Wcbo1kShN9tH/8B59JK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDqu0aHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDqu0aHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFA2C19421;
	Wed,  8 Apr 2026 18:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671946;
	bh=79lFCDsLAwfIoZOyFaBmXIizf+4lnaD6bBlEcMq7Ivo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDqu0aHRzqtH+OqjGQZtHPjTqULWYVh4xxLrWs9ARZ8dS9Sn7GWI5XabGehjrOujj
	 YVsnTaYe80/j7vuxxnn+d92uvtNvbra73yYLv5uAsc8sRQ8oYXOAyJWaQ1bbxSyJZn
	 hyS4aTsUCG+jbEPOQb1Rd/l1OQhWYtiSfyoIzwqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/312] btrfs: fix lost error when running device stats on multiple devices fs
Date: Wed,  8 Apr 2026 20:00:47 +0200
Message-ID: <20260408175938.627540699@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d06709ced0f36..9f5d5f5c53131 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8089,8 +8089,9 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans)
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



