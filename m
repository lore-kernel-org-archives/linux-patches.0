Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034143;
	b=UFTA8/5dw73wjqHaL3xDTNopGlnHdBjLPZZIZowMi991IV139CZDbT07zxUs/fuy1KgX
	 2YUTDgubGLn4gNOyzQgHVPkjBQ/aRm8qyErRO06arI3sHs2dxjiB8HzmARfnM81GKSYG1
	 Uzqx/QdtuYYShrIS6AP/SGfw9PPo4ycLoKIPmVtGJHPqQ1qOG0zarD3tLZchtQZvAmwpc
	 9uHhWa8u4iWEAmHoeksimf6ceMnjt3aK33/G1W+2+yMPGSssWz5aSamj1V59wddINss1V
	 dBHI8DOEI9WYeu5HQ07bRu55muxEr0FX+1uCruEfgq4E/e86cywY8XpcpzzXgWNxSjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fNM19AVSKZcelN+MSH2ByAA1Ir8SOvc/eNZvTWW/2Vc=;
	b=puyQkjmpCWmn4ZkIItF6N+9lR8bQUmodRpnqDpFIWuSlhrc8OMo8h/uMamHt8M2tA9O3
	 jgSNsIj8ZDdnQ8k0KzKfDpUhTU0ABMJfYlP9Ly0cYSyAm40FD9YlqlemTi391CscYNm9s
	 365hB03bB8+AotITj8KLlMsQYHqujQt8nyoiQ/BG4eV1tg2P6Ozi99v7dVtL9G2w12+PK
	 9G5uUuT8Pp2M9+3oAYH2a8U2iNPDhR4+zg25cy+twFSLrp64yPmd0/aDHt+hNUTeTuh7p
	 Z/ktqimwNJcJBow1XDeqF03ejntmUGSd4ZygS2pWjkofzpFfwNmo/eKCn7TjWsg+yyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2igE9wuG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05F3606A32A;
	Wed, 18 Nov 2026 20:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2igE9wuG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC921F000C4;
	Wed, 18 Nov 2026 20:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034143;
	bh=fNM19AVSKZcelN+MSH2ByAA1Ir8SOvc/eNZvTWW/2Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2igE9wuGNRMhw0g/0C9So5PoNoqSrLz1vu5dyIfuPgp0gR3kLN2yBk4IowWcs8SjI
	 wxM/u3cF6hgP5xnQChEAYD+FYVk6EZ3wi9Yn5uOKJWBmnuyjCbWOKKpVwB4yMxBFQb
	 VYfPQnapvku6A0TwlqTbKz8vYwayUYUiHV3leqTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0265/3318] apparmor: fix auditing of mount binary data
Date: Wed, 18 Nov 2026 15:14:47 +0100
Message-ID: <20261118150323.356524979@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit b9f2181b90ec047488dcb4fb1c631d417aff07e0 ]

AppArmor only mediates non-binary mount data, and should only
audit the mount data if it is non-binary.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/mount.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/mount.c b/security/apparmor/mount.c
index 49fe8da6fea45..5a92ed773f2ba 100644
--- a/security/apparmor/mount.c
+++ b/security/apparmor/mount.c
@@ -343,8 +343,8 @@ static int match_mnt_path_str(const struct cred *subj_cred,
 
 audit:
 	return audit_mount(subj_cred, profile, OP_MOUNT, mntpnt, devname,
-			   type, NULL,
-			   flags, data, AA_MAY_MOUNT, &perms, info, error);
+			   type, NULL, flags, !binary ? data : NULL,
+			   AA_MAY_MOUNT, &perms, info, error);
 }
 
 /**
-- 
2.53.0



