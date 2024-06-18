Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D060A15383C;
	Tue, 18 Jun 2024 12:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715283; cv=none; b=jaGY/1UmWPPemVGwuVLqFKdtNw8TlKyA6ra9XmKYjeR6EOv+l8hOPz12hDF/1nzo8C0YTOZA5VIkV9WYsEeY3P4bBRxHZWdB6Z4PYnufKf3Wyhvp6JVD+5wjGXIh6nau0U488LUjh6CKblunqVLZMMlWkoz+h7xTW7BEwR605a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715283; c=relaxed/simple;
	bh=DBsvYbwxLfmWCKsiVNmGR6LqH87LRk5FbC+sg6JOwW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ae0NKdgBPCfb1VF8Ap7z3X3Nh94P5ytP1sOKaGIoz0BEHuebQpM7oKh/dkWPzg1qfGOK2Rnz0Rb6AUSmGxCnLx5zS7Qq5+H8nK2Tv5F4wwkUfetpHw6/s2nwUA7ZiQYn53CyWgY3frcBZvkAuU4DGWT5Eyu8VbIXpmnlH9LchYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fmr9LJZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fmr9LJZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F36C3277B;
	Tue, 18 Jun 2024 12:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715283;
	bh=DBsvYbwxLfmWCKsiVNmGR6LqH87LRk5FbC+sg6JOwW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fmr9LJZxdxizf61ntkQ1XYJQJ7XCLF8KfUk5dPtiKW/a6s+U+1yj9u/x5A9lC0Z1g
	 DxXoetalL+9EKgEnRLbfFDWugJtJ2pN4tV+VshU1fVRhBKYlLZZ4t8PW+0/HuddMx3
	 IYeAPlZtRaFkxusUZ4dtdv4YVndTJKXo9QfOH+sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 257/770] fanotify_user: use upper_32_bits() to verify mask
Date: Tue, 18 Jun 2024 14:31:50 +0200
Message-ID: <20240618123417.195223834@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Christian Brauner <christian.brauner@ubuntu.com>

[ Upstream commit 22d483b99863202e3631ff66fa0f3c2302c0f96f ]

I don't see an obvious reason why the upper 32 bit check needs to be
open-coded this way. Switch to upper_32_bits() which is more idiomatic and
should conceptually be the same check.

Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210325083742.2334933-1-brauner@kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 842cccb4f7499..98289ace66fac 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1268,7 +1268,7 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 		 __func__, fanotify_fd, flags, dfd, pathname, mask);
 
 	/* we only use the lower 32 bits as of right now. */
-	if (mask & ((__u64)0xffffffff << 32))
+	if (upper_32_bits(mask))
 		return -EINVAL;
 
 	if (flags & ~FANOTIFY_MARK_FLAGS)
-- 
2.43.0



