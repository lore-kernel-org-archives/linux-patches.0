Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E41421A1D;
	Tue, 31 Mar 2026 16:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975078; cv=none; b=TjoE7J6uCrvlo/sYYjK53th/9ns7zZO3c7rhtk/6oTH2RRZRUAEhoF89tMybT5MtzjCgB2crsm8jWiJ5n+u+awQH576/sTEbjsdCg9rlJGP/oZA7LIr2gYxYsrE2HxFwlrJPh/kUitztq4N6LsoqWsbgAzUHXMa8D0A/dJKyPGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975078; c=relaxed/simple;
	bh=W3MQPQQd+msDjCqgfo0WCWsydHgSVqHODBQWdONKWA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ss2Hb7/uvgMC3nEeCYydu6I9xkf+dhEWPLnRse1uOMyCxA4vMCrvBtScMDBRM20YXggGMFlZLakj8OoaiK1+DyHMemEFuQVvk8hV1B/wCp1Bbf3NUvPB5wEsFpQhZ9h464ENgZ563w4JhOOyXdBlD3JLEbsIAhINMOmMZr81+ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ewh2Alou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ewh2Alou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CAFC4AF09;
	Tue, 31 Mar 2026 16:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975078;
	bh=W3MQPQQd+msDjCqgfo0WCWsydHgSVqHODBQWdONKWA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewh2AlouuRvGmknVLHurKJArKBMZPRiS5wZc7GY/wqyMbxMffQuJyWMoTW2o6mTYg
	 9TFQOrwNR9f2bShnblV84rV/hACSQRhmL3C4jSg16cWfUU7Ndt43M9Xo1NQb4yBotR
	 HOOa7SHW4mBPjEvHHMAympGwrn03/tBcFor+IeaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 154/342] RDMA/efa: Fix possible deadlock
Date: Tue, 31 Mar 2026 18:19:47 +0200
Message-ID: <20260331161804.675931906@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit 0f2055db7b630559870afb40fc84490816ab8ec5 ]

In the error path for efa_com_alloc_comp_ctx() the semaphore assigned to
&aq->avail_cmds is not released.

Detected by Smatch:
drivers/infiniband/hw/efa/efa_com.c:662 efa_com_cmd_exec() warn:
inconsistent returns '&aq->avail_cmds'

Add release for &aq->avail_cmds in efa_com_alloc_comp_ctx() error path.

Fixes: ef3b06742c8a2 ("RDMA/efa: Fix use of completion ctx after free")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Link: https://patch.msgid.link/20260314045730.1143862-1-ethantidmore06@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_com.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 56caba612139f..e97b5f0d70038 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -629,6 +629,7 @@ int efa_com_cmd_exec(struct efa_com_admin_queue *aq,
 	comp_ctx = efa_com_alloc_comp_ctx(aq);
 	if (!comp_ctx) {
 		clear_bit(EFA_AQ_STATE_RUNNING_BIT, &aq->state);
+		up(&aq->avail_cmds);
 		return -EINVAL;
 	}
 
-- 
2.53.0



