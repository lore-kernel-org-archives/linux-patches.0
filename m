Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1957E10A1F;
	Mon,  4 Mar 2024 21:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587657; cv=none; b=AAkgkSsgfe3H6HyVSFNsFwe7KThlEZ01dEIn67jh6eqBjUEtBMPZPLJ5aqEdTAxM3Wh5iBkau8wXYUWOlXDF4a8KWaoOpiR8lmmGACKY+U5CxZrvde2ogD00iTpY02D8EY6ZqB1CkOcj0ccwRIsMDZ2izbtC3LGt/WhuKcO2cY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587657; c=relaxed/simple;
	bh=GhdmwJHtS3qRtesp4tcKPveB0huYheWWp2JP2ivhDuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uau6BjqsPugJ0vRTc99c6SEBtGEbEQ8nuMjtgcS6DoN1fWPQJGR2a7xb8Il9MMLp6KePxG30QyiycYn3K6ycW6k2nUxHkWEjYKE0SdrBWUDV/QewjYAYN7O11giaMACB0uCUBtmSSLaJQsVljKPU7o43vrO/xCnQq9QPJkWPc5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TW7sC/7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TW7sC/7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58661C43390;
	Mon,  4 Mar 2024 21:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587656;
	bh=GhdmwJHtS3qRtesp4tcKPveB0huYheWWp2JP2ivhDuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TW7sC/7UadwFYokmXecmITiCtx0vUQ7/No9FOCgQ3A4U1rtW59k4ZdOONYIMIoka4
	 lMDOYl8otfLa/FAbjBJy3xIEAk4uQcXdl38CYuXC8Q7cBOgyfw0BI81kHBWpKcZh2z
	 9YXl2nALmZjonbuPRk3h/xFZkP3Ll9eCw2YXQYbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 015/162] tun: Fix xdp_rxq_infos queue_index when detaching
Date: Mon,  4 Mar 2024 21:21:20 +0000
Message-ID: <20240304211552.320917347@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit 2a770cdc4382b457ca3d43d03f0f0064f905a0d0 ]

When a queue(tfile) is detached, we only update tfile's queue_index,
but do not update xdp_rxq_info's queue_index. This patch fixes it.

Fixes: 8bf5c4ee1889 ("tun: setup xdp_rxq_info")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Link: https://lore.kernel.org/r/1708398727-46308-1-git-send-email-wangyunjian@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 4a4f8c8e79fa1..8f95a562b8d0c 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -653,6 +653,7 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 				   tun->tfiles[tun->numqueues - 1]);
 		ntfile = rtnl_dereference(tun->tfiles[index]);
 		ntfile->queue_index = index;
+		ntfile->xdp_rxq.queue_index = index;
 		rcu_assign_pointer(tun->tfiles[tun->numqueues - 1],
 				   NULL);
 
-- 
2.43.0



