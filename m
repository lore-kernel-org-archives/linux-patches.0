Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7DC335BC4;
	Mon, 18 Aug 2025 13:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523222; cv=none; b=mTgvU9OMgXz4z/wDWngkS0jEVV//KyocgMg9iGXXOlArIAPOTyyrqoVzkhiSZ+rDz1LPkt2VEVQSguPvtsKrz31hBWwW0IIkZ+FjOOYLpMovJxaNtbtTsNBeLrlG6kLCg/w5VoKznVQDAjtzOuKgZJMCxCVjztxwQSb0vJJBRzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523222; c=relaxed/simple;
	bh=8+TptXcJiJLBZgqMflUFBgmKQLB3XvhP5QsxioZz0JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B3/drBozpviBZttOnBAy6sqEIh1+yn0EVucmn8Q/nvcDE4ewzsZkcDrkUt0oL4y2bqXbp4N8iNfDJpFACenaOGXpCjoKsxHBO3NyGBYeed/zkTK5YpBkrto5+X4eYztAsZkI7WSe4BapSQNUALZWa68lIcsNNbM6FZwp/rj1aek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xEf1/MD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xEf1/MD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC1CC4CEEB;
	Mon, 18 Aug 2025 13:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523222;
	bh=8+TptXcJiJLBZgqMflUFBgmKQLB3XvhP5QsxioZz0JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xEf1/MD78/taQiLdQAsGBY80O7JbEXyclxEGisJA/ZOsRni80QI5CoQzOT0iJAABI
	 Uzu6rj/SuwPvXTrw6Qyr0F1273y2wlC2i6innEkI5Az5YQ7S0vBL4iWoXoFVOoAbg9
	 cwMhJQ79tjIB6aoYzL4UjqakG90/PgO4xE/kOoOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 107/515] landlock: opened file never has a negative dentry
Date: Mon, 18 Aug 2025 14:41:33 +0200
Message-ID: <20250818124502.483425292@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit d1832e648d2be564e4b5e357f94d0f33156590dc ]

Reviewed-by: Christian Brauner <brauner@kernel.org>
Acked-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/landlock/syscalls.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index 33eafb71e4f3..0116e9f93ffe 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -303,7 +303,6 @@ static int get_path_from_fd(const s32 fd, struct path *const path)
 	if ((fd_file(f)->f_op == &ruleset_fops) ||
 	    (fd_file(f)->f_path.mnt->mnt_flags & MNT_INTERNAL) ||
 	    (fd_file(f)->f_path.dentry->d_sb->s_flags & SB_NOUSER) ||
-	    d_is_negative(fd_file(f)->f_path.dentry) ||
 	    IS_PRIVATE(d_backing_inode(fd_file(f)->f_path.dentry)))
 		return -EBADFD;
 
-- 
2.39.5



