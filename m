Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2B717A2EC;
	Mon, 13 Oct 2025 15:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369430; cv=none; b=dPoLf8vVb3IxhY+6Sk32PosA0+wDwl6rYViqklQt00WF5iHXwjyfwEIQ+y4UhhkaYBGlxZQvjZQzU/LjM3UJDrZzG1qnJ4+55NU8cS50jr+mjfBIH4S8Rvgw3xf+b2I6vw++JTLJrfxy2p49UGdlGkfOsXuwJogVQmYc8NZYRtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369430; c=relaxed/simple;
	bh=mqOniKok2LzM3zlbjfGBpi9CgzfQUbtu7U/T2cqbl68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AreJa8+DzKPV6fldvww7DiQtSNTaMACB9sjE0Or1I/CIEN1BLtsXqS8ZfKnd5yQQU1mn9UavqNvQ78PJXjIsxfl5ndlUIGOPBQcd7jdfzFa+QSQtftIeTT1Q/VP4p1EPm5um20aXC2RsrXwVFStEWpHIPJ7S1y0eWV/q75CAxoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESWa9gsI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESWa9gsI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9E2C4CEE7;
	Mon, 13 Oct 2025 15:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369430;
	bh=mqOniKok2LzM3zlbjfGBpi9CgzfQUbtu7U/T2cqbl68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESWa9gsInAizOB/EmWRTqJu8ZzRnZVClheZv4q0rH9LyUKUowj2sv3qZQTbQuflho
	 7G5Zc+9+kPNkU6beKkDoj/NbWWisHb3heRSqdwhuXn6PZjdgpRCJdnfTMoVU1WpGDu
	 niVZLaZDgI6tRg2v0RQImcgqDm9WzVqjBWMKAis0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhilesh Patil <akhilesh@ee.iitb.ac.in>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 244/563] fwctl/mlx5: Fix memory alloc/free in mlx5ctl_fw_rpc()
Date: Mon, 13 Oct 2025 16:41:45 +0200
Message-ID: <20251013144420.123828526@linuxfoundation.org>
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

From: Akhilesh Patil <akhilesh@ee.iitb.ac.in>

[ Upstream commit 7f059e47326746ceebe2a984bd6124459df3b458 ]

Use kvfree() to free memory allocated by kvzalloc() instead of kfree().
Avoid potential memory management issue considering kvzalloc() can
internally choose to use either kmalloc() or vmalloc() based on memory
request and current system memory state. Hence, use more appropriate
kvfree() which automatically determines correct free method to avoid
potential hard to debug memory issues.  Fix this issue discovered by
running spatch static analysis tool using coccinelle script -
scripts/coccinelle/api/kfree_mismatch.cocci

Fixes: 52929c2142041 ("fwctl/mlx5: Support for communicating with mlx5 fw")
Link: https://patch.msgid.link/r/aKAjCoF9cT3VEbSE@bhairav-test.ee.iitb.ac.in
Signed-off-by: Akhilesh Patil <akhilesh@ee.iitb.ac.in>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fwctl/mlx5/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fwctl/mlx5/main.c b/drivers/fwctl/mlx5/main.c
index f93aa0cecdb97..4b379f695eb73 100644
--- a/drivers/fwctl/mlx5/main.c
+++ b/drivers/fwctl/mlx5/main.c
@@ -345,7 +345,7 @@ static void *mlx5ctl_fw_rpc(struct fwctl_uctx *uctx, enum fwctl_rpc_scope scope,
 	 */
 	if (ret && ret != -EREMOTEIO) {
 		if (rpc_out != rpc_in)
-			kfree(rpc_out);
+			kvfree(rpc_out);
 		return ERR_PTR(ret);
 	}
 	return rpc_out;
-- 
2.51.0



