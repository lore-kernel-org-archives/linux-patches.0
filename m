Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0C73769E0;
	Wed, 20 May 2026 18:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300875; cv=none; b=qPYlE9wZ8EpuBawwm11flDlcC1fK0kPba9EB68BPwH0aUR9SP7/oIfOtdC382DbaWn4XkQdSw1CQwtm4OOESGFGCHjZIe6fIc5Vyx46OBsky3utfoMiT1zEHetl9fKN+AZfNCm7J/4tAEdKvkyuPXYDIIZ/ANMYPjaSW9B4YvlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300875; c=relaxed/simple;
	bh=lVYiZpZyep7UI2wW9bjaIoWrjQCNDnbqYPiuZZspI+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JypcNFKn7V/97wwM+JeoQdD0LPm0IwdLBIU1SQDe7TWuSrZj2zSqeVDnwt8KirUvPxaKpoRBD8XTqwzNcxRXeW7H521v1+D1mzTVqabyESgt62E5HItCyuQknBtkANYRDjqyTldc4rjyK8SijSJ59rrXXHozqXqSizcKUbZxZC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BD3lszTH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BD3lszTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6791F00893;
	Wed, 20 May 2026 18:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300874;
	bh=aG8XPZUaSDlFbcNSnLpoAEvWxpaJrYshgXyMMWIvLxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BD3lszTHBw7fkma+FPWmrRkHuKoCGmf30xcLF+s5KppilSJoidz6V1OxE6TzQXbvl
	 71giPZkZv+/xYMenWl06e/ytqoWkvJ8Jyzf1GEY8XP/MgN3K8q+UEZx44pNfXJrXUt
	 3ODLunINzuijwA2lUD5iXTYVHHz/QxmlHJmYHdoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 339/666] mtd: parsers: ofpart: call of_node_put() only in ofpart_fail path
Date: Wed, 20 May 2026 18:19:10 +0200
Message-ID: <20260520162118.581173511@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>

[ Upstream commit 0c87dea1aab86116211cb37387c404c9e9231c39 ]

ofpart_none can only be reached after the for_each_child_of_node() loop
finishes. for_each_child_of_node() correctly calls of_node_put() for all
device nodes it iterates over as long as we don't break or jump out of
the loop.

Calling of_node_put() inside the ofpart_none path will wrongly decrement
the ref count of the last node in the for_each_child_of_node() loop.

Move the call to of_node_put() under the ofpart_fail label to fix this.

Fixes: ebd5a74db74e ("mtd: ofpart: Check availability of reg property instead of name property")
Signed-off-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/ofpart_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/parsers/ofpart_core.c b/drivers/mtd/parsers/ofpart_core.c
index 09961c6f39496..a5ba78c6723ee 100644
--- a/drivers/mtd/parsers/ofpart_core.c
+++ b/drivers/mtd/parsers/ofpart_core.c
@@ -191,11 +191,11 @@ static int parse_fixed_partitions(struct mtd_info *master,
 ofpart_fail:
 	pr_err("%s: error parsing ofpart partition %pOF (%pOF)\n",
 	       master->name, pp, mtd_node);
+	of_node_put(pp);
 	ret = -EINVAL;
 ofpart_none:
 	if (dedicated)
 		of_node_put(ofpart_node);
-	of_node_put(pp);
 	kfree(parts);
 	return ret;
 }
-- 
2.53.0



