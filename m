Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EA327A900;
	Tue, 27 May 2025 16:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364737; cv=none; b=BpUGG2FFTRKRASAwDASG1PUkAfzxDAeD5J+8u+ymsW7O1HpfkPePK+GvQwa12518A6Jolg+UXWkWs//xr6ZzZj2UCQMYOXxcLHoytmzOvl1W5BAt8PwgbwsjHX26RahjzrM8n2b6UNHmU12lczUentdjrWXlcoTO8+XwbrqdOFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364737; c=relaxed/simple;
	bh=NFNTsMW/N+FjGo9xtAvv3bkB4xf7nMx9G16P45z8PrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lomGpHF58jwWfU/olnTEVncX9dxBneEzA/XK267WB5bGGQNgTUgxKZ6nPvAnn6tf+A9q7Mnn65mb1CSf5kFrYTawiK8FrT2hc3I9HztaIKne6qgmUXgx250d9UfoKPsu3Pry34+w6++0Ag0UTF7Mb5bLtPKU9wciFDg7B/TGLLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qOQhDtcp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qOQhDtcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EADC4CEEB;
	Tue, 27 May 2025 16:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364737;
	bh=NFNTsMW/N+FjGo9xtAvv3bkB4xf7nMx9G16P45z8PrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qOQhDtcp2MIaJ3TmGK+INPrZ9NyfFphZa8t1y4cG1wTIiA/JR2auFqF7tbz578t8J
	 kfulv3QgmzcS+B0YtuUsQ8At4yNM6ygI0e71aGNkIPhga6TqxXK/Nw0vMwAw/4etCv
	 C7ZfOrpwiApI3pXfnb+cHnzLsOnYUdGTT8X4f3bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/626] btrfs: send: return -ENAMETOOLONG when attempting a path that is too long
Date: Tue, 27 May 2025 18:20:12 +0200
Message-ID: <20250527162449.868442114@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit a77749b3e21813566cea050bbb3414ae74562eba ]

When attempting to build a too long path we are currently returning
-ENOMEM, which is very odd and misleading. So update fs_path_ensure_buf()
to return -ENAMETOOLONG instead. Also, while at it, move the WARN_ON()
into the if statement's expression, as it makes it clear what is being
tested and also has the effect of adding 'unlikely' to the statement,
which allows the compiler to generate better code as this condition is
never expected to happen.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/send.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index b1015f383f75e..c843b4aefb8ac 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -487,10 +487,8 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
 	if (p->buf_len >= len)
 		return 0;
 
-	if (len > PATH_MAX) {
-		WARN_ON(1);
-		return -ENOMEM;
-	}
+	if (WARN_ON(len > PATH_MAX))
+		return -ENAMETOOLONG;
 
 	path_len = p->end - p->start;
 	old_buf_len = p->buf_len;
-- 
2.39.5



