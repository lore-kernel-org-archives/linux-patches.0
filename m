Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAC68462;
	Thu, 17 Apr 2025 18:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916072; cv=none; b=TLQqoH/+0dzgbW7H7eldImQ7kNV8VbMhz2RMZz3oaeMBnhpFmOeWxIcdIKVoevI3pilOgHv+v7UICPzRk0lhJGpVm4ErC++lRKWb9k+RflsDozGJHnxePlkTL3w1v6ckqB4d64OEokyHwNi3vtR24Q1mJ3yDd2Nf1A0wD/o8fYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916072; c=relaxed/simple;
	bh=5ei4Urceerb7+ogEkt2cQ6A3lOp7tyFzJoR8m8EO7/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QI+08qyMhxJ3K/K1pOZCus3FGg/LvWOD3SPfoSL3+F4yXfNcGFpb5lRsfNI3OlBKHfpku+P4uMBP+inQD/fAPetAy6JeIVSWMW/PqU6JYBGFObbXq2ySYbgveQp8jzljvTvpsElJ0lESdsVHuLzJ4fAo4X57sIfAl+bQbeQwCBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMhknN7M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMhknN7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95916C4CEE4;
	Thu, 17 Apr 2025 18:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916072;
	bh=5ei4Urceerb7+ogEkt2cQ6A3lOp7tyFzJoR8m8EO7/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMhknN7MprG3ujE01SE8fiX6eQXNkMq15zvwIaHEH7i59G9VMnjcQkmIDPg8b9IGt
	 7zRZvUGwkMP3UijHQtTvlES4bgXbERZ+OAW//EbT0MhuShZZC2wHNRuLxliZxtP0P9
	 +P8yCJBYqCdZqbrwUkTeAWSmkWHGR7sYQXJGRqYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 334/393] dm-verity: fix prefetch-vs-suspend race
Date: Thu, 17 Apr 2025 19:52:23 +0200
Message-ID: <20250417175121.037954749@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 2de510fccbca3d1906b55f4be5f1de83fa2424ef upstream.

There's a possible race condition in dm-verity - the prefetch work item
may race with suspend and it is possible that prefetch continues to run
while the device is suspended. Fix this by calling flush_workqueue and
dm_bufio_client_reset in the postsuspend hook.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -796,6 +796,13 @@ static int verity_map(struct dm_target *
 	return DM_MAPIO_SUBMITTED;
 }
 
+static void verity_postsuspend(struct dm_target *ti)
+{
+	struct dm_verity *v = ti->private;
+	flush_workqueue(v->verify_wq);
+	dm_bufio_client_reset(v->bufio);
+}
+
 /*
  * Status: V (valid) or C (corruption found)
  */
@@ -1766,6 +1773,7 @@ static struct target_type verity_target
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,
 	.map		= verity_map,
+	.postsuspend	= verity_postsuspend,
 	.status		= verity_status,
 	.prepare_ioctl	= verity_prepare_ioctl,
 	.iterate_devices = verity_iterate_devices,


