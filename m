Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB801DE3B5;
	Wed,  6 Nov 2024 12:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897459; cv=none; b=DnlQ139+3rDE0NiazRhkXKAkCMvPPzGYbFeEM7B+LvyKlp3ywl8pR8xhBh8tot5yWQuczG6qI7Dp0+R8ATRFHzgi5vJBldanPqhQFHc6R0FI0uNJHCIs9OwG6hNi6cJ6FAiqMfGPNM5wclSmsBZgbZLTsU2o3Xrn3rOgbOySmQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897459; c=relaxed/simple;
	bh=nVm8jv1l21/FwnqZqg8xKWDdyHnmiuBFIN1KO+PGkF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SptL+e0Wy6qB2Rc/Jgeq+dK+x7HkPYWp0mawQ5fFZisU9HjRsP6RyZbcUrELL/GvtxG0mrEtwRU1cd2S52cIpatvuymHh4pGLeNtoTK420B+qlGjDLjKt3mqooVYJVNS3B7kb9Aqzjq9Wv1d7bwI1pHgvfOtYSofxif1G8tNZLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDhsd42L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDhsd42L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5C6C4CECD;
	Wed,  6 Nov 2024 12:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897459;
	bh=nVm8jv1l21/FwnqZqg8xKWDdyHnmiuBFIN1KO+PGkF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDhsd42LbH4sfzc1QXOP9uZ7UINngVoytmGEKNIk+vjMgXimKF6C/t9dc7Vu3W+xz
	 pz9WiCAngLiNEtDFmpYC9fanD6uf26qBgmWh1lxmOI6mb3JUDV1czD67kF/9/fNAJY
	 ZJz8cFqhnWPLS1dvv4PHs8Ia6vq0RRiqajoxeilo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bc7ca0ae4591cb2550f9@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/151] fs/ntfs3: Fix possible deadlock in mi_read
Date: Wed,  6 Nov 2024 13:04:08 +0100
Message-ID: <20241106120310.491785861@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 03b097099eef255fbf85ea6a786ae3c91b11f041 ]

Mutex lock with another subclass used in ni_lock_dir().

Reported-by: syzbot+bc7ca0ae4591cb2550f9@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index bcdc1ec90a96a..61c4da8e6c3de 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -81,7 +81,7 @@ static struct dentry *ntfs_lookup(struct inode *dir, struct dentry *dentry,
 		if (err < 0)
 			inode = ERR_PTR(err);
 		else {
-			ni_lock(ni);
+			ni_lock_dir(ni);
 			inode = dir_search_u(dir, uni, NULL);
 			ni_unlock(ni);
 		}
-- 
2.43.0



