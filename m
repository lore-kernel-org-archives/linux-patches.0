Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211422;
	b=b4VrX0tQOtcwqTtgbLnIk/5Z2wp4D0QGf6DRovIMvMqOVAvAnPTzIk1czGwYMK9aWVNV
	 n2WX7Aehe/U25eQnV6KhRm0S2faxpvJX5nhoLu/aSXIaJ0YptWf6tuifHEb5axruEuK+1
	 t2sP8nb2lb5pidRYZPPpFQj92yrJnljAPU2stBrur3mGM9uN6o/ioPkAKaVS4LZzRpubB
	 7yhLIjAoF3znM3RVnaA2DamiRaL5VJxE9e7OzsqAH0vJzoD26WK+m/XMtTiW8Nb0xwLyF
	 EOH+nG35RmrHcM51fIDyYZMan+kZllALKhVdT54mQBtQ0ni40j0BC51YSVXHSaXWAzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YAnHw6IuYDLnBKz4VVD7jzV/qnVk559VjPSr5zts98s=;
	b=cd/O1MT0qMuOW8M0/ZwQxSsCuEI0m2IJb8/KOPYTXPbn37FdA3SP2cS9lD9O8RMDBHgZ
	 cshtcRpWpqLlSwXzWmAMVen8RYy27US9cj0fbUGrYS4Wz9kqV7gWadIGTouvXPz5b+feG
	 qoTrbnUokVCodG66OVjmUBdzsa4YHkGZI0akSLRlkmeZrWpiTbW8wqh2IFDWGBJp/M/9R
	 YJFvkKndGBJRgBWPidmllq6sdD8iS4zjoKQkbzl5wXaE0ocKy0CYo6zk3VehaYrF14waE
	 Q0vUBlo1reXRKFJRoA0JbNQD+Cs3i7Tais+bna9QH4aWvDXlD77TSaV2bA+Ra7qThSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mROm1Cnx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0420D606A31F;
	Wed, 28 Oct 2026 18:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mROm1Cnx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DB71F01825;
	Wed, 28 Oct 2026 18:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211421;
	bh=YAnHw6IuYDLnBKz4VVD7jzV/qnVk559VjPSr5zts98s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mROm1Cnxm65b/OpSVL3ewN2SVhghJsnl+gEUBKZImnVNpse876po+ZmnxYNLsOk/2
	 4rvKvA1kpJIqTPvGhvy8DZcsJLc8FuC/w1WTw+lAC3XXQhlxL5XGSlFeNzoouRPS2H
	 FJf858w1lDpf3E9LCMMXmy7x2pMDB2sLgLdp/Vfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 316/571] tty: vt: fix memory leak in vc_allocate()
Date: Wed, 28 Oct 2026 17:57:43 +0100
Message-ID: <20261028170015.499258294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Mingyu Wang <25181214217@stu.xidian.edu.cn>

[ Upstream commit 5b114bfc1dfd88f9d50822d532f7f1fce0f7388a ]

If the screen buffer allocation fails in vc_allocate(), the error handling
path jumps to `err_free`. However, this path fails to release the unicode
screen map attached to `vc->uni_pagedict_loc`.

During the early stages of vc_allocate(), the unicode screen map is either
newly allocated via con_set_default_unimap() or shares the default unicode
map from a previously initialized console (which increments its refcount).
If the subsequent kzalloc() for the screen buffer fails, the err_free path
frees the vc structure but leaves the attached uni_pagedict with an
elevated refcount. This results in an unreferenced object memory leak, as
the reference to the dictionary is lost and its refcount can never reach
zero.

This issue was discovered by DevGen (an automated virtual device modeling
fuzzer based on Syzkaller). During fuzzing with kernel fault injection
(failslab) enabled, the fuzzer forcefully failed the kzalloc() for the
screen buffer, exposing this error-handling path leak.

Fix this by checking *vc->uni_pagedict_loc and calling con_free_unimap(vc)
in the err_free path before kfree(vc). This safely decrements the refcount
and releases the dictionary memory if this was the last reference. The
explicit check is added to maintain consistency with other callers.

Fixes: 34902b7f2754 ("tty: vt, get rid of weird source code flow")
Cc: stable <stable@kernel.org>
Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20260803144556.163856-1-25181214217@stu.xidian.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: Replaced the upstream uni_pagedict_loc field with the existing vc_uni_pagedir_loc field. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/vt/vt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 124c1e5875629..187d42f61426e 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1160,6 +1160,8 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 	return 0;
 err_free:
 	visual_deinit(vc);
+	if (*vc->vc_uni_pagedir_loc)
+		con_free_unimap(vc);
 	kfree(vc);
 	vc_cons[currcons].d = NULL;
 	return err;
-- 
2.53.0



