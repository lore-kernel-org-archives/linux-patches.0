Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7836627F4F5;
	Wed, 30 Sep 2026 15:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782912; cv=none; b=bzz14QGXI3zbpHOLCDyPmUzoIrKyrEsecltA9vY0bR+BfZjPnBC/fVxXUlH26ywiQ5rGUoXLq+TbksOTbDSwmgSODYqHABclhDHfRmaayGi0DvhpVRqVx1RTxc5DpxeMlF1siDHYzgkOhgleC2aUSbfXLeiKBE8AwKkiFIw9lUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782912; c=relaxed/simple;
	bh=dIBT/e3p9cbyTxJhGJCboqUgnX7vmoIzov/aQjxlA7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vDJuiTZFMXAE4CLp7LvKWkB0jCGZL9lWCrOh73kVxQORvplP4F57btcMRZ1Xki+vtsOJlRF1lg3EFAnMBm3yEtOmAik18RxP6eGw7DXlikcXT5W3qSORQsL0aGkKjUtb4L+67MxuwEBoejgcoPnAPwbMbyYNZhxkCF7IwHoPqmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frll0LfJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frll0LfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADE31F00898;
	Wed, 30 Sep 2026 15:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782905;
	bh=qbHEC+3u87UTVZcfglfgM/M6xxrnmI8c76msFNhKfGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=frll0LfJxayWpXDFy1twRhzfvgHsQPd0zFLJL1fKyk+lxPCnxKhQniNo2ahV111bt
	 HVAt06c+5hN7JELOWJ1IgSAXZr2t3pPOqAkzLQ4nN/tHwpb+5G/FQzijKX9bTMRMkI
	 HaOHl8KAx5B1Q1GxMpnchQrFh7A+PvKoP+Rdzzvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Tao Cui <cuitao@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 166/595] blk-cgroup: fix leaks and online flag on radix_tree_insert failure
Date: Wed, 30 Sep 2026 17:20:59 +0200
Message-ID: <20260930152351.310514516@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7ffdc3360a6c2..8f6f11ba8ef57 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -295,15 +295,15 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg,
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



