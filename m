Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6A042885F;
	Sat, 12 Sep 2026 12:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217381; cv=none; b=rJ/ocyez5Lv5wD3CWxbwS2gtodEVwZ8BGUlThOm2eJrmrCMsDInRvrM23N0fUjWg4gOfVqwZ5hireJ8SDtKF3haeYcd5eeb2Dscm537OEu1C2X5uaZjYxCyYnY0+rzlsAT+Kw6EkXIazZ/4yK/dVbOZwgcQapNgg+E14uhMYaI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217381; c=relaxed/simple;
	bh=kNDxA/5ZDKJqcbWfdRXE5sy1Vw1+5mmdhx3B2T1wwe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RyaMvitLNGZXinf4KNxUcO/ZgJrdMxy2oC6TpPUASaOzvF7lP8p5LqE4uY3/SUMeg8pf270HAeX8XCV2Vkoa3j03pTwDqeKp/2c924JEhIXzageqfk6K1SQCF134B2Ie6l8sRQtOT7PwchTkGgo+YFRPlFHlQUwd6rM2ijyfE4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrD0nnW+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrD0nnW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647DE1F000FF;
	Sat, 12 Sep 2026 12:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217380;
	bh=PzuEo79xKVOInDT0iNUxwf7fbyOKemomWQaZQ+jl/pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrD0nnW+C1kVpY0spenF4VYS4bqeZayFrP3mPqK8NKSUxpMrxu7aU7Gd6WbE4CvQe
	 ZoUAUXCKVoT+redpMCcP4o0d2S6CJn5DxaOyTzSfeTyQXGdjvFk8UWBnGh8MGZmhPk
	 z0uDoWH91fVk6S2rKPjjNjIk5i55ZSioKNEB/ps0=
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
Subject: [PATCH 6.12 0887/1376] rapidio: clear mport->net when rio_add_net() fails
Date: Sat, 12 Sep 2026 08:55:13 +0200
Message-ID: <20260912065627.332839472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



