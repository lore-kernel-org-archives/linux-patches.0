Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C17189B94;
	Mon, 23 Dec 2024 16:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969778; cv=none; b=qrU24XHwvyvnkrYD/EjLAwZU/Vq/J2qgxaxRelIukf/YQc2JwDk8Z2d70b3nUrU96G5+yBAMrE1XqKyn3QyI1gsFk4z0/DuhDKUpRPcBHI4tnWMKhV/Jmk+xKMvVqkzics++SBgdkrslCpq7nzuleL0OCsNs1oCPIQuhROBO2wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969778; c=relaxed/simple;
	bh=Jj1MURUGEGNliuTUZOoKLEg0T1kG8Qcs2T8cQmsmsU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dh/bdIeX2DuwWmw/LDhlwtQlMjZ5VTwRcK4x8LMfTmwP75/PKot90619c3ZKVUYhe6UyqAeWV+aMP85eakNj58yPFNHkshr0FcksKQiSkUi46rgaWm5+GE96aJ70qzGzDQm3YGFe3v942XFT3FkzKYF5OphMKai04zm6dZS9QHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTWswjtg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTWswjtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCAB6C4CED6;
	Mon, 23 Dec 2024 16:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969778;
	bh=Jj1MURUGEGNliuTUZOoKLEg0T1kG8Qcs2T8cQmsmsU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTWswjtgQf7iw5JAViCaMlf0v4iZndNYhBi8QRmjDJbKlvJH8GGj5XhEZoKiBadbE
	 79oDfUK3f2mpfv/65pzTEZn0p3hyg4I7p6jZ3hZWVtabZXKXhAC5U2lqSBJEPuva36
	 jIL+syY3dIAqw62ww9M09VNy9iWM67lYSBmhUAjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/160] net: netdevsim: fix nsim_pp_hold_write()
Date: Mon, 23 Dec 2024 16:57:44 +0100
Message-ID: <20241223155410.734670223@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b9b8301d369b4c876de5255dbf067b19ba88ac71 ]

nsim_pp_hold_write() has two problems:

1) It may return with rtnl held, as found by syzbot.

2) Its return value does not propagate an error if any.

Fixes: 1580cbcbfe77 ("net: netdevsim: add some fake page pool use")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241216083703.1859921-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 017a6102be0a..1b29d1d794a2 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -596,10 +596,10 @@ nsim_pp_hold_write(struct file *file, const char __user *data,
 		page_pool_put_full_page(ns->page->pp, ns->page, false);
 		ns->page = NULL;
 	}
-	rtnl_unlock();
 
 exit:
-	return count;
+	rtnl_unlock();
+	return ret;
 }
 
 static const struct file_operations nsim_pp_hold_fops = {
-- 
2.39.5



