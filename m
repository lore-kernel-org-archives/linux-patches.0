Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F76B28387;
	Sun,  1 Sep 2024 16:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208201; cv=none; b=tkp85Qs9C72WerRhbP6wJ5MjCES6Cyz4sm4DGFetMkApcntM13HsK7c2lbAP/i8gmAaRhkFwcWpt8tq7HLt67/mAPb6TCyY3HgKokywv+WhgRm1cbmQnLvFdySAXeNRpFqgn5jMt//cyLo0mCxjfMtRHKES1jCriRRXyQaPEzLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208201; c=relaxed/simple;
	bh=boF8wD+mrZL9Kt/pZEyxjR6NefOpTlA5pNHXbro3jPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFbXLvz66Pighug5Eu5o7PzUHIov2wz32NMUjM3+idjWjGUdq6XzTJuOs4RBMzxfLdg6KSxxiXHXYT47Aj8As9SlMndF0OrlXVFZFTmZjDvXGjIhnD2cDF7dMBLT9o/KFV9da51gtcMa1WTqdWm4uZHtapVGT3ipM6qvuyWgeFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4bmncX9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4bmncX9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AA4C4CEC3;
	Sun,  1 Sep 2024 16:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208201;
	bh=boF8wD+mrZL9Kt/pZEyxjR6NefOpTlA5pNHXbro3jPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4bmncX99SAJM1E7BT9dz4eQ+ZNeUMmsAJ0VvM0TnMhrZbseNKPAlyxrWcDklap1H
	 y0ITPt/pMYlkQ2RjgSGCQnceBEDy3V2jC55leMd0FnvhDDzGLbTdAyQltXduhxs1AP
	 u/Q4Fue0L1FpGj8jttelHZZquU6WJUtut6hHWBiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.10 010/149] btrfs: run delayed iputs when flushing delalloc
Date: Sun,  1 Sep 2024 18:15:21 +0200
Message-ID: <20240901160817.855940133@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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
@@ -4100,6 +4100,8 @@ static int try_flush_qgroup(struct btrfs
 		return 0;
 	}
 
+	btrfs_run_delayed_iputs(root->fs_info);
+	btrfs_wait_on_delayed_iputs(root->fs_info);
 	ret = btrfs_start_delalloc_snapshot(root, true);
 	if (ret < 0)
 		goto out;


