Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E4351B17E;
	Wed, 30 Sep 2026 17:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790612; cv=none; b=o4e0nifrVN40QBLMToGk1+K11shOzXUEkb2AzCNrhIYoM8H2TzESI0wcf93rR2PVk61uPExBWm/kQSo2vMiytY4O9+f6swYtmWv08xC7H7+07Rmj10nmRgx4jwE2rcGCF1yzt8SmN6Nu13mViPtGuMmes7DJPpzs47Z9u3Q8qPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790612; c=relaxed/simple;
	bh=EV9DElkPkLxX661zyOlc9BgiGNJRPiqayZcFc8mhorU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPZ3vx55F46DLhvm+GXONBn/qeMcVvaIVvrilZM89JGOE/BIfpdR15TAoxmH0x4SXT7lil3RzU6FvDbuze5cMXo9n4RQeXs8gXJTOR9Vlyn1mz2Mk+oHIzs82Zu/Uj1MZhbSnMrd5xtEMl1wPBFLGJEEjCABCe4TwS9KeOUgJxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIcBxlex; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIcBxlex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1ED1F000FF;
	Wed, 30 Sep 2026 17:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790610;
	bh=Qnjermaab9z6wcgExb77wklw4fUj2v2AYy0hquaKmoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iIcBxlexCNKgdntmgiZPnHMivXGDTeUo++ypI5Ec5qxoRGqiiR8ze44iO3ohQykOz
	 COeMeTZItyNyWtw1JEJJLBInbqgAsMB0Lxo33PvTldxKVWgPcoANrq3rPgvf1/Pr9c
	 EAk0Mv1HRWhQW2bR5hjU2dr4FQ90st75Fvikvxho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 013/752] thunderbolt: Release request if tb_cfg_request() fails in __tb_xdomain_response()
Date: Wed, 30 Sep 2026 17:18:03 +0200
Message-ID: <20260930152358.434260567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b31c4e439f278..b5dad78c6b230 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -112,6 +112,7 @@ static int __tb_xdomain_response(struct tb_ctl *ctl, const void *response,
 				 size_t size, enum tb_cfg_pkg_type type)
 {
 	struct tb_cfg_request *req;
+	int ret;
 
 	req = tb_cfg_request_alloc();
 	if (!req)
@@ -123,7 +124,11 @@ static int __tb_xdomain_response(struct tb_ctl *ctl, const void *response,
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



