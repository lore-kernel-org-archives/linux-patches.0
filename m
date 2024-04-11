Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09471E48E;
	Thu, 11 Apr 2024 10:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832638; cv=none; b=Yz0RmTNJg7tqLo/gk9fGoBbK0B6BM2vYfr90fQAkCz+VEf3L/ARQPKvXHr8Jc06ZABMpdZ6XvClIQeJBcsQaArn1p/nNqFylueom+rdQUzxbF6LKGXDYd7mZKsOVDmmytV7gUeaSziGJ2xwij7X6k/KEvTH1tpX0l14TyPGltRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832638; c=relaxed/simple;
	bh=2J1Xqe9R+ILT4xPMaYs9T8w3yp+1uDJC3Pm/3lPg1mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKZzql1Z6Bk1R/iz17d2S3jjzVbYXr5BdjXuj5KGh5eEFsaLNVTUCvjE6Ks1c2HWAExbwTwIMZUN2hoq17NNwjrcOBTlk9qv5eCd23lSOQcmLronSJ5g4hUCNqECD03uCJZBADQUseTanC7wPStcBghE+6IMIObJ/X8qV698vLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvhX/PQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvhX/PQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFAAC433C7;
	Thu, 11 Apr 2024 10:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832638;
	bh=2J1Xqe9R+ILT4xPMaYs9T8w3yp+1uDJC3Pm/3lPg1mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvhX/PQIddKmBUtF89yCRnYcrOGbAEbh5i/zrXg8AUqcngu+4BwArTm/E+tcAxz78
	 K+3mGMRhmMnn8dXc41jdYqX9XWWj0kxeymc1zzV5r2D48lzGZn42y8MlW4T0i8SmzF
	 HLXTop+1Sscge4MgmycIvNqcgkSZrTL+xg1hna7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 15/57] btrfs: handle chunk tree lookup error in btrfs_relocate_sys_chunks()
Date: Thu, 11 Apr 2024 11:57:23 +0200
Message-ID: <20240411095408.456091492@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 7411055db5ce64f836aaffd422396af0075fdc99 ]

The unhandled case in btrfs_relocate_sys_chunks() loop is a corruption,
as it could be caused only by two impossible conditions:

- at first the search key is set up to look for a chunk tree item, with
  offset -1, this is an inexact search and the key->offset will contain
  the correct offset upon a successful search, a valid chunk tree item
  cannot have an offset -1

- after first successful search, the found_key corresponds to a chunk
  item, the offset is decremented by 1 before the next loop, it's
  impossible to find a chunk item there due to alignment and size
  constraints

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/volumes.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 1ce0fa487e5b2..36e77956c63fa 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3358,7 +3358,17 @@ static int btrfs_relocate_sys_chunks(struct btrfs_fs_info *fs_info)
 			mutex_unlock(&fs_info->reclaim_bgs_lock);
 			goto error;
 		}
-		BUG_ON(ret == 0); /* Corruption */
+		if (ret == 0) {
+			/*
+			 * On the first search we would find chunk tree with
+			 * offset -1, which is not possible. On subsequent
+			 * loops this would find an existing item on an invalid
+			 * offset (one less than the previous one, wrong
+			 * alignment and size).
+			 */
+			ret = -EUCLEAN;
+			goto error;
+		}
 
 		ret = btrfs_previous_item(chunk_root, path, key.objectid,
 					  key.type);
-- 
2.43.0



