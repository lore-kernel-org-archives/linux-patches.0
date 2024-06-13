Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E80A1422B5;
	Thu, 13 Jun 2024 11:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278722; cv=none; b=iVV9hkxkBWJRROw7fb8eX9O/pJMJAQ+JCnBe3tVcZu3itcf979lHkO+EA23wKZHTg+RhrPWk7TIGgpygYx5nrCr/XVke5Ve4ca49CRonlbWN4THMMfYjx6KgCrCJMXEMtKrjEWmN6FMG5OLiLTAGgihAnD1adG4J/1WYwWtQ8ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278722; c=relaxed/simple;
	bh=UnyNWnoarycoXpXLCsfaceWS6X+wr/sfNX80jub/yMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBFCrfC3KxOKrrunB7nyV40UQTKIl7K7wINrxrTCW2lgIP+mK3d3PJ7Ji3oQ2lFo8zz+2vCHoeZ9Vyzu8I8UCKfKivHa0Kq3w73cEnaqo3KC1XrRelCxXknD8XckRB24sSK/e6OIkLFs6Vb1GigIZF+1igNZ9ijSPdwilEmXh1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chFkQlv9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chFkQlv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B3CC2BBFC;
	Thu, 13 Jun 2024 11:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278722;
	bh=UnyNWnoarycoXpXLCsfaceWS6X+wr/sfNX80jub/yMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chFkQlv93ritMo7F8+XGR8DFB2mQ2++N+SaueK19R3a3B6RWBij/rJMxxzgcjA554
	 X/Bc4MXy/xxdS1wm7CoJnneAcvS65l2FkFK86YJAUH/bsVeGPEmbantu8OTr19d98O
	 Xew1hF6lv5/jbXolrFb/R4x4C//a5T7MLJmVRf5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 017/213] nilfs2: fix out-of-range warning
Date: Thu, 13 Jun 2024 13:31:05 +0200
Message-ID: <20240613113228.653158369@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index ecb5e4cf058b5..369c55e1b9417 100644
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



