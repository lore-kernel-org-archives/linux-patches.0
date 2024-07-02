Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C33814293;
	Tue,  2 Jul 2024 17:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940890; cv=none; b=slXP9B/U9IWIdOL/PQBlpX+FObQf8z6Iy5VbwR4HcfAnB4NIrTar8RRA6HZA4Zpg9+UcqzNNgbSlPzQIu4abeQR0/7GGJRspcJrFFska8ENRCQudj00QHEOtUjntnWKfI6R/8FD/ishqzO7r8kmA8DHPlvuq4BO9ZQBv4B/DfNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940890; c=relaxed/simple;
	bh=SNzhYhDpL+de/L7kHma+tHTiaZAuAOdGzaT7AvGwGG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EoqGfzI7Nwt97KFktTG9TGs4IYpQWw1M6BLz/fWkYF1XIyepGYT/Ire5c4GRBw6LebbYcKAifWC5ew07ujDio9qRzqkmkRLyoXRffRh3gIQsYDO3LE8Qtf6lLjp5aHTtrAlPDyR9E8+WqeYgCdG2kiBwzjoMTemgzACcj/jNUUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4Nhdrhc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4Nhdrhc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B2FC116B1;
	Tue,  2 Jul 2024 17:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940889;
	bh=SNzhYhDpL+de/L7kHma+tHTiaZAuAOdGzaT7AvGwGG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4Nhdrhcoid6bdvK71mtjyHBTanfeOultu+eAOmqdM76yqwYz1zyRNpxNnThRaoed
	 8JJHYEekLzGgvI74SCzLis+J1NEMoeb+IVVpSoZa9zzpPIL+h2owFPP6mRZcurX5A2
	 r+J0PC69p6rvJUUbppT2leGYcjlJxAHV74ioHu3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/163] media: dvbdev: Initialize sbuf
Date: Tue,  2 Jul 2024 19:02:59 +0200
Message-ID: <20240702170235.524611056@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 17d1316de0d7dc1bdc5d6e3ad4efd30a9bf1a381 ]

Because the size passed to copy_from_user() cannot be known beforehand,
it needs to be checked during runtime with check_object_size. That makes
gcc believe that the content of sbuf can be used before init.

Fix:
./include/linux/thread_info.h:215:17: warning: ‘sbuf’ may be used uninitialized [-Wmaybe-uninitialized]

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvbdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 733d0bc4b4cc3..b43695bc51e75 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -956,7 +956,7 @@ int dvb_usercopy(struct file *file,
 		 int (*func)(struct file *file,
 			     unsigned int cmd, void *arg))
 {
-	char    sbuf[128];
+	char    sbuf[128] = {};
 	void    *mbuf = NULL;
 	void    *parg = NULL;
 	int     err  = -EINVAL;
-- 
2.43.0



