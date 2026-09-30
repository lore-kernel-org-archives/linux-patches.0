Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DB92AEEB;
	Wed, 30 Sep 2026 16:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784048; cv=none; b=FOV9bju9v3V4Km+kGamf7WVrOnzwcYOHdUSxVQyFMNMmZynJLgohxYevlIm6JoytiRSsTLd7B0QaUV26s2nB8KFyvOmCLYe1c6d4ptYXc98q/fwuPhQjp4GCMUZED97bB1cvibWEMwQX5bjnA8pmPJc1TgY+MIrMwwVFqv7NfZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784048; c=relaxed/simple;
	bh=3ymEiSY8yGfyOIBm0+7j2k70lGHkPDC4KUu/KqHEr5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndC0Eoe38WhOWwryjR1Dq+0s8vCZ3bPNzKRdB8/hVYCyXP+zb+6DinkIC1pT/lhUU9LO04OeJ/Pt2BGWGohR8OG9dkXDAc52QtsuJGHuUQdE8fEYPetfrBC+FLxbig+L0+65wAHGNYFF3Q1AODkoXlwBi0O10ubK00xLkDcGoV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hLIrWhP/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hLIrWhP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBAC1F000FF;
	Wed, 30 Sep 2026 16:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784045;
	bh=3zFxe34jwlChwS96cob1WSTuq38LnBHbRXr4qUl3P4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLIrWhP/3CwS+AQYcX0FX+Zq2W4CtweN5J4b3O2bMC25UYNdnSlHubxomszyM8nLD
	 y3j7vzsotLcbdhtAhwvG5pFSMykarL2Xd6YbSkKa0qZ4uBV3jKVgZU1WVkQ4QG+YOE
	 kGR+dzKFXTVk0nn4/upxvgh0UAVOnxe+hMx/Re60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/982] thunderbolt: Release request if tb_cfg_request() fails in __tb_xdomain_response()
Date: Wed, 30 Sep 2026 17:12:34 +0200
Message-ID: <20260930152417.178570968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 371911e2ae428..6a003316b878b 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -138,6 +138,7 @@ static int __tb_xdomain_response(struct tb_ctl *ctl, const void *response,
 				 size_t size, enum tb_cfg_pkg_type type)
 {
 	struct tb_cfg_request *req;
+	int ret;
 
 	req = tb_cfg_request_alloc();
 	if (!req)
@@ -149,7 +150,11 @@ static int __tb_xdomain_response(struct tb_ctl *ctl, const void *response,
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



