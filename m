Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87BE6130A47;
	Thu, 13 Jun 2024 12:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280759; cv=none; b=tAa6jDOoXZowX/TYKA/Kl52Xa2MMdJSBRdJZHDafGweEu3CX5WjIfg5t7jDcj7XibvQCS2RjnoGRFOz4Lf4E0Y9n1HQkm7lcD4WAn2cqfnk7+JZJsU9kxoOD/oQou2dwxd2E9wTYsbijMNeY4WUy1ehSTbAaFt+00piFxQ+sME8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280759; c=relaxed/simple;
	bh=hsaxmUvOF6LMXAGSBC3Ro4rm9tUWa9FE+XOXbUDUxZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fvWUOch8odjGBmnDzGq1bP5dRvltjQuhOhDJe2EZ1KBE2jGsmCY/31Gb348LnlWGZyRaj1AGsecWAiAmnAFD5JxzmThHsMYSlb80F44AiLRNZ5pAHbl0kBeKu2Uqx61MOScVyLFrW7LI6wiju/BFNWE7bbv2h+W9VmdeRf7KFS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BXMGNBI8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BXMGNBI8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8ADC2BBFC;
	Thu, 13 Jun 2024 12:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280759;
	bh=hsaxmUvOF6LMXAGSBC3Ro4rm9tUWa9FE+XOXbUDUxZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXMGNBI8Lt/tDV8vWb77td+iUvSWH5og9DdgYfSoHjSuW2X6zKWwJopp9ykelnuXz
	 EPh1VNHF0ChSAKEK3CrmRbN8XzxP6V5vn662MFN8Xcziy52OJ1mvAn/Ify/ZaH2UCi
	 y9BhxFwBxuOQGXqRk7DHxAphz16hx203ftHAeRh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/317] nilfs2: fix out-of-range warning
Date: Thu, 13 Jun 2024 13:30:42 +0200
Message-ID: <20240613113248.476211566@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c473bcdd80d4ab2ae79a7a509a6712818366e32a ]

clang-14 points out that v_size is always smaller than a 64KB
page size if that is configured by the CPU architecture:

fs/nilfs2/ioctl.c:63:19: error: result of comparison of constant 65536 with expression of type '__u16' (aka 'unsigned short') is always false [-Werror,-Wtautological-constant-out-of-range-compare]
        if (argv->v_size > PAGE_SIZE)
            ~~~~~~~~~~~~ ^ ~~~~~~~~~

This is ok, so just shut up that warning with a cast.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240328143051.1069575-7-arnd@kernel.org
Fixes: 3358b4aaa84f ("nilfs2: fix problems of memory allocation in ioctl")
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 01235fac5971f..668c1b28a940e 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -59,7 +59,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	if (argv->v_nmembs == 0)
 		return 0;
 
-	if (argv->v_size > PAGE_SIZE)
+	if ((size_t)argv->v_size > PAGE_SIZE)
 		return -EINVAL;
 
 	/*
-- 
2.43.0



