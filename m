Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96062686AA;
	Tue,  8 Apr 2025 11:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111004; cv=none; b=M+iTBjSGE6Fn+fGheivhcYUOSbi2Qd93YG6hx85APO+p2I4XdUMmS1mq1EG1Ho92DWLWyFd6VaZivjajdbyfUDstMogbVxqdTE6cSoAZWdmVrgWBv77efN4dQuILQ422aQCWPFbVcIcg+L0T3EZD8aMnJtT/U8RnqQpjjefN1Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111004; c=relaxed/simple;
	bh=FxagNngIiWeZHZip6UjfaVSbHi9MzzFySYovINNIUuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VL1CjTd+U8VWTlvTtomFOU5+u4Ju4PMbNuDXGwaSoyzfvbdRABspU8392sSq7GFVgYYrR+JGi5tF1zp391JaRJ39EoVQ6PBqhjhwHU29/qNLglI2H/m8Mrj8uq4juoJ06N9Bjo2mNcMj5/j2Mc45WSeMifjGYZtAaw8Z1Vg2bmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UeEN1JVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UeEN1JVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534A4C4CEE5;
	Tue,  8 Apr 2025 11:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111004;
	bh=FxagNngIiWeZHZip6UjfaVSbHi9MzzFySYovINNIUuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UeEN1JVLU6VQsoHwOaRFnBfSgLtdJuyK4tiLo4YNxnRkG5IyfxKWon+7j1htO4gIG
	 X0FEcG4ZoBmJVF8Hm3YyvK/5a9oqbb1kJshEy6JLDUgh0AE1ErqQ3yHLjVhFd+fO8r
	 zgO5Qh2NpsR4x1DKToRyEQTxgRhrxyDH2VrYvGU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 274/731] drm/panthor: Fix race condition when gathering fdinfo group samples
Date: Tue,  8 Apr 2025 12:42:51 +0200
Message-ID: <20250408104920.649262294@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit 0590c94c3596d6c1a3d549ae611366f2ad4e1d8d ]

Commit e16635d88fa0 ("drm/panthor: add DRM fdinfo support") failed to
protect access to groups with an xarray lock, which could lead to
use-after-free errors.

Fixes: e16635d88fa0 ("drm/panthor: add DRM fdinfo support")
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250130172851.941597-6-adrian.larumbe@collabora.com
Link: https://patchwork.freedesktop.org/patch/msgid/20250107173310.88329-1-florent.tomasin@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_sched.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 77b184c3fb0ce..1349581196780 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -2878,6 +2878,7 @@ void panthor_fdinfo_gather_group_samples(struct panthor_file *pfile)
 	if (IS_ERR_OR_NULL(gpool))
 		return;
 
+	xa_lock(&gpool->xa);
 	xa_for_each(&gpool->xa, i, group) {
 		mutex_lock(&group->fdinfo.lock);
 		pfile->stats.cycles += group->fdinfo.data.cycles;
@@ -2886,6 +2887,7 @@ void panthor_fdinfo_gather_group_samples(struct panthor_file *pfile)
 		group->fdinfo.data.time = 0;
 		mutex_unlock(&group->fdinfo.lock);
 	}
+	xa_unlock(&gpool->xa);
 }
 
 static void group_sync_upd_work(struct work_struct *work)
-- 
2.39.5



