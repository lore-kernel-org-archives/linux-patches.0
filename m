Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F35145B13;
	Thu, 11 Apr 2024 10:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832177; cv=none; b=NTeY9fqiz0jb8yzXg9UmYVO8KqNnsjnCinngYhghl/gVY7qOyQb5/+nM42Gj63ByI/mheLg7sbvrrrD+HAN839eJNgXZjGbku/FQynxnFNynScSsSlNCmpjg9Faq/TPbuGbtheCSiDWDPdpKgK9Dydd29NIJTJVszGRrtN0kea0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832177; c=relaxed/simple;
	bh=Q9n2GJrQuqzYvJOdiXmk9gPAEfwScV/epO5Nb2QPrFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwhXf2bs8dRzNbQGzMLYM/ZaaZiddcuEC8Oeo7ofrKY45XY9z7xaiKOPHu5SP8FeOJazHrf+9drtuSB7W150rkqY2ZgtOYUai6gkvT+kgGZPJ/Yx9a/DqHAh6ldYsCFwMvF79L+puC1wfzwf7P5aRCBniE/t7TmIowKArHf47a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtKdMlnp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtKdMlnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CAFC433F1;
	Thu, 11 Apr 2024 10:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832177;
	bh=Q9n2GJrQuqzYvJOdiXmk9gPAEfwScV/epO5Nb2QPrFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtKdMlnpEvEI6bj8fe8Jzrr+Bchp8QtQhh1c65g61bJtMSgsBU6nao7f1DpaRtchA
	 e7Nh4cUBWlKOupK3lRLKD/R65INpngaSsigHvljwFN2eipu+if4QYEQodanu/yriXK
	 hrsuuRs51JG6Yl4op9lGCeN3JUv6WbJREspzBRIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 255/294] btrfs: send: handle path ref underflow in header iterate_inode_ref()
Date: Thu, 11 Apr 2024 11:56:58 +0200
Message-ID: <20240411095443.241491571@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0b04adfd4a4a4..0519a3557697a 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -966,7 +966,15 @@ static int iterate_inode_ref(struct btrfs_root *root, struct btrfs_path *path,
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



