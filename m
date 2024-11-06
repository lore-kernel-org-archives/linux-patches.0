Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462FE18C00E;
	Wed,  6 Nov 2024 12:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896089; cv=none; b=eyDO8binek82/98i7VgGp//uOPlsXaiPRLEOXfLK+R2iRz0UzVw8Bl8OVhXnIHszGg4m/3sTkYXRtNe6HygZBC4ZhfDWyb80DLolcHD3hJTNth11MKv4SrdlEHfoaXQ0CKq4nQQVneG/SuVvyPrBTEHvWFWivc27mi6uasTR1RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896089; c=relaxed/simple;
	bh=C8Hok5jhkAY0jjo291On6PQcO3ynlskmg42dt2yC3MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRFuyIiwIjUXuW4rCUokVrn5Iq9aP6/DvkH0Cjikief9JwCSheGAt4o96u5LSScmwBHP3LTLYqrbtbHive9OXCuDJp+4Ep8GHdEbGTyWgichlBlh9pyz2OnDWlK6KGHYM2/zPj4QGhvyCrABA5+7f7cS6sY98l8yMi12yjg1P5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfcWg8Rw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfcWg8Rw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C337DC4CECD;
	Wed,  6 Nov 2024 12:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896089;
	bh=C8Hok5jhkAY0jjo291On6PQcO3ynlskmg42dt2yC3MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfcWg8Rw2pIj8pchmtmx7m0plWMSsdDnAHO9icdteT93xhHlWcH5dkahGb8eNrUvW
	 QT6nSvpFWcfgU9ZT9MEzPkhHg2VhQgd966KA4oG/nxYuPstKD4A72rwh3U1DKYnGib
	 Mw/EnqMmWLPEDUhoxHpB2+6a6MR18YTFwtg9a27k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bc7ca0ae4591cb2550f9@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 087/245] fs/ntfs3: Fix possible deadlock in mi_read
Date: Wed,  6 Nov 2024 13:02:20 +0100
Message-ID: <20241106120321.347487391@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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
index 0a70c36585463..02b745f117a51 100644
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



