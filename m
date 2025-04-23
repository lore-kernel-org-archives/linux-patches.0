Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7928828EA70;
	Wed, 23 Apr 2025 15:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420845; cv=none; b=uDrbO9yxUn7LB/oKMvkBPcGrZ3z0ZQ7t0eS9BsQ/DbjI0LTyUZQM2pqjAHr6hvid21MGdtduzD567gLpIZzFHRMHJNQlHysHt1J0pc7tYSpjFSZ/p1BWNm1PCr+3hudUGxWqX9gIYz2KkUMhszAUaTojiFeUp9CC8bDDC4+CzCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420845; c=relaxed/simple;
	bh=cSXmgXUZX9El/81XCNjTvmS1yjMrS2sgtBSSt81maYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6DWEnl8KbH787AbMlhBktI1rrpEUyVTCa6MyxTL0OBjNcH1vaBHimR+FyfTsNnKZ1KORsnilbkzT5WMPEZgks3+quJvIp8FAFLXE4vEh9+zqERMqWzUu5K0ecuK3+S8ZTuXRuxlcPj898oS5QiT/O2yoqzLbkvWdLrsKi1E3jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWY+V/pO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWY+V/pO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C75C4CEE3;
	Wed, 23 Apr 2025 15:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420845;
	bh=cSXmgXUZX9El/81XCNjTvmS1yjMrS2sgtBSSt81maYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWY+V/pObM5tgm1P4r4f6IwF4UnmaZE4+bvuWLzlj5UbIlxVH9YmqcsvBBGCjRG8T
	 bcwiNvDwCd9Sy6D41uLqzPQoS6xjyzUCzD6xi4j+7JOz2o/hcJ0L2+NzGEAMMRG6zA
	 YKF38Qv3quqR4839ICpIcTWWA6pvfvrqzI1VD0u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sidong Yang <sidong.yang@furiosa.ai>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.14 127/241] btrfs: ioctl: dont free iov when btrfs_encoded_read() returns -EAGAIN
Date: Wed, 23 Apr 2025 16:43:11 +0200
Message-ID: <20250423142625.757186658@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sidong Yang <sidong.yang@furiosa.ai>

commit 8e587ab43cb92a9e57f99ea8d6c069ee65863707 upstream.

Fix a bug in encoded read that mistakenly frees the iov in case
btrfs_encoded_read() returns -EAGAIN assuming the structure will be
reused.  This can happen when when receiving requests concurrently, the
io_uring subsystem does not reset the data, and the last free will
happen in btrfs_uring_read_finished().

Handle the -EAGAIN error and skip freeing iov.

CC: stable@vger.kernel.org # 6.13+
Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4903,6 +4903,8 @@ static int btrfs_uring_encoded_read(stru
 
 	ret = btrfs_encoded_read(&kiocb, &data->iter, &data->args, &cached_state,
 				 &disk_bytenr, &disk_io_size);
+	if (ret == -EAGAIN)
+		goto out_acct;
 	if (ret < 0 && ret != -EIOCBQUEUED)
 		goto out_free;
 


