Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547CF1422CE;
	Thu, 11 Apr 2024 10:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831196; cv=none; b=s3cK5JY2wH5x0fXyd7huzxN401HmeyzJqzjCZ0SVehJ7QVvcgjY3uUxBTibeZTX7ll4qeG+6ki0rOmXC+Z+eOf1oZGBreG09/iOewt6AzGTtpP6tXH6rV8FLyzGu8rTPG8BaG6Rf/sE5+UOro+PMj9dQRpJvzyw113tYM/lwrCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831196; c=relaxed/simple;
	bh=4uqGYyLklEQXYwIdfzlfgeawtbxu9pMDuhSkELuuHGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptb4Fbs1R4E7iQYlQWpVIVE/FATAkBqB9y8xIdnGkBIRKckFmLO8y+x+sl23Fx8VFDsJbo0WA0dFbGLLfm9HXpaIxKMBBBNayVGhuel3LyF6ibRjZeimObpGFPzt355j2NuBc7Tk7diF/8cfhu/ZB+nhKoPsFSPU2/1rSk6rqP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpKPZMhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpKPZMhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47C8C433F1;
	Thu, 11 Apr 2024 10:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831196;
	bh=4uqGYyLklEQXYwIdfzlfgeawtbxu9pMDuhSkELuuHGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpKPZMhd8QIFfwJw96xcc0X+QlSSJGARk/1dcvolacpVDeITsX8yhmnQPNPE0XuYW
	 1eVrCpwvG1ptuuZAAd671OaiwHYqwbHSNZiVgKaglEYOxj1zu2rtzKIfhKBGFHwnFB
	 RJis32uwMrU2HUdH2WepkqFwAC35yoYWy/uJh6k4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/114] btrfs: send: handle path ref underflow in header iterate_inode_ref()
Date: Thu, 11 Apr 2024 11:56:07 +0200
Message-ID: <20240411095418.091641489@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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
index 6a1102954a0ab..b430e03260fbf 100644
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



