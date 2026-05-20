Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5D829D26E;
	Wed, 20 May 2026 17:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298597; cv=none; b=HEckAY2eF66jjkH7WazL9rSOXwEoHuIkWsXjJcBER2Ewfso4VKSbI34voKN/s25uiZXjv/bmyx4VHCEmfz/wLxVHYEh01r7jgUy2PXB95CrtBkje3D9/XdQONjaAyatavTIuj2RuGiWeE56lv00KmpvD0rPoFGUeg08ri2uKPhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298597; c=relaxed/simple;
	bh=Uo+c98FdW4H3i0DflAd5YFA/6Ftz7mbJEQUMz7jhKHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRZxFKGxrNcZ0ISqx5KhOacxvjZzDeeEchxTmeTZbU/nhE7zMLHhPYBrHiiCksKbjRvbosDbuZwcRkUBtOwUC/dsA0UI+GTZkuqSwd8kIubGWUPdoXQhlS42KdPKXvMNxr0Ilbl0EQa9UgQvtLJMVn01FZqp4iryYojVZjtK9bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MpGgN5qs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpGgN5qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2B81F000E9;
	Wed, 20 May 2026 17:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298596;
	bh=jKibvQyNtu7ymRWttVH8OSWyRXO3xWWexmQqjtshx4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MpGgN5qsVIu6k3jLBWNjouNIUX6KXGhtaWlh7sLgBJZxFnkn8S2XhXz84Mr8uE6/N
	 6T2GDLVFenfJGWRe50QA0au4I4SXW4BNSl9HxD7tmum7Oi3KCnyoTDNOz8W+oUmr5b
	 vW4LGvyH52zmvVwXM5B6Vs7i0u8cYSEYpC6VtBVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 470/957] mtd: parsers: ofpart: call of_node_put() only in ofpart_fail path
Date: Wed, 20 May 2026 18:15:53 +0200
Message-ID: <20260520162144.717683159@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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



