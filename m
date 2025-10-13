Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7169E31984E;
	Mon, 13 Oct 2025 15:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369299; cv=none; b=BAMRzh42ffD1BXMiGAZisuJqs2vGp9yjXhPAle1hnb+tvqfpZa7fDeNhtVgIiNhgeIQE1JJffr63MeYIYQn0ndkZIClTH09cC3jOMeXRDcyEyEUE+BiWQ7KjcJNess5PlwOmXipz8zmy4b+xXTtKOtwkQA3NT5z4zYUvzrlcIBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369299; c=relaxed/simple;
	bh=+PCIuAvnutkTUpjffJC9KqJMNJpmjWis+V7BcUO3sBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mhk9NSjm1BuY8+Wi0dM8Wr/NEIZYJqgBOWj2rei+cpm8FpnOjuIJO3T5iq0aIRyMd3g5ZJ0TzSC+q0QTVLkpzwZs1qHXspamH3P9ZBVtpMcFXfBZ7VGW4jdeO0tzyhoAdj3u76a0Vt/n1/HRyBL+v1gukjybQ6EIJMtjU6+8qGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJWRjUd2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJWRjUd2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A3CC116C6;
	Mon, 13 Oct 2025 15:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369298;
	bh=+PCIuAvnutkTUpjffJC9KqJMNJpmjWis+V7BcUO3sBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJWRjUd2NeTPrzMCBRuBOJvpEGFxhxRBe+7N1BcxD7z3/UvLzg51a7/2Y1hh8yW2J
	 /gbebE2BepGRaycEQdpbqzw/qI/hz/wfeZIlrU+TqjfVzD5jKodFgaKaZ01Q8YMaTp
	 d5gDzNhDMyDvGHb1k4INJgvyDsZWzybsqUe74LRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 164/563] nvmet-fcloop: call done callback even when remote port is gone
Date: Mon, 13 Oct 2025 16:40:25 +0200
Message-ID: <20251013144417.231302636@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 10c165af35d225eb033f4edc7fcc699a8d2d533d ]

When the target port is gone, it's not possible to access any of the
request resources. The function should just silently drop the response.
The comment is misleading in this regard.

Though it's still necessary to call the driver via the ->done callback
so the driver is able to release all resources.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Closes: https://lore.kernel.org/all/CAHj4cs-OBA0WMt5f7R0dz+rR4HcEz19YLhnyGsj-MRV3jWDsPg@mail.gmail.com/
Fixes: 84eedced1c5b ("nvmet-fcloop: drop response if targetport is gone")
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fcloop.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
index 257b497d515a8..5dffcc5becae8 100644
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -496,13 +496,15 @@ fcloop_t2h_xmt_ls_rsp(struct nvme_fc_local_port *localport,
 	if (!targetport) {
 		/*
 		 * The target port is gone. The target doesn't expect any
-		 * response anymore and the ->done call is not valid
-		 * because the resources have been freed by
-		 * nvmet_fc_free_pending_reqs.
+		 * response anymore and thus lsreq can't be accessed anymore.
 		 *
 		 * We end up here from delete association exchange:
 		 * nvmet_fc_xmt_disconnect_assoc sends an async request.
+		 *
+		 * Return success because this is what LLDDs do; silently
+		 * drop the response.
 		 */
+		lsrsp->done(lsrsp);
 		kmem_cache_free(lsreq_cache, tls_req);
 		return 0;
 	}
-- 
2.51.0



