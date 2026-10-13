Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A173CFF6F;
	Tue, 13 Oct 2026 11:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892468; cv=none; b=UjMMKDgZd+tZp1AVicTnEiKGJoKqWy2qu+eeqn8o4eJ1WT/4U9cYHZe5IuNWAtgtHywRtsC8iFegpJL9uSlK66V8s8+CLH12Ag3sHSvMrDes84Td7PhO2qMb+Ga5971WQCdcmdSbOMZkd4akyIC9asYdZrjbc0/ay3FkZsAt+jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892468; c=relaxed/simple;
	bh=V0ZAIlfE6oVInCCVL233wsctAi6PI/lLQWA4M59NK00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjCOOoUQcHg/tTzjauChz0pLgxgg/KfJTcXLZJwIAc6vjSxvX8Xa19WSo6cnDfkM9hOiz1bGmESUUAyaFjgq529xJXesGBBjzxsZrYkPGx9dss+tlgm4iwImJzGFEjS8Ei0Dlhm/w49GifGkSKFc96djN+QujhkD3jgsMAxFfCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uEgnwCVS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEgnwCVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9481F000FF;
	Tue, 13 Oct 2026 11:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892467;
	bh=xWQVZQdiGyR2ScMAyTw/eHljG1qh9ZFd/UOEy3MxyCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uEgnwCVSj2qqsg0NtnQ5SuKNX4mhIdrjoVGdtOZt4D54wr4qZy2XrSwFC/GEIy5HB
	 n1btEiJif7/u0UFff1GJmXnBPzee3ZMwbSnUZm5oQ28EMX3krQEBQJD6E9vAZf9y7P
	 uuW1bQpNZ7L0X9ZIkceVnfM7WacepMEHL40/ICl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 184/281] mount: refuse MOVE_MOUNT_SET_GROUP on an unbindable mount
Date: Tue, 13 Oct 2026 13:38:20 +0200
Message-ID: <20261013112859.630253930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit a2b42babc912e4fb428cbb42adb4f6e1e067113d ]

do_set_group() only accepts mounts as targets that are neither shared
nor a slave. That encompasses undindable mounts.

If the source mount is a slave mount the target mount will end up with
source's master as its master. It keeps T_UNBINDABLE. That means we get
a mount that is both unbindable and a slave:

  mount --bind /tmp/src /tmp/src
  mount --make-shared /tmp/src
  mount --bind /tmp/src /tmp/b
  mount --make-slave /tmp/b
  mount --bind /tmp/src /tmp/c
  mount --make-unbindable /tmp/c
  move_mount(b, "", c, "", MOVE_MOUNT_SET_GROUP)
  grep /tmp/c /proc/self/mountinfo
  ... /tmp/c ... master:646 unbindable ...

This property cannot be produced any other way. change_mnt_propagation()
drops the master when it makes a mount unbindable (iow, it becomes
private) and doesn't touch an unbindable mount when it is supposed to
turned into a slave mount.

End-result is that the unbindable-slave mount receives everything
propagated from its master's peer group while it can't be bind mounted
itself. Not sure what that's supposed to do.

On the other side: if the source mount is shared, the target mount drops
T_UNBINDABLE because because set_mnt_shared() clears T_SHARED_MASK.

So teach do_set_group() to refuse an unbindable target mount the same
way a shared or slave target mount is refused.

The main user of MOVE_MOUNT_SET_GROUP is CRIU which restores sharing
first and applies MS_UNBINDABLE afterwards. It never hits this.

Link: https://patch.msgid.link/20260923-work-mount-fixes-v1-3-f424cf8d3242@kernel.org
Fixes: 9ffb14ef61ba ("move_mount: allow to add a mount into an existing group")
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 472cca0b730d9..010bc659188d4 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3530,7 +3530,7 @@ static int do_set_group(const struct path *from_path, const struct path *to_path
 		return -EINVAL;
 
 	/* Setting sharing groups is only allowed on private mounts */
-	if (IS_MNT_SHARED(to) || IS_MNT_SLAVE(to))
+	if (IS_MNT_SHARED(to) || IS_MNT_SLAVE(to) || IS_MNT_UNBINDABLE(to))
 		return -EINVAL;
 
 	/* From should not be private */
-- 
2.53.0



