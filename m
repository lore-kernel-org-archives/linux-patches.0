Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059958;
	b=lS4Ee4xRyUb2UNO6YKuHvtdfs0vWO6JjGaKLe5hX5vF2RBg5HdFmS5MCFhCPWZciQXTB
	 0EaIFKiKVvEJeGjrgb7UOCDZNwa2m05xucK+R+8JAAknI7U637JCJFZEiD8XO0zTyPOC/
	 zxp3SPPvPR+L3yLVg1SHST5HjBlqCTuFMPKXAiGWJxgk08ehBTKymG+mFHdg3h4KQiqPa
	 +7ULjZKWTVZN8V6EYE7tfCdCit3HbQYY8JLol8equhSeuKowkX5vkSQ8I3UYaetrOIL8A
	 PecpuVoonqSJZT2J9hmY4jgJF/6++JVViDyjNyxBnOoJr++DrGheszIpxQBGTckzEug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3eU57pFtWNJMSiff/Qre6ZV/pl/fAYcM0Ac7+5rxgUM=;
	b=WZjxCdNoG4EJQtl9XR0zDbVDWWSFrFyWrkwJPgIEhuOLAC9HIqbWvY2UIzf699kwnro3
	 9myjolLDe6hqTpAygt8AplTFUc/gcC334LdiDSco5jZyBj24aR/1tj0P73uyuZzaFFU9D
	 g/VdXZp9zgNGQN5qk9dONOaegJ0nKgPKXL3nhP6TXz74AjLITGdjXzRmOjQoNblZsXubT
	 bCP/bzOF+D8nysMwYGtQGABbc8vbjL7o8m02Ab9eKmoTI6IcN7BKnljjDznsTP+q5fc4l
	 w3Yl1tu9ox3NhDPxI+GztHUIXj5rkZETs517S35hvF5SiWi7sFKj5eqp8Y4Jz5kPZ4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yBuKipyF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15957606A33F;
	Thu, 19 Nov 2026 03:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yBuKipyF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362701F000C4;
	Thu, 19 Nov 2026 03:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059957;
	bh=3eU57pFtWNJMSiff/Qre6ZV/pl/fAYcM0Ac7+5rxgUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yBuKipyFTVXI77s+2nCbomhPr8yM3EDQiIS9sTN+VAUlzrcHBGnFtTsKJlhfPpwv4
	 NviaM9sVPque7259GWFOiF9GKY7YZidIfE2XapiT4ZiWGmI0QLT2DWdFgqfdW9iEBW
	 A8KjXaUZ8jAcOKHj+GaerYJ4HmPAkMPGf+avS/W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1028/1848] /proc/sys: use d_splice_alias() calling conventions to simplify failure exits
Date: Wed, 18 Nov 2026 15:51:06 +0100
Message-ID: <20261118150000.376559463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 1eae9a47835ed4703055afbb3c52fef6d07a8a4c ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: eeecea75ece2 ("proc: don't let an entry below /proc/<pid>/net be a mountpoint")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/proc_sysctl.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 78bd606314281..b7e3d36737cfe 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -524,13 +524,8 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 			goto out;
 	}
 
-	inode = proc_sys_make_inode(dir->i_sb, h ? h : head, p);
-	if (IS_ERR(inode)) {
-		err = ERR_CAST(inode);
-		goto out;
-	}
-
 	d_set_d_op(dentry, &proc_sys_dentry_operations);
+	inode = proc_sys_make_inode(dir->i_sb, h ? h : head, p);
 	err = d_splice_alias(inode, dentry);
 
 out:
@@ -688,13 +683,8 @@ static bool proc_sys_fill_cache(struct file *file,
 			return false;
 		if (d_in_lookup(child)) {
 			struct dentry *res;
-			inode = proc_sys_make_inode(dir->d_sb, head, table);
-			if (IS_ERR(inode)) {
-				d_lookup_done(child);
-				dput(child);
-				return false;
-			}
 			d_set_d_op(child, &proc_sys_dentry_operations);
+			inode = proc_sys_make_inode(dir->d_sb, head, table);
 			res = d_splice_alias(inode, child);
 			d_lookup_done(child);
 			if (unlikely(res)) {
-- 
2.53.0



