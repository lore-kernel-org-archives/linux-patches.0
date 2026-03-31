Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBCC1413258;
	Tue, 31 Mar 2026 16:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975539; cv=none; b=tvqPbKAGNtI6mOayBFpIN5pAoxdNGIKzuOS1RSAPs/nPHjttVP65bgwaZxM7egVfvdBwMUlhPBSVHOeJxPvAtvWJXd7z6xkjcp1C7cbxZ2QBi0ImIVnFCwCeTEZN8RtrF4yICZGDHWC/iPHzatql0olAHZWhupKi5KA5aCfsXW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975539; c=relaxed/simple;
	bh=IPgXGiGJgd9n6ycu72gv2g/I8vaXMPPmHQp6ThCYy2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nv3YKsPsr/bIXDXCF1q97xkB+uitBVmQTC4uh5J/nng2rzgPEEsDtdyWQ5ukN8hE2UVkzc3MQkrzd6F7m0Yrc9vJyOHhPpBGpGche/cBOdQH1iDhWPI8HNHDjVsmn7No2D0L8EN1XvWxvNGva3Yib0Fwg9IloOnanZDKrMlXm3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CF0xxq7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CF0xxq7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C669C19424;
	Tue, 31 Mar 2026 16:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975539;
	bh=IPgXGiGJgd9n6ycu72gv2g/I8vaXMPPmHQp6ThCYy2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CF0xxq7qqNINTdLfY3+9NCkWr0DN9d9buAmLFHV8KtFDF6qkfKsFxSCXvUAe7cLaT
	 SP+nVbiRMn20w8QFP4JHAjs5mtnddqaSmojw2FX45lnuNaNgRJflzaU8udEXHVhMJW
	 OEVHV1DVpfvTMDzXUfM6XsKGP9u1RuTc6/TKPgBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 333/342] btrfs: fix lost error when running device stats on multiple devices fs
Date: Tue, 31 Mar 2026 18:22:46 +0200
Message-ID: <20260331161811.157900474@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index fbf23d20cce01..052b830a0b66e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7874,8 +7874,9 @@ int btrfs_run_dev_stats(struct btrfs_trans_handle *trans)
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



