Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F132EBB8D;
	Tue, 21 Jul 2026 20:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667253; cv=none; b=pOL0bbrZnrBe9io/dMqR2Hm/SVH9CkHJyRd2JOmkj9bsXD5Buo5UAKYCz6l6SncXM/RP+C04Dov+f4JaYM00tCtgG4qSuzrgtgNnaPOuSs3JwV1D/CV4rdjilgRo+Z6V+xuuK/E5tO738SYTyEh4IphbiKNEKSQqY0FZxnmsnzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667253; c=relaxed/simple;
	bh=KLkk2wOZ0HGv8DvRyi12AWsX7drLRXos0OtnT2WQ7cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4jBavLokNNKPDEU+60uydo482tU8l2EPf8Lse+M/AO+XxgNSIGwJ9NstAmrhexB5nk7d3vZtfnCKeqIEQ+VcfbPiRdPKHpyOKp6sXzhWRVr36JOltDgR/DkIFZ33TQwIPekyG8UVMCBj1zLDGjHjV4WuWr5MbrWn2EuufanXrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBsaafTH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBsaafTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8781F000E9;
	Tue, 21 Jul 2026 20:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667252;
	bh=kxx4QFjfa3MzRLuXK4hQu9EyooQ9qeJJEybuYRj6Ibo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EBsaafTHUO3dfzNu/Qteysx/D+toU7rZkGVcADYnbEWUMRq6psk+yEpB9tfNpDyTL
	 GRhCGusxjhP5DLy+bE2harU+n0/hGW5mNBZaWhgVkcO9Pmx3uIs9Fps0bMur4BZ9b2
	 wfTLTqAOwiOLntqX8pPZX5w3QVuu0jMCb32U6g4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 0991/1266] mm/damon/sysfs-schemes: put stats for scheme_add_dirs() internal error
Date: Tue, 21 Jul 2026 17:23:48 +0200
Message-ID: <20260721152504.009006487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 05ea83ee88ca70f8932906d9f2617ff996f45b50 upstream.

damon_sysfs_scheme_add_dirs() setup the tried_regions directory after the
stats directory setup is completed.  When the tried_regions directory
setup is failed, the setup function ensures the reference for the tried
regions directory is released.  Hence the error path should put references
on setup succeeded directory objects, starting from the stats directory.
However, the error path is putting the tried_regions directory instead of
the stats directory.

As a direct result, the stats directory object is leaked.  Worse yet, if
the tried_regions directory setup failed from the initial allocation, the
scheme->tried_regions field remains uninitialized.  The following
kobject_put(&scheme->tried_regions->kobj) call in the error path will
dereference the uninitialized memory.  The setup failures should not be
common.  But once it happens, the consequence is quite bad.

Fix this issue by correctly putting the stats directory instead of the
tried_regions directory.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260618005650.83868-3-sj@kernel.org
Link: https://lore.kernel.org/20260617005223.96813-1-sj@kernel.org [1]
Fixes: 5181b75f438d ("mm/damon/sysfs-schemes: implement schemes/tried_regions directory")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1303,12 +1303,12 @@ static int damon_sysfs_scheme_add_dirs(s
 		goto put_filters_watermarks_quotas_access_pattern_out;
 	err = damon_sysfs_scheme_set_tried_regions(scheme);
 	if (err)
-		goto put_tried_regions_out;
+		goto put_stats_out;
 	return 0;
 
-put_tried_regions_out:
-	kobject_put(&scheme->tried_regions->kobj);
-	scheme->tried_regions = NULL;
+put_stats_out:
+	kobject_put(&scheme->stats->kobj);
+	scheme->stats = NULL;
 put_filters_watermarks_quotas_access_pattern_out:
 	kobject_put(&scheme->filters->kobj);
 	scheme->filters = NULL;


