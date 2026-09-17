Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D7250128E;
	Thu, 17 Sep 2026 17:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664893; cv=none; b=MGO/AK4+DYXHdufy5h5/2U40zAbvxIkxAraFs+FAM6mxAtvN/68d1p0e2ShkYH329PjXXtzwlZHUt6VEPANmoZzuaP0L136rzIQ5cZzubcHaazxqhkMlQB0S19EQefPd5rynXWuiBtrJ3pTWS5DOa2AoLXlzGOUWRtVjuXxD6VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664893; c=relaxed/simple;
	bh=DYGWe4KhtoPkqMk+vAzOzzNyGbqzm5lV+T+ylOxLQfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E1WzvQCzIGEpFJO0kOK+vPXEz5JjN2+Iq8PIlw7exB1TM/EaJXmHXAczDtVn+0zmn0dLGWmCHryj8BUnxHRhyrOcUkdpJDprk/ggjiewGw5n8PKeBELQZ4S4FlBS+bNYCoUjBHm8HLbljZAzNZ/nBN12/qS4tZ1rltG9B4J5obY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q20pjbm7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q20pjbm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D99D1F00898;
	Thu, 17 Sep 2026 17:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664891;
	bh=Y2pVZJDvUu+sJ13f8Y0ZTuxSH9WH5zDcbZrnqW6/ZbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q20pjbm74akdERux2k5Pb7KHFfFZqiVK299hJHVgEyvvSTC+a4PuGmIhfyTIQU74n
	 aVk641FMqxacs+boDEPoxhhspLzm/pC2hpKH4T3Wj30Rjy7dz6onx2nF1gVgi+UfKe
	 MBc+r6l+BTmerKGyTExcXDv0iP8Rw4EwV2x2jPr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Tao Cui <cuitao@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0524/1250] blk-cgroup: fix leaks and online flag on radix_tree_insert failure
Date: Thu, 17 Sep 2026 16:05:19 +0100
Message-ID: <20260917151606.149119836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit dbbca20764382b4d411ec2918f4e278ffe547acc ]

When radix_tree_insert() fails in blkg_create(), the error path has two
issues:

1. blkg->online is set to true unconditionally, even when the blkg was
   never fully inserted.  Move the assignment inside the success block.

2. The error path calls blkg_put() without first calling
   percpu_ref_kill().  Because the refcount is still in percpu mode,
   percpu_ref_put() only does this_cpu_sub() without checking for zero,
   so blkg_release() is never triggered.  This permanently leaks the
   blkg memory, its percpu iostat, policy data, the parent blkg
   reference, and the cgroup css reference — the latter preventing the
   cgroup from ever being destroyed.

Fix by replacing blkg_put() with percpu_ref_kill(), matching the pattern
used in blkg_destroy().

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Link: https://patch.msgid.link/20260715132407.1469777-1-cui.tao@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f638d3dd5ebcf..171efbbd3c8a8 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -432,15 +432,15 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 				blkg->pd[i]->online = true;
 			}
 		}
+		blkg->online = true;
 	}
-	blkg->online = true;
 	spin_unlock(&blkcg->lock);
 
 	if (!ret)
 		return blkg;
 
 	/* @blkg failed fully initialized, use the usual release path */
-	blkg_put(blkg);
+	percpu_ref_kill(&blkg->refcnt);
 	return ERR_PTR(ret);
 
 err_put_css:
-- 
2.53.0



