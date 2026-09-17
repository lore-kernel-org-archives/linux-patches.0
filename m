Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1FF34FDA5F;
	Thu, 17 Sep 2026 17:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667276; cv=none; b=RjTwvkvDIu+rL9kJ/yKWDIFokeyUCbYlihYheq7Ex02lrcAOJa7Y2Q7jVvIaADaUuhcHV3cPbgWG5g5jL7tNUK5UqO0rgrKsOInenI2+JL1W8BvXzZ31nWyqZ9NzzTHTxEiLCv6eqZrWYqj09PAAA3862EWm5EgBIKrvihtN46o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667276; c=relaxed/simple;
	bh=NWec41Za0FgNMZDEsSk4IadCy1ZK4c6Xld85Pq8n8Yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6XKhuBBpAV5IJnrIlh7KghUcCLv1FYQxms2fwsKE648gWgbtCD15VsOUrebW7pSn24jjfd2fJ53RXOoXxxenSumXYHDHt2PISZyXySNZBu6KgRNeadwMLVFXgBlFKtz+dId7pn3xvYfmeEQI8X/X7fkJrT177nh01R0mo0T/9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWkStLqh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWkStLqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323641F000FF;
	Thu, 17 Sep 2026 17:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667274;
	bh=+OLTDG6BtmdGXFiAWxBlRjxxaBTlcWk2Rc8RuvKLkGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWkStLqh47l6eD2QxkE6FkdtiFOL8fWupIg+9YjE694P4XRw2iC4qCOVWdgsfKm1e
	 qVVZl5trfAwTDaCWTNajByO7GjjYtnkv24mKNl80YU1bOdMHS9ycFWc/5qJnWVm8lR
	 EkOBoQ3F1mLM/bXC9S2awprM2vQN9KRuAdlMxnkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0037/1102] thunderbolt: Release request if tb_cfg_request() fails in __tb_xdomain_response()
Date: Thu, 17 Sep 2026 15:59:40 +0100
Message-ID: <20260917151540.375989183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 7afe15d53ddcc..01444cf383d01 100644
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



