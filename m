Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B163C6612;
	Tue, 17 Mar 2026 16:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766551; cv=none; b=sBF9f6i/ON7Y6wUGLQ+C3TfUB454V7ulOkfL+6XwSe9cJgmARBeiQMp03UPsk+HNezj3wKjtWUGLMX4sK86jL/k8xETCLmGW4PHGZLAGdGvFS7j5PHK5zz9I+i90uKRMITiy4LaReN8JlPs18uFqCqhISmtzRkWF89/AqWrDr78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766551; c=relaxed/simple;
	bh=zLenQE/jhP5GTGsOxY3f6/pH9lMzf9f/gpGyfX+eSp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5VjNSW733Tbw0te0Fbe42UqSZbN+GUYr+rvBnPPWOHkdUomQvLOTizZBqDmA1q/IXA48u5x8hPhXvUSudOtwqXvB0j4o+Dj8DE7uF11wbzLtKlhf2Ob9u3ZQHgbuGsgL+NnzkrNNW75/2C42iiZGC67k1Pwerip9IZ//HFNZSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSTI5D94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSTI5D94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9E3C4CEF7;
	Tue, 17 Mar 2026 16:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766551;
	bh=zLenQE/jhP5GTGsOxY3f6/pH9lMzf9f/gpGyfX+eSp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSTI5D94x3oe7HUlFNJm1XB6sjuaP2Kn6WelETsTn9ahb2onUhXu8KkI3yM7TIobK
	 7sjvHQXGcH72u/EKme0wKodJu6CVrEJitF3hz1OTRGDDNIB0kj4+Q82iqOFm9LAGDE
	 /3bSQBa0J0y7QkB6WQcON/6GW2o+TqbkSoXXi99U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.19 238/378] btrfs: fix chunk map leak in btrfs_map_block() after btrfs_chunk_map_num_copies()
Date: Tue, 17 Mar 2026 17:33:15 +0100
Message-ID: <20260317163015.770084613@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

From: Mark Harmstone <mark@harmstone.com>

commit f15fb3d41543244d1179f423da4a4832a55bc050 upstream.

Fix a chunk map leak in btrfs_map_block(): if we return early with -EINVAL,
we're not freeing the chunk map that we've just looked up.

Fixes: 0ae653fbec2b ("btrfs: reduce chunk_map lookups in btrfs_map_block()")
CC: stable@vger.kernel.org # 6.12+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6707,8 +6707,10 @@ int btrfs_map_block(struct btrfs_fs_info
 		return PTR_ERR(map);
 
 	num_copies = btrfs_chunk_map_num_copies(map);
-	if (io_geom.mirror_num > num_copies)
-		return -EINVAL;
+	if (io_geom.mirror_num > num_copies) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	map_offset = logical - map->start;
 	io_geom.raid56_full_stripe_start = (u64)-1;


