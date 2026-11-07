Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062658;
	b=BQ6hCgK0+7we/tnml7mcGHM1XXUM1hJOm+PPf3od0T7KAQLVECmHhCfKXx0+Q75DtodS
	 fOrf5K18ZsNX8m8GJNORW7nlPS54er06d7lnpb2psvlxKKwJid6qtweXN4+3rtAtfd9on
	 kboz12RdiBqy0CMwQHaib/cUtxjRhFDWre/Q0mvBpTUkKCPga4+EeXnUhDECOOFhL+w7f
	 eqMQsSv5he5JPxXV3pVBJE+9ES75Vv4+uMQcfkSVGKihfWNPyXdm05qn9zQfiXVS+1vDa
	 b9LWvE/945J3uM8E6LtPrXzQ71q4EwH0jccnRB5UaWVwfJ5DYPG5LtlIJNmu9ABujdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mmfeIL6Zkn8L8+E8wyNxjAxSjEamR/b1iZh9k7wIYxk=;
	b=KO3DWJNyf4xqGWa9jT/ECu7z8ZYoeD3wLIEUbG81tEeLTM5PWIgAky/JysjozaC/DerD
	 BwE9jNUQGBR+8sHu9cwk+AsFnAOVzOJ0MDE02XyXvooHxOmXbcZbListJGYgktCcfZaGA
	 J0u+58eXfFNyWO+cNLNYgnsoYfrTys6yyKxvuYibjBvgFtAgMMOpX19Z/sGlVX731JCh8
	 LgsBNrt5q2gJq1xbTlbHnFwqN5xobhlPfwddGD1AbWb79Db88QuZUljRQEjuz1yoZIOdu
	 F69KgNonGUn/LhbUuV/DIfCY5SpgQQNxspm12zNORxNU5IwfBHcdY3KYT1Jhh+Ysy8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YP0/DZ15";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE58606A32E;
	Sat,  7 Nov 2026 14:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YP0/DZ15
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8892D1F0089F;
	Sat,  7 Nov 2026 14:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062657;
	bh=mmfeIL6Zkn8L8+E8wyNxjAxSjEamR/b1iZh9k7wIYxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YP0/DZ157RNTJCPPtaE5N7i+l8gfGzoY3hAEsxqYytKfrQbjTAAXFAHrM7Aw0bgo5
	 L7eQnx63LQeSXTVZyuyq6nj/3LiQCvmgcOfBFUuTFxshmbLlNVIFzLRFOe1tf1+bBD
	 DL1JxF1BvWf3eFnBMqdx6fUf7aqhuGXwwIMXpfqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1521/1536] mount: refuse setns() with a shared fs_struct again
Date: Sat,  7 Nov 2026 08:58:57 -0500
Message-ID: <20261107135040.595772163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 948e604aca8af30490accf7d46d44814ffa26f80 ]

mntns_install() refuses to switch the mount namespace of a task that
shares its fs_struct, since root and cwd of the others would move to a
namespace they are not in.  It looks at nsset->fs for that.  If more
than the mount namespace is asked for, that is a private copy made by
prepare_nsset(), which has one user by definition; commit_nsset() then
writes root and cwd of the copy to the fs_struct of the task.

A thread of a process with two threads, pidfd of a task in another
mount namespace:

	setns(pidfd, CLONE_NEWNS)			-EINVAL
	setns(pidfd, CLONE_NEWNS | CLONE_NEWUTS)	0

and after the second call the other thread, still in the old mount
namespace, has lost its cwd (/tmp became /) and sees the mounts of the
other namespace under /.

Look at the fs_struct that is going to be changed.  The second call then
fails with -EINVAL like the first one.

Fixes: 303cc571d107 ("nsproxy: attach to namespaces via pidfds")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index fa611381c3a35..d188ad61f40ae 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5942,7 +5942,7 @@ static int mntns_install(struct nsset *nsset, struct ns_common *ns)
 	if (is_anon_ns(mnt_ns))
 		return -EINVAL;
 
-	if (fs->users != 1)
+	if (current->fs->users != 1)
 		return -EINVAL;
 
 	get_mnt_ns(mnt_ns);
-- 
2.53.0



