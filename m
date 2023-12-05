Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A056FB1;
	Tue,  5 Dec 2023 03:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zt0FcHTr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6947C433C8;
	Tue,  5 Dec 2023 03:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701748068;
	bh=oGpGf5yOE4Y3kjtu6NiPDZow1fLspy0Ro0LmohovN2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zt0FcHTr7k//9zFXMJqS77+Zg4hmNmtR9WMU51ifEC5YYp+SPZtEV1qT8xRLJSvob
	 hbxYos+5QGP2FfDW1nt+OIr4xEJewCsOYxwkd4Ne3YX/p2WsXOvpk8Sj+TjB8/j4WE
	 tYXAKubLGLF/P17DOYpkU+1K2lFbcs/lyiQql7J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 66/94] btrfs: make error messages more clear when getting a chunk map
Date: Tue,  5 Dec 2023 12:17:34 +0900
Message-ID: <20231205031526.544098687@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 7d410d5efe04e42a6cd959bfe6d59d559fdf8b25 upstream.

When getting a chunk map, at btrfs_get_chunk_map(), we do some sanity
checks to verify we found a chunk map and that map found covers the
logical address the caller passed in. However the messages aren't very
clear in the sense that don't mention the issue is with a chunk map and
one of them prints the 'length' argument as if it were the end offset of
the requested range (while the in the string format we use %llu-%llu
which suggests a range, and the second %llu-%llu is actually a range for
the chunk map). So improve these two details in the error messages.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/volumes.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3090,15 +3090,16 @@ struct extent_map *btrfs_get_chunk_map(s
 	read_unlock(&em_tree->lock);
 
 	if (!em) {
-		btrfs_crit(fs_info, "unable to find logical %llu length %llu",
+		btrfs_crit(fs_info,
+			   "unable to find chunk map for logical %llu length %llu",
 			   logical, length);
 		return ERR_PTR(-EINVAL);
 	}
 
 	if (em->start > logical || em->start + em->len <= logical) {
 		btrfs_crit(fs_info,
-			   "found a bad mapping, wanted %llu-%llu, found %llu-%llu",
-			   logical, length, em->start, em->start + em->len);
+			   "found a bad chunk map, wanted %llu-%llu, found %llu-%llu",
+			   logical, logical + length, em->start, em->start + em->len);
 		free_extent_map(em);
 		return ERR_PTR(-EINVAL);
 	}


