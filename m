Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B681A3B2D1A;
	Wed, 30 Sep 2026 17:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791171; cv=none; b=kpOo/RxxSwihhoofK7xgh+gT/X46wJ9Ur2K2rWUOfyhneRbabcUG7ZE/hgmWXshmYxjpfFZaU+thkIWWjnKr9p+o3MbjlaLYhvQXINJjlQTnLvB2ZytH5nOR9TZHhc036yG/rTIQAFF90IC4cESOUAxugymAUc4RlPCoO3967Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791171; c=relaxed/simple;
	bh=TIahjvaUjWP5OgOTTGt5JX/y17BWxKPxjf8Pr7qFtSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=quUO8qXRVbNEmawaXj4QWONbtmKCx2rioL4SNZNrLeL7VcnMWZ1PZf7H1ocxQJUwr1C0sxQ/Hs4VDKBy73Q70z71gEAh2Auqe5Kzp6RwUEQng5ux62Opy5oXHBenxYKModkJ3uccQVxTCUAuAsMk1FGhvQJVy2o63mZ1Dn9uXc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkkRjyVt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkkRjyVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D16B1F000FF;
	Wed, 30 Sep 2026 17:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791170;
	bh=2EPpeBaygn1w9Bu7EUscC5x+FZ0sf1xB/lB2wCX/8TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GkkRjyVtiNDJGdjEpOO8S5eMlfe/V2J3yYs7sytyMPRUQvxvOnq9aYGPC4QQgGtcr
	 nHkSvoQMtzdEhvS0N9RWTXLzsDr4rumXIc3zpjPE2Hjwzi0jLQY5Q81q6RqlGj1Oxp
	 O6ES9m3gm9a8/CUr6kjqYrxmYkK45h6GxsMpbTlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Tao Cui <cuitao@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 208/752] blk-cgroup: fix leaks and online flag on radix_tree_insert failure
Date: Wed, 30 Sep 2026 17:21:18 +0200
Message-ID: <20260930152402.732693810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1179c4bee7052..4e8546adfce2b 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -296,15 +296,15 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
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



