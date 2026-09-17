Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D414484896;
	Thu, 17 Sep 2026 16:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661025; cv=none; b=lV+H2H2PPTrOy+UXhL6ALbzcBe8L9vXFQQiMtOulAZ/Hi/3w3XYH+BRTVa2OoWUQdoDLeXC8OIC+DqF+Fse1uqVJQgXV8Mg5bxYiMn8qnjliKSw0uGnccfZkT6Mk60rdKYhtMG0D0i+XpGrytELMmD/gND5eZdi6i8V6elZqvcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661025; c=relaxed/simple;
	bh=6xm1xi8DsBt/hW1KKQXQGPYRYJCwu5eKu8vLolKpfB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uABbGlGjU2V9s+9W1Dq1DwPSpy8bkXY4sO90OW0qJ0KEUo2phFxTGRky8kjeDMye9HwooFFov5xuEGcVr9CLQEATbHZ+FsmTPlsz9ysvInjwOEQVSOGSmuq8Nbaue9Xl9IvEr8ljPLkbNdoXlr0wmnjIZ/RT2AuQr4kn4Ad/Ji4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XD9bU1YY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XD9bU1YY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA93D1F00893;
	Thu, 17 Sep 2026 16:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661024;
	bh=nbLgQwuscO06MtbNr8xPxNvE/bPDfBSihDVxi9Gd0qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XD9bU1YYm61rGlsDDb9wVxdsvHdulWpvJ8RZIv7aNCih8i5OFHxOxzj4wrtVhrqmT
	 UI9r1zy8vawnlXl9ap24HGKbNVUeMo+JH/u26vCg/SVrWqYKI6hbArpcYgVmkin3/E
	 inWa1dZyUHYQi10ndEZ8GUZ41sfDvKPn2kc1d8xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0057/1250] thunderbolt: Release request if tb_cfg_request() fails in __tb_xdomain_response()
Date: Thu, 17 Sep 2026 15:57:32 +0100
Message-ID: <20260917151553.487008583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b27ef872edeac..5fbdd412a712f 100644
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



