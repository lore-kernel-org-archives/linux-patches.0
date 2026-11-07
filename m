Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063785;
	b=j6nklar3Gq5RevbZyBUPKLJfIxNvUmW8NjOM07DGHuSLCiAaWyStdz8Z0m0MpKh+Tmkl
	 DJ4f3ywdKNCylqqATUw7lR5zDh+m9JMRTpOtyASjZ3znvASqiwv3/GGknOK/64I+kywHS
	 B7abfSeLQRKkj08QtXFm7TPQncJde3EufRSuyGvyGrQ7S+VfcBNVyGWK2RXF3FdAGAk1s
	 LfZpP7JiZOL7IJRYi+rQhaqG/yr/4fM6jg9YVExZeei4lWF0YcIehp8WQ8cvntkW71paI
	 vrwoApUFzaYfB5MD56MMmGlhaOfifurV/NWw9/CD7W2pKYNJIc9clx8MQes1Eleq52Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mWsk0CdfZ9qXhHeTi8YhrH7vSytk3dxmBEqW92Tk6Uw=;
	b=mAiQCE/EtjBPpN41GIUyXY7hKi/XMIBYlFKcH5bOKBY1KwL6O3ykrYDN9Y6A5KAPh4gI
	 HX2efDWP4AK17+0CmjR/bLWLmAT4gFzVZ+IU6YDP6OtZy+FEfVRuhccdJCp+a6dlXs+K6
	 e/iI6JVxB8BO5z/CCfNpnhaKSLZBJ44O7aBnlwtidQ0j0m9Skh7tgjXGBC+uTYBEXeLW4
	 Idc3NVRE2zCrjBQGG4PjF4g0X9T+4CYqFjBXa6X0Ry1547dM59UUpXWwgoXTA8CJiJXSL
	 /5CRKUvGUuKhMF1oUTDPHXPCfS6C+7vPeCvBeYQbaGsdcPVS3okk2WRnfpOL7Wx+79Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5TS5L6o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A468606EE98;
	Sat,  7 Nov 2026 15:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5TS5L6o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12021F0089F;
	Sat,  7 Nov 2026 15:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063785;
	bh=mWsk0CdfZ9qXhHeTi8YhrH7vSytk3dxmBEqW92Tk6Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5TS5L6ouqPFZIhQJ66TWdyAeFuy50VtYXU7J1C39N7o00niMwrkAPKe6v4RzrFeh
	 pEVlAdGAxjz59elmCXUid0A7C17HC+PwfVO/pbOeRaU7hcx2wJCzOdBHQVtEuwqTuD
	 TYfUraJbIgv+584aTPEp/qUMy/kmLJqq5H5n4oxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 848/869] mount: refuse setns() with a shared fs_struct again
Date: Sat,  7 Nov 2026 08:58:50 -0500
Message-ID: <20261107134921.565278944@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bb73b317f9e72..34e0d14c454ba 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -6376,7 +6376,7 @@ static int mntns_install(struct nsset *nsset, struct ns_common *ns)
 	if (is_anon_ns(mnt_ns))
 		return -EINVAL;
 
-	if (fs->users != 1)
+	if (current->fs->users != 1)
 		return -EINVAL;
 
 	get_mnt_ns(mnt_ns);
-- 
2.53.0



