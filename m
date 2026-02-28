Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC00F372235;
	Sat, 28 Feb 2026 17:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301522; cv=none; b=sRBCBSx77UtzOengMsxuwbNhDVKbtyq+FE2E7I1ghfksIrp1yHxtDWoDcbT8h7/yl29K3LgvtaTTlSkmuV8zYQo8885ocTzfBiPFvUstZYNqYNWknMkPCY6yS/X/H5BKFln8eJsC0ILwP1H8ljV5NDRL6pGjB/poC6nnNwbMAME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301522; c=relaxed/simple;
	bh=wCnE7cEyShlxOeQ+GQYspjb7N7YcTMi/8A5wfEM+Tc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcZ6WrkXDklo8DFDrScsrwDzKWyg6LgvyMn97IRI0LZJPUaNRCcHCYbrtlze+mb4TQNJPA0SscOUstqbgLnb0ytWvKHy+nqreZvOsPA3WNMYcWs+1ZUkWPERHaD77GJnclAlJczC8dVVJKfOK8hGxKbztA0mepfGRxZzAZvPlGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rWl1d6i0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rWl1d6i0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D796BC116D0;
	Sat, 28 Feb 2026 17:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301522;
	bh=wCnE7cEyShlxOeQ+GQYspjb7N7YcTMi/8A5wfEM+Tc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWl1d6i0zzifWnKzRkUXt6frbF4vinErvrK+r9DGbOnT4nZQ8nxCFEL9hiWETYhvX
	 xqD38y5JH9QhtzNISCo88A1WjtHhuVb1kQMWZhFEoPwPA60LJ9lnNSReEA7Grb0yjv
	 Y3chxX7Nd/VH5KPp1MSqXQX2VocDW/pYt+jjv9PTKGX6W8IXpKM49tF6KhJya6KVRq
	 yjCrCC0syE8rWlM9VX9b9wWy7zqZz7KTjN1/Kx3nyjhUuzKDDFF5+7UG5yt3JiPcnV
	 8oQw3HTb/f65zzP7izXkp3WR1cPJk8C6w43/33zBTVPWXHEnO5N9YnCfAT1hxogJBH
	 0RTW2uGsJD1Cg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Andrii Nakryiko <andrii@kernel.org>,
	Ruikai Peng <ruikai@pwno.io>,
	Thomas Gleixner <tglx@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 707/752] procfs: fix possible double mmput() in do_procmap_query()
Date: Sat, 28 Feb 2026 12:46:58 -0500
Message-ID: <20260228174750.1542406-707-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 61dc9f776705d6db6847c101b98fa4f0e9eb6fa3 ]

When user provides incorrectly sized buffer for build ID for PROCMAP_QUERY
we return with -ENAMETOOLONG error.  After recent changes this condition
happens later, after we unlocked mmap_lock/per-VMA lock and did mmput(),
so original goto out is now wrong and will double-mmput() mm_struct.  Fix
by jumping further to clean up only vm_file and name_buf.

Link: https://lkml.kernel.org/r/20260210192738.3041609-1-andrii@kernel.org
Fixes: b5cbacd7f86f ("procfs: avoid fetching build ID while holding VMA lock")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reported-by: Ruikai Peng <ruikai@pwno.io>
Reported-by: Thomas Gleixner <tglx@kernel.org>
Tested-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com
Cc: Ruikai Peng <ruikai@pwno.io>
Closes: https://lkml.kernel.org/r/CAFD3drOJANTZPuyiqMdqpiRwOKnHwv5QgMNZghCDr-WxdiHvMg@mail.gmail.com
Closes: https://lore.kernel.org/all/698aaf3c.050a0220.3b3015.0088.GAE@google.com/T/#u
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/task_mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 2ee152a318f50..b490245ff9be7 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -780,7 +780,7 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 		} else {
 			if (karg.build_id_size < build_id_sz) {
 				err = -ENAMETOOLONG;
-				goto out;
+				goto out_file;
 			}
 			karg.build_id_size = build_id_sz;
 		}
@@ -808,6 +808,7 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 out:
 	query_vma_teardown(&lock_ctx);
 	mmput(mm);
+out_file:
 	if (vm_file)
 		fput(vm_file);
 	kfree(name_buf);
-- 
2.51.0

