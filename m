Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B3E1993A8;
	Thu,  6 Jun 2024 14:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683232; cv=none; b=dyXoN3k3PuXTwzXJ9vsdcUja4EwSEeEcHY9FvDjD9D+8/CysupfYTPv9TMmevqRlEToZiCsyTVWfM0oIqk0GJEJK+9TPoJaXJeLGCwKj0kz4znpvxtY/g+Lt9Womo3YxT0dMplUg9JiF/aSo7jaESMrINCuWIynDni67PvZZJVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683232; c=relaxed/simple;
	bh=gGu/pMAH9zkLRJZlBccYCwPlmEPI+kHICWTWVaW2rGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dc/nJucLYdub1kprCHpCR24QjpYCS3UWrAnb/YeimMNV7U5NGZtjHN4mCDmLNYEV6faZyKgl/uMasywY4kZAO2We/LTNsn7WGJZi6bhZM4Y3rHcZDutD58PqQTKDda8QXTkaN47+ZKg78KswhDrf070jsXwH2A2Sg9ndqRhoRN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6vqut5P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6vqut5P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E8BC2BD10;
	Thu,  6 Jun 2024 14:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683232;
	bh=gGu/pMAH9zkLRJZlBccYCwPlmEPI+kHICWTWVaW2rGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6vqut5Pif7ZLJXaNi/50W1uo/4JLfrgYuuGqZext2uAEq6XGz/ICRB3wpcN5+bLB
	 iNj3ArYqnRLI4n/3hv/XKFHAAJyNjU2ucBbAuiw5zlvmIreYCn10jt0VIjsek21DxT
	 aD8hQUCqmG2Z8u/OiqD6cRwSQRMftqHVncq9EEnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/473] nilfs2: fix out-of-range warning
Date: Thu,  6 Jun 2024 16:00:00 +0200
Message-ID: <20240606131702.226304814@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ef9f9a2511b72..1d4d610bd82b5 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -60,7 +60,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	if (argv->v_nmembs == 0)
 		return 0;
 
-	if (argv->v_size > PAGE_SIZE)
+	if ((size_t)argv->v_size > PAGE_SIZE)
 		return -EINVAL;
 
 	/*
-- 
2.43.0



