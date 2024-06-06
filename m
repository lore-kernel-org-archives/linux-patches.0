Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A8219644F;
	Thu,  6 Jun 2024 14:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683153; cv=none; b=fh/Uzrz3YO/DvVDXj8rmdJVMMi6YDA3MRXIdxsot1yQc9PEjB2xXeq7KiQ2+1YHtohn2zXtYPFtehafwtfnNRqcg9YIqmBcS6+vkD6xDqSTlcy4MGCTWZ1yv65DJFs9RzlV5boK/so2SA2S0fpnTwPLk1A9Vx108GkgB+ZeNUK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683153; c=relaxed/simple;
	bh=Cy7cSfhqcAxXrVhpqoKQHeB0Twkagfnv2UMZ2Vg7mC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxHDIbvtuZxcMNTIP/mmMGD//p2AJ4+118m23hfI2ghs9lARE1yxK2LFg9ixy4tR4F6IknPlKJOMSCLjMJGoOcREoj7SRu7uQV1MrhK4L6P8XI1io6XDLPa/L0+b2PRDIojWv0WEwH1JqIulFq9Tfat3qEKxlqDeh7vw2+4ssfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gf/UDfr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gf/UDfr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A04C2BD10;
	Thu,  6 Jun 2024 14:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683153;
	bh=Cy7cSfhqcAxXrVhpqoKQHeB0Twkagfnv2UMZ2Vg7mC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gf/UDfr8F7pPj6/Do2lul0UtGVHtYF6vQEBndMKKmeZaTyhrXJSvI6B2mTC0O6b3x
	 Og1NRwVDCX+m8Lc4dpUW2v0q8eHCtkKZCpSfups45tbi0vaAR5ofOohX+Z5E0BpRQ5
	 rYNRUcwzzUSXKPvitX2c0bM+Y1f4G9AilzoGdBO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/744] nilfs2: fix out-of-range warning
Date: Thu,  6 Jun 2024 15:56:10 +0200
Message-ID: <20240606131735.544328711@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 40ffade49f389..53022bfe0b72d 100644
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



