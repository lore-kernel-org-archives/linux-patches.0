Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8723513FD94;
	Thu, 11 Apr 2024 10:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830983; cv=none; b=keDhtc2a56oxq8T480IweOAokgzRS/MhbILCrnrcjN/ysIiAq5LkToM23k1Ys/yPEMoIM21nw9JUvvJoh2CV36Jy6OIrOaczLpEHh448lKEqJ2y1+iII+0I5gxYAxDgpIf1SccZNds+IMWMbhbKkNZVmSe3TAnGwnvqU0zfIs3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830983; c=relaxed/simple;
	bh=4B/w1SNOFkGkjELrct9wWDpnAjbx3R74KwqQOYh+Os0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmMbtLgGva2EFm0tUoPjUFN9VQOT2ic/YM4JopeOQ1E/M9v6YKEWVKCjUORNZ9ieR3MJ9pAS76NW5fYpoRxCTl2X6bWVDzncv3wnUc9oMriDCBiUJr4o2aahRJjXJreNKLH7zdP7cuZQwQi1QVZJuKTwSOXWVkcqm1+t9H50VVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLqYwcEj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLqYwcEj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5507C433C7;
	Thu, 11 Apr 2024 10:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830983;
	bh=4B/w1SNOFkGkjELrct9wWDpnAjbx3R74KwqQOYh+Os0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLqYwcEjnqK8l/YqrB8yXZa98FeLHEMRU/lyDpepbIEeGPkCWPiB3qVQ/y/9v70AY
	 dund1VX8scfFDViBe04n3BTE596+bbHBarF2sqUfiHtieDQBV0HlBnDMfv8h2Mn94M
	 V3VWXKsq2cXezy928zUTdEkhity5xTJYR82W4ab0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/215] btrfs: send: handle path ref underflow in header iterate_inode_ref()
Date: Thu, 11 Apr 2024 11:56:32 +0200
Message-ID: <20240411095430.368345239@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 3c6ee34c6f9cd12802326da26631232a61743501 ]

Change BUG_ON to proper error handling if building the path buffer
fails. The pointers are not printed so we don't accidentally leak kernel
addresses.

Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 0dfa88ac01393..576c027909f8a 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -973,7 +973,15 @@ static int iterate_inode_ref(struct btrfs_root *root, struct btrfs_path *path,
 					ret = PTR_ERR(start);
 					goto out;
 				}
-				BUG_ON(start < p->buf);
+				if (unlikely(start < p->buf)) {
+					btrfs_err(root->fs_info,
+			"send: path ref buffer underflow for key (%llu %u %llu)",
+						  found_key->objectid,
+						  found_key->type,
+						  found_key->offset);
+					ret = -EINVAL;
+					goto out;
+				}
 			}
 			p->start = start;
 		} else {
-- 
2.43.0



