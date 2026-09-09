Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7991A563FBF;
	Wed,  9 Sep 2026 14:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964601; cv=none; b=ZRMGFQQS2Dl+7tFWQuIqUid1hFZTI/+b4gSD9XtoFaFDEIi6XOT5KHif5a6WSXKlyaW2pnNQBr1rTAJ0bHKobKrkkZxhJFhLt/B1cWnIS6RB4zQrOZyyxFJB7R46UHTrYOd+xoqB1w055L6p63sXJkX6tSX6pJeICXksx9J0sqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964601; c=relaxed/simple;
	bh=DD8+IZjLQDcaHRjirPyxy53K+p+TpS++td1QAofOvic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1f3sDR6HkZczac23VSmd72sj43vY5qyX9VZirew+q9c0/8wnFkNLx9gkSdo8oJgaR62Cn8m/3f6Dvs+uHaaqf0peTukhiS/Nl0WcMSWGRfq+k3uQw783bmkXwhxrB/8gxq2uayOZAo7zXEeQrjzR/oCvJ5m9BNDSYZtL/ygWkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFZFc1ue; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFZFc1ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9731F00A3A;
	Wed,  9 Sep 2026 14:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964600;
	bh=vRLi7LxoUtKX+3cC99ZymFi4xHtHlOK11QBbYZ6ewc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eFZFc1uep+r7ov4evvwT2usVMTCUR+ubQRO030IerWCHH/u5rgZ5hYhY33EpaFAyJ
	 bfw7Gy9dASaWk+vZxkG3ik7gp5Zdo2hxGCB6l7XEwAASFObAZDL/rwsWfA/fs8iJI8
	 tHVOxdMgNk6Gcjrg+NydIVdSQPHlN8gfEyiEnMUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Parikh <vivek.parikh@breachx.ai>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 442/583] ovl: fix double end_creating() on the casefold-mismatch path
Date: Wed,  9 Sep 2026 15:42:07 +0200
Message-ID: <20260909134253.293241200@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vivek Parikh <vivek.parikh@breachx.ai>

[ Upstream commit 077ab8985ee278c3d8618182d335b0f0cd919e16 ]

ovl_create_real() releases the new dentry twice when the casefold
consistency check fails.  The S_IFDIR branch calls end_creating() and
sets err, then falls through to the common out: label which calls
end_creating() on the same dentry again:

	case S_IFDIR:
		newdentry = ovl_do_mkdir(ofs, dir, newdentry, attr->mode);
		err = PTR_ERR_OR_ZERO(newdentry);
		if (!err && ofs->casefold != ovl_dentry_casefolded(newdentry)) {
			pr_warn_ratelimited(...);
			end_creating(newdentry);	/* first */
			err = -EINVAL;
		}
		break;
	...
	if (err)
		goto out;
	...
 out:
	if (err) {
		end_creating(newdentry);	/* second, same dentry */
		return ERR_PTR(err);
	}

end_creating() is end_dirop(), which does inode_unlock() on the parent
and dput() on the dentry, so the parent directory's i_rwsem is unlocked
twice and the dentry is put twice.  The second unlock releases a lock
that is not held, which is what wedges every later creation under that
parent, and the second dput() drops a reference that was never taken.

The branch was added by commit dfc7da402ccc ("ovl: Check for casefold
consistency when creating new dentries") as a bare dput(), which already
released the reference twice; commit fe497f0759e0 ("VFS: change
vfs_mkdir() to unlock on failure.") converted both sites to
end_creating(), adding the double unlock.

This is reachable by an unprivileged user.  The casefold consistency of
the layers is validated at mount time in ovl_parse_layer(), and again on
every lookup in ovl_lookup_single(), but ofs->workdir is the internal
"work" subdirectory created inside the user-supplied workdir, and that
subdirectory is not re-checked.  Marking it casefolded after the mount
therefore makes every ovl_create_temp() inherit the wrong state - and
that path reaches ovl_create_real() through ovl_start_creating_temp(),
which uses start_creating() with a generated name and so never runs the
lookup-time check.

  unshare -Urm
  mount -t tmpfs -o casefold=utf8-12.1.0 tmpfs mnt
  mkdir -p mnt/lower/d mnt/upper mnt/work mnt/merged
  mount -t overlay ovl -o lowerdir=mnt/lower,\
        upperdir=mnt/upper,workdir=mnt/work mnt/merged
  chattr +F mnt/work/work
  mkdir mnt/merged/d/sub		# directory copy-up

  overlayfs: wrong inherited casefold (work/#5)

and the next copy-up blocks forever on the parent's i_rwsem:

  mkdir           D  start_creating+0x65/0xb0
                     ovl_start_creating_temp+0xb0/0xe0 [overlay]
                     ovl_create_temp+0xa3/0x1d0 [overlay]
                     ovl_copy_up_one+0x1f1c/0x21c0 [overlay]
                     ovl_copy_up_flags+0xf5/0x140 [overlay]
                     ovl_create_object+0xb7/0x220 [overlay]
                     ovl_mkdir+0x23/0x40 [overlay]

Drop the end_creating() from the branch and let out: own the cleanup,
which is what every other error path in this function already does.

Fixes: dfc7da402ccc ("ovl: Check for casefold consistency when creating new dentries")
Cc: stable@vger.kernel.org
Signed-off-by: Vivek Parikh <vivek.parikh@breachx.ai>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ adapted end_creating() cleanup removal to the older dput() API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/dir.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -191,7 +191,6 @@ struct dentry *ovl_create_real(struct ov
 			if (!err && ofs->casefold != ovl_dentry_casefolded(newdentry)) {
 				pr_warn_ratelimited("wrong inherited casefold (%pd2)\n",
 						    newdentry);
-				dput(newdentry);
 				err = -EINVAL;
 			}
 			break;


