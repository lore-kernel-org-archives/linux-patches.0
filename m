Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A0913B5B9;
	Thu, 11 Apr 2024 10:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830152; cv=none; b=qvJEGpNkj7tryp20zsna3vue6pep+4q3Cv0bZQSkKu+uvK25GKD7OuLamSAjlK+V2xoh8IDzJ5wRO9WCCHhNZGR2g4TQI+QYNYfxlHhwgFFSYlxzXmvveF3+Z224aBwLiA3KOMr550bZ8GH4tbewyaYsCki5dT4JL/E081s1E6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830152; c=relaxed/simple;
	bh=G6wcByXRod8gjQ8Hje1O1ToZH+zu/aBgPDz74+cT8nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8TVlXIn66o6HThQzhKKWjguvTvmWrvM49quPDPpUgTheJAzuxSFh0ZcNShy1pzzJL5xApa5fDY+XgqW373sy54u7eiKoLPW6iRdVjDzmcGTVoJdyJ8K/lhvRPcNylSdZ40y3rEoyTDO5sSTVrHbEAzj8LmjFkqyeGI88YS46WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tOlAPs1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tOlAPs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928F0C433F1;
	Thu, 11 Apr 2024 10:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830152;
	bh=G6wcByXRod8gjQ8Hje1O1ToZH+zu/aBgPDz74+cT8nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0tOlAPs1IPf/s9FK5rwcmtnk8NyNEH4e6UsuROP55uahGP6DiUx+v2wla7nKEFI7E
	 fgXkYjXKr1jLOHlW+3mZIYYT/u16M4qLAW4g0POnsdt+hDQVhYrVFGho9aPVoda7k1
	 PAwy3csEvrx+mqFxg1BNae7JbZ8EEqP+UhEkChlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 050/143] btrfs: send: handle path ref underflow in header iterate_inode_ref()
Date: Thu, 11 Apr 2024 11:55:18 +0200
Message-ID: <20240411095422.423240786@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index e9516509b2761..e8187669153dd 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1070,7 +1070,15 @@ static int iterate_inode_ref(struct btrfs_root *root, struct btrfs_path *path,
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



