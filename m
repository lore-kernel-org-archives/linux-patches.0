Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A9624A05D;
	Fri,  4 Sep 2026 05:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498319; cv=none; b=TGXRuBqtR5M7ZVqwrPjmydLune7iRFkO6y5c3WA3XPQl+DaV2gYP0bjC46BpSNglzXNMLaOG+JfscrFj9Y+pHg43Y5htbT7XfRxUzoQQ4/h9csCVke2SzdcLWwXoO5QhOiS3zDRFWKPAnuBxi0fLtmfPYltq6Ageim8PIG/NZU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498319; c=relaxed/simple;
	bh=oHIeZp3PKlCp0OJ1iASUnEwVmpDVVaSGJUdAM4KKqCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r258Y3a8YSLWZuzWoQklvEgvuN0Vwg6YlkKvySyM5dtfEG8OM2ibFUYPtmklBj1H6H3YT4A+FIMrSKaHrUvkjXHQW8QeNqplGtv8eboPD1nI7jHM14bP7d1IG8Ii8RyR2sZAWIXVEeFYMdGOMSCVuGhWqb2OLqy4abia0q9JCrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sg3HUrt7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sg3HUrt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEE21F00A3D;
	Fri,  4 Sep 2026 05:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498318;
	bh=PFtyjQfmENkyjDW1Q1nMiMInouDBG7FYcN83IrEO3/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sg3HUrt7SLxrTxWRygtSM0trUwpttuoFT9nq3v9w3g2rAnN5JSg/kNg6wMCZfkght
	 5/pEpv6qjkf4XQG5GmMYMw3eZR2+dLGgqr/1y4B+R9I9TIYtAmiYBP/vb7TGqiU05s
	 FmfcZORh19QvyNx9nHm/il3tbfEEj0pqLeK2PEbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Parikh <vivek.parikh@breachx.ai>,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 020/713] ovl: fix double end_creating() on the casefold-mismatch path
Date: Fri,  4 Sep 2026 06:49:48 +0200
Message-ID: <20260904045804.278441515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Vivek Parikh <vivek.parikh@breachx.ai>

commit 077ab8985ee278c3d8618182d335b0f0cd919e16 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/overlayfs/dir.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -188,7 +188,6 @@ struct dentry *ovl_create_real(struct ov
 			if (!err && ofs->casefold != ovl_dentry_casefolded(newdentry)) {
 				pr_warn_ratelimited("wrong inherited casefold (%pd2)\n",
 						    newdentry);
-				end_creating(newdentry);
 				err = -EINVAL;
 			}
 			break;


