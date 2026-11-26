Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705200;
	b=GV8P5DtdrYDijruW75UvB5RA0nuG0kuYRUcKl/9lYf4H7+hC98alxcsVqyLSNC3juI/a
	 VW2g1jXZaTzzbD3dCHHMuKpkFS4jRAIPtmauLJBUxNfnGVz7HgRlKpCvr9dqvRbPBDUf4
	 2xah3GvAM8Kv9Uzd9gooVmwjwzldXn8LBqqIcc2EadC3cS/oA9MG+uSIBYaoozyeP2gOz
	 oDTYzR2C/K2p5LKDdDSqHPaPWU7lfx5ObYKCF/xCzzYg/5hhlVarSCQHebvYPJp+STd3L
	 dj7V4X9BLXoe+7m/kl/G/6qSKuidziuXOVeRArL/T/KmVAIPgxDDv2YIY1iORIcYVWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Xd1lHigQFuqj1brKoV9bKV5BzmLnBrxTw/pprTOzg8=;
	b=qbfN0XTj6YAjzx2uXS1d8EnO2LAb8S8Z3fduyA8c4SGjlbd9QSWIBXGCxQeAdsoAiluH
	 wDZOt/xu7W5HUApegeO5wuSaSh6/lBe/E/f+hmVzoy7I4ANeGYWKiy3OwjlmBalvWS6Ko
	 PqOttrETUy36fMlw8xgAk5XjP0a06w837Mdt1Q83vm5QUOQbg1W2R+WcXqbYTL1PE/E0Y
	 zWIOfc5goGiuzuos+4yElSXHhy/3zW7DUhEk+Iflx/ZIR5ZNnR7bQ2gts2R4QYdVGvUKH
	 YRbXUhpwc+en0zzJQAGjskKqokDCrlIW+3hLo/d8WPOzuk+DdaHS/qyYKyvDn9Kr5Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uBwskKGk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AC1606A31C;
	Thu, 26 Nov 2026 15:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uBwskKGk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2111F000C6;
	Thu, 26 Nov 2026 14:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705200;
	bh=+Xd1lHigQFuqj1brKoV9bKV5BzmLnBrxTw/pprTOzg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uBwskKGka0nOAC8xSMbSFSpPk+i2mN6+jSX/sTDpPqEKgkRREeoBIEEwWlDCeW85h
	 IIF/6WqOx23tE//5vxDTz4jZJMKRe6351Uij74ez0LiWJglzAA+QlrELB7LpqdA0ag
	 yoCkqedxzeC9OjaIJRknXXCMC/UtnpTKMpG980HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/319] fs/read_write: make default_llseek() killable
Date: Thu, 26 Nov 2026 15:38:04 +0100
Message-ID: <20261126144009.364560171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 2e1a8fbff51bb9bdf0fe9c6602855e308efcfcdb ]

Allows killing processes that are waiting for the inode lock.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Link: https://lore.kernel.org/20250513150327.1373061-4-max.kellermann@ionos.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 7a5783cfac71 ("fs: reject negative offsets for SEEK_DATA and SEEK_HOLE in default_llseek()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/read_write.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index b2d9a27a7414d..8bcba645fdf6c 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -238,7 +238,9 @@ loff_t default_llseek(struct file *file, loff_t offset, int whence)
 	struct inode *inode = file_inode(file);
 	loff_t retval;
 
-	inode_lock(inode);
+	retval = inode_lock_killable(inode);
+	if (retval)
+		return retval;
 	switch (whence) {
 		case SEEK_END:
 			offset += i_size_read(inode);
-- 
2.53.0



