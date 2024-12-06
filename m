Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F413149E0E;
	Fri,  6 Dec 2024 14:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733495973; cv=none; b=V/jgKSQHkWynszlxyzX1GvYABQP5HLjkBjEcgjXCU2ITkhl3IFBaPjl+U9QYD2OaPMrey9fYuba0RF2SrEtV5gin3+j7q9LN63Y+vZYEBTuuzXQz02zqUCnhczeKJEPVmm6rl+4r3AeUsmwQL18r6EbPVyRxOaHH/KoOCU6qe30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733495973; c=relaxed/simple;
	bh=qlpfdFnw/wsQAK+6fmacj9BsUc5NPoHa19Bh7fdX3+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1Xg9m+9slBq0KIKuP2Y8+2j0CQGTUHSzuFI6gQm6+Ve9vnx0J/MVBGIuU1eyIpygaaROqGPZmCf++tmjaSmKZM/v/obevAyVphobY2ggYIc8eije2KrDioseKnpaO8ggoRo6rOzhT6GJ7mkAD3rqxriPIETFgR+p748OXv2emg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bw40mNbL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bw40mNbL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3E4C4CED1;
	Fri,  6 Dec 2024 14:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733495972;
	bh=qlpfdFnw/wsQAK+6fmacj9BsUc5NPoHa19Bh7fdX3+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bw40mNbLOVxm2pvse5SPk3dIEs2QfJH7CnVgJiXwfzpy65hv2HT2wnP3/KSsXtl8s
	 gT5h/j8z+TXN+t4Bt45DpEnlu5gx4UAp3oOy/Iue9azBtpGE6ufdGOUWnKbIWnhIhP
	 QJJs8hNToU1RVzaU0KiSxk36tkzOpfyVHIv75Tq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/146] btrfs: dont loop for nowait writes when checking for cross references
Date: Fri,  6 Dec 2024 15:35:38 +0100
Message-ID: <20241206143527.947674822@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit ed67f2a913a4f0fc505db29805c41dd07d3cb356 ]

When checking for delayed refs when verifying if there are cross
references for a data extent, we stop if the path has nowait set and we
can't try lock the delayed ref head's mutex, returning -EAGAIN with the
goal of making a write fallback to a blocking context. However we ignore
the -EAGAIN at btrfs_cross_ref_exist() when check_delayed_ref() returns
it, and keep looping instead of immediately returning the -EAGAIN to the
caller.

Fix this by not looping if we get -EAGAIN and we have a nowait path.

Fixes: 26ce91144631 ("btrfs: make can_nocow_extent nowait compatible")
CC: stable@vger.kernel.org # 6.1+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d9f511babd89a..b43a8611aca5c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2446,7 +2446,7 @@ int btrfs_cross_ref_exist(struct btrfs_root *root, u64 objectid, u64 offset,
 			goto out;
 
 		ret = check_delayed_ref(root, path, objectid, offset, bytenr);
-	} while (ret == -EAGAIN);
+	} while (ret == -EAGAIN && !path->nowait);
 
 out:
 	btrfs_release_path(path);
-- 
2.43.0



