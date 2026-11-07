Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062559;
	b=ICqZ/Xpq93HE2g5a7v+H66LuXvuqkB8ZqESSbWycUJT4Acq7HCc0plvP9+kG1nEhHCe5
	 5sI8zCLYsVrLSUPa4bvVPFH60YDewE3y3ufXW5Cr9wThwalhUGmisVeP9BREpASatemc+
	 bawIggTiLGZIOdWfC5TG62LgC5cqAJ3fC2xgKKfUhLPL/bE7rRqeUWD6WmRLvtJVFzOUJ
	 oBwbxFJxgzx2ZM911pyOtsxLlmuQswKcDlk8E3RAAlKBxsBKBKc/Z22r1XWaQJmG8Q6PI
	 rkNCleEqhCqq834ds1iqbK5zUgTVtljSqHJ7WmQqvtWufFJKsGPLGyFe2q1ehDHPl0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mWI5BJnqp0q7fcTRupXz+RivCT7G7gkOhkAzc/eGrnI=;
	b=I+Hg6Cuvm2Xrz14SNeWrdnPEjLsC2m5wf0vaF8TfmSIu3Z28dpn+gBglJyVllOsRUJFt
	 K23nA+a+ygi4oMcfXCrbWcr+P9hJZS4melfR/pfrgXcvYA9blFmQ/wMqxwlN0H1FU8lvf
	 +vSesBYrCAaY7jwNEKZCIeKA6haWMYPk4iWpEMoqZmMvAsIJ3G8lyPmbgxzAndkSCFgIc
	 eHLKzx7lDu7ySlawasegpcForY1p5qdzy/HgIVm/7ZacNLa9XlQbspfxY0SD2o+uGEwN7
	 8Wyv3/YPetwuZJ1E67N5DOdWQmjHFsRP9L1U1fY7F/6oQZbNNVPlZzKX7XJhbK0fyKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fh+3M8um;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94D2606A64A;
	Sat,  7 Nov 2026 14:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fh+3M8um
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768081F008A5;
	Sat,  7 Nov 2026 14:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062558;
	bh=mWI5BJnqp0q7fcTRupXz+RivCT7G7gkOhkAzc/eGrnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fh+3M8um3vu7d8k4fSLPlpY6H6dmCa38Imh5rbAO0m+85N483mANfMG987Muji6lh
	 wQE4zy3umyWxbe9+OuuWJ+BFwO3paFZws+sB1GpH/PRfVzQ3Q3Jald3gxNxvklllqq
	 GvjyShUPPW7SVAoGBmbYBGQrvv0Kem+xF4Wa5PJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1405/1536] writeback: clear old wb dirty state after inode switches
Date: Sat,  7 Nov 2026 08:57:01 -0500
Message-ID: <20261107135037.287414893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sun <sunjunchao@bytedance.com>

[ Upstream commit a396fe9f74ea367ae3fab2dcb70b24e83db9f0cb ]

Switching an inode to another wb updates the target wb's dirty-I/O state,
but no longer checks whether the source wb's dirty-I/O lists became empty.
The check was lost when inode_io_list_del_locked(inode, old_wb) was
removed to support tracking clean attached inodes.

If the last dirty inode is moved, WB_has_dirty_io remains set on the old
wb and its bandwidth contribution remains in bdi->tot_write_bandwidth.
This can keep an empty wb scheduled for periodic writeback and overstate
the total bandwidth used to distribute writeback work.

Call wb_io_lists_depopulated() on the old wb after the batch of inode
switches, while its list_lock is still held. This clears the flag and
removes the bandwidth contribution if its dirty-I/O lists are empty.

Fixes: f3b6a6df38aa ("writeback, cgroup: keep list of inodes attached to bdi_writeback")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Link: https://patch.msgid.link/20261016115230.3640770-3-sunjunchao@bytedance.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 925fc4a42c67d..435f14b7e2cca 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -535,6 +535,7 @@ static void process_inode_switch_wbs(struct bdi_writeback *new_wb,
 		}
 	}
 
+	wb_io_lists_depopulated(old_wb);
 	spin_unlock(&new_wb->list_lock);
 	spin_unlock(&old_wb->list_lock);
 
-- 
2.53.0



