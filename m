Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6809E18593B;
	Sun,  1 Sep 2024 16:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209154; cv=none; b=JlFk/+1gc05clj0SWhlNPTvwrwK99d+VZ5KE9sAIKWzPHdJdGvoYMA3uCCiEe+Z8okPbrS7TdBWh3xUx0SvtgGG2EddIRsx/NrpM2q/62B2dlz6NzDKbYCCuUaKnDg/DdFGB+dcdkpz30FRKWXMfnwrL+yO2Ge9+cdxq+vc4dwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209154; c=relaxed/simple;
	bh=LlRh3IOqcOHntNATvqQDMioHE5mjMCDMQUACnEw8yAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVQMhmKjfKr2Y8yUf1pU0DZqPOxrKnV5V081U8k2PYBb+fctciZzsfpKD7QlVeGVPTaNKPixZOwTQgfUhF7wSPnNXifCPTa5eczj5Z3FnmWA3rPIuNbhGL/suQ4tjzw+VApAatdZRLUF6s00f9pwe/pl2AQBVMV1V5N8ZhJIDeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KnTm4Cs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KnTm4Cs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C64C4CEC3;
	Sun,  1 Sep 2024 16:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209154;
	bh=LlRh3IOqcOHntNATvqQDMioHE5mjMCDMQUACnEw8yAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KnTm4Cs/zj14zC6c18j+C64Pxi60fdPLnCleIjMsba+ThTTL70lxjOIb3boLfTOWu
	 uso1yZqzz+aDYa8VBUDQBV4PrXVLp5tYq/m+3wSwzypQSWVeeNYWRRn45YJ7Nv5Idg
	 7+XFO2hzIv0sVjpwI7xPn8719W+jOatTHWqStDKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 03/71] btrfs: run delayed iputs when flushing delalloc
Date: Sun,  1 Sep 2024 18:17:08 +0200
Message-ID: <20240901160802.012777840@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3745,6 +3745,8 @@ static int try_flush_qgroup(struct btrfs
 		return 0;
 	}
 
+	btrfs_run_delayed_iputs(root->fs_info);
+	btrfs_wait_on_delayed_iputs(root->fs_info);
 	ret = btrfs_start_delalloc_snapshot(root, true);
 	if (ret < 0)
 		goto out;


