Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5819178CE4;
	Mon, 12 Aug 2024 16:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479463; cv=none; b=uw9h06jifuH9X06hVweaTWPdmZvm9CFLQsyYmCVZulB/6I/ZsOg56FEVIkBNTjU2i3hcgU0Qy9xjY9Qkzknt54iNG/sEbzxt+LGa0LrplNj1PMI3R0PeroLlITRJmysqmfTOHThl2lOae+Xg7jsarcQmih2yN4QMSTTOE6RPm20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479463; c=relaxed/simple;
	bh=JOxD+qO6FcjAN38rn5jt2KMU0D7UKdf6fAlFR7VFlqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqZ4lxLyjmb90qkRn9DYhSjK/APHQhOAu0ClR6XyQZYz74fUbw2eZhUZE5xxlSsS6o56KBmNs9o9y+NqE7TswVIQbyZShR44Tk5PR2BOCQjWJI5fADi5tgoLXi/5C9bVsFPadW7OdaW06HeHgtfz0+4gv6qP/AZTyY8/oLLC7rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4No8pfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4No8pfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3221CC32782;
	Mon, 12 Aug 2024 16:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479463;
	bh=JOxD+qO6FcjAN38rn5jt2KMU0D7UKdf6fAlFR7VFlqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4No8pfgwr2MWz4Q57muNJ9sjtvN7hQH420x/4R2IQeEJnZ/W8txle65mZq9jKua1
	 3Kiqh0iTIQZdCeTNqYOcsUfozVZotLhaevMeSv5H/SBhR7WYr10c3Rk5fh8ygw4BSw
	 b3UGcdeudV6CtnyBazPG7+kNbLaeSCohnngXjbX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaxi Shen <shenxiaxi26@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+eaba5abe296837a640c0@syzkaller.appspotmail.com
Subject: [PATCH 6.6 064/189] ext4: fix uninitialized variable in ext4_inlinedir_to_tree
Date: Mon, 12 Aug 2024 18:02:00 +0200
Message-ID: <20240812160134.606517980@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

From: Xiaxi Shen <shenxiaxi26@gmail.com>

[ Upstream commit 8dc9c3da79c84b13fdb135e2fb0a149a8175bffe ]

Syzbot has found an uninit-value bug in ext4_inlinedir_to_tree

This error happens because ext4_inlinedir_to_tree does not
handle the case when ext4fs_dirhash returns an error

This can be avoided by checking the return value of ext4fs_dirhash
and propagating the error,
similar to how it's done with ext4_htree_store_dirent

Signed-off-by: Xiaxi Shen <shenxiaxi26@gmail.com>
Reported-and-tested-by: syzbot+eaba5abe296837a640c0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=eaba5abe296837a640c0
Link: https://patch.msgid.link/20240501033017.220000-1-shenxiaxi26@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inline.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 012d9259ff532..a604aa1d23aed 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1411,7 +1411,11 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
 			hinfo->hash = EXT4_DIRENT_HASH(de);
 			hinfo->minor_hash = EXT4_DIRENT_MINOR_HASH(de);
 		} else {
-			ext4fs_dirhash(dir, de->name, de->name_len, hinfo);
+			err = ext4fs_dirhash(dir, de->name, de->name_len, hinfo);
+			if (err) {
+				ret = err;
+				goto out;
+			}
 		}
 		if ((hinfo->hash < start_hash) ||
 		    ((hinfo->hash == start_hash) &&
-- 
2.43.0



