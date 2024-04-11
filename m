Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBDA145B07;
	Thu, 11 Apr 2024 10:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829926; cv=none; b=Ki6K4Ij83htrNXOOQDjsq9N68MY569yKCY91lR639jooWNMxy8sH0QU9629xM5VdWGhL8Xg4QBWA21jVvrPgY2L0jEIipESKJwJqXZbxGK18b+sHhfIMt04Y8jNAezduz2YYKpYHRIo+NzR8YLHKyztx2CkVFJSjheUNUTyUy6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829926; c=relaxed/simple;
	bh=+rVmsbpJDU0CnrY7Y3beTawKrti5N3WS6M6RKOLkhDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1inRkp3Exnt22f1ruswcau2GZ1wkLg0Z50gS3ELVcL7CVTpZZ73DFTPkfb+VK4hbF3psmmtM8dVG5ehEEKzT5WroWAJIy6XzFFGf4IXH2WYM+pwPh8SfRn3V4AuuahNMkHvZqKNHDbJnIX8LHZKwXJxCMVmwjWMTVaU7RJPt4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lYQcB/3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lYQcB/3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0715CC433C7;
	Thu, 11 Apr 2024 10:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829926;
	bh=+rVmsbpJDU0CnrY7Y3beTawKrti5N3WS6M6RKOLkhDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYQcB/3zyQPIB0wKdrJ7r1yHrFQhoC0g9yU9qt9lHaBA0ocspV205ZugapVBSSW5I
	 aIP9P71tageDo263+UwpcoImPlNJKlGQ/5R7sTUqrEqKJ1jbezxOdDreb8t292Qrh/
	 nscSPA4xZMoK1KYEW+MYS9Hry3gkquIOEkKtyRnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 151/175] btrfs: send: handle path ref underflow in header iterate_inode_ref()
Date: Thu, 11 Apr 2024 11:56:14 +0200
Message-ID: <20240411095424.108535355@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 0c86409a316e8..e3b6ca9176afe 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -958,7 +958,15 @@ static int iterate_inode_ref(struct btrfs_root *root, struct btrfs_path *path,
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



