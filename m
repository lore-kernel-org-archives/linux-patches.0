Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B921638DC59;
	Sat, 12 Sep 2026 10:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208882; cv=none; b=DFd1/sJKyLS8lZYgErEI1tiZHRt/PDXRKcMrw7PitP3Eg7fjdVZvFKs/eE6unDUozsigrlxDZqjCGY/KRI3ccHncfcJbOGzjBkUMxTE5zwm4EXm96p0Q7n5ykO+z/6YaouQmNAd0SgARRFOFMMUS6im1PutdvWzULqwqgwl+s1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208882; c=relaxed/simple;
	bh=nPM9OfFnrqwaZOs0hXlrzwogdH487mmzSfFNsF2sg/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVTZiMDa4vRz727dqmr2vmv1itj/OkWBirSgxhUW+4HDY1UfRVHJUX8ZMNnCKs2SNIYzm7/AEygq0pzPosAltBjbUMiwpJrIQg4MjjhfoXwy6DXJTM4i8weBkZ4vc/rhv6eWPN66I4eYi/hqNlpo6AS3vZd18Vj/L0gRfkbyCJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4aLFitT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4aLFitT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD89D1F000FF;
	Sat, 12 Sep 2026 10:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208881;
	bh=87HeFd7zUOv49PgGAunUqUJHxdnbljTnoP0rV+JH+QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4aLFitTi1I8CYdMf+PKx5tqpY5GJkqX4yde7yp6x/mwACIXRSpdpVui0buIyxxqF
	 Vq46umtrKoMwjEPesyVCjcLdGf5Dz3GM6ZpWXkvvUQWPe2XGh/L9zfiLTd4/S38wlw
	 D3bI7cnvvZcBNgDJbn9IdKNxuPkg1PbP+FlW/ft8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Cheng <chencheng@fnnas.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0708/1518] md/bitmap: resume array on backlog_store() error path
Date: Sat, 12 Sep 2026 08:47:57 +0200
Message-ID: <20260912065639.448784673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Cheng <chencheng@fnnas.com>

[ Upstream commit 2911cd0a0f4366a7e06832bc5f0a7fdcc138e4dc ]

backlog_store() suspends the array before checking whether a write-mostly
device exists. If no such device exists, the error path only unlocks
reconfig_mutex and leaves the array suspended, blocking subsequent I/O.

Use mddev_unlock_and_resume() to release both states.

Fixes: 58226942ad3d ("md: use new apis to suspend array before mddev_create/destroy_serial_pool")

Signed-off-by: Chen Cheng <chencheng@fnnas.com>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260718034236.4119093-1-chencheng@fnnas.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 2a95840782927..110c236045dcc 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2862,7 +2862,7 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 	if (!has_write_mostly) {
 		pr_warn_ratelimited("%s: can't set backlog, no write mostly device available\n",
 				    mdname(mddev));
-		mddev_unlock(mddev);
+		mddev_unlock_and_resume(mddev);
 		return -EINVAL;
 	}
 
-- 
2.53.0



