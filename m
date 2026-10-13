Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D944ED19E;
	Tue, 13 Oct 2026 12:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894253; cv=none; b=hLlRIeYYu+8/sWocgro0pUZ+DQ7sK7JUt4U3hMd6I6IRr73CUVbv/poZ6mErww/3ViB1lUmjpKxHwh5Vw2dJ4Xy9H7LvEFczhQkMfnOf4Y0yKvPK3BSA19asnw3RvpRnUbOZI31CKPOF6dO6A6/Zi3Th2nkvUVGdAy2J7/AAcMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894253; c=relaxed/simple;
	bh=lIzvfctoRUykaV8iOeqUrhWk8xQBlI2RQn0RAqUcvkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UyZAgW7IUDdewZ1X45JCI4wOQDsn8X59/Bj3HlXHAvPVFN4zOKi+LkzLkQCFc03Nu9f831JqlLR9wQEnv3zhjYMPeTBlUEYjdDiIhjHa4ATb/QK1cl0Qp+iyS2iZ6qtjJ2nFcCGFuso+wF22pRvHduJvJ6zoLwLa8zZrLjL9RtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iaOYMY5i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iaOYMY5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0001F000FF;
	Tue, 13 Oct 2026 12:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894251;
	bh=O7kH6MSi86C3BLahxBrJImyBh1j78yz34Ny43WcG68c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iaOYMY5iuFc4/qLVH9uijc5SalYshFxt7UFjU+e+OIvt1KtOq3S1DN5S65FCl9tuy
	 iaUIDHyztxRg/P0rhj0PaCzUNuA/PHoMY49oXznfmpSmix/DUJjPLpBWb1bmh1+ey5
	 zLCTAnmZ/wBAH8iGyMlpvOjjw35Zg/tkkiLdz4SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 499/621] ksmbd: remove redundant DACL check in smb_check_perm_dacl
Date: Tue, 13 Oct 2026 13:38:14 +0200
Message-ID: <20261013112932.670263145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>

[ Upstream commit 8dd2e58b62731a96e276ee0545fb910ffb2057d9 ]

A zero value of pdacl->num_aces is already handled at the start of
smb_check_perm_dacl() so the second check is useless.

Drop the unreachable code block, no functional impact intended.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: cc2f133e80eb ("ksmbd: fix maximum allowed access checks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smbacl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 2a46646b3a0e4..114fd2e67725d 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1511,9 +1511,6 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			granted |= le32_to_cpu(ace->access_req);
 			ace = (struct smb_ace *)((char *)ace + le16_to_cpu(ace->size));
 		}
-
-		if (!pdacl->num_aces)
-			granted = GENERIC_ALL_FLAGS;
 	}
 
 	if (!uid)
-- 
2.53.0



