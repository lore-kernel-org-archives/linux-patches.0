Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C9450B42A;
	Wed, 30 Sep 2026 15:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782351; cv=none; b=YMBtFqBLdU0ftWPwAUKHgvHKeFMsPJ5e5/QM1QsjOI9nLc63kOnl6uwUfPCaMliziqocGH2CNOLIPUzeq0TroUJIpmDC/ml2i5ldg2eAI87jOPDgQTMFj2Jj31Ms5CnA8nUNgYiJNYxd9OV9W+Fnz70FHaaVc6sNXpYmwS8BywQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782351; c=relaxed/simple;
	bh=hpO5VTTqU8iagYXaF734ttIaBM7+KC/FKbU4nGP04s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYTGLCXlOKPTmkvaxFHvLiVP4i9PtiPHbMUH4gCEge4lzrIrteXM3joKqDjMy7voOXA6j0690bCqKuW7U0g+221N+uW6hQWXpVIoxjVDvd6IKOBXXhoh4eqCDHo0X6IjlATnKGj9c1u4c/cRJdbJyz/kBMXUjxzu/a572dzSbjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZDLYHke; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZDLYHke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C294C1F008A1;
	Wed, 30 Sep 2026 15:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782337;
	bh=HHOOW9odzintQwbksNXIF4f6eCUiCFi3rEJHO8d3yEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZDLYHkeOI1T4Vib4T4QEcvSEJh4toX+IIvjP478/em5qUtb0IUOuq01yr5VjsrHh
	 31cH0c75PMJNrRn+DIthSqcN2gD1Zbbqpv0SpfqNTvetU2gZXNRs4+mua2z471twal
	 ODf1HTDRY+n+8Wg382gGyUW9w1A5NPA1aC0Oe0gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/595] thunderbolt: Release request if tb_cfg_request() fails in __tb_xdomain_response()
Date: Wed, 30 Sep 2026 17:18:25 +0200
Message-ID: <20260930152347.982426851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 47ccebf42c5a5..a354532988fb2 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -97,6 +97,7 @@ static int __tb_xdomain_response(struct tb_ctl *ctl, const void *response,
 				 size_t size, enum tb_cfg_pkg_type type)
 {
 	struct tb_cfg_request *req;
+	int ret;
 
 	req = tb_cfg_request_alloc();
 	if (!req)
@@ -108,7 +109,11 @@ static int __tb_xdomain_response(struct tb_ctl *ctl, const void *response,
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



