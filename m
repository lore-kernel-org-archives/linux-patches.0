Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7462F2342;
	Tue, 17 Jun 2025 16:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176415; cv=none; b=W530TmkGy2w6wv7NkjEV9qJJDpBfCfxBZYs2ONOEfBOOG6UdPb1kMMkjDrJhVqUrmHJPz+suPga8smhus8go4pLmGLpUnXBsSASLKPyI/jOdChQI9biGtoEWAdqUNYi8itYNVx8J+/K1MShvxMqM8+98VbFSkjNH6fYNDHgW6tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176415; c=relaxed/simple;
	bh=g4E4DCOqot0ZWEKZCcoZQQE9yUq9CQnjtiN8rJVWQTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1FFc9AZJtXjI8FvVD6VBsiSmJRdq5cffRo6GqtccWa6YtdGT5Phs/ORA3N48BOFxJQih4bJ+UaLtkLcaC/J5yTimC4eYvBhk1e6Dn3PAdaPwEicRVkrghdyVEnp15kH+LLQ1e+9ZsAU6HEXbFPnUEkhr55ozaeoYurZNqa9nM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7u+awai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7u+awai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728C4C4CEE3;
	Tue, 17 Jun 2025 16:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176414;
	bh=g4E4DCOqot0ZWEKZCcoZQQE9yUq9CQnjtiN8rJVWQTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7u+awaik1dd3Bk38oP1/niRwiPqKb2dhUkpDx2+UPdW015UpBWixgjEwqw1APtvN
	 d5hbfwlMVYlh3+Yd1fZSix+fV1Uz7hy46yJxzppCvXe6zRrVtI8Oe/JwxyRlF/3VMl
	 JGPbaw3UZdJ8Huh4VOKFIvbewTj3l2zgBLQqNg+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 275/356] fix propagation graph breakage by MOVE_MOUNT_SET_GROUP move_mount(2)
Date: Tue, 17 Jun 2025 17:26:30 +0200
Message-ID: <20250617152349.264769590@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit d8cc0362f918d020ca1340d7694f07062dc30f36 ]

9ffb14ef61ba "move_mount: allow to add a mount into an existing group"
breaks assertions on ->mnt_share/->mnt_slave.  For once, the data structures
in question are actually documented.

Documentation/filesystem/sharedsubtree.rst:
        All vfsmounts in a peer group have the same ->mnt_master.  If it is
	non-NULL, they form a contiguous (ordered) segment of slave list.

do_set_group() puts a mount into the same place in propagation graph
as the old one.  As the result, if old mount gets events from somewhere
and is not a pure event sink, new one needs to be placed next to the
old one in the slave list the old one's on.  If it is a pure event
sink, we only need to make sure the new one doesn't end up in the
middle of some peer group.

"move_mount: allow to add a mount into an existing group" ends up putting
the new one in the beginning of list; that's definitely not going to be
in the middle of anything, so that's fine for case when old is not marked
shared.  In case when old one _is_ marked shared (i.e. is not a pure event
sink), that breaks the assumptions of propagation graph iterators.

Put the new mount next to the old one on the list - that does the right thing
in "old is marked shared" case and is just as correct as the current behaviour
if old is not marked shared (kudos to Pavel for pointing that out - my original
suggested fix changed behaviour in the "nor marked" case, which complicated
things for no good reason).

Reviewed-by: Christian Brauner <brauner@kernel.org>
Fixes: 9ffb14ef61ba ("move_mount: allow to add a mount into an existing group")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 7942a33451ba0..4d8afd0e1eb8f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2995,7 +2995,7 @@ static int do_set_group(struct path *from_path, struct path *to_path)
 	if (IS_MNT_SLAVE(from)) {
 		struct mount *m = from->mnt_master;
 
-		list_add(&to->mnt_slave, &m->mnt_slave_list);
+		list_add(&to->mnt_slave, &from->mnt_slave);
 		to->mnt_master = m;
 	}
 
-- 
2.39.5



