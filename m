Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FE2E571;
	Mon, 14 Oct 2024 14:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915828; cv=none; b=GSJcMoBGJ2C0fi6ahEGDRK3SSIvrcdP33fN8Gxl/7mlU2c7SdeLwTbO6UjosBF/u+1oG1r+MEofpv7zDZ+Ndz/WO0+vN/LVzwIi58AEDwqmvCO0ApWSVrV57zS6XaiDUOLFFR8SZHBjuLSmDU4TquWdiLvbt+7NRAkjlQaGDBXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915828; c=relaxed/simple;
	bh=I7NLEYV0n01ilu5idESXd4W/KYQAXC0n8blzwWjRrZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFuO5MGbBgU3TOAFtcgb4iZkvYK/aW44akzFecdGHN/1tbOFhAP1w5beMeDdNG2s9mOyjg9ZlRzJBvtzSRPVCbRfxv1viDXa3FrAFg9J5TOXqORrKBOQAm4+odNsNalGNQVRJLaIOk5S+MDdPDi81HBDphX2c+jLOhbO5F+sW/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DudhOkPY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DudhOkPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60493C4CEC7;
	Mon, 14 Oct 2024 14:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915827;
	bh=I7NLEYV0n01ilu5idESXd4W/KYQAXC0n8blzwWjRrZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DudhOkPYHTNz+vX7CDjzswphr/auuEvNX+AfQKzS6RF2kMEH4eIw1F3RQae4JmHNm
	 O6qI1gO9WTFdey9FriO21wai/meR/GCN5io2f8UTCxweK4Y0w5ftpqyeASwFL/HXGY
	 LZcit+oR2un3McPK4UNMNWKhUdEL8j1nE0SRBZ78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7f71f79bbfb4427b00e1@syzkaller.appspotmail.com,
	Diogo Jahchan Koike <djahchankoike@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 011/214] ntfs3: Change to non-blocking allocation in ntfs_d_hash
Date: Mon, 14 Oct 2024 16:17:54 +0200
Message-ID: <20241014141045.433734362@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diogo Jahchan Koike <djahchankoike@gmail.com>

[ Upstream commit 589996bf8c459deb5bbc9747d8f1c51658608103 ]

d_hash is done while under "rcu-walk" and should not sleep.
__get_name() allocates using GFP_KERNEL, having the possibility
to sleep when under memory pressure. Change the allocation to
GFP_NOWAIT.

Reported-by: syzbot+7f71f79bbfb4427b00e1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7f71f79bbfb4427b00e1
Fixes: d392e85fd1e8 ("fs/ntfs3: Fix the format of the "nocase" mount option")
Signed-off-by: Diogo Jahchan Koike <djahchankoike@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/namei.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index f16d318c4372a..0a70c36585463 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -395,7 +395,7 @@ static int ntfs_d_hash(const struct dentry *dentry, struct qstr *name)
 	/*
 	 * Try slow way with current upcase table
 	 */
-	uni = __getname();
+	uni = kmem_cache_alloc(names_cachep, GFP_NOWAIT);
 	if (!uni)
 		return -ENOMEM;
 
@@ -417,7 +417,7 @@ static int ntfs_d_hash(const struct dentry *dentry, struct qstr *name)
 	err = 0;
 
 out:
-	__putname(uni);
+	kmem_cache_free(names_cachep, uni);
 	return err;
 }
 
-- 
2.43.0



