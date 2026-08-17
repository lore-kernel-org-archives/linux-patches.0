Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603BD3C8C65;
	Mon, 17 Aug 2026 13:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974648; cv=none; b=mLAAHPdBx5vm9wRC2K6n9fSfzdPSwBqsIMkASDAfO6BMU4GpHu8ZUj7XD93wqbLBscpWR0vmZUHIrSfxowVQKzJp9z57lqctd2cN+rcaql0+s5eCG4kAxvHejZ275GeKed5DFvVV+HeX5icB+l1YywFlNxLHUaTzPwoEuKe/wqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974648; c=relaxed/simple;
	bh=sDEIWgR/CW8RpvS2f/ZJIzJ6HL1SzF/aNppf4v+TuUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjzVfeuUHYVs86trUI9q0lYiOWO3hr3CX5piWpJ9WGKhwOpw79dUqFouHuGo82o0BIa/xUJ9YZlrbfB1wA7B7k80OdqOc27XHIBeOFOG6bVZNxBa6Ms1p6SQDvt0bI54CU6uqJi4vIWBKa0djP2TVZPnd4QuzK1Yj6i2wVgX6iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=le6/62o7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="le6/62o7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2811F000E9;
	Mon, 17 Aug 2026 13:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974646;
	bh=hShxhhMD6ldaisfAm/SLwScp9d6QREolg34N8MqRrB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=le6/62o7xuhqOF4RwAs8OgPDO89IKJjt9s2V4DnYYtA2/kPBAE1k3fOl2Y96SUDV6
	 iow8smnyRzlYaLTyw/fB5tbZxdWtokjIGE0RDkBn5+5Nxw8VeVQHdNzFTeMhm8w2L+
	 nBnl/8emRcw7Mylo5mwLydht/8FhmFHze0HUbPEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 7.1 256/271] fs,fsverity: remove check for fsverity being enabled in setattr_prepare()
Date: Mon, 17 Aug 2026 15:33:01 +0200
Message-ID: <20260817132547.276474415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/attr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/attr.c b/fs/attr.c
index 4f437fabb7f0..71888ac903c2 100644
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
2.55.0



