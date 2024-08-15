Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD24A7DA7D;
	Thu, 15 Aug 2024 13:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730361; cv=none; b=V1+l1mtIBYhBQihLt32fMEIsYUZFbsR9NNFB3HEvhaU3v/hpW1/rMojvdysJZIFK5GNwchtvsW0My/zp72COskofneG10ePxvKUWvnl/LsQJU0JP6jSROTZR6rCi2+Vw3DWAH9wUfbtDbhIR5iUNrmqI16RmJa2kigqKfaEADMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730361; c=relaxed/simple;
	bh=pyTuzs/8WZmtwopkCixkrsuyk10ZM78evxe5k3WDQkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDL3aw7fd1qfcl0DNRNJDDdQppUeYrN6jUZI+dW0ioVa/VjPb8lgp3NLvZB/QBSuzOfFISFMrGKhy3SlViq6pGD5LA7McP5nHNBf8sMjUl6mpcqc8sXfQ4QUgnasvfpjtBNzHGY1illD3GTfTxU0w1oAye1PDMuJXR53T/tTcow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Za+2gpxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Za+2gpxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327F5C32786;
	Thu, 15 Aug 2024 13:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730361;
	bh=pyTuzs/8WZmtwopkCixkrsuyk10ZM78evxe5k3WDQkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Za+2gpxBV6Avi4V8/MwtutnTh7iv5oL9asGF0IDJn04yvzQBtpdVNbStY1N4y9MTe
	 VPulJSQKY5WfWDgTfisJDjLzypfsULowZU/1DKuXZid77G0E8G+78l9zLnZBMelzX2
	 Rop22GQz1Kb/XrUo82+aN5wGoWHWFi40sv6AF5OU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaxi Shen <shenxiaxi26@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+eaba5abe296837a640c0@syzkaller.appspotmail.com
Subject: [PATCH 5.15 384/484] ext4: fix uninitialized variable in ext4_inlinedir_to_tree
Date: Thu, 15 Aug 2024 15:24:02 +0200
Message-ID: <20240815131956.279422513@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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
index 6fe665de1b203..bc7f6417888dc 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1446,7 +1446,11 @@ int ext4_inlinedir_to_tree(struct file *dir_file,
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



