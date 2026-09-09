Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C43454B1C6;
	Wed,  9 Sep 2026 13:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961852; cv=none; b=Yh/Z/ua1X4T28YAKuhdqAEl38xCfCGQpjsqgerLfgncOYfN39YIWvn1j35NeoRDKCuG4awVpdl+wrhHvLuzg/nTy8ruuGknSKxCvMtj7mqaihwal1NFk2w32WItLW6LThpuBIqdnw0jNOxtTSRNOVkgaG9mrXzY9BP5VvNcVTCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961852; c=relaxed/simple;
	bh=mfKU6ZiEToQO2YbUzMMYg1dom2gMo44Uw9HV2agLcE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7EMjz9gY5oRndpFphQfUmwzDSXh1uLYYPgAu2NK2In2xwdjKIGrF1N4JkVvWnwr/pkBGBwWmZaJ+nGcczLZgIBPht4Y5E2v5fCFDkHb6WPVzA+pId8v1j0TFqx40a70l33Wk5UqZ4UAUF2wQjYEaCpRXhzdgnBXwzaTDLytefU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zT9fpdfg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zT9fpdfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D051F00A3A;
	Wed,  9 Sep 2026 13:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961850;
	bh=8G8rlhSNpsO5WN2Fhpo2LO97geU+p7dBiRg0nD3nb6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zT9fpdfgzkBWJ1kA1d6NeMXWUjSi2daXAwWp+XefHO6+lVN0eprieAmva9iI0rNaR
	 cpaaO+l2z3p15LRtbOEc3Hl9A5QUsv9ms35g6CrlAxkqz0Sq1Rurp86+1TkkO+46OM
	 bjw06KcgChr3ab89an2wLNVw891E1HZRZ5pNYIWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 089/556] mm/damon/sysfs: kobject_del() target (normal), context and kdamond dirs
Date: Wed,  9 Sep 2026 15:36:09 +0200
Message-ID: <20260909134233.636820194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

commit 263af33a72d1995ae6cdc22b08d527e2bda17259 upstream.

Patch series "mm/damon/sysfs: kobject_del() directories that users can
create/remove".

DAMON sysfs interface allows users to create and remove arbitrary number
of directories on sysfs, using a few files having 'nr_' prefix.  For
example, 'nr_kdamonds'.  When the user writes a number 'N' to the files,
directories having name starting from '0' to 'N - 1' are created in the
same directory.  The pre-existing number-named directories are removed
before creating the new directories.

For the removal of the existing directories, DAMON sysfs interface use
only kobject_put().  Because DAMON sysfs interface is the only kernel
component that manages the directories, there is no problem in normal
situations.  However, if CONFIG_DEBUG_KOBJECT_RELEASE is enabled, the
removal of dirs are delayed.  Let's suppose a user writes a non-zero
number to the 'nr_*' files while there are pre-existing number-named
directories, on the config enabled kernel.  DAMON sysfs interface
decreases the reference counts of the existing directories and immediately
creates new directories.  Because the removal of the sysfs directories is
delayed, it shows some pre-existing directories of the same names when it
tries to create the new directories, and fails.

For example, the issue can be triggered like below:

    # grep DEBUG_KOBJECT_RELEASE /boot/config-$(uname -r)
    CONFIG_DEBUG_KOBJECT_RELEASE=y
    # ls
    nr_kdamonds
    # echo 1 > nr_kdamonds
    # echo 1 > nr_kdamonds
    bash: echo: write error: File exists
    # dmesg
    [...]
    [  300.880458] kobject: kobject_add_internal failed for 0 with -EEXIST, don't try to register things with the same name in the same directory.
    [...]

Some of the error handling paths of the directories also lack the
kobject_del() call.  If the user uses nr_* file right after the errors,
similar issues can happen.

This doesn't cause catastrophic issues like kernel panics or memory
corruptions.  Users can work around by removing all directories first
(write 0 to the nr_* files) and then create new directories after
confirming the old directories are gone.  But, this is definitely a bug
that causes a bad user experience.

Fix the issues by calling kobject_del() before creating new directories.


This patch (of 11)

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for normal creation paths of target, context and kdamond
directories, and error paths of context and kdamond directories by adding
kobject_del() calls.

Note that this fix for target directories is not complete since it has a
similar issue in the damon_sysfs_targets_add_dirs() error path.  Because
the normal path issue and the error path issue are introduced by different
commits, this commit is fixing only the normal path issue.  A commit for
the error path will be added next.

Link: https://lore.kernel.org/20260628220121.97360-1-sj@kernel.org
Link: https://lore.kernel.org/20260628220121.97360-2-sj@kernel.org
Fixes: c951cd3b8901 ("mm/damon: implement a minimal stub for sysfs-based DAMON interface")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -333,6 +333,7 @@ static void damon_sysfs_targets_rm_dirs(
 
 	for (i = 0; i < targets->nr; i++) {
 		damon_sysfs_target_rm_dirs(targets_arr[i]);
+		kobject_del(&targets_arr[i]->kobj);
 		kobject_put(&targets_arr[i]->kobj);
 	}
 	targets->nr = 0;
@@ -1644,6 +1645,7 @@ static void damon_sysfs_contexts_rm_dirs
 
 	for (i = 0; i < contexts->nr; i++) {
 		damon_sysfs_context_rm_dirs(contexts_arr[i]);
+		kobject_del(&contexts_arr[i]->kobj);
 		kobject_put(&contexts_arr[i]->kobj);
 	}
 	contexts->nr = 0;
@@ -1682,13 +1684,15 @@ static int damon_sysfs_contexts_add_dirs
 
 		err = damon_sysfs_context_add_dirs(context);
 		if (err)
-			goto out;
+			goto del_out;
 
 		contexts_arr[i] = context;
 		contexts->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&context->kobj);
 out:
 	damon_sysfs_contexts_rm_dirs(contexts);
 	kobject_put(&context->kobj);
@@ -2505,6 +2509,7 @@ static void damon_sysfs_kdamonds_rm_dirs
 
 	for (i = 0; i < kdamonds->nr; i++) {
 		damon_sysfs_kdamond_rm_dirs(kdamonds_arr[i]);
+		kobject_del(&kdamonds_arr[i]->kobj);
 		kobject_put(&kdamonds_arr[i]->kobj);
 	}
 	kdamonds->nr = 0;
@@ -2559,13 +2564,15 @@ static int damon_sysfs_kdamonds_add_dirs
 
 		err = damon_sysfs_kdamond_add_dirs(kdamond);
 		if (err)
-			goto out;
+			goto del_out;
 
 		kdamonds_arr[i] = kdamond;
 		kdamonds->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&kdamond->kobj);
 out:
 	damon_sysfs_kdamonds_rm_dirs(kdamonds);
 	kobject_put(&kdamond->kobj);


