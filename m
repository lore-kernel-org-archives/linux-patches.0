Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7503335AC1E;
	Sat, 12 Sep 2026 08:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201688; cv=none; b=aEsBaGTGYMFCJP/rORenvY96l3opcfNJuR1qDltKZhYw3X0mEyc4bM3FpjKBmpv20v1yZ+G14p/etnlcjhVwLdppKSEG/pk1ynHBnmPRbH4EAgluXk5WkflNM+tG5fkYpf7yFBVy8OSGWflMwo7HPQi/LnoQxPbyWN8bsIeludc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201688; c=relaxed/simple;
	bh=0suRC4U28S+BofITsHuwR1TED0cCpol7VDqlhyVExjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYdloNGrI4YgoZjWCHUNnpOjZfOwG6TJB5ynhhO3TF1HFSizeCKjmNczbqy0Db/f1C7nm406ydz8zMJEihOJ3q2mlQRY03U/EdR6hqg62Zay1MQG5TI4ZTTRoAGOSigNNS7CF+BoZRwqouopn2CT21fpJVtrTiLa6fZaWrdPmtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eY1RWlUL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eY1RWlUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792971F000FF;
	Sat, 12 Sep 2026 08:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201686;
	bh=9YcjiZtTDiu3YhbPIHfY8Iu4Pzfdf8rAuxKaTctlQUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eY1RWlULWsWOgj5d7/ce+2wHP5//dE2ScNIV10KQgaMqbGhvUZHVsJhEpJ4RHRC1n
	 P4rPqQCDu8A+SJsAcYdt1YXABEEquk9fqO7yb4VsD6IEO0RM6Xc66VupFazhMvR/7a
	 zmr28QFYz8YzKvxjciS5dyaEx2hTSiKrS/kebVB4=
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
Subject: [PATCH 7.2 1045/1815] rapidio: clear mport->net when rio_add_net() fails
Date: Sat, 12 Sep 2026 08:46:35 +0200
Message-ID: <20260912065713.549779079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



