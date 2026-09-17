Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4723C4E77FA;
	Thu, 17 Sep 2026 18:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668425; cv=none; b=gnZdvhJYre5KUjnLgAys+Cl0LzuSYsXKUV/hdUlJOlzv9CoNoWCEZ0P58qczWQ498hGZFLRbWwNlGylR7QzeYYO8iHrqNBmimRIh0sfFZitakWO3ezbgulo2nafR1Hhx7SQv7rOB4bTeDCbysZlsdBONDJVmr7sjH3Mv5ffiGjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668425; c=relaxed/simple;
	bh=x0jPxA3/dnhKz7DJ9ABtm6F9hW4sd3tG2hqxk37fRLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nRuL9/CkI8Jc/ijNMmXs+i+lL0xBzdo23kOKsKEjSwQj53EgPkgtoSVn66jpZnZJPWU8fnkPap/INOdf78YuKT32h8eTzGktM2vqTZty9yd61+RF8IrTdWjNzk+LKXAniSreKnYjGb2UNPC9EYqEEdpjkCa+R2PyrjGcOFzJC2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSKZ7Ulf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSKZ7Ulf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238181F000FF;
	Thu, 17 Sep 2026 18:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668422;
	bh=fq0MZWaufRTUmOrwLToLVOKj6wAbsRofuDtFoWbVzTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSKZ7UlfGPGf42Fpu2vTzxjSqfZA5i5+4BQzaS3lcF6bXJq++u2KdP7YcFXbbPEAR
	 w7zbGFtEV+KmMPMHbB2MJF+JTFCom0by9a6+PvwmIRyP0nZNoNTQl3b/9OaR4UycoO
	 FEvFyWYGo6OiV+mvNxjrEU9eyC1nmxV3XYVMrPFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Tao Cui <cuitao@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0421/1102] blk-cgroup: fix leaks and online flag on radix_tree_insert failure
Date: Thu, 17 Sep 2026 16:06:04 +0100
Message-ID: <20260917151550.237513001@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7f00e9e9cc061..d89da7e067f42 100644
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



