Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A0618A924;
	Mon, 28 Oct 2024 06:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098176; cv=none; b=EBhHRlBn20DtUG3r+EBHY4KwDLiym6U+mjHFwB8lUuHhXLWa48vIOYLffuKqpaHsk+b5JhdC9BDKWESm1Z2ON5JlcjFoC60iPmWSq7+kYH8tEFhUEu5Vn8Nm2B9wVBHhofX3wcYlmpV27YdirgHEyVYUhPeKN6DtjxN98TrDzlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098176; c=relaxed/simple;
	bh=Qgx/IOt2pU/WCc7WtaySsj4SjOnq0mYVrLXci2rl9d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdMOnqmJ5y6O1yQD63jS6IDJi3fA+q45TeCDcxAtW+NvPM7m/OVpXZcA7lnoOpocBo5oxHkcWrR4txjwCLaAaOhzNj3L2/RAOZh9JAC+SwKjPGWXI1ZzzYjvYfXts3LQgsKmri7iQ8CX6K+8KXXVJRuiwbb1GPJSeIR15JwPo7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEGy9yT8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEGy9yT8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5EDC4CEC3;
	Mon, 28 Oct 2024 06:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098175;
	bh=Qgx/IOt2pU/WCc7WtaySsj4SjOnq0mYVrLXci2rl9d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEGy9yT8myjqELJx41Ohrz76XpFSJXzA1spu2IBZfuBHYvNUuv+UJY3P2oUBiOmhC
	 Fae2aWi9iGRz7hn1Xqm6xa68KO4ptfCPQVdIAgooME3Tz0utYMWrEBRHEk+tdhwqTp
	 RQyowy5USSk24v87P45rOTYSZZV0ZlQb6wJXJzZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 111/261] cdrom: Avoid barrier_nospec() in cdrom_ioctl_media_changed()
Date: Mon, 28 Oct 2024 07:24:13 +0100
Message-ID: <20241028062314.811289260@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit b0bf1afde7c34698cf61422fa8ee60e690dc25c3 ]

The barrier_nospec() after the array bounds check is overkill and
painfully slow for arches which implement it.

Furthermore, most arches don't implement it, so they remain exposed to
Spectre v1 (which can affect pretty much any CPU with branch
prediction).

Instead, clamp the user pointer to a valid range so it's guaranteed to
be a valid array index even when the bounds check mispredicts.

Fixes: 8270cb10c068 ("cdrom: Fix spectre-v1 gadget")
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/1d86f4d9d8fba68e5ca64cdeac2451b95a8bf872.1729202937.git.jpoimboe@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cdrom/cdrom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 9b0f37d4b9d49..6a99a459b80b2 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2313,7 +2313,7 @@ static int cdrom_ioctl_media_changed(struct cdrom_device_info *cdi,
 		return -EINVAL;
 
 	/* Prevent arg from speculatively bypassing the length check */
-	barrier_nospec();
+	arg = array_index_nospec(arg, cdi->capacity);
 
 	info = kmalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
-- 
2.43.0



