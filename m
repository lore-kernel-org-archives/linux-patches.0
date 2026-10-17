Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AAE374E60;
	Sat, 17 Oct 2026 17:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258918; cv=none; b=Y5vutBxI8NpE/wPNLLq+Zyw3Tiiy1G2LqDoMKnW767BcSwU2lhNp0piIS7FArNRk/hl3EP6JfCadQ9VY/gZzoJSBe0DQLLJVucJpdnyruUSp5+txCzJwtBpuGoBTMVENfl2hBTHg1pYHBypAHy29O0+ncplHft0jpXQFyxP95Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258918; c=relaxed/simple;
	bh=Am3wJ82vifH+crvapAApZkP63L/PFpWXV4cE3VkxO6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mueXiNVnUZOsd4rWIN2PQRsuDwLEqPDH86a7XhvB8SMXANMFvaHoXVDh9zTWLh5/8PhAovsh+WjyEDK0s/XwY0KppFZOSFoJ84tslsQHif/jgbVHPU4LAXfVqs9VyTDTs/2NJIRLft+UZ9zfjQFUIVk/jDRk2CbLtSI1tOQkAi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bComwN4R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bComwN4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF981F000C4;
	Sat, 17 Oct 2026 17:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258917;
	bh=jzujj2OENpQICV2kx/+HE4BJsbFIfqkSiwy3pzDn/os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bComwN4RewW+nq6nve27wSfkd4Z/b367qI2EiWfuMqQS29NwldmU+AWcuxyEz2p3z
	 J8nrOKOo5QSv3l/6ffIsnJEDU7w6s7wysTBSkv3F1koezGWAiitAiluTzpei895jsW
	 uMJdlc2tSJXTjNFXMs3HI2T5QpOqjMW7SInjdOZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1042/1674] ethtool: rss: fix indir_table and hkey leak on get_rxfh failure
Date: Sat, 17 Oct 2026 17:55:14 +0200
Message-ID: <20261017160457.879556897@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 266297692f97008ca48bc311775c087c59bd7fe3 ]

rss_prepare_get() allocates the indirection table and hash key buffer
via rss_get_data_alloc(), then calls ops->get_rxfh() to populate them.
If get_rxfh() fails, the function returns an error without freeing
the allocation.

Fixes: 4f038a6a02d2 ("net: ethtool: Don't call .cleanup_data when prepare_data fails")
Link: https://patch.msgid.link/20260522230647.1705600-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/rss.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/rss.c b/net/ethtool/rss.c
index 5764202e6cb62..8387cbda3373d 100644
--- a/net/ethtool/rss.c
+++ b/net/ethtool/rss.c
@@ -94,8 +94,10 @@ rss_prepare_data(const struct ethnl_req_info *req_base,
 		ret = ops->get_rxfh(dev, data->indir_table, data->hkey,
 				    &dev_hfunc);
 
-	if (ret)
+	if (ret) {
+		kfree(rss_config);
 		goto out_ops;
+	}
 
 	data->hfunc = dev_hfunc;
 out_ops:
-- 
2.53.0



