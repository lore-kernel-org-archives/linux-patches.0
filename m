Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CF61459F6;
	Wed,  5 Feb 2025 14:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765418; cv=none; b=bx4kq+2HH8RcdwT30YrkMflLJeWCqXSmpvrYQvEPuMPsZBgC+KIZI5lj+U+iM0RAvliOT2Ki3yBTmH0JiRTwgpbN7BqmZSv/vaS1t/14rBJF4GQmFBxfK4c0+7hc8zJACXpYj5YjUIRhzoQSjSMDnxPWqg/mDd46uVXIs7Syglk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765418; c=relaxed/simple;
	bh=2rFq29rEC3XCQWnz8sgDxgL5vhzLwWNjFM6qvdFlJeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Okz7v/dHuAsosP4/x58eRQ/Jh5oWvV0pjegxJ7TVkALTfoVO6CO2bUd1mc/WC0CYsYFMDT/LYp3jOf+6gX9HgOkVD0VLx1cKMV+kPbiKFZsqOtrQnQgiykVueuBblKPK3eXx0ReR69u0k+Ksmh29IyvaNqOjd/dFSuxRrwtzy+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SF0Zr/oQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SF0Zr/oQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AFFC4CED1;
	Wed,  5 Feb 2025 14:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765418;
	bh=2rFq29rEC3XCQWnz8sgDxgL5vhzLwWNjFM6qvdFlJeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SF0Zr/oQ44M7xyaaOq6gqub1XObMm5O5ItWlrLrEbicQnrVAVuyYORy5qCaMIwgxU
	 tLGC2hoI6JUwhC5rRzQTrOJ85XyfQ1XvE6MI77vDJ1Aq2pMZZHiUHnnP8MlEFrMqQL
	 e7eRU/UIIpFSg9hj52NI/Eyi6MwlDYTFQcEhylP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/590] dev: Acquire netdev_rename_lock before restoring dev->name in dev_change_name().
Date: Wed,  5 Feb 2025 14:39:33 +0100
Message-ID: <20250205134503.626800757@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit e361560a7912958ba3059f51e7dd21612d119169 ]

The cited commit forgot to add netdev_rename_lock in one of the
error paths in dev_change_name().

Let's hold netdev_rename_lock before restoring the old dev->name.

Fixes: 0840556e5a3a ("net: Protect dev->name by seqlock.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250115095545.52709-2-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1867a6a8d76da..9bdb8fe5ffaa5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1279,7 +1279,9 @@ int dev_change_name(struct net_device *dev, const char *newname)
 rollback:
 	ret = device_rename(&dev->dev, dev->name);
 	if (ret) {
+		write_seqlock_bh(&netdev_rename_lock);
 		memcpy(dev->name, oldname, IFNAMSIZ);
+		write_sequnlock_bh(&netdev_rename_lock);
 		WRITE_ONCE(dev->name_assign_type, old_assign_type);
 		up_write(&devnet_rename_sem);
 		return ret;
-- 
2.39.5



