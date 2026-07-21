Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8CC3C2790;
	Tue, 21 Jul 2026 16:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649739; cv=none; b=SVTfF1Q4snWHA1b7WIpu6tLoTeTuoa+nOuzDu/oiVoJ0D1e/3pGXG6zKTsmxeZJ4n/dr4Nz7agvGqOtvlfRnI0Tsu2kruCD72wAeGEHflvJNOlOOMo29ELHjgSE6ZcYTSf+JLnBfg8VJ4Yz9tiJ06HO9DwuWZCCViD1VJrwf2n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649739; c=relaxed/simple;
	bh=2CRjLTW9WRTPVFMNL7APOM7qHYik86YokxO7WmiWVR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+Qr3HOOX1FiFJVMI1aDNaX6bvABykoG0gzbKC7w9HUVeesNxZ7kBQcaTgl7cSd35/eWLHd4pQ8tm14IWLIograL3WMhCmAW8Fi5UqTzyIc/O7arScKsDsaK+QBNqRFw7pBT3DEl6bWbi5N/UGvvkwNvr3/HGisnDD89SdTRrjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qM2zk3tB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qM2zk3tB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD701F000E9;
	Tue, 21 Jul 2026 16:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649738;
	bh=kiN1bJe2BvclPWVGtmM41BDmUkbTI0IZ7CEYKrG/UGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qM2zk3tBZfEOHCuIt3m3n+36aR7uxP6fdqkuASL+F/o8ucBBakaWi9V4jV0dB9Tfo
	 0ZBO3TBDMbbf4oan2ZLcFcJhs7z5vNSz1lGdGZXWMOTyetjfAXPUu3zY2VpfKLdkZm
	 XZy0yUh2Gnru+OO6xwGLyTfUp7L4yuDnf4FjeXTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0646/2077] ext4: fix ERR_PTR(0) in ext4_mkdir()
Date: Tue, 21 Jul 2026 17:05:19 +0200
Message-ID: <20260721152608.041960854@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 8e1c43af7cf5091d99db38b7c8129e394d7f45b5 ]

When mkdir succeeds, ext4_mkdir() returns ERR_PTR(0) which is incorrect.
It should return NULL instead for success and ERR_PTR() only with
negative error codes for failure.

Fixes: 88d5baf69082 ("Change inode_operations.mkdir to return struct dentry *")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Link: https://patch.msgid.link/20260604073647.211279-1-zenghongling@kylinos.cn
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 4a47fbd8dd30ce..8cadaeb15b2bd2 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3054,7 +3054,7 @@ static struct dentry *ext4_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 out_retry:
 	if (err == -ENOSPC && ext4_should_retry_alloc(dir->i_sb, &retries))
 		goto retry;
-	return ERR_PTR(err);
+	return err ? ERR_PTR(err) : NULL;
 }
 
 /*
-- 
2.53.0



