Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6AD46D2CE;
	Tue, 21 Jul 2026 18:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660399; cv=none; b=M624/4W3AIa3IFAnnIhOlWOfUxj1HeAxaFdQb+4n8M6Law+hOERwh2Vhowy+KazkxHjMN08y+n+LcnL5RbnvPIjrklpEyVeVVAaXBG8lOTTsXGJ5JfpER7a+lmKmKTSieQ0Db2HsKUNihseXmUpP/Q3+6IMdehlQ5YcWykbzWaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660399; c=relaxed/simple;
	bh=L12rvdKLO7d2GMeXo7xBNsMGgsbg8xY6XBtwJYxaWmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEMVMNXbAtFtONwqHR+Eti8xmb8zZgGbRJjkvQtgrpSrJ+gSUAuA8KzNK0Z1gTwoFQVDtF23ZLmXDPn6ya9Ns+FtW9B509IjyfYJghlnoLQ/RwfMrRwhx2eaJbyY/tFfWb4CxZ8Idlp7YtbWnR7MPg06WcNnoqNEeK5uBbLL9GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5n5udgc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5n5udgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303491F000E9;
	Tue, 21 Jul 2026 18:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660398;
	bh=dPsGBBhfU2hpfkOxiWcondHTKIXzXhopJrw0HvFuulc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5n5udgc3/5hE+pDFw/esSb23Nxnb9k+jJxWR3L7wfJrsRirip8Zy7QBZPGh0X20P
	 LJxn7ETc68b2spsBkQ30B6lxuc2k6Zz6cGMHEjx2eBZoO3Iteq7QPcNvZutIdJmM15
	 RfegFxdBY15ySzyyWs655mKy2M0ojpcVm56hDOiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0963/2077] sunrpc: Fix error handling in rpc_sysfs_xprt_switch_add_xprt_store()
Date: Tue, 21 Jul 2026 17:10:36 +0200
Message-ID: <20260721152615.536887763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 37957478be021b92981aa4c99b69f308d3b784d0 ]

xprt_create_transport() never returns NULL, only valid pointers or
error pointers. Using IS_ERR_OR_NULL() is incorrect, and PTR_ERR(NULL)
would return 0, which indicates EOF in a sysfs store function.

Fix this by using IS_ERR() instead of IS_ERR_OR_NULL().

Fixes: df210d9b0951 ("sunrpc: Add a sysfs file for adding a new xprt")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/sysfs.c b/net/sunrpc/sysfs.c
index a90480f8015480..49686bf740e694 100644
--- a/net/sunrpc/sysfs.c
+++ b/net/sunrpc/sysfs.c
@@ -348,7 +348,7 @@ static ssize_t rpc_sysfs_xprt_switch_add_xprt_store(struct kobject *kobj,
 	xprt_create_args.reconnect_timeout = xprt->max_reconnect_timeout;
 
 	new = xprt_create_transport(&xprt_create_args);
-	if (IS_ERR_OR_NULL(new)) {
+	if (IS_ERR(new)) {
 		count = PTR_ERR(new);
 		goto out_put_xprt;
 	}
-- 
2.53.0



