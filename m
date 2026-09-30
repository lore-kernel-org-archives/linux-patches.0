Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06A13B1ED7;
	Wed, 30 Sep 2026 18:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794720; cv=none; b=ar0lIUGa2j6c9DYwipQWtYekmS0U8ulKzDnuupC0wf7g/D6Wj0Dbf0xlVYYspQbfmS2dLI9tP+4OlA4FhmX7CPk7q4m6d/AuwBfpwO7JPZ5zWL5dX6R/MmJvCw0EK3hHh3LhR17AttgmYjcFd0zNjYv7X0lpnl1KkPoqkBQJa9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794720; c=relaxed/simple;
	bh=653X3crqDbsx10DBGheBO/8uiHl55eYhWmQEAWrNpxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W1JD37zK7XUmJhXDJrJfXFzjIqCmwqSuXDdlk9Ij91jIKj9Nu5Rh5CaMdqurqmTMEth9TJZFxC0yh2J8H0LzGik1CPyeMROFbvfczKpMy6IeJYNpuDA+7gtn8pIEGT2TmgUzqTjHbU94dSFyDuXj9QqHWHfEisA4rXTbL4PvRUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ce5u6fav; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ce5u6fav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391F21F000FF;
	Wed, 30 Sep 2026 18:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794719;
	bh=LyGusqxtZYU3fCXIyIuPGEiboAEzmvTdcml5kWZaEdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ce5u6favC0IN4jpzaXbT/U43fbBGEUstuULUCLaD1oDkA+NrxvfPJYZydjaZmRn4q
	 8ImOIgTk2GWpBacKke+vEeb9sdC3OHojRkBHWLENddj0k6YMCy0gR81qlUB2jnFGI1
	 Gx52D38R7Di0Ouqg77TBqr3y64rPbhhoF+Z+5T4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Tao Cui <cuitao@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0309/1193] blk-cgroup: fix leaks and online flag on radix_tree_insert failure
Date: Wed, 30 Sep 2026 17:16:33 +0200
Message-ID: <20260930152441.010621001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cd30f2ca561f5..9b1034fe8c879 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -439,15 +439,15 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
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



