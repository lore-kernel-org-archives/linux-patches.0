Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B622C6AF;
	Sun,  1 Sep 2024 16:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207957; cv=none; b=EqXY8hxGVvKvQ+AGSL/ZPusfTFuaLGnENNgEl1Rp9e6cyvdvewmdiyNYpP1xygmFZKQIfljvjM7m8TF1REag6+SZ0k4gt6FropRIKfAZdTdk4qC6jMxX7BhFIJD5W9ov+2rE3pFBX+1TAaLhs5rbN57OUaNiVFaMJ3rJgYmpxck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207957; c=relaxed/simple;
	bh=XGzH7ojEsv3zq3moN4wKgw/MOuJtovVoe9Yzarb4Z60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iah5Y00RH8MK5wO04NXIkueiMX/a3N4SFmGPdEyx6xLlhgD/GR9ETyHOckbaYuqWaYmNWtoNqCOBAKTom0M8CzbZcAZfcS1Z5gq7JyQuyBPXSTaXCkXYMLfWbPG+v/k4FBSfASE9FKQeWBZ7wI6GUoi78RGaptOVhwfPG58PZ0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcCRfXzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcCRfXzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04B6C4CEC3;
	Sun,  1 Sep 2024 16:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207957;
	bh=XGzH7ojEsv3zq3moN4wKgw/MOuJtovVoe9Yzarb4Z60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcCRfXzUu/LDhGFIjlDqLWD1ID4HfjMT7qoS8zdTtoxKqC78yRjw69L3Uua8HdmsM
	 Ma293cL9gJ7O4kOgKlkqaqwQE1KN/GwcHz16hQ68rsSljyGDJY7qVw0llCXXV4iSS1
	 SCyDTe2sVNqwvvC/8mSCarxbTTQIvQmNrGQIpiUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 04/93] btrfs: run delayed iputs when flushing delalloc
Date: Sun,  1 Sep 2024 18:15:51 +0200
Message-ID: <20240901160807.519426622@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3762,6 +3762,8 @@ static int try_flush_qgroup(struct btrfs
 		return 0;
 	}
 
+	btrfs_run_delayed_iputs(root->fs_info);
+	btrfs_wait_on_delayed_iputs(root->fs_info);
 	ret = btrfs_start_delalloc_snapshot(root, true);
 	if (ret < 0)
 		goto out;


