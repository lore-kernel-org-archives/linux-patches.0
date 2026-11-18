Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022492;
	b=iNBxGleBmv6x2b0I5SRVsd2iwIZ4xq3tBCoESGSZ7k3jOChjEsV872JtZzbmVaQ5JvBP
	 yx/ubBfHLzQInWowmbUDmmsPqQdK/2kc2im90llTE37uF3YMmtCGaFhRdd8oKVZtuyOTD
	 DPDosxNcHOl6x2FTHnyV6PvczbvbIWpEAgLo3SRBUIblItZ4prlBwXgnSovvyLs03Uhz7
	 Mz8wC2Qqzgm09GTYgZDS3qh6vmOab/+IGWvqDc6+39NiPfbkEIS0UD3fUaAUu4OrHZmuV
	 w6xk0V+j/Y8AYoa4CMmb1gUqn3SU+/wjx/a5Rk1BOaV0BdUHbsokZs1axGDZNnFcY0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022492;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ag1bvp2+ht5K8fSBVPGh2Gq4RoORLJrjgSLYH8cSblk=;
	b=BcL/bE1cAgiDp5mJuntJxbKR0oPhTKiN0pXHrkz4eIdWXrOyuNtclJq0dAwAa23PtBV9
	 Qgy8Fy7/ygN98sg/8WkUmu6jvpxDVCj1J7YhZt9AMM0iTq7IvQQygPaAFvlUulE+8xPqq
	 z4xjusUfJXgUlzSR4pl5ae5WHjim8rUobe2RWUo/b6c+ev8Ydj2S7etr6fwTOuvxbxA5Q
	 OeQSNaEbEFsWZMRlr7tPUhEdvFE++NOTP1fx0HMr6n9ZXgxW0VDkdNFwCdZmigY6bLa1Y
	 I9K8xZ7uiftzjVZquUM3KgB2PiewzZTksOjk5QNgQEZt0QJb0glZaOMwzFu0pFC28TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yNVd+BHp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49438606A333;
	Wed, 18 Nov 2026 17:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yNVd+BHp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949361F000C5;
	Wed, 18 Nov 2026 17:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022492;
	bh=ag1bvp2+ht5K8fSBVPGh2Gq4RoORLJrjgSLYH8cSblk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yNVd+BHpvlJ5zVOsi5RBTIuL2FrgIvwC2A6wJytSRERKYHLFGCQGa3taY32WP106T
	 bngv2nDjMmYrzrEKngIliCKKPrcBUPQqmbXWU8RMuojiV0fm95qfU9jOr3pvpqvRrJ
	 3MltfGJgXgzUKfictb+7NoVYo97IEFPQKF/S7i4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0032/2151] ovl: port ovl_dir_llseek() to cred guard
Date: Wed, 18 Nov 2026 15:29:27 +0100
Message-ID: <20261118150122.825602755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 5517646e14d18768ee72ae2f4320826f2169329a ]

Use the scoped ovl cred guard.

Link: https://patch.msgid.link/20251117-work-ovl-cred-guard-v4-26-b31603935724@kernel.org
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 323899b4ed23 ("ovl: inherit FMODE_NONOTIFY when opening directory realfiles")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/readdir.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 9ccbf78389f82..7fa4fecf15360 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -959,14 +959,8 @@ static loff_t ovl_dir_llseek(struct file *file, loff_t offset, int origin)
 static struct file *ovl_dir_open_realfile(const struct file *file,
 					  const struct path *realpath)
 {
-	struct file *res;
-	const struct cred *old_cred;
-
-	old_cred = ovl_override_creds(file_inode(file)->i_sb);
-	res = ovl_path_open(realpath, O_RDONLY | (file->f_flags & O_LARGEFILE));
-	ovl_revert_creds(old_cred);
-
-	return res;
+	with_ovl_creds(file_inode(file)->i_sb)
+		return ovl_path_open(realpath, O_RDONLY | (file->f_flags & O_LARGEFILE));
 }
 
 /*
-- 
2.53.0



