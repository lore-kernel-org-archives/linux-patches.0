Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37782C190;
	Sun,  1 Sep 2024 17:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210497; cv=none; b=tDLHB+fHdBYeD/xYGfKotZhXkElLsD4ePuYjreOmdwEJcQkbAH9lqjSjg3rjSPwfaAUDbolyjygJ7+yvuF67CyIardF+JPtGD5Q71utxPu/7jHTMCL6RG1wYFdWPj3JAKbpSo9VT1Nbmov8t2OzxhrL872YplKdqUqnxVczynvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210497; c=relaxed/simple;
	bh=1RWceZPmmH4UtqoPzAbzP6Q0Flk8hv+FpT9R4dDgfSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSA/iFmciG0hTtiR2v2ojVBSQsinYYhxu40QBxzJ6lUPFs6mf55VM+VS5s7Q0hX4sNRoUpb2RqkbvQLIG0SQzuIj4AnI6eBIMrSNMCepk+SVLcAlP/wo7uNVZ029XJx0b6CiHujsn3QMv26Kipw1yXT99+VVx2GNIAW8CWW2vXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VG96fJCT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VG96fJCT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395F7C4CEC3;
	Sun,  1 Sep 2024 17:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210497;
	bh=1RWceZPmmH4UtqoPzAbzP6Q0Flk8hv+FpT9R4dDgfSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VG96fJCT1Iqg/A6yUtvZvAvJwbouEMCqi7MnDXRi+p8nt3nEIFihjsxyC7pjYjv4Q
	 QOnZA2xNAUGz4z9WuyP9llL9n10LwrjvTav8iHwWihu0+toDyzH3raIptGzdD2HbZs
	 3j8zDtjolsVMjoD7Rguu0XQaIeBZPOo+f+yfMBD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 176/215] btrfs: run delayed iputs when flushing delalloc
Date: Sun,  1 Sep 2024 18:18:08 +0200
Message-ID: <20240901160830.013829791@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit 2d3447261031503b181dacc549fe65ffe2d93d65 upstream.

We have transient failures with btrfs/301, specifically in the part
where we do

  for i in $(seq 0 10); do
	  write 50m to file
	  rm -f file
  done

Sometimes this will result in a transient quota error, and it's because
sometimes we start writeback on the file which results in a delayed
iput, and thus the rm doesn't actually clean the file up.  When we're
flushing the quota space we need to run the delayed iputs to make sure
all the unlinks that we think have completed have actually completed.
This removes the small window where we could fail to find enough space
in our quota.

CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/qgroup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3677,6 +3677,8 @@ static int try_flush_qgroup(struct btrfs
 		return 0;
 	}
 
+	btrfs_run_delayed_iputs(root->fs_info);
+	btrfs_wait_on_delayed_iputs(root->fs_info);
 	ret = btrfs_start_delalloc_snapshot(root, true);
 	if (ret < 0)
 		goto out;


