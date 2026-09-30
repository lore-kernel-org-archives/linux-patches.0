Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858BB5208C2;
	Wed, 30 Sep 2026 18:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793903; cv=none; b=OOJx4XjT/fyM5FphyMQWD5jK3RVNWj70lwdRFDf+xNn570UNivgiRPhnq1fdn8KFVxBQJsMfS40v+DmZJiVFiaaZ+zalfF8Msumn/PqrJCsgzdZXnSN64mxh9uDIsm7vFf3qOVhyzwzCNzb+LsYqTJbb6aFFVnA08EXQkhCwI0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793903; c=relaxed/simple;
	bh=6+LmSvfo79YaR1eb7WWOzlAab/o5DgfokJYdbXkgXWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GC47ySzcdISWeEGI4cZDoDl67ITr67E3HmAeCR6kxBm9tG05duc7YYIFUv0vkXSZrH76KBoh6Hirn2l1WpyOhQ+YqAmjMK4Q/5To0I4BxhoM3mXMUHJ1igF7qm2ztvyBbSL5RewZWMnP7yey6iHfrQDb+nRT9qyZuZdYPY1XW4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EemfZ0jh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EemfZ0jh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22661F00898;
	Wed, 30 Sep 2026 18:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793901;
	bh=vlpTfpsQR/tnLD8dhHKL9Ce3AsupswSxAMpildGb3EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EemfZ0jhQ3dDwCRfF6XEG4nMg63LCtPgTPHdIytHx4TXxCFgd1Sgq4t3e4pyOUPJi
	 u5JWc/jZMJK+Vj+8NXqcN2616qiIAywrgWAws82oN4nlRGhrD8LGM0YPHBVNs77F3n
	 0yZ7HFD+UJ+LRVte4TjegJUlKhGqYzIFBppBPGVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0023/1193] thunderbolt: Release request if tb_cfg_request() fails in __tb_xdomain_response()
Date: Wed, 30 Sep 2026 17:11:47 +0200
Message-ID: <20260930152434.809905799@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 4c63f29872cb444b33665348bbd2f45cab06afcd ]

If tb_cfg_request() fails setting up the request (for example the
control channel is shut down already) it returns an error without
calling the callback. To avoid leaking that memory, call
tb_cfg_request_put() if tb_cfg_request() fails.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/xdomain.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 87fbced665b91..99a3f4317b5ca 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -139,6 +139,7 @@ static int __tb_xdomain_response(struct tb_ctl *ctl, const void *response,
 				 size_t size, enum tb_cfg_pkg_type type)
 {
 	struct tb_cfg_request *req;
+	int ret;
 
 	req = tb_cfg_request_alloc();
 	if (!req)
@@ -150,7 +151,11 @@ static int __tb_xdomain_response(struct tb_ctl *ctl, const void *response,
 	req->request_size = size;
 	req->request_type = type;
 
-	return tb_cfg_request(ctl, req, response_ready, req);
+	ret = tb_cfg_request(ctl, req, response_ready, req);
+	if (ret)
+		tb_cfg_request_put(req);
+
+	return ret;
 }
 
 /**
-- 
2.53.0



