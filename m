Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44ED288505;
	Sat, 12 Sep 2026 16:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230765; cv=none; b=Ry24blNYI6oUAG36O4x7bMbrwMcYwofG0xelhU8vPyCNGEzU3+hhRVDYJxKjPwFahynB+q+EI6SssSd05YdGaM8IPxE2R/nu8oCzO9zGpjzUEV9VH4elBSDwm+9stOMN7N4yMbE3fZNpaomV69DTXKNStgiPIcQ4XXYBd8TBnfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230765; c=relaxed/simple;
	bh=9oIsf+Tf5JKPu0/duC7isrE2v1fTtlpwYAS+WNQ7c9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OG0TJS2XIQRT0UvHp0YYOENmaJp6CggqS80n4yxxAh+SGPDRhZ3fmjV0+M2y9kvBGgm+i+7FrUePFgzfZxBgyhzeQaaQrX1ZGOWcr/MpCfFDzUlCVgE8mi1DZ5NhIUPLRuBFprVS6GWvwnj+5srzzl8zvd8Wuci3NdMhh1T5nw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q33k+zRx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q33k+zRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86CC1F000FF;
	Sat, 12 Sep 2026 16:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230763;
	bh=Q2cI6zCDjpO5GwAedPwWvh6bHH+YuONyYll9WCFts1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q33k+zRxEAt7iN/5z/lldfB//FicjaJ200mmbkoysSnoptjhjold67vk5Quu+4naw
	 dpHKM/2hEw8ZR6uS7WSKsISQvsFgX3eiQTD0QVZ9Wl/UHaixawwKDGv5zCphd0DHkM
	 BQB1i57Pb2STYgqOO+4ysgG8ixOw1xC22HHiDJBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Yang yingliang <yangyingliang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0860/1191] rapidio: clear mport->net when rio_add_net() fails
Date: Sat, 12 Sep 2026 08:59:48 +0200
Message-ID: <20260912065607.567486682@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit b74030fbf187b43c1f85b66a7082e9946511cb5d ]

rio_alloc_net() stores the newly allocated rio_net in mport->net before
rio_scan_alloc_net() registers the device.

If rio_add_net() fails, rio_scan_alloc_net() drops the device reference
with put_device(), which releases the rio_net through the device release
callback.  However, mport->net is left pointing at the freed object.

A later mport unregister path can then dereference the dangling mport->net
pointer and may try to free the same rio_net again.

Clear mport->net in the rio_add_net() failure path, matching the cleanup
done for the destID table allocation failure path.

Link: https://lore.kernel.org/20260708070628.721010-1-lgs201920130244@gmail.com
Fixes: e842f9a1edf3 ("rapidio: add check for rio_add_net() in rio_scan_alloc_net()")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Yang yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/rio-scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index dcd6619a4b027..3cc25d0534513 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -874,6 +874,7 @@ static struct rio_net *rio_scan_alloc_net(struct rio_mport *mport,
 		net->dev.release = rio_scan_release_dev;
 		if (rio_add_net(net)) {
 			put_device(&net->dev);
+			mport->net = NULL;
 			net = NULL;
 		}
 	}
-- 
2.53.0



