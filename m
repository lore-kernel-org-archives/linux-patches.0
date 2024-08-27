Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7EB1C4EE6;
	Tue, 27 Aug 2024 15:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772270; cv=none; b=ZdKCeDbKmC5QhXp/FzwcZsSD8W7xYGnkzHZtxJcYdKzYrFsGmorsgjNYoK0j6aoEG4H0O5imMLrHHgaJAt3YiyS941kOureK7qMnwkY/BbhVk/6QP1AeUUF0fcku/4lIFI2Rm6bY8jvSwQZXfDhYsb++W+VCusICCK6OOWwtsr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772270; c=relaxed/simple;
	bh=TnGDE5GvqJPwUL6+ljwvOIX2T/sPNsEH0nlnk8HW6ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kHMiS+o/Eyxr32cVZxtSw6E2TSdPOixkRe/a2CWEOpWY/PH/ui0nivyoqCQeCJBikmAJiXm9dqAxh+qU4h4n7eTlaybJ3dtZMoWEfUMlMS8CkleRCo4u6ul+J3mVuZXG/Wm6k+6gzn3+IgyzXAfhD3fckwooljaYCDVdrDjMNs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I87Dld23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I87Dld23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A74FC61071;
	Tue, 27 Aug 2024 15:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772270;
	bh=TnGDE5GvqJPwUL6+ljwvOIX2T/sPNsEH0nlnk8HW6ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I87Dld23Y10tZlZcWIBBI+tKuFRKnIcErvv9jITJ/nYrJcVVjFRVO8jueACA2+47A
	 idGID/W9x3ku8Kh0nVt/UigelXUQvbOIfOZnAP0VCLSfeSzB17920K9+oDWgKa6F0I
	 bn2T81kHAACnAfVocuBBy0kQ657ohr7pcvyTejl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neel Natu <neelnatu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/321] kernfs: fix false-positive WARN(nr_mmapped) in kernfs_drain_open_files
Date: Tue, 27 Aug 2024 16:37:51 +0200
Message-ID: <20240827143844.435919905@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neel Natu <neelnatu@google.com>

[ Upstream commit 05d8f255867e3196565bb31a911a437697fab094 ]

Prior to this change 'on->nr_mmapped' tracked the total number of
mmaps across all of its associated open files via kernfs_fop_mmap().
Thus if the file descriptor associated with a kernfs_open_file was
mmapped 10 times then we would have: 'of->mmapped = true' and
'of_on(of)->nr_mmapped = 10'.

The problem is that closing or draining a 'of->mmapped' file would
only decrement one from the 'of_on(of)->nr_mmapped' counter.

For e.g. we have this from kernfs_unlink_open_file():
        if (of->mmapped)
                on->nr_mmapped--;

The WARN_ON_ONCE(on->nr_mmapped) in kernfs_drain_open_files() is
easy to reproduce by:
1. opening a (mmap-able) kernfs file.
2. mmap-ing that file more than once (mapping just once masks the issue).
3. trigger a drain of that kernfs file.

Modulo out-of-tree patches I was able to trigger this reliably by
identifying pci device nodes in sysfs that have resource regions
that are mmap-able and that don't have any driver attached to them
(steps 1 and 2). For step 3 we can "echo 1 > remove" to trigger a
kernfs_drain.

Signed-off-by: Neel Natu <neelnatu@google.com>
Link: https://lore.kernel.org/r/20240127234636.609265-1-neelnatu@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/file.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index e4a50e4ff0d23..adf3536cfec81 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -532,9 +532,11 @@ static int kernfs_fop_mmap(struct file *file, struct vm_area_struct *vma)
 		goto out_put;
 
 	rc = 0;
-	of->mmapped = true;
-	of_on(of)->nr_mmapped++;
-	of->vm_ops = vma->vm_ops;
+	if (!of->mmapped) {
+		of->mmapped = true;
+		of_on(of)->nr_mmapped++;
+		of->vm_ops = vma->vm_ops;
+	}
 	vma->vm_ops = &kernfs_vm_ops;
 out_put:
 	kernfs_put_active(of->kn);
-- 
2.43.0



