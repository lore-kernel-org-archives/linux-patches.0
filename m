Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8564E50BB;
	Tue, 13 Oct 2026 12:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895553; cv=none; b=WowpeRRoCRhZSGQEF8Twd4gr/pC5GBg1Q6pBvH+uCjGNPFTWGoECnmdDDXz2rx+KhOk35BkzG/LukqYJK1wMXz9x31f6k2ckq7+I23C1Lzx0BBOqad5I9qBZMJngbRlldHbgRyZCXhntkJymt/4pvwjE9ZFPf+XUMOV4zX6cKgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895553; c=relaxed/simple;
	bh=q+ObUSY5SJ4mUd0fz2/TVQcHZ11qmdF8zMK2ILP6za0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hX/GG3ZxH7TUXiCR3SEn/E4rKB28ag0fUm4HzczQI8SRRCDAf4MLooEmrp5be3spCyFQanMsniFaTOCoflG163g4usY3m0G5ujwBZcVpZ9yI2ZQTxe8UmS4YpCN4qoZaUAr4ID+2dH/ZGTKk1O34C6mb5fYjDvV2U7PEhjTBUus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qez3lldl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qez3lldl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F5E1F000FF;
	Tue, 13 Oct 2026 12:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895552;
	bh=JfUq+5MhNzaqp80jXbMS+KZR7UDz4bHG05/fjJiHSXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qez3lldllqKzL+ZkWE15VHCsPtjCgjPzaJlHhtSAAROoL4Kh7bCatIIHbUu5rVAY8
	 oWQceauB9a6oAdgMkH3qO5gOvpVCULuKIeLIDtjcUdot3vP1QrjWUxf1q2rxfSBPvL
	 J/OKOf7LfOXGfX6LUya4z4Z4RmqwCzX/La2J0aVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 276/497] fs,fsverity: remove check for fsverity being enabled in setattr_prepare()
Date: Tue, 13 Oct 2026 13:37:23 +0200
Message-ID: <20261013112914.443374279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Albershteyn <aalbersh@kernel.org>

commit d2f96bcb89d36d488a10e3bcf819b98536968286 upstream.

The check that fs-verity is available in the kernel is not necessary
here. Filesystems could have fsverity files even without fs-verity
enabled. In that case, truncate on fsverity file will succeed, what this
check is trying to prevent.

Fixes: e9734653c523 ("fs,fsverity: reject size changes on fsverity files in setattr_prepare")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20260727094352.1734826-1-aalbersh@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/attr.c b/fs/attr.c
index 714f159d58ea3..927cb18d25d52 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -176,7 +176,7 @@ int setattr_prepare(struct mnt_idmap *idmap, struct dentry *dentry,
 		 * covered by the open-time check because sys_truncate() takes a
 		 * path, not an open file.
 		 */
-		if (IS_ENABLED(CONFIG_FS_VERITY) && IS_VERITY(inode))
+		if (IS_VERITY(inode))
 			return -EPERM;
 
 		error = inode_newsize_ok(inode, attr->ia_size);
-- 
2.53.0



